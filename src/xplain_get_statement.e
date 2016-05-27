note

	description: "Describes the Xplain get statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #5 $"

class

	XPLAIN_GET_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature {NONE} -- Initialization

	make (a_selection: XPLAIN_SELECTION)
		require
			have_selection: a_selection /= Void
		do
			selection := a_selection
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR)
			-- Write output according to this generator.
		do
			a_generator.write_select (selection)
		end


feature -- Access

	selection: XPLAIN_SELECTION


feature --  Status

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Is parameter `a_parameter' used by this statement?
		do
			Result := selection.uses_parameter (a_parameter)
		end


invariant

	have_selection: selection /= Void

end
