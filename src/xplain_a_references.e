note

	description: "Xplain char foreign key constraint restriction"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999-2004, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"


class

	XPLAIN_A_REFERENCES

inherit

	XPLAIN_IDENTIFICATION_RESTRICTION
		rename
			make as make_xplain_domain_restriction
		redefine
			sqlcolumnconstraint
		end

create

	make

feature -- initialization

	make
		do
			make_xplain_domain_restriction (True)
		end

feature

	sqldomainconstraint (sqlgenerator: SQL_GENERATOR; column_name: STRING): STRING
			-- Table never used in create domain statements
		do
			Result := Void
				check
					call_never: False
				end
		end

	sqlcolumnconstraint (sqlgenerator: SQL_GENERATOR; column_name: STRING): STRING
			-- Constraint used when creating columns
		do
				check
					valid_type: owner /= Void
				end
			Result := sqlgenerator.sqlcolumnconstraint_type (Current, owner)
		end


end
