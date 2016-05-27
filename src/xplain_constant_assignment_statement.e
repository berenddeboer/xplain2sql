note

	description: "Describes the Xplain constant assignment statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_CONSTANT_ASSIGNMENT_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature -- Initialization

	make (a_constant: XPLAIN_VARIABLE; a_expression: XPLAIN_EXPRESSION)
		require
			valid_constant: a_constant /= Void
			valid_expression: a_expression /= Void
		do
			constant := a_constant
			expression := a_expression
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR)
			-- Write output according to this generator.
		do
			a_generator.write_constant_assignment (constant, expression)
		end


feature --  Warnings

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Is parameter `a_parameter' used by this statement?
		do
			-- cannot occur
		end


feature -- Access

	constant: XPLAIN_VARIABLE
	expression: XPLAIN_EXPRESSION


invariant

	valid_constant: constant /= Void
	valid_expression: expression /= Void

end
