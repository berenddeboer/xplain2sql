note

	description: "Base class for InterBase output."

	author:     "Berend de Boer <berend@pobox.com>"

deferred class

	SQL_GENERATOR_INTERBASE


inherit

	SQL_GENERATOR_ADVANCED
		redefine
			make,
			OneLineCommentPrefix,
			AutoPrimaryKeySupported,
			DomainNullAllowed,
			ColumnNullAllowed,
			ExpressionsInDefaultClauseSupported,
			SupportsDefaultValues,
			StoredProcedureParamListStartRequired,
			StoredProcedureReturnParamListStart,
			SQLTrue,
			SQLFalse,
			SupportsTrueBoolean,
			SQLCoalesce,
			asserted_format_string,
			CalculatedColumnsSupported,
			drop_column,
			datatype_numeric,
			sqlcheck_boolean,
			init_forced_default,
			sql_last_auto_generated_primary_key,
			sqlsysfunction_current_timestamp,
			sqlsysfunction_system_user,
			extension_index_name,
			sp_define_param_name,
			sp_end,
			sp_use_param,
			sp_start,
			sqlinitvalue_attribute,
			sql_string_combine_separator
		end


feature {NONE} -- Initialisation

	make
		do
			precursor
			init_error := ""
		end


feature -- SQL Comments

	OneLineCommentPrefix: detachable STRING once end


feature -- command separation

	begin_new_separator
		require
			no_separator_conflict: not equal("^", CommandSeparator)
		do
			std.output.put_character ('%N')
			std.output.put_string ("set term ^ ")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	end_new_separator
		do
			std.output.put_character ('%N')
			std.output.put_string ("set term ")
			std.output.put_string (CommandSeparator)
			std.output.put_string (" ^")
			std.output.put_character ('%N')
		end


feature -- Identifiers

	MaxIdentifierLength: INTEGER
		once
			Result := 31
		end


feature -- domain options

	DomainNullAllowed: BOOLEAN once Result := False end


feature -- table options

	AutoPrimaryKeySupported: BOOLEAN
		once
			Result := True
		end

	ColumnNullAllowed: BOOLEAN
		once
			Result := False
		end

	ExpressionsInDefaultClauseSupported: BOOLEAN = False
			-- Does the SQL dialect support expressions (1 + 1 for
			-- example) in the default clause?


feature -- Strings

	sql_string_combine_separator: STRING = " || "


feature -- insert options

	SupportsDefaultValues: BOOLEAN
			-- Does the dialect supports the default values clause in an
			-- insert statement?
		once
			Result := False
		end


feature -- Stored procedure options

	StoredProcedureParamListStartRequired: BOOLEAN = False
			-- True if start of a parameter list like '(' is required. It
			-- is for DB/2, it isn't for Oracle for example.

	StoredProcedureReturnParamListStart: STRING = "%Nreturns (%N"


feature -- Booleans

	SQLTrue: STRING = "'T'"
	SQLFalse: STRING = "'F'"

	SupportsTrueBoolean: BOOLEAN
		do
			Result := False
		end


feature -- functions

	SQLCoalesce: STRING
		once
			Result := ""
		end


feature -- assertions

	CalculatedColumnsSupported: Boolean = True

	asserted_format_string: STRING
		once
			Result := "computed by ($s)"
		end


feature -- sql creation

	create_init (type: XPLAIN_TYPE)
		local
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
		do
			begin_new_separator
			std.output.put_string ("create trigger ")
			std.output.put_string (quote_valid_identifier("tr_" + type.sqlname (Current) + "Init"))
			std.output.put_string (" for ")
			std.output.put_string (quote_identifier(type.sqltablename (Current)))
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("active before insert position 1 as begin%N")
			from
				cursor := type.new_init_attributes_cursor (Current)
				cursor.start
			until
				cursor.after
			loop
				if attached cursor.item.init as init and then
					not init.is_constant then
					-- Prepare error msg here because in
					-- `sqlinitvalue_attribute' we don't have access to all
					-- information necessary to provide a decent error
					-- message.
					init_error := "init statement for " + type.name + " its " + cursor.item.name + " cannot be supported in InterBase.%N"
					std.output.put_string (Tab)
					if cursor.item.is_init_default then
						std.output.put_string (format ("if (new.$s is null) then%N", <<cursor.item.q_sql_select_name (Current)>>))
						std.output.put_string (Tab)
						std.output.put_string (Tab)
					end
					-- Because InterBase has no case expression, we need to trick a bit.
					if not attached {XPLAIN_IF_EXPRESSION} cursor.item.init as if_expression then
						std.output.put_string ("new.")
						std.output.put_string (cursor.item.q_sql_select_name (Current))
						std.output.put_string (" = ")
						std.output.put_string (sql_init_expression (cursor.item))
					else
						std.output.put_string ("if (")
						std.output.put_string (if_expression.condition.sqlinitvalue (Current))
						std.output.put_string (") then%N")
						std.output.put_string (Tab + Tab + Tab)
						std.output.put_string ("new.")
						std.output.put_string (cursor.item.q_sql_select_name (Current))
						std.output.put_string (" = ")
						std.output.put_string (if_expression.then_specification.sqlinitvalue (Current))
						std.output.put_string (CommandSeparator)
						std.output.put_character ('%N')
						std.output.put_string (Tab + Tab)
						std.output.put_string ("else%N")
						std.output.put_string (Tab + Tab + Tab)
						std.output.put_string ("new.")
						std.output.put_string (cursor.item.q_sql_select_name (Current))
						std.output.put_string (" = ")
						std.output.put_string (if_expression.else_specification.sqlinitvalue (Current))
					end
					std.output.put_string (CommandSeparator)
					std.output.put_character ('%N')
				end
				cursor.forth
			end
			std.output.put_string ("end ^")
			end_new_separator
		end

	create_primary_key_generator (type: XPLAIN_TYPE)
		do
			std.output.put_character ('%N')
			std.output.put_string (sql_create_generator)
			std.output.put_character (' ')
			std.output.put_string (quote_identifier (generator_name(type)))
			std.output.put_string (";")
			std.output.put_character ('%N')
			begin_new_separator
			std.output.put_string ("create trigger ")
			std.output.put_string (quote_valid_identifier("tr_" + type.sqlname(Current) + "BeforeInsert"))
			std.output.put_string (" for ")
			std.output.put_string (quote_identifier(type.sqltablename(Current)))
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("active before insert position 0 as%N")
			std.output.put_string ("declare variable new_gen integer;%N")
			std.output.put_string ("begin%N")
			std.output.put_string (Tab)
			std.output.put_string ("if (new.")
			std.output.put_string (quote_identifier (type.sqlpkname (Current)))
			std.output.put_string (" is Null) then%N")
			std.output.put_string (Tab)
			std.output.put_string (Tab)
			std.output.put_string ("new.")
			std.output.put_string (quote_identifier (type.sqlpkname (Current)))
			std.output.put_string (" = GEN_ID(")
			std.output.put_string (quote_identifier (generator_name (type)))
			std.output.put_string (", 1);%N")
			std.output.put_string (Tab)
			std.output.put_string ("else%N")
			std.output.put_string (Tab)
			std.output.put_string (Tab)
			std.output.put_string ("if (new.")
			std.output.put_string (quote_identifier (type.sqlpkname (Current)))
			std.output.put_string (" > GEN_ID(")
			std.output.put_string (quote_identifier (generator_name (type)))
			std.output.put_string (", 0)) then%N")
			std.output.put_string (Tab)
			std.output.put_string (Tab)
			std.output.put_string (Tab)
			std.output.put_string ("new_gen = GEN_ID(")
			std.output.put_string (quote_identifier (generator_name (type)))
			std.output.put_string (", new.")
			std.output.put_string (quote_identifier (type.sqlpkname (Current)))
			std.output.put_string (" - ")
			std.output.put_string (sql_last_auto_generated_primary_key (type))
			std.output.put_character (')')
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_string ("end ^")
			end_new_separator
		end

	create_use_database (database: STRING)
			-- start using a certain database
		do
			std.output.put_string ("connect ")
			std.output.put_string (database)
			std.output.put_string (".gdb")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

feature -- drop statements

	drop_column (tablename, columnname: STRING)
			-- generate code to drop some column from some table
			-- used to purge attributes/variable/values
		do
			std.output.put_string ("alter table ")
			std.output.put_string (tablename)
			std.output.put_string (" drop ")
			std.output.put_string (quote_identifier(columnname))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	drop_primary_key_generator (type: XPLAIN_TYPE)
		do
			std.output.put_string ("delete from rdb$generators%N")
			std.output.put_string (Tab)
			std.output.put_string ("where rdb$generator_name = '")
			std.output.put_string (generator_name (type))
			std.output.put_string ("'")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_string ("drop trigger")
			std.output.put_string (quote_valid_identifier("tr_" + type.sqlname(Current) + "BeforeInsert"))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end


feature -- type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		do
			Result := "char(1)"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- platform dependent approximate numeric data type
		do
			Result := "double precision";
		end

	datatype_numeric (representation: XPLAIN_R_REPRESENTATION): STRING
			-- numeric seems to be better, however Delphi doesn't support this
			-- properly, it seems to convert it to an integer instead of
			-- float or BCD
		do
			if representation.before + representation.after <= 7 then
				Result := "float"
			else
				Result := "double precision"
			end
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		do
			Result := "float"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
		do
			Result := "blob"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
		do
			Result := "blob sub_type text"
		end

feature -- generate constraints definitions

	sqlcheck_boolean (restriction: XPLAIN_B_RESTRICTION; column_name: STRING): STRING
			-- InterBase SQL check condition with Booleans
		do
			if restriction.required then
				Result := "(value = 'T' or value = 'F')"
			else
				Result := "(value is Null or (value = 'T' or value = 'F'))"
			end
		end


feature -- other names generators

	generator_name (type: XPLAIN_TYPE): STRING
		do
			Result := "gen_" + type.sqlname(Current)
			if Result.count > MaxIdentifierLength then
				Result.keep_head (MaxIdentifierLength)
			end
		end

feature -- generate columns either base or type columns

	init_forced_default (an_attribute: XPLAIN_ATTRIBUTE): BOOLEAN
			-- not applicable for InterBase. Has before-insert triggers.
		do
			Result := False
		end

feature -- ansi niladic functions

	sqlsysfunction_current_timestamp: STRING
		once
			Result := "'now'"
		end

	sqlsysfunction_system_user: STRING
		once
			Result := "USER"
		end


feature -- Return sql code

	sql_create_generator: STRING
		do
			Result := "create generator"
		end

	sql_last_auto_generated_primary_key	(type: XPLAIN_TYPE): STRING
			-- Return code to get the last auto-generated primary key for
			-- `type'. Certain SQL dialects can only return the last
			-- generated key, so this code is not guaranteed to be `type'
			-- specific.
		do
			Result := format ("GEN_ID($s, 0)", <<quote_identifier (generator_name (type))>>)
		end


feature -- generation of init [default] expressions

	sqlinitvalue_attribute (expression: XPLAIN_ATTRIBUTE_EXPRESSION): STRING
		do
			-- try to minimize the need to create singleton selects
			if expression.first.next = Void then
				Result := "new." + quote_identifier (expression.first.item.sqlcolumnidentifier (Current))
			else
				-- not supported by InterBase, cannot be done.
				Result := "0"
				std.error.put_string (init_error)
			end
		end


feature -- Extension specific methods

	extension_index_name (an_extension: XPLAIN_EXTENSION): STRING
			-- Name of index on temporary table to speed up join to that table
		do
			Result := quote_valid_identifier (once "idx_" + an_extension.type.name + once "_" + an_extension.name)
		end


feature -- Get a variable/value

	sqlgetvalue_inside_sp (a_value: XPLAIN_VALUE): STRING
			-- SQL expression that returns the value of a value inside a
			-- stored procedure
		do
			Result := a_value.quoted_name (Current)
		end


feature -- Stored procedure names and parameter conventions

	sp_define_param_name (name: STRING): STRING
			-- Return `name' formatted as the name of the parameter as it
			-- appears in the header, and hopefully as it is known to
			-- clients.
		do
			Result := quote_identifier (name)
		end

	sp_end
		do
			is_stored_procedure := False
			std.output.put_string ("end ^")
			end_new_separator
		end

	sp_get_auto_generated_primary_key (type: XPLAIN_TYPE): STRING
		do
			create Result.make (64)
			Result.wipe_out
			Result.append_string (quote_identifier (type.sqlpkname(Current)))
			Result.append_string (" = ")
			Result.append_string (sql_last_auto_generated_primary_key (type))
			Result.append_string (CommandSeparator)
		end

	sp_start (a_procedure: detachable XPLAIN_PROCEDURE)
		do
			begin_new_separator
			precursor (a_procedure)
		end

	sp_use_param (name: STRING): STRING
			-- return stored procedure parameter `name' formatted
			-- according to the dialects convention when using
			-- parameters in sql code. It is usually prefixed by '@' or ':'
		do
			Result := ":" + quote_identifier (name)
		end


feature {NONE} -- Implementation

	init_error: STRING
			-- Scratch used to give a more meaningful error in
			-- `sqlinitvalue_attribute'

end
