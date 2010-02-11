indexing

	description:
		"Produces general MySQL output."

	mysql_shortcomings:
		"1. Biggest problem is the lack of subselects."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"


deferred class

	SQL_GENERATOR_MYSQL

inherit

	SQL_GENERATOR_SIMPLE
		redefine
			AutoPrimaryKeySupported,
			ConstraintNameSupported,
			CheckConstraintSupported,
			InlineUniqueConstraintSupported,
			TemporaryTablesSupported,
			SQLTrue,
			SQLFalse,
			datatype_int
		end


feature -- identifiers

	MaxIdentifierLength: INTEGER is
		once
			Result := 64
		end

feature -- table options

	AutoPrimaryKeySupported: BOOLEAN is once Result := True end

	ConstraintNameSupported: BOOLEAN is
		once
			Result := False
		end

	CheckConstraintSupported: BOOLEAN is
		once
			Result := False
		end

	InlineUniqueConstraintSupported: BOOLEAN is
		once
			Result := False
		end

	TemporaryTablesSupported: BOOLEAN is once Result := True end


feature -- Booleans

	SQLTrue: STRING is once Result := "'T'" end
	SQLFalse: STRING is once Result := "'F'" end


feature -- type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING is
		do
			Result := "char(1)"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING is
		do
			Result := "datetime"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING is
			-- platform dependent approximate numeric data type
		do
			Result := "double"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING is
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

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING is
		do
			Result := "numeric(12,4)"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING is
		do
			Result := "longblob"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING is
		do
			Result := "longtext"
		end


end
