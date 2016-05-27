note

	description: "Xplain primary key character representation"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_PK_A_REPRESENTATION

inherit

	XPLAIN_PK_REPRESENTATION
		rename
			datatype as undefined_datatype,
			mw_column_value as undefined_mw_column_value,
			value_representation as undefined_value_representation,
			write_with_quotes as undefined_write_with_quotes
		end

	XPLAIN_A_REPRESENTATION
		select
			datatype,
			mw_column_value,
			value_representation,
			write_with_quotes
		end

create

	make

feature

	undefined_datatype (mygenerator: ABSTRACT_GENERATOR): STRING
		require else
			fail: False
		do
			-- undefined
		end

feature  -- SQL access

	pkdatatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- return data type, call mygenerator to return this
		do
			result := mygenerator.datatype_pk_char (Current)
		end

feature -- Access

	is_integer: BOOLEAN = False
			-- This is a integer based primary key.

end
