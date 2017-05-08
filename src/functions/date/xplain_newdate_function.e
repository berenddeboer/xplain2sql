note

	description:

		"Allows adding or subtracting days, months or years from dates"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2017, Berend de Boer"
	license: "MIT License (see LICENSE)"


class

	XPLAIN_NEWDATE_FUNCTION


inherit

	XPLAIN_EXPRESSION
		redefine
			add_to_join,
			is_using_other_attributes,
			uses_its
		end


create

	make


feature {NONE} -- Initialization

	make (a_date, a_number, a_part: XPLAIN_EXPRESSION)
		do
			date := a_date
			number := a_number
			part := a_part
		end


feature -- Access

	date,
	number,
	part: XPLAIN_EXPRESSION
			-- Allow saying newdate(d, 10, "years")

	name: STRING = "newdate"


feature -- Status

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		do
			Result :=
				date.is_using_other_attributes (an_attribute) or else
				number.is_using_other_attributes (an_attribute) or else
				part.is_using_other_attributes (an_attribute)
		end

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			Result := date.uses_its or else number.uses_its or else part.uses_its
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result :=
				date.uses_parameter (a_parameter) or else
				number.uses_parameter (a_parameter) or else
				part.uses_parameter (a_parameter)
		end


feature -- SQL code

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST)
			-- Possibility of expression to add something to join part of
			-- a select statement.
		do
			date.add_to_join (sqlgenerator, join_list)
			number.add_to_join (sqlgenerator, join_list)
			part.add_to_join (sqlgenerator, join_list)
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- The representation of left operand. Maybe should be
			-- improved to infer better? If you add int and double, should
			-- return double I think.
			-- Also I think we should return a type that is equal to the
			-- types involved. A division is always an integer division
			-- if both types are integer. Cast a type to a double to get
			-- a double result. Anyway, this is what PostgreSQL seems to
			-- be doing.
		do
			Result := sqlgenerator.value_representation_date
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING
			-- Expression for newdate function
		do
			Result := sqlvalue (sqlgenerator)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Expression for newdate function
		do
			Result := sqlgenerator.sql_newdate (date, number, part)
		end


end
