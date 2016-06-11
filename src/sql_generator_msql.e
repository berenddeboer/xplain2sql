note

	description:
		"Produces msql 2.0.4.1 output. Maybe lower versions are supported also."

	known_bugs: ""

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"

class

	SQL_GENERATOR_MSQL

inherit

	SQL_GENERATOR_SIMPLE
		redefine
			ConstraintNameSupported,
			CheckConstraintSupported,
			ColumnNullAllowed,
			InlineUniqueConstraintSupported,
			datatype_char,
			datatype_int,
			datatype_numeric,
			datatype_varchar
		end

create

	make

feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "msql 2.0.4.1"
		end


feature -- identifiers

	MaxIdentifierLength: INTEGER
		once
			Result := 64
		end


feature -- Table options

	ConstraintNameSupported: BOOLEAN
		once
			Result := False
		end

	CheckConstraintSupported: BOOLEAN
		once
			Result := False
		end

	ColumnNullAllowed: BOOLEAN
		once
			Result := False
		end

	InlineUniqueConstraintSupported: BOOLEAN
		once
			Result := False
		end


feature -- type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		do
			Result := "char(1)"
		end

	datatype_char (representation: XPLAIN_C_REPRESENTATION): STRING
		do
			Result := "char(" + representation.length.out + ")"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		do
			Result := "int"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- platform dependent approximate numeric data type
		do
			Result := "real"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
		do
			Result := "int"
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		do
			Result := "real"
		end

	datatype_numeric (representation: XPLAIN_R_REPRESENTATION): STRING
		do
			Result := "real"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
		do
			-- not suported
			Result := ""
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
		do
			Result := "text(256)"
			-- Note: 256 is expected avg length.
			-- may contain more characters.
		end

	datatype_varchar (representation: XPLAIN_A_REPRESENTATION): STRING
		do
			Result := "char(" + representation.length.out + ")"
		end


end
