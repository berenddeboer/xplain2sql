note

	description: "Default optional or required (null/not null) restriction"

	author:     "Berend de Boer <berend@pobox.com>"

class

	XPLAIN_REQUIRED

inherit

	XPLAIN_DOMAIN_RESTRICTION

create

	make

feature

	sqldomainconstraint (sqlgenerator: SQL_GENERATOR; column_name: STRING): detachable STRING
			-- Constraint used when creating domains;
			-- Void means no domain constraints.
			-- default is no SQL check condition,
			-- is something like value is not null but we implement that
			-- directly with null/not null constraint itself
		do
			Result := Void
		end

end
