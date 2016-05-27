note

	description:

		"Structure used during parsing"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #2 $"


class

	XPLAIN_EXTEND_ATTRIBUTE


create

	make


feature {NONE} -- Initialization

	make (a_name: STRING; a_domain: XPLAIN_REPRESENTATION)
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
			domain := a_domain
		end


feature -- Access

	name: STRING

	domain: XPLAIN_REPRESENTATION


invariant

	ame_not_empty: name /= Void and then not name.is_empty

end
