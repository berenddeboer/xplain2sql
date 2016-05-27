note

	description: "Base class for Microsoft Access SQL output"

	Problems:
		"1. It seems to be impossible to run an entire DDL script in MS Access.%
	%   So copy/past from the script into Access to create the tables."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #7 $"

deferred class

	SQL_GENERATOR_MSACCESS

inherit

	SQL_GENERATOR_SIMPLE
		redefine
			AutoPrimaryKeySupported,
			CheckConstraintSupported,
			TemporaryTablesSupported,
			datatype_char,
			datatype_int,
			datatype_numeric,
			datatype_pk_int,
			datatype_ref_int,
			datatype_varchar
		end


feature -- identifiers

	MaxIdentifierLength: INTEGER
		once
			Result := 64
		end


feature -- table options

	AutoPrimaryKeySupported: BOOLEAN
		once
			Result := True
		end

	CheckConstraintSupported: BOOLEAN
		once
			Result := False
		end

	TemporaryTablesSupported: BOOLEAN
			-- support 'create temporary table' statement
		once
			Result := True
		end


feature -- type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		do
			Result := "logical"
		end

	datatype_char (representation: XPLAIN_C_REPRESENTATION): STRING
		do
			Result := "char(" + representation.length.out + ")"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		do
			Result := "datetime"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- platform dependent approximate numeric data type
		do
			Result := "float"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
		do
			inspect representation.length
			when 1 .. 4 then
				Result := "smallint"
			else
				Result := "integer"
			end
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		do
			Result := "money"
		end

	datatype_numeric (representation: XPLAIN_R_REPRESENTATION): STRING
			-- exact numeric data type
		do
			Result := "float"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
		do
			Result := "image"
		end

	datatype_pk_int (representation: XPLAIN_PK_I_REPRESENTATION): STRING
		do
			if CreateAutoPrimaryKey then
				Result := AutoPrimaryKeyConstraint
			else
				Result := precursor (representation)
			end
		end

	datatype_ref_int (representation: XPLAIN_PK_I_REPRESENTATION): STRING
			-- foreign key data type for integer primary keys
		do
			if CreateAutoPrimaryKey then
				Result := "integer"
			else
				Result := precursor (representation)
			end
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
		do
			Result := "text"
		end

	datatype_varchar (representation: XPLAIN_A_REPRESENTATION): STRING
		do
			Result := "char(" + representation.length.out + ")"
		end


end
