indexing

	description:
		"Produces ANSI-SQL-92 output. %
		%As no product complies with with ANSI-92, the state of this %
		%generation is unknown."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #5 $"

class

	SQL_GENERATOR_ANSI

inherit

	SQL_GENERATOR_BASIC
		redefine
			target_name,
			IdentifierWithSpacesSupported,
			TemporaryTablesSupported,
			datatype_boolean,
			datatype_datetime,
			datatype_int,
			datatype_float,
			quote_identifier
		end

create

	make

feature -- About this generator

	target_name: STRING is
			-- Name and version of dialect
		once
			Result := "ANSI-92 SQL"
		end


feature -- Identifiers

	IdentifierWithSpacesSupported: BOOLEAN is once Result := True end


feature -- table options

	TemporaryTablesSupported: BOOLEAN is once Result := True end


feature -- type specification for xplain types

	datatype_boolean (representation: XPLAIN_B_REPRESENTATION): STRING is
		do
			Result := "boolean"
		end

	datatype_datetime (representation: XPLAIN_D_REPRESENTATION): STRING is
		do
			Result := "timestamp with time zone"
		end

	datatype_float (representation: XPLAIN_F_REPRESENTATION): STRING is
			-- platform dependent approximate numeric data type
		do
			Result := "double precision"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING is
		do
			inspect representation.length
			when 1 .. 4 then
				Result := "smallint"
			when 5 .. 9 then
				Result := "integer"
			else
				Result := "numeric(" + representation.length.out + ", 0)"
			end
		end


feature -- Identifiers

	quote_identifier (identifier: STRING): STRING is
			-- Identifier surrounded by quotes
		do
			Result := "%"" + identifier + "%""
		end


end
