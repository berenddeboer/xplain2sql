indexing

	description: "Produces very basic ANSI SQL output"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #5 $"

class

	SQL_GENERATOR_BASIC

inherit

	SQL_GENERATOR_SIMPLE
		redefine
			OneLineCommentPrefix,
			AutoPrimaryKeySupported,
			ViewsSupported
		end

create

	make

feature -- About this generator

	target_name: STRING is
			-- Name and version of dialect
		once
			Result := "Subset of ANSI-92 SQL"
		end

feature -- SQL Comments

	OneLineCommentPrefix: STRING is once Result := Void end

feature -- identifiers

	MaxIdentifierLength: INTEGER is
		once
			Result := 30
		end

feature -- table options

	AutoPrimaryKeySupported: BOOLEAN is once Result := False end

	ViewsSupported: BOOLEAN is once Result := False end


feature -- type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING is
		do
			Result := "integer"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING is
		do
			Result := "varchar(20)"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING is
			-- platform dependent approximate numeric data type
		do
			Result := "float";
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING is
		do
			Result := "numeric(12,4)"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING is
		do
			Result := "not supported"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING is
		do
			Result := "not supported"
		end


end
