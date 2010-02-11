indexing

	description:

		"An expression that does not involve attributes"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #2 $"


deferred class

	XPLAIN_NON_ATTRIBUTE_EXPRESSION


inherit

	XPLAIN_EXPRESSION
		redefine
			is_using_other_attributes
		end


feature -- SQL generation

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING is
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' when no attributes are involved.
		do
			Result := sqlvalue (sqlgenerator)
		end


feature -- Status

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		do
			Result := False
		end


end
