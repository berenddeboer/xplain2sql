note

	description:

		"Xplain node for linked list of strings"

	author:     "Berend de Boer <berend@pobox.com>"


class

	XPLAIN_A_NODE

inherit

	XPLAIN_ENUMERATION_NODE [STRING]

create

	make

feature

	to_sqlcode (sqlgenerator: SQL_GENERATOR): STRING
			-- Return string suitable for sql in enumeration.
			-- Maybe the use of a single quote looks a bit like knowledge about
			-- sql here instead of in sqlgenerator. However use of ' is ubiquitous.
		do
			if item.is_empty then
				Result := the_empty_string
			else
				create Result.make (1 + item.count + 1)
				Result.append_character ('%'')
				Result.append_string (item)
				Result.append_character ('%'')
			end
		end


feature {NONE} -- once strings

	the_empty_string: STRING = "''"
			-- Empty string

end
