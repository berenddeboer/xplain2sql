note

  description: "Produces output for Interbase 6."

  Known_bugs:
  "1. InterBase doesn't let you override the not null status of a domain.%
  %   it should warn when user wants to do this.%
  %2. init [default] does not suport if-then-else or case %
  %   expressions. There is no warning though %
  %3. extend function doesn't work quite well, because InterBase doesn't%
  %   have the coalesce function. Need to write UDF to support%
  %   to support this.%
  %4. Because of no temporary table, generate views instead. Also%
  %   a usefull option.%
  %5. default values in insert into statement is not supported.%
  %   So sp_create_insert does create incorrect code in certain cases."

  author:     "Berend de Boer <berend@pobox.com>"
  copyright:  "Copyright (c) 2000, Berend de Boer"

class

	SQL_GENERATOR_INTERBASE6


inherit

	SQL_GENERATOR_INTERBASE
		redefine
			IdentifierWithSpacesSupported,
			quote_identifier,
			SupportsDomainsInStoredProcedures,
			max_numeric_precision,
			ExistentialFromTable,
			create_select_function,
			create_select_list,
			create_use_database,
			datatype_int,
			value_identifier,
			sp_user_declaration,
			sp_user_result
		end


create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "InterBase 6.0/FireBird 1.x"
		end


feature -- Identifiers

	IdentifierWithSpacesSupported: BOOLEAN
		once
			Result := True
		end

	quote_identifier (identifier: STRING): STRING
			-- return identifier, surrounded by quotes
		local
			s: STRING
		do
			s := "%"" + identifier + "%""
			Result := s
		end


feature -- Stored procedure options

	SupportsDomainsInStoredProcedures: BOOLEAN
		do
			Result := False
		end


feature -- Numeric precision

	max_numeric_precision: INTEGER
		once
			Result := 18
		end


feature -- select options

	ExistentialFromTable: STRING = "RDB$DATABASE"
			-- Name of the dual table to be used in a select statement
			-- where a from is required


feature -- SQL creation

	create_select_function (selection_list: XPLAIN_SELECTION_FUNCTION)
		do
			if is_stored_procedure then
				std.output.put_string ("for ")
				std.output.put_string (sql_select_function_as_subselect (selection_list))
				std.output.put_string (" into%N")
				std.output.put_string (Tab)
				std.output.put_character (':')
				std.output.put_string (quote_valid_identifier (selection_list.function.name + " " + selection_list.subject.type.name))
				std.output.put_string ("%Ndo%Nbegin%N")
				std.output.put_string (Tab)
				std.output.put_string ("suspend;%Nend%N")
			else
				precursor (selection_list)
			end
		end

	create_select_list (selection_list: XPLAIN_SELECTION_LIST)
			-- For Interbase selects in a stored procedure have to be
			-- treated differently.
		local
			node: detachable XPLAIN_EXPRESSION_NODE
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			my_attribute: XPLAIN_ATTRIBUTE
		do
			if is_stored_procedure then
				std.output.put_string ("for ")
				do_do_create_select_list (selection_list, False)
				std.output.put_string ("into%N")
				std.output.put_string (Tab)
				std.output.put_character (':')
				std.output.put_string (quote_valid_identifier ("column " + selection_list.subject.type.sqlpkname (Current)))
				if not selection_list.show_only_identifier_column then
					if selection_list.expression_list = Void then
						cursor := selection_list.subject.type.attributes.new_cursor
						from
							cursor.start
						until
							cursor.after
						loop
							my_attribute := cursor.item
							if CalculatedColumnsSupported or else not my_attribute.is_assertion then
								std.output.put_string (",%N")
								std.output.put_string (Tab)
								std.output.put_character (':')
								std.output.put_string (quote_valid_identifier ("column " + my_attribute.sql_select_name (Current)))
							end
							cursor.forth
						end
					else
						from
							node := selection_list.expression_list
						until
							node = Void
						loop
							std.output.put_string (",%N")
							std.output.put_string (Tab)
							std.output.put_character (':')
							if attached node.new_name as n then
								std.output.put_string (quote_identifier (make_valid_identifier (n)))
							elseif attached node.item.sqlname (Current) as n then
								std.output.put_string (quote_valid_identifier ("column " + n))
							end
							node := node.next
						end
					end
				end
				std.output.put_string ("%Ndo%Nbegin%N")
				std.output.put_string (Tab)
				std.output.put_string ("suspend;%Nend%N")
			else
				precursor (selection_list)
			end
		end

	create_select_value_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL that returns the value when asked for that value
			-- inside a stored procedure.
		do
-- 			std.output.put_string (a_value.quoted_name (Current))
-- 			std.output.put_string (" = ")
-- 			std.output.put_string (quote_valid_identifier ("my_" + a_value.name))
			std.output.put_string (quote_valid_identifier (a_value.name))
			std.output.put_string (" = ")
			std.output.put_string (a_value.quoted_name (Current))
		end

	create_use_database (database: STRING)
			-- start using a certain database
		do
			precursor (database)
			std.output.put_string ("set sql dialect 3")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_value_assign_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit code to assign `a_value'.`expression' to `a_value'
			-- inside a stored procedure.
		local
			can_assign: BOOLEAN
		do
			if attached {XPLAIN_SELECTION_EXPRESSION} a_value.expression as selection then
				can_assign :=
					a_value.expression.is_literal or else
					selection = Void
			end
			if can_assign then
				-- Expression does not generate an SQL select,
				-- so assume we can assign it. We have to distinguish
				-- those cases because InterBase does not allow a
				-- subselect for a variable.
				std.output.put_string (a_value.quoted_name (Current))
				std.output.put_string (" = " )
				std.output.put_string (a_value.expression.sqlvalue (Current))
			else
				std.output.put_string (a_value.expression.sqlvalue (Current))
				std.output.put_string ("%Ninto :")
				std.output.put_string (a_value.quoted_name (Current))
			end
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_value_declare_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit code to declare `a_value' inside a stored procedure.
		do
			std.output.put_string ("declare variable ")
			std.output.put_string (a_value.quoted_name (Current))
			std.output.put_string (" ")
			std.output.put_string (a_value.representation.datatype (Current))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end


feature -- type specification for xplain types

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		do
			Result := "timestamp"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
		local
			len: INTEGER
		do
			inspect representation.length
			when 1 .. 4 then
				Result := "smallint"
			when 5 .. 9 then
				Result := "integer"
			else
				if representation.length > max_numeric_precision then
					std.error.put_string ("Too large integer representation detected: I")
					std.error.put_integer (representation.length)
					std.error.put_string ("%NRepresentation truncated to ")
					std.error.put_integer (max_numeric_precision)
					std.error.put_character ('%N')
					len := max_numeric_precision
				else
					len := representation.length
				end
				Result := "numeric(" + len.out + ", 0)"
			end
		end


feature -- Value specific features

	value_identifier (a_value: XPLAIN_VALUE): STRING
			-- Return identifier, not quoted.
		do
			if is_stored_procedure then
				Result := make_valid_identifier ("my_" + a_value.name)
			else
				Result := make_valid_identifier (a_value.name)
			end
		end


feature -- Stored procedures

	sp_user_declaration (procedure: XPLAIN_PROCEDURE)
			-- Emit value declarations.
		do
			from
				procedure.statements.start
			until
				procedure.statements.after
			loop
				if attached {XPLAIN_VALUE_STATEMENT} procedure.statements.item_for_iteration as value_statement then
					optional_create_value_declare (value_statement.value)
				end
				procedure.statements.forth
			end
		end

	sp_user_result (procedure: XPLAIN_PROCEDURE)
			-- Output the proper clause when rows are returned or not.
		local
			type: XPLAIN_TYPE
			value: XPLAIN_VALUE
			node: detachable XPLAIN_EXPRESSION_NODE
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			my_attribute: XPLAIN_ATTRIBUTE
		do
			if procedure.returns_rows then
				std.output.put_string ("%Nreturns (%N")
				if attached procedure.last_get_statement as get_statement then
					type := get_statement.selection.subject.type
					if attached {XPLAIN_SELECTION_LIST} get_statement.selection as selection_list then
						std.output.put_string (Tab)
						std.output.put_string (quote_valid_identifier ("column " + type.sqlpkname (Current)))
						std.output.put_character (' ')
						std.output.put_string (type.representation.datatype (Current))
						if not selection_list.show_only_identifier_column then
							if selection_list.expression_list = Void then
								cursor := type.attributes.new_cursor
								from
									cursor.start
								until
									cursor.after
								loop
									my_attribute := cursor.item
									if CalculatedColumnsSupported or else not my_attribute.is_assertion then
										std.output.put_string (",%N")
										std.output.put_string (Tab)
										std.output.put_string (quote_valid_identifier ("column " + my_attribute.sql_select_name (Current)))
										std.output.put_character (' ')
										std.output.put_string (my_attribute.abstracttype.representation.datatype (Current))
									end
									cursor.forth
								end
							else
								from
									node := selection_list.expression_list
								until
									node = Void
								loop
									std.output.put_string (",%N")
									std.output.put_string (Tab)
									if attached node.new_name as n then
										std.output.put_string (quote_valid_identifier (n))
									elseif attached node.item.sqlname (Current) as n then
										std.output.put_string (quote_valid_identifier ("column " + n))
									end
									std.output.put_character (' ')
									std.output.put_string (node.item.exact_representation (Current).datatype (Current))
									node := node.next
									if node /= Void then
										std.output.put_character ('%N')
									end
								end
							end
						end
					else
						if attached {XPLAIN_SELECTION_FUNCTION} get_statement.selection as selection_function then
							std.output.put_string (Tab)
							std.output.put_string (quote_valid_identifier (selection_function.function.name + " " + type.name))
							std.output.put_character (' ')
							std.output.put_string (selection_function.representation (Current).datatype (Current))
						end
					end
				else
					if attached procedure.last_value_selection_statement as value_statement then
						std.output.put_string (Tab)
						value := value_statement.value
						std.output.put_string (quote_valid_identifier (value.name))
						std.output.put_character (' ')
						std.output.put_string (value.representation.datatype (Current))
					end
				end
				std.output.put_string (StoredProcedureParamListEnd)
			end
		end

end
