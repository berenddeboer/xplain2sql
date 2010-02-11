indexing

	description: "Describes a stored procedure parameter being used in an expression. This stored procedure has been written using SQL code, not with the Xplain procedure statement."
	author:      "Berend de Boer <berend@pobox.com>"
	copyright:   "Copyright (c) 2000, Berend de Boer"
	date:        "$Date: 2008/12/15 $"
	revision:    "$Revision: #8 $"

class

	XPLAIN_UNMANAGED_PARAMETER_EXPRESSION

inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION


create

	make


feature {NONE} -- Initialization

	make (aname: STRING) is
		require
			valid_name: aname /= Void and then not aname.is_empty
		do
			name := aname
		end


feature -- Access

	name: STRING


feature -- Status

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			Result := False
		end


feature -- SQL output

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- representation is value representation
		do
			Result := sqlgenerator.value_representation_char (250)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- return string
		do
			Result := sqlgenerator.sp_use_param (name)
		end

invariant

	name_not_empty: name /= Void and then not name.is_empty

end
