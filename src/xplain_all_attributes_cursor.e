note

	description: "Traverses over all Xplain attributes that should be %
	%in a create table statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2001, Berend de Boer"


class

	XPLAIN_ALL_ATTRIBUTES_CURSOR [G]


inherit

	DS_FILTER_CURSOR [XPLAIN_ATTRIBUTE]
		rename
			make as ds_make,
			is_included as is_generated_attribute
		end


create {XPLAIN_TYPE}

	make


feature {NONE} -- Initialization

	make (type: XPLAIN_TYPE; sqlgenerator: SQL_GENERATOR)
		require
			type_not_void: type /= Void
			sqlgenerator_not_void: sqlgenerator /= Void
		do
			ds_make (type.attributes)
			generate_assert := sqlgenerator.CalculatedColumnsSupported
		end


feature -- Access

	generate_assert: BOOLEAN
			-- Create output for assertions as calculated columns as well


feature -- Filter checks

	is_generated_attribute: BOOLEAN
			-- Is current item included in the filter?
		do
			if attached {XPLAIN_ASSERTION} item.abstracttype as assertion then
				Result :=
					not item.is_assertion or else
					(generate_assert and then
						(assertion.is_literal or else
							assertion.is_simple))
			end
		end


end
