note

	description: "Selection of a single value."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2001, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #7 $"

deferred class

	XPLAIN_SELECTION_VALUE


inherit

	XPLAIN_SELECTION
		redefine
			add_to_join,
			uses_parameter
		end


feature -- Access

	property: XPLAIN_EXPRESSION
			-- value if applicable; void otherwise


feature -- Status

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Is parameter `a_parameter' used by this statement?
		do
			Result :=
				precursor (a_parameter) or else
				(property /= Void and then property.uses_parameter (a_parameter))
		end


feature --  Joins

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST)
			-- Retrieval statement can make sure the join_list is up to
			-- date.
		do
			if property /= Void then
				property.add_to_join (sqlgenerator, join_list)
			end
			precursor (sqlgenerator, join_list)
		end


feature -- SQL generating functions

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- Suitable representation
		deferred
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- SQL expression that returns a single value
		deferred
		ensure
			valid_result: Result /= Void and not Result.is_empty
		end


end
