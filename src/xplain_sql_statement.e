note

	description: "Literal SQL."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"

class

	XPLAIN_SQL_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature -- Initialization

	make (a_sql: STRING)
		do
			sql := a_sql
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR)
			-- Write output according to this generator.
		do
			if attached sql as s then
				a_generator.write_sql (s)
			end
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			-- We don't know, might do
			Result := True
		end


feature -- Access

	sql: STRING


end
