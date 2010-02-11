indexing

	description: "Produces FoxPro SQL output"

	bugs:
		"This code is not maintained/tested on a regular basis."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #7 $"

class

	SQL_GENERATOR_FOXPRO

inherit

	SQL_GENERATOR_SIMPLE
		redefine
			ViewsSupported,
			datatype_char,
			datatype_int,
			datatype_numeric,
			datatype_varchar
		end


create

	make


feature -- About this generator

	target_name: STRING is
			-- Name and version of dialect
		once
			Result := "FoxPro SQL"
		end


feature -- identifiers

	MaxIdentifierLength: INTEGER is
		once
			Result := 64
		end


feature -- table options

	ViewsSupported: BOOLEAN is
		once Result := False end


feature -- type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING is
		do
			Result := "L"
		end

	datatype_char (representation: XPLAIN_C_REPRESENTATION): STRING is
		do
			Result := "C(" + representation.length.out + ")"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING is
		do
			Result := "T"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING is
			-- platform dependent approximate numeric data type
		do
			Result := "D"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING is
		do
			Result := "I"
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING is
		do
			Result := "M"
		end

	datatype_numeric (representation: XPLAIN_R_REPRESENTATION): STRING is
			-- exact numeric data type
		local
			precision, scale: INTEGER
		do
			precision := representation.before + representation.after
			scale := representation.after
			Result := "N(" + precision.out + "," + scale.out + ")"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING is
		do
			Result := "M"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING is
		do
			Result := "M"
		end

	datatype_varchar (representation: XPLAIN_A_REPRESENTATION): STRING is
		do
			Result := "C(" + representation.length.out + ")"
		end


end
