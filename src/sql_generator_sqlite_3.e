note

	description:

		"SQLite version 3 support"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2005 Berend de Boer, see forum.txt"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #5 $"


class

	SQL_GENERATOR_SQLITE_3


inherit

	SQL_GENERATOR_WITHOUT_SP
		undefine
			sqlcolumnrequired_base,
			sqlcolumnrequired_type
		redefine
			AutoPrimaryKeySupported,
			AutoPrimaryKeyConstraint,
			datatype_char,
			datatype_varchar,
			DomainsSupported,
			DropColumnSupported,
			SQLTrue,
			SQLFalse,
			SupportsTrueBoolean,
			ViewColumnsSupported,
			sql_string_combine_separator
		end

	SQL_GENERATOR_WITH_TRIGGERS
		redefine
			AutoPrimaryKeySupported,
			AutoPrimaryKeyConstraint,
			ChecksNullAfterTrigger,
			datatype_char,
			datatype_varchar,
			DomainsSupported,
			DropColumnSupported,
			SQLTrue,
			SQLFalse,
			SupportsTrueBoolean,
			ViewColumnsSupported,
			sql_string_combine_separator
		end


create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "SQLite 3"
		end


feature -- Domain options

	DomainsSupported: BOOLEAN
			-- Does this dialect support creation of user defined data types?
		once
			Result := False
		end


feature -- Identifier capabilities

	MaxIdentifierLength: INTEGER = 256
			-- Maximum length of identifiers;
			-- Not sure if SQLite has any limit here.


feature -- Table options

	AutoPrimaryKeySupported: BOOLEAN = True
			-- Does this dialect support auto-generated primary keys?

	AutoPrimaryKeyConstraint: STRING
			-- The SQL that enables an autoincrementing primary key
		once
			Result := PrimaryKeyConstraint + " autoincrement"
		end

	ViewColumnsSupported: BOOLEAN = False
			-- Does the dialect require a list of columns after the view
			-- name?


feature -- init [default] options

	ChecksNullAfterTrigger: BOOLEAN
			-- Does this dialect check for nulls in columns after a
			-- trigger has been fired?
		once
			-- Unfortunately it does not.
			Result := False
		end


feature -- Booleans

	SQLTrue: STRING once Result := "1" end
	SQLFalse: STRING once Result := "0" end

	SupportsTrueBoolean: BOOLEAN = False
			-- Does this dialect support first-class Booleans?
			-- Or do they have to be emulated?
			-- Interestingly, most dialects don't support it.


feature -- Strings

	sql_string_combine_separator: STRING = " || "


feature -- purge options

	DropColumnSupported: BOOLEAN
			-- Does this dialect support dropping of columns?
		once
			Result := False
		end


feature -- create statements

	create_init (type: XPLAIN_TYPE)
		local
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			comma: STRING
		do
			std.output.put_string (format ("%Ncreate trigger $s after insert on $s%Nfor each row%Nbegin%N", <<quote_valid_identifier("tr_" + type.sqlname (Current) + "Init"), type.quoted_name (Current)>>))
			std.output.put_string (Tab)
			std.output.put_string (format ("update $s set%N", <<type.quoted_name (Current)>>))
			Tab.append_string ("  ")
			from
				cursor := type.new_init_attributes_cursor (Current)
				cursor.start
				comma := ""
			until
				cursor.after
			loop
				if not cursor.item.init.is_literal then
					std.output.put_string (comma)
					std.output.put_string (Tab)
					std.output.put_string (cursor.item.q_sql_select_name (Current))
					std.output.put_string (" = ")
					Tab.append_string ("  ")
					std.output.put_string (sql_init_expression (cursor.item))
					Tab.remove_tail (2)
					comma := ",%N"
				end
				cursor.forth
			end
			Tab.remove_tail (2)
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("where rowid = new.rowid")
			std.output.put_string (CommandSeparator)
			std.output.put_string ("%Nend")
			std.output.put_string (CommandSeparator)
			std.output.put_string ("%N%N")
		end

	create_primary_key_generator (type: XPLAIN_TYPE)
		do
			-- nothing
		end

	create_use_database (database: STRING)
			-- start using a certain database
		do
			-- nothing
		end


feature -- drop statements

	drop_primary_key_generator (type: XPLAIN_TYPE)
		do
			-- nothing
		end


feature -- Stored procedures

	sp_get_auto_generated_primary_key (type: XPLAIN_TYPE): STRING
			-- Statement that returns the generated primary key into the
			-- output parameters. Statement should end with CommandSeperator.
		do
			-- We should not be called
			Result := ""
		end


feature -- Data types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		do
			Result := "integer"
		end

	datatype_char (representation: XPLAIN_C_REPRESENTATION): STRING
		do
			Result := "text"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		do
			-- datetime not really supported, no idea how to handle this
			Result := "text"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- Platform dependent approximate numeric data type using
			-- largest size available on that platform.
		do
			Result := "real"
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		do
			Result := "real"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
		do
			Result := "blob"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
		do
			Result := "blob"
		end

	datatype_varchar (representation: XPLAIN_A_REPRESENTATION): STRING
		do
			Result := "text"
		end


end
