note

	description:
		"Xplain node for linked list of attribute names"

	author:		"Berend de Boer <berend@pobox.com>"


class

	XPLAIN_ATTRIBUTE_NAME_NODE


inherit

	XPLAIN_NODE [XPLAIN_ATTRIBUTE_NAME]


create

	make


feature

	prefix_table: detachable STRING
			-- Prefix attribute with this table (or table alias);
			-- This prefix must be quoted!


feature

	set_prefix_table (a_prefix: STRING)
		require
			valid_prefix: a_prefix /= Void
		do
			-- We only set the prefix if one hasn't been set
			-- already. This functionality is used in
			-- XPLAIN_EXTENSION_FUNCTION_EXPRESSION to set a prefix to
			-- the outer table to correlated queries have the correct
			-- prefix to the outer table.
			if not attached prefix_table then
				prefix_table := a_prefix
			end
		end

end
