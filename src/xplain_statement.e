indexing

	description: "Describes a single Xplain statement like type, get or insert."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"


deferred class

	XPLAIN_STATEMENT


feature -- Commands

	cleanup is
			-- When statement is used in procedure, values and extends
			-- are temporal and should be removed from the universe.
			-- Override in descendents to do the proper cleanup.
		do
			-- Nothing
		end

	optimize_for_procedure (a_procedure : XPLAIN_PROCEDURE) is
		require
			procedure_not_void: a_procedure /= Void
		do
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Is parameter `a_parameter' used by this statement?
		require
			parameter_not_void: a_parameter /= Void
		deferred
		end

	write (a_generator: ABSTRACT_GENERATOR) is
			-- Write output according to this generator.
		require
			generator_not_void: a_generator /= Void
		deferred
		end


feature -- Status

	updates_attribute (a_type: XPLAIN_TYPE; an_attribute_name: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this statement update the attribute `an_attribute_name'
			-- of type ``a_type'?
		require
			a_type_not_void: a_type /= Void
			an_attribute_name_not_void: an_attribute_name /= Void
		do
		end

end
