note

	description: "Describes a procedure parameter being used in an expression."
	author:      "Berend de Boer <berend@pobox.com>"
	copyright:   "Copyright (c) 2000, Berend de Boer"

class

	XPLAIN_PARAMETER_EXPRESSION


inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION


create

	make


feature {NONE} -- Initialization

	make (a_name: XPLAIN_ATTRIBUTE_NAME)
		require
			name_not_void: a_name /= Void
			name_has_object: a_name.object /= Void
			name_object_is_abstracttype: a_name.abstracttype /= Void
		do
			name := a_name
		end


feature -- Access

	name: XPLAIN_ATTRIBUTE_NAME
			-- The parameter name


feature -- Status

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			Result := False
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result := name.role ~ a_parameter.role and name.name ~ a_parameter.name
		end


feature -- SQL output

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- representation is value representation
		do
			check attached name.object as o then
				Result := o.representation
			end
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Return parameter value expression as string.
		do
			Result := sqlgenerator.sp_use_param (name.abstracttype.sqlcolumnidentifier (sqlgenerator, name.role))
		end

invariant

	name_not_void: name /= Void
	name_has_object: name.object /= Void
	name_object_is_abstracttype: name.abstracttype /= Void

end
