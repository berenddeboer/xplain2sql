note

	description: "Constant string expression."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

class

	XPLAIN_STRING_EXPRESSION

inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION
		redefine
			has_wild_card_characters,
			is_constant,
			is_string,
			sqlvalue_as_wildcard
		end

create

	make


feature {NONE} -- Initialization

	make (a_value: STRING)
		require
			value_not_void: a_value /= Void
		do
			value := a_value
		end


feature -- Access

	value: STRING
			-- Actual string code


feature -- Status

	has_wild_card_characters: BOOLEAN
			-- Does the expression contain the Xplain wildcard characters
			-- '*' and '?'?
		do
			Result := value.has ('*') or value.has ('?')
		ensure then
			definition: Result = value.has ('*') or else value.has ('?')
		end

	is_constant: BOOLEAN = True
			-- Is this expression a constant value?

	is_string: BOOLEAN = True
			-- Is this a string?

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			Result := False
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result := False
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
			-- Just `value'
		do
			Result := mygenerator.as_string (value)
		end

	sqlvalue_as_wildcard (mygenerator: SQL_GENERATOR): STRING
			-- `value' formatted for SQL like expression
		local
			s: STRING
			i: INTEGER
		do
			s := value.twin
			from
				i := 1
			until
				i > s.count
			loop
				inspect s.item (i)
				when '*' then
					s.put ('%%', i)
				when '?' then
					s.put ('_', i)
				else
					-- Don't change
				end
				i := i + 1
			variant
				s.count - (i - 1)
			end
			Result := mygenerator.as_string (s)
		end


invariant

	value_not_void: value /= Void

end
