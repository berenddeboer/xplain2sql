note

	description: "Produces mySQL 5.0 output."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2005, Berend de Boer"


class

	SQL_GENERATOR_MYSQL5


inherit

	SQL_GENERATOR_ADVANCED
		redefine
			minimum_date_value,
			AutoPrimaryKeyConstraint,
			ChecksNullAfterTrigger,
			sql_string_combine_start,
			sql_string_combine_separator,
			sql_string_combine_end,
			create_select_value_inside_sp,
			create_select_value_outside_sp,
			create_value_assign_inside_sp,
			create_value_assign_outside_sp,
			create_value_declare_inside_sp,
			create_value_declare_outside_sp,
			create_use_database,
			datatype_int,
			DomainsSupported,
			ExpressionsInDefaultClauseSupported,
			SupportsQualifiedSetInUpdate,
			max_numeric_precision,
			quote_identifier,
			quoted_value_identifier,
			output_update_extend_join_clause,
			output_update_join_clause,
			create_delete,
			sql_select_function_limit_before,
			sql_select_function_limit_after,
			conditional_drop_procedure,
			sp_define_out_param,
			sp_define_param_name,
			sp_end,
			sp_header_end,
			sp_start,
			sqlgetvalue_outside_sp,
			sql_last_auto_generated_primary_key,
			sql_extend_insert_missing_rows,
			AutoPrimaryKeySupported,
			ConstraintNameSupported,
			TemporaryTablesSupported,
			SupportsDefaultValues,
			SupportsJoinInUpdate,
			ExistentialFromTable,
			target_name,
			drop_table_if_exist,
			drop_temporary_table_if_exist,
			drop_view_if_exist
		end


create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "MySQL 5.0, ANSI mode"
		end


feature -- identifiers

	MaxIdentifierLength: INTEGER
		once
			Result := 64
		end


feature -- Domain options

	DomainsSupported: BOOLEAN once Result := False end


feature -- Date/time

	minimum_date_value: STRING = "0001-01-01"
			-- Need year 1 for mysql # 5.0.32-Debian_7etch6-log;
			-- It seems 5.0.51a-3ubuntu5.3-log handles year 0 though.


feature -- Numeric precision

	max_numeric_precision: INTEGER
			-- Maximum precision of the numeric data type
		once
			Result := 65
		end


feature -- Database

	create_use_database (database: STRING)
			-- Switch to ANSI mode for this connection.
		do
			std.output.put_string ("set session sql_mode='ansi,strict_all_tables'")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_character ('%N')
			std.output.put_string ("drop table if exists " + ExistentialFromTable)
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_string ("create table " + ExistentialFromTable + " (dummy int not null default 0)")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_string ("insert into " + ExistentialFromTable + " (dummy) values (0)")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_character ('%N')
		end


feature -- Table options

	AutoPrimaryKeySupported: BOOLEAN = True
			-- Does this dialect support auto-generated primary keys?

	AutoPrimaryKeyConstraint: STRING
			-- The SQL that enables an autoincrementing primary key
		once
			Result := "auto_increment " + PrimaryKeyConstraint
		end

	ConstraintNameSupported: BOOLEAN
		once
			Result := False
		end

	ExpressionsInDefaultClauseSupported: BOOLEAN = False
			-- Does the SQL dialect support expressions (1 + 1 for
			-- example) in the default clause?
			-- MySQL 5 is an example of a database that doesn't.

	TemporaryTablesSupported: BOOLEAN once Result := True end


feature -- init [default] options

	ChecksNullAfterTrigger: BOOLEAN
			-- Does this dialect check for nulls in columns after a
			-- trigger has been fired?
		once
			Result := False
		end


feature -- select options

	ExistentialFromTable: STRING = "xplain_dual"
			-- Name of the dual table; for MySQL we have to generate one,
			-- because MySQL's existing one has weird effects, and
			-- doesn't seem to work well.


feature -- insert options

	SupportsDefaultValues: BOOLEAN
			-- Does the dialect supports the 'default values' clause in an
			-- insert statement?
		once
			Result := False
		end

feature -- update options

	SupportsQualifiedSetInUpdate: BOOLEAN
			-- Can column names in set expression be qualified?
			-- This must be done in certain cases to avoid ambiguous updates.
		do
			Result := True
		end

	SupportsJoinInUpdate: BOOLEAN
			-- Does this dialect support a from clause in an update statement?
		do
			Result := True
		end


feature -- Strings

	sql_string_combine_start: STRING = "concat("

	sql_string_combine_separator: STRING = ", "

	sql_string_combine_end: STRING = ")"


feature -- Table SQL

	create_init (type: XPLAIN_TYPE)
		local
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			comma: STRING
		do
			std.output.put_string ("%Ndelimiter |%N")
			std.output.put_string (format ("create trigger $s before insert on $s%Nfor each row%Nbegin%N", <<quote_valid_identifier("tr_" + type.sqlname (Current) + "Init"), type.quoted_name (Current)>>))
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
					std.output.put_string (format ("set new.$s = $s", <<cursor.item.q_sql_select_name (Current), sql_init_expression (cursor.item)>>))
					std.output.put_string (CommandSeparator)
					std.output.put_character ('%N')
				end
				cursor.forth
			end
			std.output.put_string ("end |%N")
			std.output.put_string ("delimiter ")
			std.output.put_string (CommandSeparator)
			std.output.put_string ("%N%N")
		end

	create_primary_key_generator (type: XPLAIN_TYPE)
		do
			-- not necessary
		end


feature -- Auto primary key SQL

	sql_last_auto_generated_primary_key	(type: XPLAIN_TYPE): STRING
			-- Return code to get the last auto-generated primary
			-- key. For TSQL this is not type specific.
		once
			-- We also have mysql_insert_id() which returns the last id
			-- inserted in an auto incremented field, whether generated
			-- or specified.
			Result := "last_insert_id()"
		end


feature -- Value

	create_select_value_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL that returns the value when asked for that value
			-- inside a stored procedure.
		do
			std.output.put_string (format (once "select $s as `$s`", <<a_value.quoted_name (Current), a_value.name>>))
		end

	create_select_value_outside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL that returns the value when asked for that value
			-- outside a stored procedure.
			-- Should not emit `CommandSeparator'.
		do
			std.output.put_string (format (once "select $s", <<a_value.quoted_name (Current)>>))
		end

	create_value_declare_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL code to declare `a_value' inside a stored procedure.
		do
			-- Values don't need to be declared.
		end

	create_value_declare_outside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL code to declare `a_value' outside a stored procedure.
		do
			-- Values don't need to be declared.
		end

	create_value_assign_inside_sp (a_value: XPLAIN_VALUE)
			-- Emit code to assign `a_value'.`expression' to `a_value'
			-- inside a stored procedure.
		do
			std.output.put_string (format ("set $s := ($s)", <<a_value.quoted_name (Current), a_value.expression.outer_sqlvalue (Current)>>))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_value_assign_outside_sp (a_value: XPLAIN_VALUE)
			-- Assign a value to `a_value' outside a stored procedure.
		do
			std.output.put_string (format ("set $s := ($s)", <<a_value.quoted_name (Current), a_value.expression.outer_sqlvalue (Current)>>))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	quoted_value_identifier (a_value: XPLAIN_VALUE): STRING
			-- Value identifier, quoted;
			-- MySQL wants the '@' outside the quote
		local
			s: STRING
		do
			s := quote_identifier (a_value.sqlname (Current))
			create Result.make (1 + s.count)
			Result.append_character ('@')
			Result.append_string (s)
		end

	sqlgetvalue_inside_sp (a_value: XPLAIN_VALUE): STRING
			-- SQL expression that returns the value of a value inside a
			-- stored procedure
		do
			Result := a_value.quoted_name (Current)
		end

	sqlgetvalue_outside_sp (a_value: XPLAIN_VALUE): STRING
			-- SQL expression to retrieve the value of a value
		do
			Result := a_value.quoted_name (Current)
		end


feature -- Extends

	sql_extend_insert_missing_rows (an_expression: XPLAIN_EXTENSION_FUNCTION_EXPRESSION; an_extension: XPLAIN_ABSTRACT_EXTENSION): STRING
			-- An extend with a where clause will make the initial insert
			-- into the temporary table to be only a partial on. Missing
			-- rows are added here. But MySQL does not support self
			-- selects against tempory tables so for MySQL it's a two
			-- step process.
		local
			type: XPLAIN_TYPE
		do
			check attached an_expression.per_property.last as last then
				type := last.item.type
			end
			create Result.make (512)
			Result.append_string ("drop temporary table if exists extend_self_select")
			Result.append_string (CommandSeparator)
			Result.append_character ('%N')
			Result.append_string ("create temporary table extend_self_select (id ")
			Result.append_string (an_extension.type.columndatatype (Current))
			Result.append_character (')')
			Result.append_string (CommandSeparator)
			Result.append_character ('%N')
			Result.append_character ('%N')
			Result.append_string (once "insert into extend_self_select (id)%N")
			Result.append_string (Tab)
			Result.append_string (once "select ")
			Result.append_string (type.q_sqlpkname (Current))
			Result.append_string (once " from ")
			Result.append_string (type.quoted_name (Current))
			Result.append_string (once " where ")
			Result.append_string (type.q_sqlpkname (Current))
			Result.append_string (once " not in (select ")
			Result.append_string (quote_identifier (an_extension.type.sqlpkname (Current)))
			Result.append_string (once " from ")
			Result.append_string (TemporaryTablePrefix)
			Result.append_string (quote_identifier (an_extension.sqlname (Current)))
			Result.append_string (once ")")
			Result.append_string (CommandSeparator)

			Result.append_string (once "%Ninsert into ")
			Result.append_string (TemporaryTablePrefix)
			Result.append_string (quote_identifier (an_extension.sqlname (Current)))
			Result.append_string (once " (")
			Result.append_string (quote_identifier (an_extension.type.sqlpkname (Current)))
			Result.append_string (once ", ")
			Result.append_string (an_extension.q_sql_insert_name (Current, Void))
			Result.append_string (once ")%N")
			Result.append_string (Tab)
			Result.append_string (once "select ")
			Result.append_string (type.q_sqlpkname (Current))
			Result.append_string (once ", ")
			Result.append_string (an_expression.selection.function.sqlextenddefault (Current, an_expression))
			Result.append_string (once " from ")
			Result.append_string (type.quoted_name (Current))
			Result.append_string (once " where ")
			Result.append_string (type.q_sqlpkname (Current))
			Result.append_string (once " in (select id from extend_self_select)")
		end


feature -- Updates

	output_update_extend_join_clause (a_subject: XPLAIN_SUBJECT; an_extension: XPLAIN_EXTENSION; a_join_list: detachable JOIN_LIST)
			-- Output join to necessary tables when updating extended table.
		do
			if attached a_join_list as j then
				std.output.put_string (a_subject.type.quoted_name (Current))
				std.output.put_string (sql_select_joins (j))
			else
				precursor (a_subject, an_extension, a_join_list)
			end
		end

	output_update_join_clause (a_subject: XPLAIN_SUBJECT; a_join_list: detachable JOIN_LIST)
			-- Output join to necessary tables for an update statement.
			-- If a dialect doesn't support it, just the update for
			-- the extended table is emitted and it will need
			-- subselects to retrieve other pieces of data.
		do
			std.output.put_string (a_subject.type.quoted_name (Current))
			check attached a_join_list end
			if attached a_join_list as jl then
				std.output.put_string (sql_select_joins (jl))
			end
		end


feature -- Deletes

	create_delete (subject: XPLAIN_SUBJECT; predicate: detachable XPLAIN_EXPRESSION)
			-- Emit MySQL delete statement which supports joins in
			-- the delete statement itself.
		local
			join_list: JOIN_LIST
		do
			std.output.put_character ('%N')
			std.output.put_string ("delete ")
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


feature -- Functions


	sql_select_function_limit_before (selection_list: XPLAIN_SELECTION_FUNCTION): STRING
			-- Code that limits a select to return a single value. Output
			-- is placed in front of the select statement.
			-- Returns empty for no output.
		once
			Result := " "
		end

	sql_select_function_limit_after: STRING
			-- Code that limits a select to return a single value. Output
			-- is placed after the select statement.
			-- Returns empty for no output.
		once
			Result := " limit 1"
		end

feature -- Stored procedure SQL

	conditional_drop_procedure (name: STRING)
			-- Drop procedure, but only if it exists, should never
			-- generate an error or warning.
		do
			std.output.put_string (once "drop procedure if exists " + quote_identifier (name))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	sp_define_out_param (name: STRING): STRING
			-- Return `name' formatted as an output parameter, as it
			-- should appear in the header/definition of a stored
			-- procedure. See also `sp_define_in_param'.
		do
			Result := "out " + sp_define_param_name (name)
		end

	sp_define_param_name (name: STRING): STRING
			-- Return `name' formatted as the name of the parameter as it
			-- appears in the header, and hopefully as it is known to
			-- clients. It must be quoted, if it can be quoted.
		do
			Result := quote_identifier (name)
		end

	sp_end
		local
			s: STRING
		do
			s := CommandSeparator.twin
			CommandSeparator.wipe_out
			CommandSeparator.append_string ("%N//")
			precursor
			CommandSeparator.wipe_out
			CommandSeparator.append_string (s)
			std.output.put_string ("delimiter ")
			std.output.put_string (CommandSeparator)
			std.output.put_string ("%N%N")
		end

	sp_get_auto_generated_primary_key (type: XPLAIN_TYPE): STRING
			-- Statement that returns the generated primary key into the
			-- output parameters. Statement should end with CommandSeperator.
		do
			create Result.make (64)
			Result.wipe_out
			Result.append_string ("select ")
			Result.append_string (sp_use_param (type.sqlpkname (Current)))
			Result.append_string (" = ")
			Result.append_string (sql_last_auto_generated_primary_key (type))
			Result.append_string (CommandSeparator)
		end

	sp_header_end
			-- Emit code to end stored procedure declaration.
		do
			std.output.put_character ('%N')
		end

	sp_start (a_procedure: detachable XPLAIN_PROCEDURE)
			-- Start MySQL procedure.
		do
			std.output.put_string ("delimiter //%N")
			precursor (a_procedure)
		end


feature -- type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		do
			Result := "boolean"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		do
			Result := "datetime"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- platform dependent approximate numeric data type
		do
			Result := "double"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
		do
			inspect representation.length
			when 1 .. 2 then
				Result := "tinyint"
			when 3 .. 4 then
				Result := "smallint"
			when 5 .. 6 then
				Result := "mediumint"
			when 7 .. 9 then
				Result := "int"
			when 10 .. 18 then
				Result := "bigint"
			else
				if representation.length > max_numeric_precision then
					std.error.put_string ("Too large integer representation detected: ")
					std.error.put_integer (representation.length)
					std.error.put_string ("%NRepresentation truncated to ")
					std.error.put_integer (max_numeric_precision)
					std.error.put_character ('%N')
					Result := "decimal(" + max_numeric_precision.out + ", 0)"
				else
					Result := "decimal(" + representation.length.out + ", 0)"
				end
			end
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		do
			Result := "numeric(12,4)"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
		do
			Result := "longblob"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
		do
			Result := "longtext"
		end


feature -- drop statements

	drop_primary_key_generator (type: XPLAIN_TYPE)
		do
			-- not necessary
		end

	drop_table_if_exist (type: XPLAIN_TYPE)
			-- Generate a statement that drops this table, but only if it exists,
			-- No warning must be generated if the table does not exist at
			-- run-time
		do
			std.output.put_string ("drop table if exists ")
			std.output.put_string (quote_identifier (type.sqltablename (Current)))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	drop_temporary_table_if_exist (extension: XPLAIN_EXTENSION)
			-- Drop the temporary table created for `extension'.
		do
			std.output.put_string ("drop temporary table if exists ")
			std.output.put_string (extension.quoted_name (Current))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	drop_view_if_exist (a_name: STRING)
			-- Generate a statement that drops a view table, but only if
			-- it exists, no warning must be generated if the table does
			-- not exist at run-time.
		do
			std.output.put_string ("drop view if exists ")
			std.output.put_string (quote_valid_identifier (a_name))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end


feature -- identifiers

	quote_identifier (identifier: STRING): STRING
			-- return identifier, optionally surrounded by quotes if identifier
			-- contains spaces and rdbms supports spaces in identifiers
		do
			create Result.make (identifier.count + 2)
			Result.append_character ('"')
			Result.append_string (identifier)
			Result.append_character ('"')
		end

end
