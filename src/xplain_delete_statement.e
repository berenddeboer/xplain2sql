note

	description: "Describes the Xplain delete statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"

class

	XPLAIN_DELETE_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature -- Initialization

	make (a_subject: XPLAIN_SUBJECT; a_predicate: detachable XPLAIN_EXPRESSION)
		require
			subject_not_void: a_subject /= Void
		do
			subject := a_subject
			predicate := a_predicate
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR)
			-- Write output according to this generator.
		do
			a_generator.write_delete (subject, predicate)
		end


feature --  Warnings

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Is parameter `a_parameter' used by this statement?
		do
			Result :=
				(attached subject.identification as identification and then
				 identification.uses_parameter (a_parameter)) or else
				(attached predicate as p and then p.uses_parameter (a_parameter))
		end


feature -- Access

	subject: XPLAIN_SUBJECT
	predicate: detachable XPLAIN_EXPRESSION


invariant

	subject_not_void: subject /= Void

end
