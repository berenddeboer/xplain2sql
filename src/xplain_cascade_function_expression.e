note

	description: "Set function cascade expression."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2004, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"


class

	XPLAIN_CASCADE_FUNCTION_EXPRESSION


inherit

	XPLAIN_CASCADE_EXPRESSION


create

	make


feature {NONE} -- Initialization

	make (
			a_selection: XPLAIN_SELECTION_FUNCTION;
			a_grouping_attributes: XPLAIN_ATTRIBUTE_NAME_NODE)
		require
			selection_not_void: a_selection /= Void
			grouping_attributes_not_void: a_grouping_attributes /= Void
			annotated: a_grouping_attributes.item.object /= Void
		do
			selection := a_selection
			grouping_attributes := a_grouping_attributes
		end


feature -- Access

	grouping_attributes: XPLAIN_ATTRIBUTE_NAME_NODE
			-- One or more attributes

	selection: XPLAIN_SELECTION_FUNCTION


feature -- Status

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			-- Probably not applicable; don't think will be called at where we need to know this
			Result := selection.property.uses_its or else selection.predicate.uses_its
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result := selection.uses_parameter (a_parameter)
		end


feature -- SQL

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			-- to be implemented
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- attributes of the type it has to be prefixed by "new." for
			-- example.
		do
			Result := sqlvalue (sqlgenerator)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Expression in generator syntax.
		do
			Result := "not yet implemented"
		end


invariant

	selection_not_void: selection /= Void

end
