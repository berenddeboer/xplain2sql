note

	description: "Xplain procedure (xplain2sql extension)"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"


class

	XPLAIN_PROCEDURE


inherit

	XPLAIN_ABSTRACT_OBJECT
		rename
			make as abstract_make
		end

	XPLAIN_UNIVERSE_ACCESSOR

	KL_SHARED_STANDARD_FILES
		export
			{NONE} all
		end


create

	make


feature {NONE} -- Initialization

	make (a_name: STRING; a_parameters: detachable XPLAIN_ATTRIBUTE_NAME_NODE; a_procedure_kind: INTEGER; a_statements: detachable XPLAIN_STATEMENT_NODE)
			-- Initialize stored procedure.
		require
			valid_name: a_name /= Void and then not a_name.is_empty
			-- a_parameters /= Void implies for_each p in a_parameters it_holds p.item.abstracttype /= Void
		local
			r: XPLAIN_I_REPRESENTATION
			anode: detachable XPLAIN_ATTRIBUTE_NAME_NODE
			snode: detachable XPLAIN_STATEMENT_NODE
		do
			-- dummy representation for now, perhaps when stored
			-- procedures can return a value, we have to do something
			-- with that, i.e.:
			-- create procedure test (I4) = ... endproc
			create r.make (9)
			abstract_make (a_name, r)

			-- copy parameters
			create parameters.make
			from
				anode := a_parameters
			until
				anode = Void
			loop
				parameters.put_last (anode.item)
				anode := anode.next
			end

			-- copy statements
			create statements.make
			from
				snode := a_statements
			until
				snode = Void
			loop
				statements.put_last (snode.item)
				snode := snode.next
			end

			recompile := a_procedure_kind = 1
			is_postgresql_trigger := a_procedure_kind = 2
			is_path_procedure := a_procedure_kind = 3
			create sql_declare.make_empty
		ensure
			recompile_set: recompile = (a_procedure_kind = 1)
		end


feature -- Commands

	cleanup_after_write
			-- When procedure is written, it adds extends as columns to
			-- types. These extends must be removed. Also values are
			-- added to the universe, and should be removed as well.
		local
			cursor: DS_BILINEAR_CURSOR [XPLAIN_STATEMENT]
		do
			cursor := statements.new_cursor
			from
				cursor.start
			until
				cursor.after
			loop
				cursor.item.cleanup
				cursor.forth
			end
		end

	optimize_statements
			-- Check what optimiziations can be applied.
		local
			cursor: DS_BILINEAR_CURSOR [XPLAIN_STATEMENT]
		do
			cursor := statements.new_cursor
			from
				cursor.start
			until
				cursor.after
			loop
				cursor.item.optimize_for_procedure (Current)
				cursor.forth
			end
		end

	warn_about_unused_parameters
			-- Write warning to stderr if any of the parameters are
			-- declared, but not used.
		local
			used: BOOLEAN
		do
			from
				parameters.start
			until
				parameters.after
			loop
				used := False
				from
					statements.start
				until
					used or else
					statements.after
				loop
					used := statements.item_for_iteration.uses_parameter (parameters.item_for_iteration)
					statements.forth
				end
				if not used then
					std.error.put_string ("Parameter `")
					std.error.put_string (parameters.item_for_iteration.full_name)
					std.error.put_string ("' not used in procedure ")
					std.error.put_string (name)
					std.error.put_string (".%N")
				end
				parameters.forth
			end
		end


feature -- Access

	last_get_statement: detachable XPLAIN_GET_STATEMENT
			-- Last get statement, if any.
		local
			cursor: DS_BILINEAR_CURSOR [XPLAIN_STATEMENT]
		do
			cursor := statements.new_cursor
			from
				cursor.finish
			until
				Result /= Void or else
				cursor.before
			loop
				if attached {XPLAIN_GET_STATEMENT} cursor.item as s then
					Result := s
				end
				cursor.back
			end
		end

	last_value_selection_statement: detachable XPLAIN_VALUE_SELECTION_STATEMENT
			-- Last value selection statement, if any.
		local
			cursor: DS_BILINEAR_CURSOR [XPLAIN_STATEMENT]
		do
			cursor := statements.new_cursor
			from
				cursor.finish
			until
				Result /= Void or else
				cursor.before
			loop
				if attached {XPLAIN_VALUE_SELECTION_STATEMENT} cursor.item as s then
					Result := s
				end
				cursor.back
			end
		end

	parameters: DS_LINKED_LIST [XPLAIN_ATTRIBUTE_NAME]
			-- Procedure parameters

	is_path_procedure: BOOLEAN
			-- Emit columns names as XML paths

	is_postgresql_trigger: BOOLEAN
			-- Is this procedure actually a PostgreSQL trigger?

	recompile: BOOLEAN
			-- Force recompile of execution plan on every call to this
			-- procedure; execution plan will not be cached.
			-- Highly recommended when using extend statements in a
			-- stored procedure.

	returns_rows: BOOLEAN
			-- True if this is a procedure that returns a result set, 0
			-- or more rows.
		do
			Result := last_get_statement /= Void or else last_value_selection_statement /= Void
		end

	statements: DS_BILINKED_LIST [XPLAIN_STATEMENT]
			-- Zero or more Xplain statements.

	sql_declare: STRING
			-- PostgreSQL only: sql that gets inserted into the declare block


feature -- Expression builder support

	create_expression (node: XPLAIN_ATTRIBUTE_NAME_NODE): XPLAIN_EXPRESSION
			-- Return suitable expression for attribute/variable/value/extension.
		do
			-- not applicable.
			create {XPLAIN_STRING_EXPRESSION} Result.make ("SHOULD NOT HAPPEN")
		end


feature -- Names

	sqlname (sqlgenerator: SQL_GENERATOR): STRING
			-- Name as known in sql code.
			-- To be overriden, callback into sqlgenerator.
		do
			Result := sqlgenerator.sp_name (name)
		end


feature -- SQL output

	sp_function_type (sqlgenerator: SQL_GENERATOR; an_emit_path: BOOLEAN): STRING
			-- Function type as required by PostgreSQL.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
			returns_rows: returns_rows
		do
			-- Switch into correct SQL for to create the PostgreSQL
			-- function type.
			if attached last_get_statement as last_get then
				Result := sqlgenerator.sp_function_type_for_selection (last_get.selection, is_path_procedure)
			elseif attached last_value_selection_statement as last_value then
				Result := sqlgenerator.sp_function_type_for_selection_value (last_value.value.sqlname (sqlgenerator), last_value.value.representation, an_emit_path)
			else
				-- Seems we can get this if a function does not have a get or value?
				-- Or is that guaranteed by `returns_rows'?
				Result := "-- SHOULD NOT HAPPEN"
			end
		ensure
			function_type_not_empty: Result /= Void and then not Result.is_empty
		end

	write_drop (sqlgenerator: SQL_GENERATOR)
			-- Switch into correct sql drop statement.
		do
			sqlgenerator.drop_procedure (Current)
		end


invariant

	have_statements: statements /= Void
	have_parameters: parameters /= Void

end
