note

	description: "Produces Oracle 9.0.1 SQL output"

	author:     "Berend de Boer <berend@pobox.com>"

class

	SQL_GENERATOR_ORACLE

inherit

	SQL_GENERATOR_ADVANCED
		redefine
			DomainsSupported,
			AutoPrimaryKeySupported,
			CreateTemporaryTableStatement,
			FinishTemporaryTableStatement,
			FinishTemporaryValueTableStatement,
			TemporaryTablesSupported,
			ExtendIndexSupported,
			ExistentialFromTable,
			IdentifierWithSpacesSupported,
			SQLTrue,
			SQLFalse,
			SupportsTrueBoolean,
			sql_string_combine_separator,
			max_numeric_precision,
			SupportsDefaultValues,
			create_domain,
			create_end,
			create_select_function,
			create_select_list,
			forbid_update_of_primary_key,
			drop_procedure,
			drop_table_if_exist,
			drop_temporary_table_if_exist,
			datatype_char,
			datatype_int,
			datatype_numeric,
			datatype_varchar,
			sqlsysfunction_current_timestamp,
			sqlsysfunction_system_user,
			quote_identifier,
			StoredProcedureParamListStartRequired,
			sp_define_param_name,
			sp_end,
			sql_expression_as_boolean_value,
			sql_last_auto_generated_primary_key,
			sp_result_parameter,
			sp_return_parameter_format_string,
			sp_start,
			sp_user_declaration,
			as_string,
			extension_index_name,
			sql_init_expression,
			new_row_prefix
		end

create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "Oracle SQL 9.0.1"
		end


feature -- Domain options

	DomainsSupported: BOOLEAN
		once
			Result := False
		end


feature -- Table options

	AutoPrimaryKeySupported: BOOLEAN
		do
			Result := True
		end

	CreateTemporaryTableStatement: STRING = "create global temporary table"

	FinishTemporaryTableStatement: STRING
			-- String to output when temporary table definition is finished
		do
			Result := " on commit preserve rows"
		end

	FinishTemporaryValueTableStatement: STRING
			-- Oracle doesn't like alter tables when using on commit
			-- preserve rows
		do
			Result := ""
		end

	TemporaryTablesSupported: BOOLEAN = True
			-- Support 'create temporary table' statement.


feature -- extend options

	ExtendIndexSupported: BOOLEAN
		do
			-- cannot create an index when using "on commit preserve rows"
			Result := False
		end


feature -- select options

	ExistentialFromTable: STRING = "dual"
			-- dual is the name of Oracle's dummy table.


feature -- Identifiers

	IdentifierWithSpacesSupported: BOOLEAN
		do
			Result := True
		end

	MaxIdentifierLength: INTEGER
		do
			Result := 30
		end


feature -- Booleans

	SQLTrue: STRING = "'T'"
	SQLFalse: STRING = "'F'"

	SupportsTrueBoolean: BOOLEAN
			-- Does this dialect support first-class Booleans?
			-- Or do they have to be emulated?
		do
			Result := False
		end


feature -- Strings

	sql_string_combine_separator: STRING = " || "


feature -- Numeric precision

	max_numeric_precision: INTEGER
			-- Max precision of the numeric data type.
		do
			Result := 38
		end


feature -- insert options

	SupportsDefaultValues: BOOLEAN
			-- Does the dialect supports the 'default values' clause in an
			-- insert statement?
		do
			Result := False
		end


feature -- Oracle specific SQL creation statements

	create_init (type: XPLAIN_TYPE)
		local
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			comma: STRING
		do
			std.output.put_string (format ("%Ncreate trigger $s before insert on $s%Nfor each row%Nbegin%N", <<quote_valid_identifier("tr_" + type.sqlname (Current) + "Init"), type.quoted_name (Current)>>))
			-- Enable sp to change CommandSeparator
			is_stored_procedure := True
			from
				cursor := type.new_init_attributes_cursor (Current)
				cursor.start
				comma := ""
			until
				cursor.after
			loop
				if
					not cursor.item.is_init_default or else
					(attached cursor.item.init as init and then
					 not init.is_constant)
				then
					std.output.put_string (Tab)
					Tab.append_string ("  ")
					std.output.put_string (format ("select $s into :new.$s from $s", <<sql_init_expression (cursor.item), cursor.item.q_sql_select_name (Current), ExistentialFromTable>>))
					Tab.remove_tail (2)
					std.output.put_string (CommandSeparator)
					std.output.put_character ('%N')
				end
				cursor.forth
			end
			is_stored_procedure := False
			std.output.put_string ("end")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_character ('/')
			std.output.put_string ("%N%N")
		end

	create_domain (base: XPLAIN_BASE)
			-- Does not work, only when I create a single package.
		local
			s: detachable STRING
		do
			std.output.put_string ("subtype ")
			std.output.put_string (quote_identifier (domain_identifier (base)))
			std.output.put_string (" is ")
			std.output.put_string (base.representation.datatype (Current))
			s := domain_null_or_not_null (base.representation.domain_restriction)
			if s /= Void then
				std.output.put_string (" ")
				std.output.put_string (s)
			end
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_end (database: STRING)
		do
			std.output.put_string ("exit%N")
		end

	create_primary_key_generator (type: XPLAIN_TYPE)
			-- It is not possible to mix your own identifiers and
			-- auto-generated identifiers with Oracle. People wonder why
			-- Microsoft is doing so well, might it be that they just
			-- offer more functionality (call it feature creep if you
			-- want) than anyone else??
			-- To offer limited support for user generated keys, I start
			-- auto-numbering with 1000.
		local
			sn: STRING
			max: STRING
		do
			sn := quote_valid_identifier (sequence_name (type))
			std.output.put_character ('%N')
			std.output.put_string ("create sequence ")
			std.output.put_string (sn)
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("start with ")
			max := type.representation.max_value (Current)
			if type.representation.is_integer and then type.representation.length <= 3 then
				std.output.put_string ("1")
			else
				std.output.put_string ("1000")
			end
			std.output.put_string (" maxvalue ")
			std.output.put_string (max)
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_character ('%N')
			std.output.put_string ("create trigger ")
			std.output.put_string (quote_valid_identifier ("tr_" + type.sqlname (Current) + "BeforeInsert"))
			std.output.put_character ('%N')
			std.output.put_string ("before insert on ")
			std.output.put_string (quote_identifier (type.sqltablename (Current)))
			std.output.put_character ('%N')
			std.output.put_string ("for each row%N")
			std.output.put_string ("begin%N")
			std.output.put_string (Tab)
			std.output.put_string ("if (:new.")
			std.output.put_string (type.q_sqlpkname(Current))
			std.output.put_string (" is Null) then%N")
			std.output.put_string (Tab)
			std.output.put_string (Tab)
			std.output.put_string ("select ")
			std.output.put_string (sn)
			std.output.put_string (".nextval into :new.")
			std.output.put_string (quote_identifier (type.sqlpkname (Current)))
			std.output.put_string (" from ")
			std.output.put_string (ExistentialFromTable)
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("end if")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_string ("end")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_character ('/')
			std.output.put_character ('%N')
			std.output.put_character ('%N')
		end

	create_select_function (selection_list: XPLAIN_SELECTION_FUNCTION)
		do
			if is_stored_procedure then
				std.output.put_string ("open result_cursor for")
			end
			precursor (selection_list)
			if is_stored_procedure then
				std.output.put_string ("return result_cursor")
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			end
		end

	create_select_list (selection_list: XPLAIN_SELECTION_LIST)
		do
			if is_stored_procedure then
				std.output.put_string ("open result_cursor for")
			end
			precursor (selection_list)
			if is_stored_procedure then
				std.output.put_string ("return result_cursor")
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			end
		end

	create_select_value_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL that returns the value when asked for that value
			-- inside a stored procedure.
		do
			std.output.put_string ("open result_cursor for%N  select ")
			std.output.put_string (a_value.quoted_name (Current))
			std.output.put_string (" from ")
			std.output.put_string (ExistentialFromTable)
			std.output.put_string (CommandSeparator)
			std.output.put_string ("%Nreturn result_cursor")
		end

	create_use_database (database: STRING)
			-- start using a certain database
		do
			-- nothing
		end

	create_value_declare_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit code to declare `a_value' inside a stored procedure.
		do
			std.output.put_string (Tab)
			std.output.put_string (a_value.quoted_name (Current))
			std.output.put_character (' ')
			std.output.put_string (a_value.representation.datatype(Current))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_value_assign_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit code to assign `a_value'.`expression' to `a_value'
			-- inside a stored procedure.
		do
			std.output.put_string ("select (")
			std.output.put_string (a_value.expression.outer_sqlvalue (Current))
			std.output.put_string (") into ")
			std.output.put_string (a_value.quoted_name (Current))
			std.output.put_string (" from ")
			std.output.put_string (ExistentialFromTable)
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	forbid_update_of_primary_key (type: XPLAIN_TYPE)
			-- Generate code, if necessary, that forbids updating of the
			-- primary key column of the table generated for `type'.
		local
			table,
			pk: STRING
		do
			table := quote_identifier (type.sqltablename (Current))
			pk := type.q_sqlpkname (Current)
			std.output.put_string (format (forbid_update_of_primary_key_template, <<quote_identifier (trigger_primary_key_update_name (type)), table, pk, pk, table>>))
			std.output.put_string ("/%N%N")
		end


feature -- Drop statements

	drop_primary_key_generator (type: XPLAIN_TYPE)
		local
			sn: STRING
		do
			sn := quote_valid_identifier (sequence_name (type))
			std.output.put_string ("drop sequence ")
			std.output.put_string (sn)
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	drop_table_if_exist (type: XPLAIN_TYPE)
			-- Generate a statement that drops this table, but only if it exists,
			-- No warning must be generated if the table does not exist at
			-- run-time
		do
			-- Oracle cannot drop stuff without warnings it seems.
			--drop_table (type)
		end

	drop_temporary_table_if_exist (extension: XPLAIN_EXTENSION)
			-- Drop the temporary table created for `extension'.
			-- Usually, implemention of this method is a hack. It should
			-- not be needed if a dialect supports temporary tables.
		do
			-- this is a hack, until we have good temporary table support
			std.output.put_string ("drop table ")
			std.output.put_string (extension.quoted_name (Current))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end


feature -- Type specification for xplain types, in stored procedure data types don't have a specific length or precision

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		do
			if is_stored_procedure then
				Result := once_char
			else
				Result := "char(1)"
			end
		end

	datatype_char (representation: XPLAIN_C_REPRESENTATION): STRING
		do
			if is_stored_procedure then
				Result := once_char
			else
				Result := "char(" + representation.length.out + ")"
			end
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		do
			Result := "date"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- Platform dependent approximate numeric data type.
		do
			Result := once_number
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
		do
			if is_stored_procedure then
				Result := once_number
			else
				Result := "number(" + representation.length.out + ")"
			end
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		do
			if is_stored_procedure then
				Result := once_number
			else
				Result := "number(12,4)"
			end
		end

	datatype_numeric (representation: XPLAIN_R_REPRESENTATION): STRING
			-- Exact numeric data type.
		local
			precision, scale: INTEGER
		do
			if is_stored_procedure then
				Result := once_number
			else
				precision := representation.before + representation.after
				scale := representation.after
				if precision > max_numeric_precision then
					std.error.put_string ("Too large real representation detected: ")
					std.error.put_integer (precision)
					std.error.put_string ("%NRepresentation truncated to ")
					std.error.put_integer (max_numeric_precision)
					std.error.put_character ('%N')
					scale := max_numeric_precision
				end
				Result := "number(" + precision.out + "," + scale.out + ")"
			end
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
			-- Store pictures of up to 1MB.
		do
			Result := "blob"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
			-- Maximum length is 1M characters.
		do
			-- Ugly trick to return a supported data type inside stored
			-- procedures.
			Result := "clob"
		end

	datatype_varchar (representation: XPLAIN_A_REPRESENTATION): STRING
		do
			if is_stored_procedure then
				Result := once_varchar
			else
				Result := "varchar2(" + representation.length.out + ")"
			end
		end


feature -- ANSI niladic functions

	sqlsysfunction_current_timestamp: STRING
		once
			Result := "SYSDATE"
		end

	sqlsysfunction_system_user: STRING
		once
			Result := "SYS_CONTEXT('userenv', 'SESSION_USER')"
		end


feature -- Identifiers

	quote_identifier (identifier: STRING): STRING
			-- Return identifier, surrounded by quotes.
		local
			s: STRING
		do
			s := "%"" + identifier + "%""
			Result := s
		end


feature -- Auto primary keys

	sequence_name (type: XPLAIN_TYPE): STRING
			-- Return the name of the sequence used for primary key generation.
		require
			type_not_void: type /= Void
		do
			Result := "seq_" + type.sqltablename (Current) + "_" + type.sqlpkname (Current) + "_seq"
		end


feature -- Return sql code

	sql_expression_as_boolean_value (expression: XPLAIN_EXPRESSION): STRING
			-- Return SQL code for extension that is a logical
			-- expression. For SQL dialects that don't support Booleans,
			-- it might need to map the Boolean result to a 'T' or 'F'
			-- value.
		do
			Result := format ("case when $s then $s else $s end", <<expression.sqlvalue (Current), SQLTrue, SQLFalse>>)
		end


feature -- Stored procedure support

	StoredProcedureParamListStartRequired: BOOLEAN = False
			-- True if start of a parameter list like '(' is required. It
			-- is for DB/2, it isn't for Oracle for example.

	drop_procedure (procedure: XPLAIN_PROCEDURE)
			-- Drop procedure `procedure'.
		do
			if procedure.returns_rows (Current) then
				do_drop_function (procedure.sqlname (Current))
			else
				do_drop_procedure (procedure.sqlname (Current))
			end
		end

	do_drop_function (a_name: STRING)
			-- Drop procedure `a_name', `a_name' is a valid sp identifier,
			-- and not yet quoted.
		do
			-- assume go before and after is not needed
			std.output.put_string ("drop function ")
			std.output.put_string (quote_identifier (a_name))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	sp_define_param_name (name: STRING): STRING
			-- Return `name' formatted as the name of the parameter as it
			-- appears in the header, and hopefully as it is known to
			-- clients.
		do
			Result := quote_valid_identifier ("p-" + name)
		end

	sp_end
			-- Write statements, if any, to end a stored procedure.
		do
			is_stored_procedure := False
			std.output.put_string ("end")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_character ('/')
			std.output.put_character ('%N')
		end

	sp_get_auto_generated_primary_key (type: XPLAIN_TYPE): STRING
			-- Statement that returns the generated primary key into the
			-- output parameters. Statement should end with CommandSeperator.
		do
			create Result.make (64)
			Result.wipe_out
			Result.append_string ("select ")
			Result.append_string (sql_last_auto_generated_primary_key (type))
			Result.append_string (" into ")
			Result.append_string (sp_use_param (type.sqlpkname (Current)))
			Result.append_string (" from ")
			Result.append_string (ExistentialFromTable)
			Result.append_string (CommandSeparator)
			Result.append_character ('%N')
		end

	sql_last_auto_generated_primary_key	(type: XPLAIN_TYPE): STRING
			-- Return code to get the last auto-generated primary key for
			-- `type'. Certain SQL dialects can only return the last
			-- generated key, so this code is not guaranteed to be `type'
			-- specific.
		do
			Result := quote_valid_identifier (sequence_name (type)) + ".currval"
		end

	sp_return_parameter_format_string: STRING
			-- Format a parameter as a return parameter.
		once
			Result := "$s out $s"
		end

	sp_start (a_procedure: detachable XPLAIN_PROCEDURE)
			-- Write statements to start a procedure, including the
			-- "create procedure " statement itself (including space).
		do
			is_stored_procedure := True
			if a_procedure /= Void and then a_procedure.returns_rows (Current) then
				std.output.put_string ("create or replace function ")
			else
				std.output.put_string ("create or replace procedure ")
			end
		end

	sp_result_parameter (a_procedure: detachable XPLAIN_PROCEDURE)
			-- Emit the result parameter of the stored procedure, if
			-- applicable.
			-- For example DB/2 and Oracle needs to know if rows are returned.
		do
			if a_procedure /= Void and then a_procedure.returns_rows (Current) then
				std.output.put_string (" return sys_refcursor")
			end
		end

	sp_user_declaration (procedure: XPLAIN_PROCEDURE)
			-- Emit value declarations
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

			if procedure.returns_rows (Current) then
				std.output.put_string (Tab)
				std.output.put_string ("result_cursor sys_refcursor")
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			end
		end


feature -- Literal

	as_string (s: STRING): STRING
			-- Return `s' as string by surrounding it with quotes. Makes
			-- sure `s' is properly quoted, so don't use together with
			-- `safe_string'!
		do
			if s /= Void and then not s.is_empty then
				Result := precursor (s)
			else
				Result := "' '"
			end
		ensure then
			at_least_one_space: Result.count >= 3
		end


feature -- Extension specific methods

	extension_index_name (an_extension: XPLAIN_EXTENSION): STRING
			-- Name of index on temporary table to speed up join to that table
		do
			Result := quote_valid_identifier ("idx_" + an_extension.type.name + "_" + an_extension.name)
		end


feature -- Get a variable/value

	sqlgetvalue_inside_sp (value: XPLAIN_VALUE): STRING
			-- SQL expression that returns the value of a value inside a
			-- stored procedure
		do
			Result := value.quoted_name (Current)
		end


feature {NONE} -- Triggers

	trigger_primary_key_update_name (type: XPLAIN_TYPE): STRING
			-- Unquoted name for trigger that forbids updating of the
			-- primary key
		require
			type_not_void: type /= Void
		do
			Result := make_valid_identifier ("fupd_" + type.name)
		end

	forbid_update_of_primary_key_template: STRING = "%
%create trigger $s%N%
%before update on $s%N%
%for each row%N%
%begin%N%
%  if :old.$s <> :new.$s then%N%
%    raise_application_error (-20000, 'Update of primary key of table $s is not allowed.');%N%
%  end if;%N%
%end;%N"


feature -- generation of init [default] expressions

	sql_init_expression (an_attribute: XPLAIN_ATTRIBUTE): STRING
			-- SQL code that initialises a single column and takes care
			-- if the init is a default or not
		do
			-- No coalesce needed, as we have a before insert trigger,
			-- and for init statements we should emit an after insert
			-- trigger actually.
			Tab.append_string ("  ")
			check attached an_attribute.init as init then
				create Result.make_from_string (init.sqlinitvalue (Current))
			end
			Tab.remove_tail (2)
		end

	new_row_prefix: STRING = ":new."
			-- Prefix to access new rows in a trigger


feature {NONE} -- once strings

	once_char: STRING = "char"

	once_number: STRING = "number"

	once_varchar: STRING = "varchar"


end
