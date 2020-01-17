note

	description:

		"List of procedure parameters."

	library: "xplain2sql library"
	author: "Berend de Boer <berend@pobox.com>"


class

	XPLAIN_PARAMETER_NODE


inherit

	XPLAIN_NODE [XPLAIN_PARAMETER]


create

	make


feature -- Status

	has_parameter (v: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does container include `v'?
		local
			node: detachable like Current
		do
			from
				node := Current
			until
				Result or else
				node = Void
			loop
				Result := node.item.role ~ v.role and node.item.name ~ v.name
				node := node.next
			end
		end


end
