indexing

	description:

	"Boolean restriction"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_B_RESTRICTION

inherit

	XPLAIN_DOMAIN_RESTRICTION

create

	make

feature

	value_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
		do
			Result := sqlgenerator.value_representation_boolean
		end

feature

	sqldomainconstraint(sqlgenerator: SQL_GENERATOR; column_name: STRING): STRING is
		do
			result := sqlgenerator.sqlcheck_boolean (Current, column_name)
		end

end
