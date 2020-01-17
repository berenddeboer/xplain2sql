note

	description:

		"As XPLAIN_ATTRIBUTE_NAME, but captures that a parameter can be optional."

	library: "xplain2sql library"
	author: "Berend de Boer <berend@pobox.com>"


class

	XPLAIN_PARAMETER


inherit

	XPLAIN_ATTRIBUTE_NAME
		rename
			make as old_make
		end


create

	make


feature {NONE} -- Initialisation

	make (an_attribute_name: XPLAIN_ATTRIBUTE_NAME; an_is_required: BOOLEAN)
		do
			old_make (an_attribute_name.role, an_attribute_name.name)
			if attached an_attribute_name.object as obj then
				set_object (obj)
			end
			is_required := an_is_required
		end


feature -- Status

	is_required: BOOLEAN


end
