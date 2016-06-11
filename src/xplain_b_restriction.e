note

	description:

	"Boolean restriction"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

class

	XPLAIN_B_RESTRICTION

inherit

	XPLAIN_DOMAIN_RESTRICTION

create

	make

feature

	value_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			Result := sqlgenerator.value_representation_boolean
		end

feature

	sqldomainconstraint(sqlgenerator: SQL_GENERATOR; column_name: STRING): detachable STRING
		do
			result := sqlgenerator.sqlcheck_boolean (Current, column_name)
		end

end
