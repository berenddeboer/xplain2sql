indexing

	description: "Literal SQL."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_SQL_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature -- Initialization

	make (a_sql: STRING) is
		do
			sql := a_sql
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR) is
			-- Write output according to this generator.
		do
			if sql /= Void then
				a_generator.write_sql (sql)
			end
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			-- We don't know, might do
			Result := True
		end


feature -- Access

	sql: STRING


end
