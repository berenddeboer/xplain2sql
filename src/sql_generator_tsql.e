note

	description:
		"Parent class to produces output for Microsoft Transact SQL%
		%i.e. Microsoft SQL Server 7 (and 6.5)"

	author:		"Berend de Boer <berend@pobox.com>"
	copyright:	"Copyright (c) 1999, Berend de Boer"

	known_bugs:
		"1. A value can get out of scope earlier than wanted."

deferred class

	SQL_GENERATOR_TSQL

inherit

	SQL_GENERATOR_ADVANCED
		redefine
			CommandSeparator,
			IdentifierWithSpacesSupported,
			CreateDomainCheck,
			AutoPrimaryKeySupported,
			PrimaryKeyConstraint,
			AutoPrimaryKeyConstraint,
			StoredProcedureParamListStartRequired,
			TimestampSupported,
			ChecksNullAfterTrigger,
			ClusteredIndexSupported,
			ExistentialFromNeeded,
			SupportsJoinInUpdate,
			SQLTrue,
			SQLFalse,
			SupportsTrueBoolean,
			sql_string_combine_separator,
			create_assertion,
			create_constant,
			create_delete,
			create_domain,
			create_echo,
			create_extend,
			create_index,
			create_insert,
			create_select_value_outside_sp,
			create_table,
			create_value_declare_outside_sp,
			create_value_assign_outside_sp,
			drop_domain,
			drop_value,
			drop_constant,
			datatype_int,
			sqlcheck_notempty,
			sql_last_auto_generated_primary_key,
			domain_identifier,
			value_identifier,
			extension_name,
			output_update_from_clause,
			output_update_extend_from_clause,
			sql_expression_as_boolean_value,
			sql_infix_expression,
			sp_body_start,
			sp_define_param_name,
			sp_end,
			sp_return_parameter_format_string,
			sp_start,
			sqlgetvalue_outside_sp
		end


feature -- Command separation

	CommandSeparator: STRING once Result := "" end

	end_with_go
			-- some statements should terminate with go
		require
			cursor_start: -- we're at end of last generated line
		do
			std.output.put_string ("%Ngo%N")
		end

feature -- identifiers

	MaxTemporaryTableNameLength: INTEGER
		deferred
		end

	IdentifierWithSpacesSupported: BOOLEAN
		once
			Result := True
		end

feature -- domain options

	CreateDomainCheck: BOOLEAN
			-- the create rule is no longer supported by this converter
			-- the code is still there but needs to be patched a bit
			-- because it outputs wrong code
		once
			Result := False
		end

	RulePrefix: STRING = "Rule"


feature -- table options

	AutoPrimaryKeySupported: BOOLEAN once Result := True end

	PrimaryKeyConstraint: STRING
		once
			Result := "not null primary key nonclustered"
		end
	AutoPrimaryKeyConstraint: STRING
		once
			Result := "identity " + PrimaryKeyConstraint
		end

	TimestampSupported: BOOLEAN = True
			-- Does this dialect support the creation of time stamps in a table?


feature -- init [default] options

	ChecksNullAfterTrigger: BOOLEAN
			-- Does this dialect check for nulls in columns after a
			-- trigger has been fired?
		once
			-- Unfortunately it does not.
			Result := False
		end


feature -- index options

	ClusteredIndexSupported: BOOLEAN
			-- sql generator can create clustered indexes
		once
			Result := True
		end


feature -- Stored procedure options

	StoredProcedureParamListStartRequired: BOOLEAN = False
			-- True if start of a parameter list like '(' is required. It
			-- is for DB/2, it isn't for Oracle for example.


feature -- select options

	ExistentialFromNeeded: BOOLEAN = False
			-- Certain systems do not like a from clause in certain
			-- kinds of selects


feature -- update/delete options

	SupportsJoinInUpdate: BOOLEAN
			-- Does this dialect support a from clause in an update statement?
		do
			Result := True
		end


feature -- Booleans

	SQLTrue: STRING once Result := "1" end
	SQLFalse: STRING once Result := "0" end

	SupportsTrueBoolean: BOOLEAN
		do
			Result := False
		end


feature -- Strings

	sql_string_combine_separator: STRING = " + "


feature -- TransactSQL specific SQL creation statements

	create_assertion (an_assertion: XPLAIN_ASSERTION)
		do
			precursor (an_assertion)
			end_with_go
		end

	create_constant (variable: XPLAIN_VARIABLE)
		do
			precursor (variable)
			end_with_go
		end

	create_delete (subject: XPLAIN_SUBJECT; predicate: detachable XPLAIN_EXPRESSION)
			-- Emit Transact-SQL delete statement which supports joins in
			-- the delete statement itself.
		local
			join_list: JOIN_LIST
		do
			std.output.put_character ('%N')
			std.output.put_string ("delete from ")
			std.output.put_string (quote_identifier (subject.type.sqlname (Current)))
			create join_list.make (subject.type)
			if predicate /= Void then
				predicate.add_to_join (Current, join_list)
			end
			join_list.finalize (Current)

			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("from ")
			std.output.put_string (subject.type.quoted_name (Current))
			std.output.put_string (sql_select_joins (join_list))

			create_predicate (subject, predicate)
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_domain (base: XPLAIN_BASE)
		do
			std.output.put_string ("exec sp_addtype '")
			std.output.put_string (domain_identifier(base))
			std.output.put_string ("', '")
			std.output.put_string (base.representation.datatype(Current))
			std.output.put_string ("', '")
			if attached base.representation.domain_restriction as domain_restriction and then domain_restriction.required then
				std.output.put_string ("not null")
			else
				std.output.put_string ("null")
			end
			std.output.put_string ("'")
			std.output.put_string (CommandSeparator)
			end_with_go
			if CreateDomainCheck then
				if attached base.representation.domain_restriction as domain_restriction and then attached domain_restriction.sqldomainconstraint (Current, "@value") as s then
					std.output.put_string ("create rule ")
					std.output.put_string (rule_identifier(base))
					std.output.put_string (" as ")
					std.output.put_string (s)
					std.output.put_string (CommandSeparator)
					end_with_go
				end
			end
		end

	create_echo (str: STRING)
			-- output string while parsing sql script
		do
			std.output.put_string ("%Nprint '")
			std.output.put_string (str)
			std.output.put_string ("'%N")
		end

	create_extend (extension: XPLAIN_EXTENSION)
		local
			join_list: JOIN_LIST
			type: XPLAIN_TYPE
		do
			std.output.put_character ('%N')
			set_nocount_on

			-- build join statements (applies only to expression extension)
			create join_list.make (extension.type)
			extension.expression.add_to_join (Current, join_list)
			join_list.finalize (Current)

			std.output.put_string (once "select ")
			if extension.expression.sqlfromaliasname /= Void and then not extension.expression.sqlfromaliasname.is_empty then
				std.output.put_string (extension.expression.sqlfromaliasname)
			else
				std.output.put_string (quote_identifier (extension.type.sqlname (Current)))
			end
			std.output.put_string (".")
			std.output.put_string (quote_identifier (extension.type.sqlpkname (Current)))
			std.output.put_string (", ")
			std.output.put_string (extension.expression.outer_sqlvalue (Current))
			std.output.put_string (" as ")
			std.output.put_string (extension.q_sql_insert_name (Current, Void))
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("into ")
			std.output.put_string ( quote_identifier (extension.sqlname (Current)))
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("from ")
			std.output.put_string (quote_identifier (extension.type.sqlname (Current)))
			std.output.put_string (" ")
			if extension.expression.sqlfromaliasname /= Void then
				std.output.put_string (extension.expression.sqlfromaliasname)
			end
			std.output.put_string (sql_select_joins (join_list))
			std.output.put_character ('%N')
			if attached {XPLAIN_EXTENSION_FUNCTION_EXPRESSION} extension.expression as f then
				check attached f.per_property.last as last then
					type := last.item.type
				end
				std.output.put_string (Tab)
				std.output.put_string (once "group by%N")
				std.output.put_string (TabTab)
				if extension.expression.sqlfromaliasname /= Void then
					std.output.put_string (extension.expression.sqlfromaliasname)
				else
					std.output.put_string (extension.type.quoted_name (Current))
				end
				std.output.put_character ('.')
				std.output.put_string (extension.type.q_sqlpkname (Current))
			end
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')

			set_nocount_off
		end

	create_init (type: XPLAIN_TYPE)
		local
			join_list: JOIN_LIST
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			previous_line: BOOLEAN
		do
			std.output.put_character ('%N')
			end_with_go -- make sure this is the first command in the batch
			std.output.put_string ("create trigger ")
			std.output.put_string (quote_identifier (init_trigger_name (type)))
			std.output.put_string (" on ")
			std.output.put_string (quote_identifier (type.sqltablename(Current)))
			std.output.put_character ('%N')
			std.output.put_string ("for insert%N")
			-- probably also 'not for replication' (SQL Server 7 feature)
			std.output.put_string ("as%N")
			std.output.put_string (Tab)
			set_nocount_on
			std.output.put_string (Tab)
			std.output.put_string ("update ")
			std.output.put_string (quote_identifier (type.sqltablename(Current)))
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("  set%N")

			-- with T-SQL we can do joins in an update statements.
			-- While creating the list of columns to update, also build
			-- the join statements
			create join_list.make (type)
			cursor := type.new_init_attributes_cursor (Current)
			from
				cursor.start
			until
				cursor.after
			loop
				if attached cursor.item.init as init and then
					not init.is_literal then
					init.add_to_join (Current, join_list)
				end
				cursor.forth
			end
			join_list.finalize (Current)
			from
				cursor.start
				previous_line := False
			until
				cursor.after
			loop
				if not cursor.item.is_init_default then
					if attached cursor.item.init as init and then not init.is_literal then
						if previous_line then
							std.output.put_string (",")
							std.output.put_character ('%N')
						end
						std.output.put_string (Tab)
						std.output.put_string (Tab)
						if cursor.item.is_init_default then
							std.output.put_string (format ("$s = coalesce($s.$s, $s)", <<cursor.item.q_sql_select_name (Current), quote_identifier (type.sqltablename(Current)), cursor.item.q_sql_select_name (Current), init.outer_sqlvalue (Current)>>))
						else
							std.output.put_string (format ("$s = $s", <<cursor.item.q_sql_select_name (Current), init.outer_sqlvalue (Current)>>))
						end
						previous_line := True
					end
				end
				cursor.forth
			end
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("from inserted%N")
			std.output.put_string (Tab)
			std.output.put_string ("join ")
			std.output.put_string (quote_identifier (type.sqltablename(Current)))
			std.output.put_string (" on%N")
			std.output.put_string (Tab)
			std.output.put_string (Tab)
			std.output.put_string (quote_identifier (type.sqltablename(Current)))
			std.output.put_string (".")
			std.output.put_string (quote_identifier (type.sqlpkname(Current)))
			std.output.put_string (" = inserted.")
			std.output.put_string (quote_identifier (type.sqlpkname(Current)))
			if join_list.first /= Void then
				std.output.put_string (sql_select_joins (join_list))
			end

			std.output.put_string (CommandSeparator)
			end_with_go
		end

	create_index (index: XPLAIN_INDEX)
		do
			precursor (index)
			end_with_go
		end

	create_insert (type: XPLAIN_TYPE; id: detachable XPLAIN_EXPRESSION; assignment_list: XPLAIN_ASSIGNMENT_NODE)
		local
			auto_identifier: BOOLEAN
		do
			if is_stored_procedure then
				set_nocount_on
			end
			auto_identifier := id = Void
			if not auto_identifier and table_has_identity_column (type) then
				std.output.put_string ("%Nset identity_insert ")
				std.output.put_string (quote_identifier (type.sqltablename(Current)))
				std.output.put_string (" on")
			end
			precursor (type, id, assignment_list)
			if not auto_identifier and table_has_identity_column (type) then
				std.output.put_string ("set identity_insert ")
				std.output.put_string (quote_identifier (type.sqltablename(Current)))
				std.output.put_string (" off%N")
			end
			if is_stored_procedure then
				set_nocount_off
			end
		end

	create_primary_key_generator (type: XPLAIN_TYPE)
		do
			-- supported through identity constraint
		end

	frozen create_select_value_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL that returns the value when asked for that value
			-- inside a stored procedure.
		do
			do_create_select_value (a_value)
		end

	frozen create_select_value_outside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL that returns the value when asked for that value
			-- outside a stored procedure.
		do
			do_create_select_value (a_value)
		end

	do_create_select_value (a_value: XPLAIN_VALUE)
			-- Emit SQL that returns the value when asked for that value.
		do
			std.output.put_string ("select ")
			std.output.put_string (a_value.sqlname (Current))
			std.output.put_string (" as ")
			std.output.put_string (quote_identifier (a_value.name))
		end

	create_table (type: XPLAIN_TYPE)
		do
			precursor (type)
			end_with_go
		end

	create_use_database (database: STRING)
			-- Use a database.
		do
			-- need two uses, bug somewhere in SQL Server 6.5??
			-- haven't tested if this occurs with 7.0 also.
			-- for tsql 7.0 quoted identifiers are enabled, because if
			-- you use brackets in sql code your code would be less portable.
			std.output.put_string ("use ")
			std.output.put_string (database)
			std.output.put_string (CommandSeparator)
			end_with_go
			std.output.put_string ("use ")
			std.output.put_string (database)
			std.output.put_string (CommandSeparator)
			end_with_go
			std.output.put_string ("set ansi_null_dflt_on on%N")
			std.output.put_string ("set quoted_identifier on")
			end_with_go
			std.output.put_character ('%N')
		end

	frozen create_value_declare_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL code to declare `a_value' inside a stored procedure.
		do
			do_create_value_declare (a_value)
		end

	frozen create_value_declare_outside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL code to declare `a_value' outside a stored procedure.
		do
			do_create_value_declare (a_value)
		end

	do_create_value_declare (a_value: XPLAIN_VALUE)
			-- Emit SQL code to declare `a_value'.
		require
			value_not_void: a_value /= Void
			not_declared: not is_value_declared (a_value)
		do
			-- Great, Transact SQL doesn't make any difference between
			-- procedural and non-procedural code.
			std.output.put_character ('%N')
			std.output.put_string ("declare%N")
			std.output.put_string (Tab)
			std.output.put_string (value_identifier (a_value))
			std.output.put_character (' ')
			std.output.put_string (a_value.expression.representation (Current).datatype (Current))
			std.output.put_character ('%N')
			std.output.put_character ('%N')
		end

	frozen create_value_assign_inside_sp (a_value: XPLAIN_VALUE)
			-- Assign a value to `a_value' inside a stored procedure.
		do
			do_create_value_assign (a_value)
		end

	frozen create_value_assign_outside_sp (a_value: XPLAIN_VALUE)
			-- Assign a value to `a_value' outside a stored procedure.
		do
			do_create_value_assign (a_value)
		end

	do_create_value_assign (a_value: XPLAIN_VALUE)
			-- Assign a value to `a_value'.
		require
			value_not_void: a_value /= Void
			declared: is_value_declared (a_value)
		do
			set_nocount_on
			std.output.put_string ("select ")
			std.output.put_string (value_identifier (a_value))
			std.output.put_string (" = (")
			std.output.put_string (a_value.expression.outer_sqlvalue (Current))
			std.output.put_character (')')
			std.output.put_character ('%N')
			set_nocount_off
		end


feature -- drop statements

	drop_domain (base: XPLAIN_BASE)
		do
			std.output.put_character ('%N')
			std.output.put_string ("exec sp_droptype ")
			std.output.put_string (domain_identifier(base))
			std.output.put_string (CommandSeparator)
			end_with_go
		end

	drop_primary_key_generator (type: XPLAIN_TYPE)
		do
			-- nothing
		end

	drop_value (a_value: XPLAIN_VALUE)
		do
			-- values are automatically dropped at end of session
			declared_values.remove (a_value.name)
		end

	drop_constant (a_constant: XPLAIN_VARIABLE)
			-- Drop a constant, not supported on SQL Server 6.5.
		do
			precursor (a_constant)
			end_with_go
		end

feature -- type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		once
			Result := "bit"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		once
			Result := "datetime"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- platform dependent approximate numeric data type
		once
			Result := "float(15)"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
		do
			inspect representation.length
			when 1 .. 2 then
				Result := "tinyint"
			when 3 .. 4 then
				Result := "smallint"
			when 5 .. 9 then
				Result := "integer"
			else
				if representation.length > max_numeric_precision then
					std.error.put_string ("Too large integer representation detected: ")
					std.error.put_integer (representation.length)
					std.error.put_string ("%NRepresentation truncated to ")
					std.error.put_integer (max_numeric_precision)
					std.error.put_character ('%N')
					Result := "numeric(" + max_numeric_precision.out + ", 0)"
				else
					Result := "numeric(" + representation.length.out + ", 0)"
				end
			end
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		once
			Result := "money"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
		once
			Result := "image"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
		once
			Result := "text"
		end


feature -- constraints

	sqlcheck_notempty (a_pattern: XPLAIN_DOMAIN_RESTRICTION; column_name: STRING): STRING
		local
			s: STRING
		do
			s := "(ltrim("
			s := s + column_name + ") <> ''"
			s := s + ")"
			result := s
		end

feature -- Select certain things

	sqlgetvalue_inside_sp (value: XPLAIN_VALUE): STRING
			-- SQL expression that returns the value of a value inside a
			-- stored procedure
		do
			Result := value.sqlname (Current)
		end

	sqlgetvalue_outside_sp (value: XPLAIN_VALUE): STRING
			-- SQL expression that returns the value of a value outside a
			-- stored procedure
		do
			Result := value.sqlname (Current)
		end

	sql_last_auto_generated_primary_key	(type: XPLAIN_TYPE): STRING
			-- Return code to get the last auto-generated primary
			-- key. For TSQL this is not type specific.
		once
			Result := "@@identity"
		end


feature -- domain specific methods

	domain_identifier (base: XPLAIN_BASE): STRING
		local
			s: STRING
		do
			s := DomainNamePrefix + base.name
			s := no_space_identifier (s)
			Result := s
		end

	rule_identifier (base: XPLAIN_BASE): STRING
		local
			s: STRING
		do
			s := RulePrefix + base.name
			Result := make_valid_identifier (s)
		end

feature -- table specific methods

	table_has_identity_column (type: XPLAIN_TYPE): BOOLEAN
			-- return True if primary key of this table has identity constraint
		do
			Result :=
				CreateAutoPrimaryKey and
				type.representation.is_integer
		end


feature -- trigger names

	init_trigger_name (type: XPLAIN_TYPE): STRING
		do
			Result := "tr_" + type.sqlname(Current) + "Init"
		end

feature -- value specific methods

	value_identifier (value: XPLAIN_VALUE): STRING
		do
			Result := no_space_identifier ("@" + value.name)
		end

feature -- Extension

	extension_name (extension: XPLAIN_EXTENSION): STRING
			-- Return name of temporary table.
		local
			s: STRING
		do
			s := "#" + extension.type.name + "." + extension.name
			if s.count > MaxTemporaryTableNameLength then
				Result := s.substring (1, MaxTemporaryTableNameLength)
			else
				Result := s
			end
		end

	output_update_from_clause (a_subject: XPLAIN_SUBJECT; a_join_list: JOIN_LIST)
			-- Some dialects support a from + join clause in an update
			-- statement. This gives that dialects a chance to write that
			-- clause so updates can refer to any attribute without using
			-- subselects. For Transact-SQL that's good for the performance.
		do
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("from ")
			std.output.put_string (a_subject.type.quoted_name (Current))
			std.output.put_string (sql_select_joins (a_join_list))
		end

	output_update_extend_from_clause (a_subject: XPLAIN_SUBJECT; a_join_list: JOIN_LIST)
			-- Some dialects support a from + join clause in an update
			-- statement. This gives that dialects a chance to write that
			-- clause so updates of an extended attribute can use any
			-- data colum (perhaps not other extended columns).
			-- This is the from clause for the update of an extended attribute.
		do
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("from ")
			std.output.put_string (a_subject.type.quoted_name (Current))
			std.output.put_string (sql_select_joins (a_join_list))
		end


feature -- Return sql code

	sql_expression_as_boolean_value (expression: XPLAIN_EXPRESSION): STRING
			-- Return SQL code for extension that is a logical
			-- expression. For SQL dialects that don't support Booleans,
			-- it might need to map the Boolean result to a 'T' or 'F'
			-- value.
		do
			Result := format ("case when $s then 1 else 0 end", <<expression.sqlvalue (Current)>>)
		end

	sql_infix_expression (a_left: XPLAIN_EXPRESSION; an_operator: STRING; a_right: XPLAIN_EXPRESSION): STRING
		local
			text_column: BOOLEAN
			sql_operator: STRING
		do
			text_column :=
				a_left.exact_representation (Current).domain.is_equal (once_domain_t) or else
				a_right.exact_representation (Current).domain.is_equal (once_domain_t)
			if text_column then
				if an_operator.is_equal (once_equal) then
					sql_operator := "like"
				elseif an_operator.is_equal (once_not_equal) then
					sql_operator := "not like"
				else
					std.error.put_string ("Warning: Attempt to use the '" + an_operator + "' operator on a text column. " + target_name + " does not support this.%N")
					sql_operator := an_operator
				end
				Result := precursor (a_left, sql_operator, a_right)
			else
				Result := precursor (a_left, an_operator, a_right)
			end
		end


feature -- stored procedure names and parameter conventions

	sp_body_start
			-- Begin a procedure body.
			-- Should leave cursor on a new line.
		do
			std.output.put_character ('%N')
		end

	sp_define_param_name (name: STRING): STRING
			-- TSQL parameters are prefixed with a '@'.
		do
			Result := "@" + no_space_identifier (name)
		end

	sp_end
		do
			is_stored_procedure := False
			end_with_go
		end

	sp_get_auto_generated_primary_key (type: XPLAIN_TYPE): STRING
		do
			create Result.make (64)
			Result.wipe_out
			-- don't send count for this statement
			Result.append_string ("set nocount on%N")
			Result.append_string (Tab)
			Result.append_string ("select ")
			Result.append_string (sp_use_param (type.sqlpkname (Current)))
			Result.append_string (" = ")
			Result.append_string (sql_last_auto_generated_primary_key (type))
		end

	sp_return_parameter_format_string: STRING
			-- Format a parameter as a return parameter.
		once
			Result := "$s $s output"
		end

	sp_start (a_procedure: detachable XPLAIN_PROCEDURE)
		do
			std.output.put_character ('%N')
			end_with_go -- make sure this is the first command in the batch
			precursor (a_procedure)
		end

feature -- TSQL specific settings

	set_nocount_on
		do
			std.output.put_string (once_nocount_on)
		end

	set_nocount_off
		do
			std.output.put_string (once_nocount_off)
		end


feature {NONE} -- Once strings

	once_domain_t: STRING = "(T)"
	once_nocount_on: STRING = "set nocount on%N"
	once_nocount_off: STRING = "set nocount off%N"
	once_equal: STRING = "="
	once_not_equal: STRING = "<>"


end
