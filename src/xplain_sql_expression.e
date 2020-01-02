note

	description:

		"Any piece of SQL which is just injected"

	author: "Berend de Boer <berend@pobox.com>"


class

	XPLAIN_SQL_EXPRESSION


inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION


create

	make


feature {NONE} -- Initialization

	make (an_sql: STRING)
		require
			sql_not_void: an_sql /= Void
		do
			value := an_sql
		end


feature -- Access

	value: STRING
			-- Actual SQL code


feature -- Status

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			-- Might, we have no clue
			Result := True
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			-- Might, we have no clue
			Result := True
		end


feature -- SQL code

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			if value.count = 0 then
				Result := sqlgenerator.value_representation_char (1)
			else
				Result := sqlgenerator.value_representation_char (value.count)
			end
		end

	sqlvalue (mygenerator: SQL_GENERATOR): STRING
			-- Just `value'.
		do
			Result := value
		end


invariant

	value_not_void: value /= Void

end
