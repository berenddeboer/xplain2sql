note

	description:

		"Xplain node for linked list of integers"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_I_NODE

inherit

	XPLAIN_ENUMERATION_NODE [INTEGER_REF]

create

	make

feature

	to_sqlcode (sqlgenerator: SQL_GENERATOR): STRING
			-- Return integer suitable for sql in enumeration.
		do
			Result := item.out
		end

end
