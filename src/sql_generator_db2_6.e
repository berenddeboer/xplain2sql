note

	description: "Produces DB/2 version 6 SQL output"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"

	known_bugs: "Inherits from stored procedure, but it doesn't support them..."


class

	SQL_GENERATOR_DB2_6


inherit

	SQL_GENERATOR_SIMPLE
		redefine
			DomainsSupported,
			IdentifierWithSpacesSupported,
			MaxConstraintIdentifierLength,
			AutoPrimaryKeySupported,
			ColumnNullAllowed,
			ExpressionsInDefaultClauseSupported,
			DropColumnSupported,
			SQLTrue,
			SQLFalse,
			SupportsTrueBoolean,
			sql_string_combine_separator,
			create_end,
			datatype_int,
			sqlsysfunction_current_timestamp,
			sqlsysfunction_system_user,
			quote_identifier,
			index_name,
			create_use_database
		end

create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "DB/2 version 6"
		end


feature -- domain options

	DomainsSupported: BOOLEAN
		once
			Result := False
		end


feature -- Identifiers

	IdentifierWithSpacesSupported: BOOLEAN
		once
			Result := True
		end

	MaxIdentifierLength: INTEGER
			-- table names may be 128
		once
			Result := 30
		end

	MaxConstraintIdentifierLength: INTEGER
		once
			Result := 18
		end

	MaxIndexNameLength: INTEGER = 18


feature -- table options

	AutoPrimaryKeySupported: BOOLEAN
		once
			Result := False
		end

	ColumnNullAllowed: BOOLEAN
		once
			Result := False
		end

	ExpressionsInDefaultClauseSupported: BOOLEAN = False
			-- Does the SQL dialect support expressions (1 + 1 for
			-- example) in the default clause?


feature -- purge options

	DropColumnSupported: BOOLEAN
			-- can columns be removed?
		once
			Result := False
		end

feature -- Booleans

	SQLTrue: STRING once Result := "1" end
	SQLFalse: STRING once Result := "0" end

	SupportsTrueBoolean: BOOLEAN
		do
			Result := False
		end


feature -- Strings

	sql_string_combine_separator: STRING = " || "


feature -- actual creation of sql statements, you may redefine these

	create_end (database: STRING)
		do
			std.output.put_string ("disconnect ")
			std.output.put_string (database)
			std.output.put_string (CommandSeparator)
			std.output.put_string ("%N")
		end

	create_use_database (database: STRING)
			-- start using a certain database
		do
			std.output.put_string ("connect to ")
			std.output.put_string (database)
			std.output.put_string (CommandSeparator)
			std.output.put_string ("%N")
		end


feature -- Type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		once
			Result := "smallint"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		once
			Result := "timestamp"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- platform dependent approximate numeric data type
		once
			Result := "double precision"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
		do
			inspect representation.length
			when 1 .. 4 then
				Result := "smallint"
			when 5 .. 9 then
				Result := "integer"
			when 10 .. 18 then
				Result := "bigint"
			else
				Result := "numeric(" + representation.length.out + ", 0)"
			end
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		once
			Result := "numeric(12,4)"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
			-- Store pictures of up to 1MB.
		once
			Result := "blob(1M)"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
			-- Maximum length is 1M characters.
		once
			Result := "clob(1M)"
		end

feature -- ansi niladic functions

	sqlsysfunction_current_timestamp: STRING
		once
			Result := "CURRENT TIMESTAMP"
		end

	sqlsysfunction_system_user: STRING
		once
			Result := "USER"
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

feature -- Index name

	index_name (index: XPLAIN_INDEX): STRING
		do
			Result := "idx_" + index.type.sqlname (Current) + "_" + index.name
			Result.keep_head (MaxIndexNameLength)
			Result := make_valid_identifier (Result)
		end


end
