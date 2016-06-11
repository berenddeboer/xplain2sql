note

	description:

	"Xplain foreign key constraint restriction"

	author:     "Berend de Boer <berend@pobox.com>"

deferred class XPLAIN_IDENTIFICATION_RESTRICTION

inherit

	XPLAIN_DOMAIN_RESTRICTION
		redefine
			sqlcolumnconstraint
		end

feature

	owner: detachable XPLAIN_TYPE

feature

	set_owner (aowner: XPLAIN_TYPE)
		do
			owner := aowner
		end


feature

	sqldomainconstraint (sqlgenerator: SQL_GENERATOR; column_name: STRING): detachable STRING
			-- Table never used in create domain statements
		do
				check
					call_never: False
				end
		end

	sqlcolumnconstraint (sqlgenerator: SQL_GENERATOR; column_name: STRING): detachable STRING
			-- Constraint used when creating columns
		do
				check
					valid_type: owner /= Void
				end
			if attached owner as o then
				Result := sqlgenerator.sqlcolumnconstraint_type (Current, o)
			end
		end

end
