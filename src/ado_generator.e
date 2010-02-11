indexing

	description: "ADO specific type definitions"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer, see forum.txt"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #5 $"


deferred class

	ADO_GENERATOR

inherit

	ABSTRACT_GENERATOR

feature -- type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING is
		do
			Result := "adBoolean"
		end

	datatype_char (representation: XPLAIN_A_REPRESENTATION): STRING is
		do
			Result := "adVarChar"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING is
		do
			Result := "adDBTimestamp"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING is
			-- platform dependent approximate numeric data type using
			-- largest size available on that platform
		do
			Result := "adDouble"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING is
		do
			Result := "adInteger"
		end

	datatype_numeric (representation: XPLAIN_R_REPRESENTATION): STRING is
			-- exact numeric data type
		do
			Result := "adNumeric"
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING is
		do
			Result := "adCurrency"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING is
		do
			Result := "adLongVarBinary"
		end

	datatype_pk_char (representation: XPLAIN_PK_A_REPRESENTATION): STRING is
		do
			Result := "adChar"
		end

	datatype_pk_int (representation: XPLAIN_PK_I_REPRESENTATION): STRING is
		do
			Result := "adUnsignedInt"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING is
		do
			Result := "adLongVarChar"
		end

	datatype_varchar (representation: XPLAIN_V_REPRESENTATION): STRING is
		do
			Result := "adVarChar"
		end

feature -- length specification

	datalen (representation: XPLAIN_REPRESENTATION): INTEGER is
			-- this routine is a hack, best is probably to switch through the
			-- representation to the generator, but I needed the length
			-- only for ADO and the length is only necessary for
			-- character or byte datatypes, so I decided not to clutter
			-- ABSTRACT_GENERATOR for the moment.
		local
			A_representation: XPLAIN_A_REPRESENTATION
			T_representation: XPLAIN_T_REPRESENTATION
		do
			A_representation ?= representation
			if A_representation /= Void then
				Result := A_representation.length
			else
				T_representation ?= representation
				if T_representation /= Void then
					Result := 2147483647
				else
					Result := 0
				end
			end
		end

feature -- code writing

	get_column_value (column_name: STRING): STRING is
			-- get value for a certain column
		do
			Result := "rs.Fields['" + column_name + "'].Value"
		end

	get_column_value_string (column_name: STRING): STRING is
			-- get value for a certain column if it is a string
		do
			Result := "VarToStr(rs.Fields['" + column_name + "'].Value)"
		end

end
