note

	description:

		"Xplain primary representations.%
		%Descendents should override sqldatatype and include the%
		%primary key constraint in its output."

		author:     "Berend de Boer <berend@pobox.com>"
		copyright:  "Copyright (c) 1999, Berend de Boer"


deferred class

	XPLAIN_PK_REPRESENTATION


inherit

	XPLAIN_REPRESENTATION


feature -- Status

	is_integer: BOOLEAN
			-- Is this primary key based on integers?
		deferred
		end


feature -- Access

	length: INTEGER
			-- Max length of representation
		deferred
		ensure
			length_positive: length > 0
		end

	pkdatatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- if SQL generator, return complete sql definition for primary key
			-- should include data type, not null and primary key
			-- constraints
			-- else return just the data type
		require
			mygenerator_not_void: mygenerator/= Void
		deferred
		ensure
			valid_string: Result /= Void
		end

end
