indexing

	description: "Describes the Xplain type statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_TYPE_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature -- Initialization

	make (a_type: XPLAIN_TYPE) is
			-- Initialize.
		require
			have_type: a_type /= Void
		do
			type := a_type
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR) is
			-- Write output according to this generator.
		do
			a_generator.write_type (type)
		end


feature --  Warnings

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Is parameter `a_parameter' used by this statement?
		do
			Result := False
		end


feature -- Access

	type: XPLAIN_TYPE


invariant

	have_type: type /= Void

end
