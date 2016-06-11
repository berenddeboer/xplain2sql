note

	description: "Produce an XML description of the executable code."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer, see forum.txt"


class

	XML_GENERATOR

inherit

	MIDDLEWARE_GENERATOR

	KL_SHARED_STANDARD_FILES

	KL_IMPORTED_STRING_ROUTINES

	XM_UNICODE_CHARACTERS_1_0
		export
			{NONE} all
		end

	EXCEPTIONS
		export
			{NONE} all
		end


create

	make


feature {NONE} -- Initialisation

	make (a_sqlgenerator: like sqlgenerator)
		do
			sqlgenerator := a_sqlgenerator
			create xml.make_with_capacity (4096)
		end


feature -- Identifier capabilities

	MaxIdentifierLength: INTEGER
			-- Maximum length of identifiers;
			-- Not used for XML I believe.
		do
			Result := 255
		end


feature -- Main features

	dump_statements (statements: XPLAIN_STATEMENTS; a_sqlgenerator: SQL_GENERATOR)
			-- Dump statements in order of occurrence.
		local
			file: KL_TEXT_OUTPUT_FILE
		do
			sqlgenerator := a_sqlgenerator
			create xml.make_with_capacity (4096)
			xml.add_header_iso_8859_1_encoding
			xml.start_tag ("sql")
			from
				statements.statements.start
			until
				statements.statements.after
			loop
				statements.statements.item_for_iteration.write (Current)
				statements.statements.forth
			end
			xml.stop_tag

			create file.make (file_name)
			file.open_write
			if not file.is_open_write then
				std.error.put_string ("xplain2sql: cannot write to file %'")
				std.error.put_string (file_name)
				std.error.put_string ("%'%N")
				--die (exit_failure_code)
				die (1)
			end
			file.put_string (xml.xml)
			file.close
		end

	dump_type (type: XPLAIN_TYPE; a_sqlgenerator: SQL_GENERATOR)
		do
			-- Not applicable, routine should become obsolete.
		end


feature -- Write callbacks

	write_constant (constant: XPLAIN_VARIABLE)
			-- Dump every constant that has a value.
		local
			value: STRING
		do
			if constant.value /= Void then
				xml.start_tag ("constant")
				set_names (
					constant.name,
					constant.representation.domain,
					constant.sqlname (sqlgenerator),
					constant.representation.datatype (sqlgenerator),
					Void,
					constant.representation.xml_schema_data_type)
				value := constant.value.sqlvalue (sqlgenerator)
				-- strip surrounding quotes, if any
				if value.count >= 2 then
					if value.item (1) = '%'' and then value.item (value.count) = '%'' then
						value.remove (value.count)
						value.remove (1)
					end
				end
				xml.set_attribute ("value", value)
				xml.stop_tag
			end
		end

	write_constant_assignment (constant: XPLAIN_VARIABLE; expression: XPLAIN_EXPRESSION)
			-- Code for constant assignment.
		do
			-- no output
		end

	write_delete (subject: XPLAIN_SUBJECT; predicate: XPLAIN_EXPRESSION)
			-- Code for delete statement.
		do
			-- no output.
		end

	write_get_insert (
		a_selection: XPLAIN_SELECTION_LIST
		an_insert_type: XPLAIN_TYPE
		an_auto_primary_key: BOOLEAN
		an_assignment_list: XPLAIN_ATTRIBUTE_NAME_NODE)
			-- Get into a table.
		do
			-- no output
		end

	write_extend (extension: XPLAIN_EXTENSION)
			-- Code for extend statement.
		do
			-- no output
		end

	write_insert (type: XPLAIN_TYPE; id: XPLAIN_EXPRESSION; assignment_list: XPLAIN_ASSIGNMENT_NODE)
		do
			-- no output
		end

	write_procedure (procedure: XPLAIN_PROCEDURE)
			-- Dump stored procedure info.
		local
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE_NAME]
			param_name,
			param_type: STRING
		do
			if sqlgenerator.StoredProcedureSupported then
				xml.start_tag ("storedProcedure")
				set_names (
					procedure.name,
					Void,
					procedure.sqlname (sqlgenerator),
					Void,
					Void,
					Void)
				-- write parameters
				cursor := procedure.parameters.new_cursor
				from
					cursor.start
				until
					cursor.after
				loop
					xml.start_tag ("parameter")
					if sqlgenerator.NamedParametersSupported then
						param_name := sqlgenerator.sp_define_in_param (cursor.item.abstracttype.sqlcolumnidentifier (sqlgenerator, cursor.item.role))
					else
						param_name := sqlgenerator.sp_define_param_name (cursor.item.abstracttype.sqlcolumnidentifier (sqlgenerator, cursor.item.role))
					end
					if sqlgenerator.SupportsDomainsInStoredProcedures then
						param_type := cursor.item.abstracttype.columndatatype (sqlgenerator)
					else
						param_type := cursor.item.abstracttype.representation.datatype (sqlgenerator)
					end
					set_names (
						cursor.item.full_name,
						cursor.item.abstracttype.representation.domain,
						param_name,
						param_type,
						as_ncname (cursor.item.abstracttype.sqlcolumnidentifier (sqlgenerator, cursor.item.role)),
						cursor.item.abstracttype.representation.xml_schema_data_type)
					xml.stop_tag
					cursor.forth
				end
				-- write columns for last get statement, if any
				if attached procedure.last_get_statement as get_statement then
					get_statement.selection.write_select (Current)
				elseif attached procedure.last_value_selection_statement as value_statement then
					value_statement.write (Current)
				end
				xml.stop_tag
			end
		end

	write_select (selection: XPLAIN_SELECTION)
			-- Write various select statements.
		do
			-- not supported.
		end

	write_select_function (selection_list: XPLAIN_SELECTION_FUNCTION)
			-- Write get with function.
		local
			representation: XPLAIN_REPRESENTATION
			xplain_name: STRING
			sql_name: STRING
		do
			xml.start_tag ("select")
			xml.start_tag ("column")
			if selection_list.property = Void then
				representation := selection_list.function.representation (sqlgenerator, selection_list.type, Void)
				set_names (
					"value",
					representation.domain,
					"value",
					representation.datatype (sqlgenerator),
					Void,
					representation.xml_schema_data_type)
			else
				representation := selection_list.property.exact_representation (sqlgenerator)
				if attached selection_list.property.column_name as n then
					xplain_name := n
					if attached selection_list.property.sqlname (sqlgenerator) as s then
						sql_name := s
					else
						sql_name := n
					end
				else
					xplain_name := selection_list.function.name
					sql_name := xplain_name
				end
				set_names (
					xplain_name,
					representation.domain,
					sql_name,
					representation.datatype (sqlgenerator),
					Void,
					representation.xml_schema_data_type)
			end
			xml.stop_tag
			xml.stop_tag
		end

	write_select_list (selection_list: XPLAIN_SELECTION_LIST)
			-- Write get with zero or more attributes.
		local
			node: detachable XPLAIN_EXPRESSION_NODE
			xplain_name,
			column_name: STRING
			r: XPLAIN_REPRESENTATION
		do
			xml.start_tag ("select")
			xml.set_attribute ("table", selection_list.subject.type.quoted_name (sqlgenerator))
			xml.set_attribute ("xplainName", selection_list.subject.type.name)
			if selection_list.expression_list = Void then
				dump_columns (selection_list.type)
			else
				xml.start_tag ("column")
				set_names (
					selection_list.type.name,
					selection_list.type.representation.domain,
					selection_list.type.sqlpkname (sqlgenerator),
					selection_list.type.representation.datatype (sqlgenerator),
					Void,
					selection_list.type.representation.xml_schema_data_type)
				xml.stop_tag

				if not selection_list.show_only_identifier_column then
					from
						node := selection_list.expression_list
					until
						node = Void
					loop
						xml.start_tag ("column")
						if attached node.new_name as n then
							xplain_name := n
							column_name := n
						else
							if attached node.item.column_name as c then
								xplain_name := c
							else
								xplain_name := "no_column_name_given"
							end
							if attached node.item.sqlname (sqlgenerator) as c then
								column_name := c
							else
								column_name := "no_name_given"
							end
						end
						r := node.item.exact_representation (sqlgenerator)
						set_names (
							xplain_name,
							r.domain,
							sqlgenerator.make_valid_identifier (column_name),
							r.datatype (sqlgenerator),
							Void,
							r.xml_schema_data_type)
						if node.item.is_specialization then
							xml.set_attribute ("specialization", "true")
						end
						xml.stop_tag
						node := node.next
					end
				end
			end
			xml.stop_tag
		end

	write_select_value (value: XPLAIN_VALUE)
			-- Value selection: value v.
		do
			xml.start_tag ("select")
			xml.start_tag ("column")
			set_names (
				value.name,
				value.representation.domain,
				value.sqlname (sqlgenerator),
				value.representation.datatype (sqlgenerator),
				as_ncname (value.name),
				value.representation.xml_schema_data_type)
			xml.stop_tag
			xml.stop_tag
		end

	write_sql (sql: STRING)
			-- Literal SQL.
		do
			-- no output
		end

	write_type (type: XPLAIN_TYPE)
			-- Dump type info.
		do
			xml.start_tag ("table")
			set_names (
				type.name,
				type.representation.domain,
				type.sqltablename (sqlgenerator),
				Void,
				Void,
				type.representation.xml_schema_data_type)
			if sqlgenerator.CreateStoredProcedure then
				set_sp_name ("spDelete", sqlgenerator.sp_delete_name (type))
				set_sp_name ("spInsert", sqlgenerator.sp_insert_name (type))
				set_sp_name ("spUpdate", sqlgenerator.sp_update_name (type))
			end
			dump_columns (type)
			xml.stop_tag
		end

	write_update (
			subject: XPLAIN_SUBJECT;
			assignment_list: XPLAIN_ASSIGNMENT_NODE;
			predicate: XPLAIN_EXPRESSION)
			-- Code for update statement.
		do
			-- no output.
		end

	write_value (value: XPLAIN_VALUE)
			-- Value definition (includes assignment): value v = 10.
		do
			-- no output.
		end


feature {NONE} -- Write helpers

	dump_columns (type: XPLAIN_TYPE)
			-- Write all columns, attributes and auto-added ones, as a
			-- series of <column>s
		local
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			my_attribute: XPLAIN_ATTRIBUTE
		do
			-- primary key
			xml.start_tag (once "column")
			set_names (
				type.name,
				type.representation.domain,
				type.sqlpkname (sqlgenerator),
				type.representation.datatype (sqlgenerator),
				Void,
				type.representation.xml_schema_data_type)
			xml.set_attribute (once "init", once "none")
			if sqlgenerator.StoredProcedureSupported then
				xml.set_attribute (once "sqlParamName", sqlgenerator.sp_define_param_name (type.sqlpkname (sqlgenerator)))
			end
			xml.stop_tag

			-- attributes
			cursor := type.new_data_attributes_cursor (sqlgenerator)
			from
				cursor.start
			until
				cursor.after
			loop
				my_attribute := cursor.item
				if sqlgenerator.CalculatedColumnsSupported or else not my_attribute.is_assertion then
					xml.start_tag (once "column")
					set_names (
						my_attribute.full_name,
						my_attribute.abstracttype.representation.domain,
						my_attribute.sql_select_name (sqlgenerator),
						my_attribute.abstracttype.columndatatype (sqlgenerator),
						Void,
						my_attribute.abstracttype.representation.xml_schema_data_type)
					if my_attribute.is_specialization then
						xml.set_attribute (once "specialization", once "true")
					end
					if not my_attribute.is_required then
						xml.set_attribute (once "optional", once "true")
					end
					if my_attribute.is_unique then
						xml.set_attribute (once "unique", once "true")
					end
					if my_attribute.init = Void then
						xml.set_attribute (once "init", once "none")
					elseif my_attribute.is_init_default then
						xml.set_attribute (once "init", once "default")
					else
						xml.set_attribute (once "init", once "always")
					end
					if attached {XPLAIN_TYPE} my_attribute.abstracttype as my_type then
						xml.set_attribute (once "references", my_type.name)
						xml.set_attribute (once "sqlReferences", my_type.quoted_name (sqlgenerator))
					end
					if sqlgenerator.StoredProcedureSupported then
						xml.set_attribute (once "sqlParamName", sqlgenerator.sp_define_param_name (my_attribute.abstracttype.sqlcolumnidentifier (sqlgenerator, my_attribute.role)))
					end
					xml.stop_tag
				end
				cursor.forth
			end

			-- time stamp
		end

	set_names (xplain_name: STRING; xplain_domain: detachable STRING; sql_name: STRING; sql_type, an_ncname, an_xs_data_type: detachable STRING)
			-- Write the bunch of name attributes.
			-- `sql_name' should be unquoted.
		require
			xplain_name_not_empty: xplain_name /= Void and then not xplain_name.is_empty
			have_sql_name: sql_name /= Void and then not sql_name.is_empty
			ncname_void_or_not_empty: an_ncname = Void or else not an_ncname.is_empty
		local
			quoted_sql_name: STRING
		do
			if xplain_name /= Void then
				xml.set_attribute ("xplainName", xplain_name)
			end
			if xplain_domain /= Void then
				xml.set_attribute ("xplainDomain", xplain_domain)
			end
			quoted_sql_name := sqlgenerator.quote_valid_identifier (sql_name)
			xml.set_attribute ("sqlName", quoted_sql_name)
			if sql_type /= Void then
				xml.set_attribute ("sqlType", sql_type)
			end
			xml.set_attribute ("identifier", code_common_identifier (xplain_name))
			if an_ncname = Void then
				xml.set_attribute ("ncname", as_ncname (sql_name))
			else
				xml.set_attribute ("ncname", an_ncname)
			end
			xml.set_attribute ("sqlNameAsEiffelString", as_eiffel_string (quoted_sql_name))
			xml.set_attribute ("sqlNameAsCString", as_c_string (quoted_sql_name))
			if an_xs_data_type /= Void then
				xml.set_attribute ("xsd", an_xs_data_type)
			end
		end

	set_sp_name (an_attribute, sp_name: STRING)
			-- Write modification stored procedure attributes. `sp_name'
			-- is an unquoted name.
		local
			quoted_sp_name: STRING
		do
			quoted_sp_name := sqlgenerator.quote_identifier (sp_name)
			xml.set_attribute (an_attribute, quoted_sp_name)
			xml.set_attribute (an_attribute + "AsEiffelString", as_eiffel_string (quoted_sp_name))
			xml.set_attribute (an_attribute + "AsCString", as_c_string (quoted_sp_name))
		end

	as_c_string (s: STRING): STRING
			-- Quote occurrences of " in `s'.
		require
			s_not_empty: s /= Void and then not s.is_empty
		do
			Result := as_some_string (s, '\')
		end

	as_eiffel_string (s: STRING): STRING
			-- Quote occurrences of " in `s'.
		require
			s_not_empty: s /= Void and then not s.is_empty
		do
			Result := as_some_string (s, '%%')
		end

	as_ncname (s: STRING): UC_STRING
			-- As `s', but spaces replaced with '-'
		local
			p: INTEGER
			c: INTEGER
		do
			create Result.make_from_utf8 (s)
			from
				p := 1
			until
				p > Result.count
			loop
				c := Result.item_code (p)
				if not is_name_char (c) then
					Result.put ('-', p)
				end
				p := p + 1
			end
			if not is_name_first (Result.item_code (1)) then
				Result.insert_character ('_', 1)
			end
		ensure
			not_empty: is_ncname (Result)
		end

	as_some_string (s: STRING; quote: CHARACTER): STRING
			-- Return as a valid string in some language. Reserved
			-- characters are quoted using `quote'.
		require
			s_not_empty: s /= Void and then not s.is_empty
		local
			p: INTEGER
		do
			p := s.index_of ('%"', 1)
			if p = 0 then
				Result := s
			else
				Result := s.twin
				from
				invariant
					p >= 0 and p <= Result.count
				until
					p = 0
				loop
					Result.insert_character (quote, p)
					if p + 2 > Result.count then
						p := 0
					else
						p := Result.index_of ('%"', p+2)
					end
				end
			end
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Public state

	file_name: STRING = "xplain2sql.xml"


feature {NONE} -- Implementation

	code_common_identifier (name: STRING): STRING
			-- Identifier that works for most programming languages such
			-- as Eiffel, Delphi or C.
		require
			s_not_void: name /= Void and then not name.is_empty
		local
			s: STRING
			i: INTEGER
		do
			s := name.twin
			inspect s.item (1)
			when '0'..'9' then
				s.insert_character ('_', 1)
			else -- ok
			end
			from
				i := 1
			until
				i > s.count
			loop
				inspect s.item (i)
				when 'A'..'Z', 'a'..'z', '0'..'9', '_' then
					-- these are ok
				else
					s.put ('_', i)
				end
				i := i + 1
			end
			Result := s
		ensure
			got_result: Result /= Void and then not Result.is_empty
			no_spaces: Result.index_of (' ', 1) = 0
		end

	sqlgenerator: SQL_GENERATOR
			-- Current sql code generator.

	xml: XML_WRITER
			-- XML building.


feature -- The following is only here to silence the compiler, all this stuff will go

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		once
			Result := "BOOLEAN"
		end

	datatype_char (representation: XPLAIN_C_REPRESENTATION): STRING
		once
			Result := "STRING"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		once
			Result := "STRING"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- platform dependent approximate numeric data type using
			-- largest size available on that platform
		once
			Result := "DOUBLE"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
		once
			Result := "INTEGER"
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		once
			Result := "DOUBLE"
		end

	datatype_numeric (representation: XPLAIN_R_REPRESENTATION): STRING
			-- exact numeric data type
		once
			Result := "DOUBLE"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
		once
			Result := "STRING"
		end

	datatype_pk_char (representation: XPLAIN_PK_A_REPRESENTATION): STRING
		once
			Result := "STRING"
		end

	datatype_pk_int (representation: XPLAIN_PK_I_REPRESENTATION): STRING
		once
			Result := "INTEGER"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
		once
			Result := "STRING"
		end

	datatype_varchar (representation: XPLAIN_A_REPRESENTATION): STRING
		once
			Result := "STRING"
		end

	SQLTrue: STRING
			-- Return the value for True.
		once
			Result := "True"
		end

	SQLFalse: STRING
			-- Return the value for False.
		once
			Result := "False"
		end

	as_string (s: STRING): STRING
			-- Return `s' as string by surrounding it with
			-- quotes. Special characters in string should be properly
			-- quoted.
		do
			Result := s
		end

	sqlgetconstant (variable: XPLAIN_VARIABLE): STRING
			-- Return contents of a variable.
		do
			Result := no_space_identifier (variable.name)
		end

	get_column_value (column_name: STRING): STRING
			-- get value for a certain column
		do
			Result := "rs.Fields['" + column_name + "'].Value"
		end

	get_column_value_string (column_name: STRING): STRING
			-- get value for a certain column if it is a string
		do
			Result := "VarToStr(rs.Fields['" + column_name + "'].Value)"
		end

end
