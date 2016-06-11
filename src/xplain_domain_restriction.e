note

	description: "Xplain domain restriction abstraction"

	author:     "Berend de Boer <berend@pobox.com>"

deferred class

	XPLAIN_DOMAIN_RESTRICTION

feature {NONE} -- Initialization

	make (a_required: BOOLEAN)
		do
			required := a_required
		ensure
			required_set: required = a_required
		end

feature -- Access

	required: BOOLEAN
			-- Xplain doesn't know Nulls, but we have to support them
			-- when mimicking an existing relational databases

feature -- SQL code

	sqldomainconstraint (sqlgenerator: SQL_GENERATOR; a_column_name: STRING): detachable STRING
			-- Constraint used when creating domains
			-- Void means no domain constraints.
			-- If you want `a_column_name' to be quoted, you need to pass a
			-- quoted `a_column_name'
		deferred
		end

	sqlcolumnconstraint (sqlgenerator: SQL_GENERATOR; a_column_name: STRING): detachable STRING
			-- Constraint to use when creating columns;
			-- Void means no column constraints
		do
			Result := sqlgenerator.sqlcolumnconstraint_base (Current, a_column_name)
		end

feature -- Check restriction against representation

	check_attachment (sqlgenerator: SQL_GENERATOR; a_representation: XPLAIN_REPRESENTATION)
			-- Print warning if restriction is not ok for representation.
		do
			-- do nothing
		end

end
