note

	description:

		"Structure used during parsing"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"


class

	XPLAIN_EXTEND_ATTRIBUTE


create

	make


feature {NONE} -- Initialization

	make (a_name: STRING; a_domain: like domain)
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			name := a_name
			domain := a_domain
		end


feature -- Access

	name: STRING

	domain: detachable XPLAIN_REPRESENTATION


invariant

	name_not_empty: name /= Void and then not name.is_empty

end
