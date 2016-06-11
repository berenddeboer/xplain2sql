note

	description:

		"Base statement"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2016, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	XPLAIN_BASE_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature {NONE} -- Initialisation

	make (a_base: like base)
		do
			base := a_base
		end


feature -- Access

	base: XPLAIN_BASE


feature -- Commands

	write (a_generator: ABSTRACT_GENERATOR)
			-- Write output according to this generator.
		do

		end


feature -- Status

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
		do
			Result := False
		end


end
