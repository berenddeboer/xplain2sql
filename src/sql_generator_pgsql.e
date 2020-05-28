note

	description:
		"Produces PostgreSQL 7.X output. Older versions not really supported."

	Known_bugs:
		"1. Add support for create type to create domains.%
		%2. Constants are parsed as float8 and do not map to numeric datatypes.%
		%3. Strings and string comparison are case-sensitive."

	author:     "Berend de Boer <berend@pobox.com>"

deferred class

	SQL_GENERATOR_PGSQL


inherit

	SQL_GENERATOR_ADVANCED
		undefine
			sp_result_parameter
		redefine
			DomainsSupported,
			IdentifierWithSpacesSupported,
			AutoPrimaryKeySupported,
			AutoPrimaryKeyConstraint,
			TemporaryTablesSupported,
			ExistentialFromNeeded,
			ExistentialFromTable,
			NamedParametersSupported,
			OutputParametersSupported,
			sql_string_combine_separator,
			sql_like_operator,
			write_extend,
			sqlsysfunction_system_user,
			datatype_int,
			datatype_pk_int,
			sql_last_auto_generated_primary_key,
			quote_identifier,
			create_echo,
			create_extend_create_table,
			create_select_function,
			create_select_list,
			create_sync_auto_generated_primary_key_with_supplied_value,
			drop_table_if_exist,
			do_drop_procedure,
			sql_select_function_limit_before,
			sql_select_function_limit_after,
			sp_define_param_name,
			sp_delete_declaration,
			sp_end,
			sp_function_type_for_selection_list,
			sp_function_type_for_selection_value,
			sp_header_end,
			sp_insert_declaration,
			sp_update_declaration,
			sp_user_declaration,
			as_string,
			extension_index_name
		end


feature -- domain options

	DomainsSupported: BOOLEAN once Result := False end

feature -- identifiers

	MaxIdentifierLength: INTEGER
		once
			Result := 31
		end

	IdentifierWithSpacesSupported: BOOLEAN once Result := False end

feature -- table options

	AutoPrimaryKeySupported: BOOLEAN once Result := True end

	AutoPrimaryKeyConstraint: STRING
		once
			Result := "serial primary key"
		end

	TemporaryTablesSupported: BOOLEAN
		once
			Result := True
		end


feature -- select options

	ExistentialFromNeeded: BOOLEAN = False
			-- Is a from clause in a selection statement required?
			-- It's better if you don't need it. Define
			-- `ExistentialFromTable' for a work around.

	ExistentialFromTable: STRING = "dual"
			-- For portability Postgres has this table. But you don't
			-- have to use it.


feature -- ansi niladic functions

	sqlsysfunction_system_user: STRING
		once
			Result := "CURRENT_USER"
		end

feature -- Strings

	sql_string_combine_separator: STRING = " || "

	sql_like_operator: STRING = "ilike"


feature -- Auto primary key

	sql_last_auto_generated_primary_key	(type: XPLAIN_TYPE): STRING
			-- Return code to get the last auto-generated primary
			-- key. It's not type specific.
		local
			sequence_name: STRING
		do
			if sequence_name_format_one_parameter then
				sequence_name := format (sequence_name_format, <<type.sqlpkname (Current)>>)
			else
				sequence_name := format (sequence_name_format, <<type.sqltablename (Current), type.sqlpkname (Current)>>)
			end
			-- type.sqltablename (Current) + "_" + type.sqlpkname (Current) + "_seq"
			Result := "currval("
			Result.append_string (as_string (sequence_name))
			Result.append_character (')')
		end


feature -- Stored procedures

	NamedParametersSupported: BOOLEAN
			-- Can stored procedures use named parameters?
			-- PostgreSQL does not support them.
		do
			Result := False
		end

	OutputParametersSupported: BOOLEAN = False
			-- PostgreSQL does not support them.


feature -- Write

	write_extend (extension: XPLAIN_EXTENSION)
			-- Code for extend statement.
		do
			if can_write_extend_as_view (extension) then
				create_extend_view (extension)
			else
				create_extend (extension)
			end
			-- no need to create index here as in precursor, done at
			-- different place.
		end


feature -- SQL creation statements

	create_echo (str: STRING)
			-- Output string while parsing sql script.
		do
			std.output.put_string ("%Nselect '")
			std.output.put_string (str)
			std.output.put_string ("'%N")
			std.output.put_string (CommandSeparator)
		end

	create_extend_create_table (extension: XPLAIN_EXTENSION)
		local
			s: STRING
		do
			if is_stored_procedure then
				-- We truncate the temporary table, if the table exists,
				-- as dropping the table does not seem to work.
				s := format (truncate_temporary_table_template, <<extension.sqlname (Current), extension.quoted_name (Current)>>)
				std.output.put_string (safe_sql (s))
			end
			precursor (extension)
			if is_stored_procedure then
				if CreateExtendIndex then
					create_extend_create_index (extension)
				end
				end_if
			end
		end

	create_init (type: XPLAIN_TYPE)
		local
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			function_name: STRING
		do
			std.output.put_character ('%N')
			sp_start (Void)
			function_name := quote_valid_identifier("fn_" + type.sqlname (Current) + "Init")
			std.output.put_string (function_name)
			std.output.put_string ("() returns trigger as ")
			std.output.put_string (plpgsql_block_demarcation)
			std.output.put_string ("%Nbegin%N")
			from
				cursor := type.new_init_attributes_cursor (Current)
				cursor.start
			until
				cursor.after
			loop
				if
					(attached cursor.item.init as init and then
					not init.is_literal) or else
					not cursor.item.is_init_default
				then
					std.output.put_string (Tab)
					std.output.put_string ("new.")
					std.output.put_string (cursor.item.q_sql_select_name (Current))
					std.output.put_string (" = ")
					std.output.put_string (sql_init_expression (cursor.item))
					std.output.put_string (CommandSeparator)
					std.output.put_character ('%N')
				end
				cursor.forth
			end
			std.output.put_string (Tab)
			std.output.put_string ("return new")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			sp_end
			std.output.put_string ("%Ncreate trigger ")
			std.output.put_string (quote_valid_identifier ("tr_" + type.sqlname (Current) + "Init"))
			std.output.put_string (" before insert on ")
			std.output.put_string (quote_identifier (type.sqltablename (Current)))
			std.output.put_string ("%N")
			std.output.put_string (Tab)
			std.output.put_string ("for each row execute procedure ")
			std.output.put_string (function_name)
			std.output.put_string ("()")
			std.output.put_string (CommandSeparator)
			std.output.put_string ("%N%N")
		end

	create_primary_key_generator (type: XPLAIN_TYPE)
		do
			-- Supported by serial data type.
		end

	create_select_function (selection_list: XPLAIN_SELECTION_FUNCTION)
		do
			if is_stored_procedure then
				sp_start_cursor
			end
			precursor (selection_list)
			if is_stored_procedure then
				sp_return_cursor
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			end
		end

	create_select_list (selection_list: XPLAIN_SELECTION_LIST)
		do
			if is_stored_procedure then
				sp_start_cursor
			end
			precursor (selection_list)
			if is_stored_procedure then
				sp_return_cursor
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			end
		end

	create_select_value_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL that returns the value when asked for that value
			-- inside a stored procedure.
		do
			sp_start_cursor
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("select ")
			std.output.put_string (a_value.quoted_name (Current))
			std.output.put_character ('%N')
			sp_return_cursor
		end

	create_sync_auto_generated_primary_key_with_supplied_value (type: XPLAIN_TYPE; user_identification: INTEGER)
			-- Update sequence. Perhaps can be done with trigger, but I'm
			-- not sure of that.
		local
			sequence_name: STRING
		do
			sequence_name := make_valid_identifier (type.sqltablename (Current) + "_" + type.sqlpkname (Current) + "_seq")
			std.output.put_string ("select setval('")
			std.output.put_string (quote_identifier (sequence_name))
			std.output.put_string ("', ")
			std.output.put_string (user_identification.out)
			std.output.put_string (")")
			std.output.put_string (CommandSeparator)
			std.output.put_string ("%N")
		end

	create_use_database (database: STRING)
			-- start using a certain database
		do
			-- not supported
		end

	create_value_declare_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit code to declare `a_value' inside a stored procedure.
		do
			-- Only emit declaration at top, redeclaration not supported.
			if in_user_declaration then
				std.output.put_string (Tab)
				std.output.put_string (a_value.quoted_name (Current))
				std.output.put_string (" ")
				std.output.put_string (a_value.representation.datatype (Current))
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			end
		end

	create_value_assign_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit code to assign `a_value'.`expression' to `a_value'
			-- inside a stored procedure.
		do
			std.output.put_string (a_value.quoted_name (Current))
			std.output.put_string (" := (")
			std.output.put_string (a_value.expression.sqlvalue (Current))
			std.output.put_character (')')
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end


feature -- drop statements

	drop_primary_key_generator (type: XPLAIN_TYPE)
		do
			-- not applicable
			-- 2004-01-16: No? See my todo.txt.
		end

	drop_table_if_exist (type: XPLAIN_TYPE)
			-- Generate a statement that drops this table, but only if it exists,
			-- No warning must be generated if the table does not exist at
			-- run-time. Works only inside stored procedures for PostgreSQL.
		local
			s: STRING
		do
			if is_stored_procedure then
				s := format (conditionally_drop_table_template, <<type.sqlname (Current), type.quoted_name (Current)>>)
				std.output.put_string (safe_sql (s))
			end
		end


feature -- type specification for Xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		once
			Result := "boolean"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		once
			-- datetime is for an earlier version??
			--Result := "datetime"
			if TimeZoneEnabled then
				Result := "timestamp with time zone"
			else
				Result := "timestamp"
			end
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- platform dependent approximate numeric data type
		once
			Result := "float8"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
		do
			inspect representation.length
			when 1 .. 4 then
				Result := "int2"
			when 5 .. 9 then
				Result := "int4"
			when 10 .. 17 then
				Result := "int8"
			else
				Result := "numeric(" + representation.length.out + ", 0)"
			end
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		once
			Result := "numeric(12,4)"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
		once
			Result := "text"
		end

	datatype_pk_int (representation: XPLAIN_PK_I_REPRESENTATION): STRING
		do
			if CreateAutoPrimaryKey then
				if representation.length < 10 then
					Result := AutoPrimaryKeyConstraint
				else
					Result := "serial8 primary key"
				end
			else
				Result := precursor (representation)
			end
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
		once
			Result := "text"
		end


feature -- Get a variable/value

	sqlgetvalue_inside_sp (value: XPLAIN_VALUE): STRING
			-- SQL expression that returns the value of a value inside a
			-- stored procedure
		do
			Result := value.quoted_name (Current)
		end


feature -- Identifiers

	quote_identifier (identifier: STRING): STRING
			-- return identifier, optionally surrounded by quotes if identifier
			-- contains spaces and rdbms supports spaces in identifiers
		local
			i: INTEGER
			c: CHARACTER
		do
			create Result.make (identifier.count + 2)
			Result.append_character ('"')
			if IdentifierWithSpacesEnabled then
				Result.append_string (identifier)
			else
				from
					i := 1
				until
					i > identifier.count
				loop
					c := identifier.item (i)
					if c = ' ' then
						Result.append_character ('_')
					else
						Result.append_character (c)
					end
					i := i + 1
				variant
					identifier.count - i + 1
				end
			end
			Result.append_character ('"')
		end


feature -- some support

	sql_select_function_limit_before (selection_list: XPLAIN_SELECTION_FUNCTION): STRING
			-- Code that limits a select to return a single value. Output
			-- is placed in front of the select statement.
			-- Returns empty for no output.
		once
			-- only after stuff
			Result := ""
		end

	sql_select_function_limit_after: STRING
			-- Code that limits a select to return a single value. Output
			-- is placed after the select statement.
			-- Returns empty for no output.
		once
			-- output LIMIT clause
			Result := "%N" + Tab + "limit 1%N"
		end


feature -- Stored procedure support

	plpgsql_block_demarcation: STRING
			-- What character(s) to use to start a plsql block
		once
			Result := "'"
		ensure
			not_void: Result /= Void
		end

	do_drop_procedure (name: STRING)
			-- Drop procedure `name', `name' is a valid sp identifier,
			-- and not yet quoted.
		do
			-- assume go before and after is not needed
			std.output.put_string ("drop function ")
			std.output.put_string (quote_identifier (name))
			-- @@BdB: must emit parameter list here!
			std.output.put_string ("()")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	sp_define_param_name (name: STRING): STRING
			-- Return `name' formatted as the name of the parameter as it
			-- appears in the header, and hopefully as it is known to
			-- clients.
		do
			Result := quote_identifier (no_space_identifier ("a_" + name))
		end

	sp_delete_declaration (
			type: XPLAIN_TYPE;
			param_name: STRING)
			-- Emit any declarations for `sp_delete_insert' between
			-- procedure header and body.
		do
			std.output.put_string ("declare%N")
			std.output.put_string (Tab)
			std.output.put_string (sp_define_param_name (param_name))
			std.output.put_string (" alias for $1")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	sp_end
			-- Write statements, if any, to end a stored procedure.
		do
			is_stored_procedure := False
			std.output.put_string ("end")
			std.output.put_string (CommandSeparator)
			std.output.put_string (plpgsql_block_demarcation)
			std.output.put_string ("%Nlanguage 'plpgsql'")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	sp_function_type_for_selection_list (selection: XPLAIN_SELECTION_LIST; an_emit_path: BOOLEAN): STRING
			-- The function type for output of a get statement.
			-- Required for PostgreSQL output.
		local
			e: detachable XPLAIN_EXPRESSION_NODE
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			my_attribute: XPLAIN_ATTRIBUTE
			s: STRING
		do
			create Result.make (128)
			if an_emit_path then
				s := "/"
				s.append_string (path_identifier (selection.subject.type.name))
				s.append_string (once "/@instance")
				Result.append_string (quote_identifier (s))
			else
				Result.append_string (selection.subject.type.q_sqlpkname (Current))
			end
			Result.append_character (' ')
			Result.append_string (selection.subject.type.representation.datatype (Current))
			e := selection.expression_list
			if not attached e then
				cursor := selection.subject.type.new_data_attributes_cursor (Current)
				from
					cursor.start
				until
					cursor.after
				loop
					my_attribute := cursor.item
					if CalculatedColumnsSupported or else not my_attribute.is_assertion then
						Result.append_string (once ", ")
						if an_emit_path then
							Result.append_string (once "%"/")
							Result.append_string (path_identifier (selection.subject.type.name))
							Result.append_character ('/')
							Result.append_string (path_identifier (my_attribute.full_name))
							Result.append_character ('"')
						else
							Result.append_string (my_attribute.q_sql_select_name (Current))
						end
						Result.append_character (' ')
						Result.append_string (my_attribute.abstracttype.representation.datatype (Current))
					end
					cursor.forth
				end
			elseif not selection.show_only_identifier_column then
				from
				until
					e = Void
				loop
					Result.append_string (once ", ")
					if an_emit_path then
						Result.append_string (once "%"/")
						Result.append_string (path_identifier (selection.subject.type.name))
						Result.append_character ('/')
						Result.append_string (path_identifier (e.path_name))
						Result.append_character ('"')
					else
						Result.append_string (quote_valid_identifier (e.column_name))
					end
					Result.append_character (' ')
					Result.append_string (e.item.exact_representation (Current).datatype (Current))
					e := e.next
				end
			end
		end

	sp_function_type_for_selection_value (a_column_name: STRING; representation: XPLAIN_REPRESENTATION; an_emit_path: BOOLEAN): STRING
			-- The function type for output of a get statement.
			-- Required for PostgreSQL output.
		do
			create Result.make (128)
			Result.append_character ('"')
			if an_emit_path then
				Result.append_character ('/')
			end
			Result.append_string (make_valid_identifier (a_column_name))
			Result.append_character ('"')
			Result.append_character (' ')
			Result.append_string (representation.datatype (Current))
		end

	sp_get_auto_generated_primary_key (type: XPLAIN_TYPE): STRING
			-- Statement that returns the generated primary key into the
			-- output parameters. Statement should end with CommandSeperator.
		do
			create Result.make (64)
			Result.append_string (once "return ")
			Result.append_string (sql_last_auto_generated_primary_key (type))
			Result.append_string (CommandSeparator)
		end

	sp_header_end
			-- Emit code to end stored procedure declaration. Many
			-- dialects have an "as" for example
		do
			std.output.put_string (" as " + plpgsql_block_demarcation + "%N")
		end

	sp_insert_declaration (
			type: XPLAIN_TYPE;
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE];
			has_input_parameters: BOOLEAN)
			-- Emit any declarations for `sp_create_insert' between
			-- procedure header and body.
		local
			i: INTEGER
			has_init: BOOLEAN
			param_name: STRING
		do
			if has_input_parameters then
				std.output.put_string ("declare%N")
				from
					i := 1
					cursor.start
				until
					cursor.after
				loop
					has_init :=
						cursor.item.init /= Void and then
						not cursor.item.is_init_default
					if not has_init then
						std.output.put_string (Tab)
						param_name := sp_define_param_name (cursor.item.abstracttype.sqlcolumnidentifier (Current, cursor.item.role))
						std.output.put_string (param_name)
						std.output.put_string (" alias for $")
						std.output.put_string (i.out)
						std.output.put_string (CommandSeparator)
						std.output.put_character ('%N')
						i := i + 1
					end
					cursor.forth
				end
			end
		end

	sp_return_cursor
			-- Code that returns all rows in a cursor to a client.
			-- Only one select statement is allowed per procedure.
			-- Statement should NOT end with a separator.
		require
			no_CommandSeparator: CommandSeparator.is_empty
		deferred
		ensure
			CommandSeperator_set: not CommandSeparator.is_empty
		end

	sp_start_cursor
			-- Code that starts a cursor for a select statement.
			-- Only one select statement is allowed per procedure.
		deferred
		ensure
			CommandSeparator_reset: CommandSeparator.is_empty
		end

	sp_type_name (a_procedure: XPLAIN_PROCEDURE): STRING
		require
			procedure_not_void: a_procedure /= Void
			procedure_returns_rows: a_procedure.returns_rows (Current)
		deferred
		ensure
			type_name_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_update_declaration (
			type: XPLAIN_TYPE;
			pk_param_name: STRING;
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE])
		local
			i: INTEGER
			param_name: STRING
		do
			std.output.put_string ("declare%N")
			std.output.put_string (Tab)
			std.output.put_string (sp_define_param_name (pk_param_name))
			std.output.put_string (" alias for $1")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			from
				i := 2
				cursor.start
			until
				cursor.after
			loop
				std.output.put_string (Tab)
				param_name := sp_define_param_name (cursor.item.abstracttype.sqlcolumnidentifier (Current, cursor.item.role))
				std.output.put_string (param_name)
				std.output.put_string (" alias for $")
				std.output.put_string (i.out)
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
				i := i + 1
				cursor.forth
			end
		end

	sp_user_declaration (procedure: XPLAIN_PROCEDURE)
			-- Emit value declarations.
		local
			parameter: XPLAIN_ATTRIBUTE_NAME
			i: INTEGER
		do
			std.output.put_string ("declare%N")
			if not NamedParametersSupported then
				-- Emit declarations for parameters
				from
					i := 1
					procedure.parameters.start
				until
					procedure.parameters.after
				loop
					std.output.put_string (Tab)
					parameter := procedure.parameters.item_for_iteration
					std.output.put_string (sp_define_param_name (parameter.sqlcolumnidentifier (Current)))
					std.output.put_string (" alias for $")
					std.output.put_string (i.out)
					std.output.put_string (CommandSeparator)
					std.output.put_character ('%N')
					i := i + 1
					procedure.parameters.forth
				end
			end

			-- Emit declarations for value statement
			in_user_declaration := True
			sp_value_declarations (procedure.statements)

			if not procedure.sql_declare.is_empty then
				std.output.put_string (procedure.sql_declare)
				std.output.put_character ('%N')
			end

			in_user_declaration := False

			-- declation for cursor should be done in descendants
		ensure then
			not_in_user_declaration: not in_user_declaration
		end


feature -- Literal

	as_string (s: STRING): STRING
			-- Return `s' as string by surrounding it with quotes. Makes
			-- sure `s' is properly quoted, so don't use together with
			-- `safe_string'!
		do
			if is_stored_procedure then
				-- The quote trick...
				Result := safe_string (precursor (s))
			else
				Result := precursor (s)
			end
		end


feature -- Extension specific methods

	extension_index_name (an_extension: XPLAIN_EXTENSION): STRING
			-- Name of index on temporary table to speed up join to that table
		do
			Result := quote_valid_identifier ("idx_" + an_extension.type.name + "_" + an_extension.name)
		end


feature {NONE} -- SQL parts

	end_if
			-- Emit end if
		do
			std.output.put_string ("end if")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	safe_sql (s: STRING): STRING
			-- ' characters in `s' are quoted if necessary
		do
			Result := safe_string (s)
		end


feature {NONE} -- PostgreSQL templates

	conditionally_drop_table_template: STRING = "if exists(select * from pg_class where relkind = 'r' and relname= '$s' and pg_table_is_visible (oid)) = 't' then%N%Tdrop table $s;%Nend if;%N";

	truncate_temporary_table_template: STRING = "if exists(select * from pg_class where relkind = 'r' and relname= '$s' and pg_table_is_visible (oid)) = 't' then%N%Tdelete from $s;%Nelse%N";


feature {NONE} -- Implementation

	in_user_declaration: BOOLEAN
			-- Is declaration of a variable inside a procedure permissble?

end
