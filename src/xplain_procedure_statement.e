note

	description: "Describes the Xplain procedure statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_PROCEDURE_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature -- Initialization

	make (a_procedure: XPLAIN_PROCEDURE)
		require
			have_procedure: a_procedure /= Void
		do
			procedure := a_procedure
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR)
			-- Write output according to this generator.
		do
			a_generator.write_procedure (procedure)
		end


	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			-- not applicable
			Result := False
		end


feature -- Access

	procedure: XPLAIN_PROCEDURE


invariant

	have_procedure: procedure /= Void

end
