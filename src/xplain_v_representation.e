indexing

	description:

		"Xplain varying character representation. Depending on switches used for output of A or V domain."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #7 $"

class

	XPLAIN_V_REPRESENTATION

obsolete "2003-10-15 V representation is no longer supported."

inherit

	XPLAIN_A_REPRESENTATION
		redefine
			datatype,
			domain
		end

create

	make


feature -- public

	domain: STRING is
			-- Give Xplain domain as string.
		do
			create Result.make (2 + length + 1)
			Result.append_character ('(')
			Result.append_character ('V')
			Result.append_string (length.out)
			Result.append_character (')')
		end

feature -- Required implementations

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING is
			-- return sql data type, call sql_generator to return this
		do
			result := mygenerator.datatype_varchar (Current)
		end

end
