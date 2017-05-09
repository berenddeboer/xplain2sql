note

	description:

		"SQL generator which has stored procedure support"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"


deferred class

	SQL_GENERATOR_WITH_SP


inherit

	SQL_GENERATOR
		redefine
			create_select_value,
			create_value_assign,
			create_value_declare,
			drop_table,
			drop_value,
			sqlgetvalue,
			write_type,
			can_write_extend_as_view
		end


feature -- Supports

	NamedParametersSupported: BOOLEAN
			-- Can stored procedures use named parameters?
		once
			Result := True
		end

	OutputParametersSupported: BOOLEAN
			-- Does this dialect support output parametesr?
		once
			Result := True
		end

	SupportsDomainsInStoredProcedures: BOOLEAN
			-- Notably InterBase 4 supports domains, but not as the type of
			-- parameters in a stored procedure.
		do
			Result := DomainsSupported
		end

	StoredProcedureSupported: BOOLEAN
			-- Are stored procedures supported?
		once
			Result := True
		end

	StoredProcedureUserDeclarationBeforeBody: BOOLEAN
			-- Must any value and other declarations be put before the
			-- procedure body begins?
			-- I.e. this is before the "begin" statement usually.
		do
			Result := True
		end

	StoredProcedureSupportsTrueFunction: BOOLEAN
			-- Can a stored procedure return a value as a scalar value
			-- instead of as a set?
		do
			Result := False
		end


feature -- SQL pieces for stored procedures

	StoredProcedureParamListStart: STRING
			-- Zero or more characters denoting start of list of parameters.
		do
			Result := " ("
		ensure
			valid_result: Result /= Void
		end

	StoredProcedureParamListStartRequired: BOOLEAN
			-- True if start of a parameter list like '(' is required. It
			-- is for DB/2, it isn't for Oracle for example.
		do
			Result := True
		end

	StoredProcedureParamListEnd: STRING
			-- Zero or more characters denoting end of list of parameters.
		do
			Result := ")"
		ensure
			valid_result: Result /= Void
		end

	StoredProcedureReturnParamListStart: STRING
			-- Code to emit for the output parameters (always last), use
			-- in case return parameters are a separate section.
		do
			Result := ""
		ensure
			valid_result: Result /= Void
		end


feature -- What to create

	CreateStoredProcedure: BOOLEAN
			-- Should insert/update or delete stored procedures be
			-- created?
		do
			Result := StoredProcedureEnabled
		ensure then
			definition: Result = StoredProcedureEnabled
		end


feature -- Convert Xplain definition to sql, you usually do not redefine these

	write_procedure (procedure: XPLAIN_PROCEDURE)
			-- Write a stored procedure.
		do
			conditional_drop_procedure (procedure.sqlname (Current))
			if CoalesceSupported then
				procedure.optimize_statements
			end
			create_procedure (procedure)
			procedure.warn_about_unused_parameters
		end

	write_type (type: XPLAIN_TYPE)
		do
			precursor (type)
			if CreateStoredProcedure then
				-- Insert a blank line
				std.output.put_character ('%N')
				create_sp_insert (type)
				if type.has_updatable_attributes then
					std.output.put_character ('%N')
					create_sp_update (type)
				end
				std.output.put_character ('%N')
				create_sp_delete (type)
			end
		ensure then
			procedure_not_started: not is_stored_procedure
		end


feature -- create SQL for Xplain constructs

	create_procedure (procedure: XPLAIN_PROCEDURE)
			-- Output code for a user defined stored procedure.
		require
			procedure_not_void: procedure /= Void
			sp_not_started: not is_stored_procedure
		local
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE_NAME]
			param_name: STRING
			save_declared_values: like declared_values
		do
			save_declared_values := declared_values
			create declared_values.make (8)
			sp_start (procedure)
			std.output.put_string (procedure.quoted_name (Current))

			-- parameters
			if procedure.parameters.count > 0 or else StoredProcedureParamListStartRequired then
				std.output.put_string (StoredProcedureParamListStart)
				std.output.put_character ('%N')
			end
			cursor := procedure.parameters.new_cursor
			from
				cursor.start
			until
				cursor.after
			loop
				std.output.put_string (Tab)
				if NamedParametersSupported then
					param_name := sp_define_in_param (cursor.item.abstracttype.sqlcolumnidentifier (Current, cursor.item.role))
					std.output.put_string (param_name)
					std.output.put_string (" ")
				end
				if SupportsDomainsInStoredProcedures then
					std.output.put_string (cursor.item.abstracttype.columndatatype (Current))
				else
					std.output.put_string (cursor.item.abstracttype.representation.datatype (Current))
				end
				cursor.forth
				if not cursor.after then
					std.output.put_string (",%N")
				end
			end
			if procedure.parameters.count > 0 or else StoredProcedureParamListStartRequired then
				std.output.put_string (StoredProcedureParamListEnd)
			end
			sp_result_parameter (procedure)
			sp_user_result (procedure)
			sp_header_end
			if StoredProcedureUserDeclarationBeforeBody then
				sp_user_declaration (procedure)
			end
			sp_body_start
			if not StoredProcedureUserDeclarationBeforeBody then
				sp_user_declaration (procedure)
			end

			sp_body_statements (procedure)

			-- got it
			sp_end
			std.output.put_character ('%N')

			-- cleanup
			procedure.cleanup_after_write
			-- We can remove all declared values
			declared_values := save_declared_values
		ensure
			sp_finished: not is_stored_procedure
			declared_values_not_changed: declared_values.is_equal (old declared_values.twin)
		end

	frozen create_select_value (a_value: XPLAIN_VALUE)
			-- Xplain value statement that returns the value of `a_value'.
		do
			if is_stored_procedure then
				create_select_value_inside_sp (a_value)
			else
				create_select_value_outside_sp (a_value)
			end
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	frozen create_value_declare (a_value: XPLAIN_VALUE)
			-- Emit code to declare the value if it does not already
			-- exist. If it exists and its data type is changed,
			-- redeclare it.
		do
			if is_stored_procedure then
				create_value_declare_inside_sp (a_value)
			else
				create_value_declare_outside_sp (a_value)
			end
			declared_values.force (a_value, a_value.name)
		end

	frozen create_value_assign (a_value: XPLAIN_VALUE)
		do
			if is_stored_procedure then
				create_value_assign_inside_sp (a_value)
			else
				create_value_assign_outside_sp (a_value)
			end
		end


feature -- create stored procedures

	create_sp_delete (type: XPLAIN_TYPE)
		require
			allow_sp_delete: CreateStoredProcedure
			procedure_not_started: not is_stored_procedure
		local
			param_name,
			ts_param_name: STRING
		do
			-- sp header
			sp_start (Void)
			std.output.put_string (quote_identifier (sp_delete_name (type)))
			std.output.put_string (StoredProcedureParamListStart)
			std.output.put_character ('%N')

			-- write sp parameters
			param_name := type.sqlpkname (Current)
			if CreateTimestamp then
				ts_param_name := table_ts_name (type)
			else
				ts_param_name := "" -- silence compiler
			end
			std.output.put_string (Tab)
			if NamedParametersSupported then
				std.output.put_string (sp_define_in_param (param_name))
				std.output.put_string (" ")
			end
			std.output.put_string (type.representation.datatype (Current))
			if CreateTimestamp then
				std.output.put_string (",%N")
				std.output.put_string (Tab)
				std.output.put_string (sp_define_in_param (ts_param_name))
				std.output.put_string (" timestamp")
			end
			std.output.put_string (StoredProcedureParamListEnd)
			sp_result_parameter (Void)
			sp_header_end
			sp_delete_declaration (type, param_name)
			sp_body_start

			-- actual delete statement
			std.output.put_string (Tab)
			std.output.put_string ("delete from ")
			std.output.put_string (quote_identifier (type.sqltablename (Current)))
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("where%N")
			std.output.put_string (Tab)
			std.output.put_string (Tab)
			std.output.put_string (quote_identifier (type.sqlpkname (Current)))
			std.output.put_string (" = ")
			std.output.put_string (sp_use_param (param_name))
			if CreateTimestamp then
				std.output.put_string (" and%N")
				std.output.put_string (Tab)
				std.output.put_string (Tab)
				std.output.put_string ("( (")
				std.output.put_string (sp_use_param (ts_param_name))
				std.output.put_string (" is Null) or tsequal(")
				std.output.put_string (quote_identifier (table_ts_name (type)))
				std.output.put_string (", ")
				std.output.put_string (sp_use_param (ts_param_name))
				std.output.put_string (") )")
			end
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')

			sp_before_end_delete
			sp_end
		end

	create_sp_insert (type: XPLAIN_TYPE)
		require
			valid_type: type /= Void
			allow_sp_insert: CreateStoredProcedure
			procedure_not_started: not is_stored_procedure
		local
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			pk_param_name,
			param_name: STRING
			need_comma: BOOLEAN
			has_init: BOOLEAN
			has_input_parameters: BOOLEAN
		do
			-- sp header
			sp_start (Void)
			std.output.put_string (quote_identifier (sp_insert_name (type)))

			-- write sp parameters
			pk_param_name := type.sqlpkname(Current)
			cursor := type.new_data_attributes_cursor (Current)
			from
				need_comma := False
				cursor.start
			until
				cursor.after
			loop
				has_init :=
					cursor.item.init /= Void and then
					not cursor.item.is_init_default
				if not has_init then
					if not has_input_parameters then
						-- First parameter we write
						std.output.put_string (StoredProcedureParamListStart)
						std.output.put_character ('%N')
					end
					has_input_parameters := True
					if need_comma then
						std.output.put_string (",%N")
					else
						need_comma := True
					end
					std.output.put_string (Tab)
					if NamedParametersSupported then
						param_name := sp_define_in_param (cursor.item.abstracttype.sqlcolumnidentifier (Current, cursor.item.role))
						std.output.put_string (param_name)
						std.output.put_string (" ")
					end
					if SupportsDomainsInStoredProcedures then
						std.output.put_string (cursor.item.abstracttype.columndatatype (Current))
					else
						std.output.put_string (cursor.item.abstracttype.representation.datatype (Current))
					end
				end
				cursor.forth
			end

			-- pk parameter
			if OutputParametersSupported then
				if type.has_auto_pk (Current) then
					if	StoredProcedureReturnParamListStart.is_empty then
						if need_comma then
							std.output.put_string(",%N")
						end
						if not has_input_parameters then
							-- First parameter we write
							std.output.put_string (StoredProcedureParamListStart)
							std.output.put_character ('%N')
						end
					else
						if has_input_parameters then
							std.output.put_string (StoredProcedureParamListEnd)
						end
						std.output.put_string (StoredProcedureReturnParamListStart)
					end
				else
					-- no auto pk, so not a return parameter
					if need_comma then
						std.output.put_string(",%N")
					end
					if not has_input_parameters then
						-- First parameter we write
						std.output.put_string (StoredProcedureParamListStart)
						std.output.put_character ('%N')
						has_input_parameters := True
					end
				end
				std.output.put_string (Tab)
				if type.has_auto_pk (Current) then
					if NamedParametersSupported then
						std.output.put_string (format (sp_return_parameter_format_string, <<sp_define_out_param (pk_param_name), type.representation.datatype (Current)>>))
					else
						std.output.put_string (type.representation.datatype (Current))
					end
				else
					if NamedParametersSupported then
						std.output.put_string (sp_define_out_param (pk_param_name))
						std.output.put_string (" ")
					end
					std.output.put_string (type.representation.datatype (Current))
				end
			end
			-- An insert stored procedure always has a parameter, except
			-- in one case: all attributes have an init value and the
			-- dialect does not support output parameters. That last one
			-- is a trick, because we use a function result to return the
			-- identifier. This can only happen with PostgreSQL.
			if OutputParametersSupported then
				std.output.put_string (StoredProcedureParamListEnd)
				sp_result_parameter (Void)
			else
				if
					not has_input_parameters and then
					StoredProcedureParamListStartRequired
				then
					std.output.put_string (StoredProcedureParamListStart)
				end
				if
					has_input_parameters or else
					StoredProcedureParamListStartRequired
				then
					std.output.put_string (StoredProcedureParamListEnd)
				end
				-- PostgreSQL specific result for insert procedures.
				std.output.put_string (" returns integer")
			end
			sp_header_end
			sp_insert_declaration (type, cursor, has_input_parameters)
			sp_body_start

			-- actual insert statement
			std.output.put_string (Tab)
			std.output.put_string ("insert into ")
			std.output.put_string (quote_identifier(type.sqltablename(Current)))
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string (Tab)
			if has_input_parameters then
				std.output.put_character ('(')
				cursor := type.new_data_attributes_cursor (Current)
				from
					need_comma := False
					cursor.start
				until
					cursor.after
				loop
					has_init :=
						cursor.item.init /= Void and then
						not cursor.item.is_init_default
					if not has_init then
						if need_comma then
							std.output.put_string(", ")
						else
							need_comma := True
						end
						std.output.put_string (quote_identifier(cursor.item.abstracttype.sqlcolumnidentifier (Current, cursor.item.role)))
					end
					cursor.forth
				end

				-- pk parameter
				if not type.has_auto_pk (Current) then
					if need_comma then
						std.output.put_string(", ")
					end
					std.output.put_string (type.q_sqlpkname(Current))
				end

				std.output.put_character (')')
				std.output.put_character ('%N')
				std.output.put_string (Tab)
				std.output.put_string ("values")
				std.output.put_character ('%N')
				std.output.put_string (Tab)
				std.output.put_string (Tab)
				std.output.put_character ('(')
				cursor := type.new_data_attributes_cursor (Current)
				from
					need_comma := False
					cursor.start
				until
					cursor.after
				loop
					has_init :=
						cursor.item.init /= Void and then
						not cursor.item.is_init_default
					if not has_init then
						if need_comma then
							std.output.put_string(", ")
						else
							need_comma := True
						end
						param_name := sp_use_param (cursor.item.abstracttype.sqlcolumnidentifier (Current, cursor.item.role))
						std.output.put_string (param_name)
					end
					cursor.forth
				end

				-- pk parameter
				if not type.has_auto_pk (Current) then
					if need_comma then
						std.output.put_string(", ")
					end
					std.output.put_string (sp_use_param (pk_param_name))
				end

				std.output.put_character (')')

			else
				-- nothing to insert
				if SupportsDefaultValues then
					std.output.put_string ("default values")
				else
					-- For now this is DB2/Oracle/MySQL specific...
					cursor := type.attributes.new_cursor
					std.output.put_string ("values (default")
					from
						cursor.start
					until
						cursor.after
					loop
						std.output.put_string (", default")
						cursor.forth
					end
					std.output.put_character (')')
				end
			end

			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')

			-- return value
			if type.has_auto_pk (Current) then
				std.output.put_string (Tab)
				std.output.put_string (sp_get_auto_generated_primary_key (type))
				std.output.put_character ('%N')
			end

			sp_end
		end

	create_sp_update (type: XPLAIN_TYPE)
		require
			valid_type: type /= Void
			allow_sp_update: CreateStoredProcedure
			procedure_not_started: not is_stored_procedure
		local
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			pk_param_name,
			ts_param_name,
			param_name: STRING
		do
			-- sp header
			sp_start (Void)
			std.output.put_string (quote_identifier(sp_update_name (type)))
			std.output.put_string (StoredProcedureParamListStart)
			std.output.put_character ('%N')

			-- write sp parameters
			std.output.put_string (Tab)
			pk_param_name := type.sqlpkname(Current)
			if CreateTimestamp then
				ts_param_name := table_ts_name (type)
			else
				ts_param_name := "" -- silence compiler
			end
			if NamedParametersSupported then
				std.output.put_string (sp_define_in_param (pk_param_name))
				std.output.put_string (" ")
			end
			std.output.put_string (type.representation.datatype(Current))
			from
				cursor := type.new_data_attributes_cursor (Current)
				cursor.start
			until
				cursor.after
			loop
				std.output.put_string(",%N")
				std.output.put_string (Tab)
				if NamedParametersSupported then
					param_name := sp_define_in_param (cursor.item.abstracttype.sqlcolumnidentifier (Current, cursor.item.role))
					std.output.put_string (param_name)
					std.output.put_string (" ")
				end
				if SupportsDomainsInStoredProcedures then
					std.output.put_string (cursor.item.abstracttype.columndatatype(Current))
				else
					std.output.put_string (cursor.item.abstracttype.representation.datatype(Current))
				end
				cursor.forth
			end
			if CreateTimestamp then
				std.output.put_string (",%N")
				std.output.put_string (Tab)
				std.output.put_string (sp_define_in_param (ts_param_name))
				std.output.put_string (" timestamp")
			end
			std.output.put_string (StoredProcedureParamListEnd)
			sp_result_parameter (Void)
			sp_header_end
			sp_update_declaration (type, pk_param_name, cursor)
			sp_body_start

			-- actual update statement
			-- make sure to skip updating the primary key when key's are inherited
			std.output.put_string (Tab)
			std.output.put_string ("update ")
			std.output.put_string (quote_identifier(type.sqltablename(Current)))
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("set%N")
			from
				cursor := type.new_data_attributes_cursor (Current)
				cursor.start
			until
				cursor.after
			loop
				if not cursor.is_first then
					std.output.put_string(",%N")
				end
				std.output.put_string (Tab)
				std.output.put_string (Tab)
				std.output.put_string (quote_identifier (cursor.item.abstracttype.sqlcolumnidentifier (Current, cursor.item.role)))
				std.output.put_string (" = ")
				param_name := sp_use_param (cursor.item.abstracttype.sqlcolumnidentifier (Current, cursor.item.role))
				std.output.put_string (param_name)
				cursor.forth
			end
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("where%N")
			std.output.put_string (Tab)
			std.output.put_string (Tab)
			std.output.put_string (quote_identifier(type.sqlpkname(Current)))
			std.output.put_string (" = ")
			std.output.put_string (sp_use_param (pk_param_name))
			if CreateTimestamp then
				std.output.put_string (" and%N")
				std.output.put_string (Tab)
				std.output.put_string (Tab)
				std.output.put_string ("( (")
				std.output.put_string (sp_use_param (ts_param_name))
				std.output.put_string (" is Null) or tsequal(")
				std.output.put_string (quote_identifier (table_ts_name (type)))
				std.output.put_string (", ")
				std.output.put_string (sp_use_param (ts_param_name))
				std.output.put_string (") )")
			end
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')

			sp_before_end_update
			sp_end
		end

	sp_function_type_for_selection (selection: XPLAIN_SELECTION; an_emit_path: BOOLEAN): STRING
			-- The function type for output of a get statement.
			-- Required for PostgreSQL output.
		require
			selection_not_void: selection /= Void
		do
			Result := selection.sp_function_type (Current, an_emit_path)
		ensure
			function_type_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_function_type_for_selection_list (selection: XPLAIN_SELECTION_LIST; an_emit_path: BOOLEAN): STRING
			-- The function type for output of a get statement.
			-- Required for PostgreSQL output.
		require
			selection_not_void: selection /= Void
		do
			-- Implement in PostgreSQL
			Result := ""
		ensure
			function_type_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_function_type_for_selection_value (a_column_name: STRING; a_representation: XPLAIN_REPRESENTATION; an_emit_path: BOOLEAN): STRING
			-- The function type for output of a get statement.
			-- Required for PostgreSQL output.
		require
			column_name_not_empty: a_column_name /= Void and then not a_column_name.is_empty
			representation_not_void: a_representation /= Void
		do
			-- Implement in PostgreSQL
			Result := ""
		ensure
			function_type_not_empty: Result /= Void and then not Result.is_empty
		end


feature -- SQL parts

	frozen sqlgetvalue (a_value: XPLAIN_VALUE): STRING
			-- SQL expression to retrieve the value of a value
		do
			if is_stored_procedure then
				Result := sqlgetvalue_inside_sp (a_value)
			else
				Result := sqlgetvalue_outside_sp (a_value)
			end
		end


feature -- SQL code inside procedures

	conditional_drop_procedure (name: STRING)
			-- Drop procedure, but only if it exists, should never
			-- generate an error or warning.
		require
			name_not_empty: name /= Void and then not name.is_empty
			name_is_valid_sp_identifier: make_valid_sp_identifier (name).is_equal (name)
		do
			-- no support by default
		end

	create_select_value_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL that returns the value when asked for that value
			-- inside a stored procedure.
			-- We can assume the value is declared inside the stored
			-- procedure, although this is not verified yet.
			-- Should not emit `CommandSeparator'.
		require
			valid_value: a_value /= Void
			declared: is_value_declared (a_value)
			inside_sp: is_stored_procedure
		deferred
		end

	create_value_declare_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL code to declare `a_value' inside a stored procedure.
		require
			value_not_void: a_value /= Void
			not_declared: not is_value_declared (a_value)
			inside_sp: is_stored_procedure
		deferred
		end

	create_value_assign_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit code to assign `a_value'.`expression' to `a_value'
			-- inside a stored procedure.
		require
			value_not_void: a_value /= Void
			declared: is_value_declared (a_value)
			inside_sp: is_stored_procedure
		deferred
		end

	sqlgetvalue_inside_sp (a_value: XPLAIN_VALUE): STRING
			-- SQL expression that returns the value of a value inside a
			-- stored procedure
		require
			valid: a_value /= Void
			inside_sp: is_stored_procedure
		deferred
		ensure
			sql_not_empty: Result /= Void and then not Result.is_empty
		end

	do_drop_procedure (a_name: STRING)
			-- Drop procedure `a_name', `a_name' is a valid sp identifier,
			-- and not yet quoted.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
			name_is_valid_sp_identifier: make_valid_sp_identifier (a_name).is_equal (a_name)
		do
			-- assume go before and after is not needed
			std.output.put_string ("drop procedure ")
			std.output.put_string (quote_identifier (a_name))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	sp_before_end_delete
			-- Chance to emit something just before `sp_end' is called in
			-- `create_sp_delete'.
		do
			-- do nothing
		end

	sp_before_end_update
			-- Chance to emit something just before `sp_end' is called in
			-- `create_sp_update'.
		do
			-- do nothing
		end

	sp_body_statements (procedure: XPLAIN_PROCEDURE)
			-- Output statements in a stored procedure.
		require
			procedure_not_void: procedure /= Void
		do
			from
				procedure.statements.start
			until
				procedure.statements.after
			loop
				procedure.statements.item_for_iteration.write (Current)
				procedure.statements.forth
			end
		end

	sp_body_start
			-- Begin a procedure body.
			-- Should leave cursor on a new line.
		do
			std.output.put_string ("begin%N")
		end

	sp_define_in_param (name: STRING): STRING
			-- Return `name' formatted as an sp input parameter, as it
			-- should appear in the header/definition of a stored
			-- procedure.
			-- Certain dialects have conventions for this like using a
			-- '@' in front of every identifier. Spaces and such should
			-- be removed if necessary, or the entry should be quoted if
			-- that is supported for sp's.
		do
			Result := sp_define_param_name (name)
		end

	sp_define_param_name (name: STRING): STRING
			-- Return `name' formatted as the name of the parameter as it
			-- appears in the header, and hopefully as it is known to
			-- clients. It must be quoted, if it can be quoted.
		do
			Result := no_space_identifier (name)
		end

	sp_define_out_param (name: STRING): STRING
			-- Return `name' formatted as an output parameter, as it
			-- should appear in the header/definition of a stored
			-- procedure. See also `sp_define_in_param'.
		require
			output_parameters_supported: OutputParametersSupported
			named_parameters_supported: NamedParametersSupported
			name_not_empty: name /= Void and then not name.is_empty
		do
			Result := sp_define_param_name (name)
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_delete_name (type: XPLAIN_TYPE): STRING
			-- Name of stored procedure that deletes an instance of a type
		do
			Result := sp_name (once_delete + type.sqlname (Current))
		end

	sp_delete_declaration (
			type: XPLAIN_TYPE;
			param_name: STRING)
			-- Emit any declarations for `sp_delete_insert' between
			-- procedure header and body.
		require
			type_not_void: type /= Void
		do
			-- nothing
		end

	sp_end
			-- Write statements, if any, to end a stored procedure.
		require
			sp_started: is_stored_procedure
		do
			is_stored_procedure := False
			std.output.put_string ("end")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		ensure
			sp_stopped: not is_stored_procedure
		end

	sp_get_auto_generated_primary_key (type: XPLAIN_TYPE): STRING
			-- Statement that returns the generated primary key into the
			-- output parameters. Statement should end with CommandSeperator.
		deferred
			-- implement for dialects that have sp support
		ensure
			result_not_void: Result /= Void
		end

	sp_header_end
			-- Emit code to end stored procedure declaration. Many
			-- dialects have an "as" for example.
			-- Should leave cursor on a new line.
		do
			std.output.put_string (" as%N")
		end

	sp_insert_declaration (
			type: XPLAIN_TYPE;
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE];
			has_input_parameters: BOOLEAN)
			-- Emit any declarations for `sp_create_insert' between
			-- procedure header and body.
			-- `cursor' contains the data attributes of `type'.
			-- `has_input_parameters' is True if any input parameters
			-- have been emitted.
		require
			type_not_void: type /= Void
			cursor_not_void: cursor /= Void
		do
			-- nothing
		end

	sp_insert_name (type: XPLAIN_TYPE): STRING
			-- Name of stored procedure that inserts an instance of a type
		do
			Result := sp_name (once_insert + type.sqlname (Current))
		end

	sp_name (name: STRING): STRING
			-- Turn an Xplain name into a stored procedure name.
		do
			if sp_prefix.is_empty then
				Result := make_valid_sp_identifier (name)
			else
				Result := make_valid_sp_identifier (sp_prefix + name)
			end
		end

	sp_result_parameter (a_procedure: detachable XPLAIN_PROCEDURE)
			-- Emit the result parameter of the stored procedure, if
			-- applicable.
			-- For example DB/2 and Oracle needs to know if rows are returned.
			-- If `a_procedure' is void, an auto-generated procedure is created.
		do
			-- nothing
		end

	sp_return_parameter_format_string: STRING
			-- Format a parameter as a return parameter.
		once
			Result := "$s $s"
		ensure
			-- enabling this gives postcondition violation with Oracle with SE...
			-- result_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_start (a_procedure: detachable XPLAIN_PROCEDURE)
			-- Write statements to start a procedure, including the
			-- "create procedure " statement itself (including space).
			-- If `a_procedure' is Void, it is an auto-generated
			-- procedure like a table insert/update/delete procedure.
		require
			procedure_not_started: not is_stored_procedure
		do
			is_stored_procedure := True
			std.output.put_string ("create procedure ")
		ensure
			sp_started: is_stored_procedure
		end

	sp_update_declaration (
			type: XPLAIN_TYPE;
			pk_param_name: STRING;
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE])
			-- Emit any declarations for `sp_create_update' between
			-- procedure header and body.
			-- `cursor' contains the data attributes of `type'.
		require
			type_not_void: type /= Void
			cursor_not_void: cursor /= Void
		do
			-- nothing
		end

	sp_update_name (type: XPLAIN_TYPE): STRING
			-- Name of stored procedure that updates an instance of a type
		do
			Result := sp_name (once_update + type.sqlname (Current))
		end

	sp_use_param (name: STRING): STRING
			-- Return stored procedure parameter `name' formatted
			-- according to the dialects convention when using
			-- parameters in sql code. It is usually prefixed by '@' or
			-- ':'.
			-- Spaces and such should be removed if necessary, or the
			-- entry should be quoted if that is supported for sp's.
		do
			Result := sp_define_param_name (name)
		end

	sp_user_declaration (procedure: XPLAIN_PROCEDURE)
			-- Any declarations needed in a user procedure like
			-- declarations for the value statement or cursors.
			-- Exact location depends on
			-- `StoredProcedureUserDeclarationBeforeBody'.
		require
			procedure_not_void: procedure /= Void
		do
			-- nothing
		end

	sp_user_result (procedure: XPLAIN_PROCEDURE)
			-- Output any stuff before header ends in case of a user
			-- defined stored procedure.
		require
			procedure_not_void: procedure /= Void
		do
			-- nothing
		end


feature -- Drop statements

	drop_procedure (procedure: XPLAIN_PROCEDURE)
			-- Drop procedure `procedure'.
		do
			do_drop_procedure (procedure.sqlname (Current))
		end

	drop_sp (type: XPLAIN_TYPE)
			-- Drop table modification stored procedures.
		require
			allow_sp: CreateStoredProcedure
			type_not_void: type /= Void
		do
			-- assume go before and after is not needed
			do_drop_procedure (sp_delete_name (type))
			do_drop_procedure (sp_insert_name (type))
			if type.has_updatable_attributes then
				do_drop_procedure (sp_update_name (type))
			end
		end

	drop_table (type: XPLAIN_TYPE)
		do
			if CreateStoredProcedure then
				drop_sp (type)
			end
			precursor (type)
		end

	drop_value (a_value: XPLAIN_VALUE)
			-- Remove value.
		do
			-- Assume that inside a stored procedure the representation
			-- cannot change (no warning yet), and is declared just once
			-- at the top. So we ignore the case when a user purges a value.
			if not is_stored_procedure then
				precursor (a_value)
			else
				-- However, we just need to fake the fact it was removed,
				-- else we get a postcondition failure.
				declared_values.remove (a_value.name)
			end
		end


feature -- Identifiers

	make_valid_sp_identifier (name: STRING): STRING
			-- Return a valid stored procedure identifier for a given
			-- name.  Certain databases allow quoted names, but don't
			-- allow spaces (DB/2).
		require
			name_not_empty: name /= Void and then not name.is_empty
		do
			Result := make_valid_identifier (name)
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Access

	is_stored_procedure: BOOLEAN
			-- Are we currently generating output inside a stored procedure?


feature -- Extend options

	can_write_extend_as_view (an_extension: XPLAIN_EXTENSION): BOOLEAN
		do
			Result := ViewsSupported and then not is_stored_procedure
		ensure then
			no_views_in_stored_procedure: is_stored_procedure implies not Result
		end


feature {NONE} -- Once strings

	once_delete: STRING = "Delete"
	once_insert: STRING = "Insert"
	once_update: STRING = "Update"


invariant

	sp_consistent: is_stored_procedure implies StoredProcedureSupported

end
