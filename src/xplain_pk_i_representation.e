note

	description: "Xplain integer representation"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"

class

	XPLAIN_PK_I_REPRESENTATION

inherit

	XPLAIN_PK_REPRESENTATION
		rename
			value_representation as undefined_value_representation,
			write_with_quotes as undefined_write_with_quotes
		redefine
			is_integer
		end

	XPLAIN_I_REPRESENTATION
		redefine
			datatype,
			xml_schema_data_type
		select
			value_representation,
			write_with_quotes
		end

create

	make

feature

	undefined_datatype (mygenerator: ABSTRACT_GENERATOR): STRING
		require
			fail: False
		do
			-- undefined
		end

feature  -- SQL access

	datatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- return sql foreign key data type
		do
			result := mygenerator.datatype_ref_int (Current)
		end

	pkdatatype (mygenerator: ABSTRACT_GENERATOR): STRING
		do
			result := mygenerator.datatype_pk_int (Current)
		end

	xml_schema_data_type: STRING
		do
			Result := "positiveInteger"
		end


feature -- Access

	is_integer: BOOLEAN = True
			-- This is a integer based primary key.

end
