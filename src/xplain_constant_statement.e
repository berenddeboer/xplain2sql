indexing

	description: "Describes the Xplain constant definition statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_CONSTANT_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature -- Initialization

	make (a_constant: XPLAIN_VARIABLE) is
		require
			have_constant: a_constant /= Void
		do
			constant := a_constant
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR) is
			-- Write output according to this generator.
		do
			a_generator.write_constant (constant)
		end


feature --  Warnings

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Is parameter `a_parameter' used by this statement?
		do
			-- cannot occur
		end


feature -- Access

	constant: XPLAIN_VARIABLE


invariant

	have_constant: constant /= Void

end
