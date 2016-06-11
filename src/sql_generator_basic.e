note

	description: "Produces very basic ANSI SQL output"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

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

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "Subset of ANSI-92 SQL"
		end

feature -- SQL Comments

	OneLineCommentPrefix: detachable STRING once end

feature -- identifiers

	MaxIdentifierLength: INTEGER
		once
			Result := 30
		end

feature -- table options

	AutoPrimaryKeySupported: BOOLEAN once Result := False end

	ViewsSupported: BOOLEAN once Result := False end


feature -- type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING
		do
			Result := "integer"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING
		do
			Result := "varchar(20)"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING
			-- platform dependent approximate numeric data type
		do
			Result := "float";
		end

	datatype_money (representation: XPLAIN_M_REPRESENTATION): STRING
		do
			Result := "numeric(12,4)"
		end

	datatype_picture (representation: XPLAIN_P_REPRESENTATION): STRING
		do
			Result := "not supported"
		end

	datatype_text (representation: XPLAIN_T_REPRESENTATION): STRING
		do
			Result := "not supported"
		end


end
