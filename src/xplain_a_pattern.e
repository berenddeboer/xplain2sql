note

	description:

	"Xplain string pattern"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #3 $"

class XPLAIN_A_PATTERN

inherit
   
   XPLAIN_A_DOMAIN_RESTRICTION
      rename
         make as make_xplain_domain_restriction
      end

create
	 
	 make

feature
   
   pattern: STRING

feature  -- Initialization
	 
	 make (apattern: STRING)
			do
         make_xplain_domain_restriction(True)
				 pattern := apattern
			end	 

feature

   sqldomainconstraint(sqlgenerator: SQL_GENERATOR; column_name: STRING): STRING
         -- return SQL search condition something like
         -- "check value like 'abc%'"
      do
         result := sqlgenerator.sqlcheck_like(Current, column_name)
      end

end -- class XPLAIN_A_PATTERN
