indexing

	description: "Describes the Xplain value selection statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #5 $"

class

	XPLAIN_VALUE_SELECTION_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature -- Initialization

	make (a_value: XPLAIN_VALUE) is
		require
			have_value: a_value /= Void
		do
			value := a_value
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR) is
			-- Write output according to this generator.
		do
			a_generator.write_select_value (value)
		end


feature --  Status

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Is parameter `a_parameter' used by this statement?
		do
			-- no
		end


feature -- Access

	value: XPLAIN_VALUE

end
