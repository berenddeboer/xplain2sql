note

  description: "Expression where a Boolean value is supposed to be True. As I didn't know a word for it, it's not not."
  author:     "Berend de Boer <berend@pobox.com>"
  copyright:  "Copyright (c) 2003, Berend de Boer"
  date:       "$Date: 2008/12/15 $"
  revision:   "$Revision: #3 $"

class

	XPLAIN_NOTNOT_EXPRESSION


inherit

	XPLAIN_WRAPPED_EXPRESSION
		redefine
			sqlvalue
		end


create

	make


feature -- SQL generation

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			Result := expression.representation (sqlgenerator)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Return expression in generator syntax.
		do
			Result := sqlgenerator.sql_notnot_expression (expression)
		end


end
