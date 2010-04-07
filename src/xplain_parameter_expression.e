indexing

	description: "Describes a procedure parameter being used in an expression."
	author:      "Berend de Boer <berend@pobox.com>"
	copyright:   "Copyright (c) 2000, Berend de Boer"
	date:        "$Date: 2008/12/15 $"
	revision:    "$Revision: #9 $"

class

	XPLAIN_PARAMETER_EXPRESSION


inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION


create

	make


feature {NONE} -- Initialization

	make (a_name: XPLAIN_ATTRIBUTE_NAME) is
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

	uses_its: BOOLEAN is
			-- Does expression has an its list somewhere?
		do
			Result := False
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			Result := name.is_equal (a_parameter)
		ensure then
			definition: Result = name.is_equal (a_parameter)
		end


feature -- SQL output

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- representation is value representation
		do
			Result := name.object.representation
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Return parameter value expression as string.
		do
			Result := sqlgenerator.sp_use_param (name.abstracttype.sqlcolumnidentifier (sqlgenerator, name.role))
		end

invariant

	name_not_void: name /= Void
	name_has_object: name.object /= Void
	name_object_is_abstracttype: name.abstracttype /= Void

end
