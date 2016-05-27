note

	description: "Xplain constant (previously variable)"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"

class

	XPLAIN_VARIABLE

inherit

	XPLAIN_ABSTRACT_OBJECT

create

	make

feature

	create_expression (node: XPLAIN_ATTRIBUTE_NAME_NODE): XPLAIN_EXPRESSION
			-- return suitable expression for variable
		do
			create {XPLAIN_VARIABLE_EXPRESSION} Result.make (node.item.variable)
		end

feature -- Names

	sqlname (sqlgenerator: SQL_GENERATOR): STRING
			-- Name as known in sql code.
		do
			Result := sqlgenerator.constant_identifier (Current)
		end

feature -- Drop statement

	write_drop (sqlgenerator: SQL_GENERATOR)
		do
			sqlgenerator.drop_constant (Current)
		end

feature -- Constant state

	value: XPLAIN_EXPRESSION
			-- last set value, Void if no value given.

	set_value (new_value: XPLAIN_EXPRESSION)
		require
			new_value_not_void: new_value /= Void
		do
			value := new_value
		ensure
			value_not_void: value /= Void
		end

end
