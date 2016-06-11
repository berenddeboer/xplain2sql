note

	description: "Integer/real number constant expression"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999-2001, Berend de Boer"

class

	XPLAIN_NUMBER_EXPRESSION

inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION
		redefine
			is_constant
		end


create

	make


feature {NONE} -- Initialization

	make (a_value: STRING)
		require
			value_not_empty: a_value /= Void and then not a_value.is_empty
		do
			value := a_value
		end


feature -- Access

	value: STRING
			-- Raw value; kept as string as it could be larger than we
			-- can handle in Eiffel.


feature -- Status

	is_constant: BOOLEAN = True
			-- Is this expression a constant value?

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


feature -- SQL output

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			if value.is_integer then
				Result := sqlgenerator.value_representation_integer (9)
			else
				Result := sqlgenerator.value_representation_float
			end
		end

	sqlvalue (mygenerator: SQL_GENERATOR): STRING
			-- Just the number.
		do
			Result := value
		end


invariant

	value_not_empty: value /= Void and then not value.is_empty

end
