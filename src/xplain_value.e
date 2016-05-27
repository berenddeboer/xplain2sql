note

	description: "Xplain value"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #10 $"

class

	XPLAIN_VALUE

inherit

	XPLAIN_ABSTRACT_OBJECT
		rename
			make as inherited_make
		redefine
			may_be_redefined,
			quoted_name
		end

create

	make

feature {NONE} -- Initialization

	make (
			sqlgenerator: SQL_GENERATOR;
			a_name: STRING;
			a_expression: XPLAIN_EXPRESSION)
		require
			have_sqlgenerator: sqlgenerator /= Void
			name_not_empty: a_name /= Void and then not a_name.is_empty
			have_expression: a_expression /= Void
		do
			-- User does not need to care about representation of
			-- values, but we do...
			inherited_make (a_name, a_expression.representation (sqlgenerator))
			expression := a_expression
		end


feature -- Access

	expression: XPLAIN_EXPRESSION
			-- How the value is computed


feature -- Status

	may_be_redefined: BOOLEAN = True
			-- Values can be redefined (i.e. updated)


feature -- SQL

	create_expression (node: XPLAIN_ATTRIBUTE_NAME_NODE): XPLAIN_EXPRESSION
			-- Return suitable expression for variable.
		do
			create {XPLAIN_VALUE_EXPRESSION} Result.make (node.item.value)
		end

	quoted_name (sqlgenerator: SQL_GENERATOR): STRING
			-- As `sqlname', but quoted (i.e. with double quotes for
			-- example)
		do
			Result := sqlgenerator.quoted_value_identifier (Current)
		end

	sqlname (sqlgenerator: SQL_GENERATOR): STRING
			-- Name as known in sql code
		do
			Result := sqlgenerator.value_identifier (Current)
		end

	write_drop (sqlgenerator: SQL_GENERATOR)
		do
			sqlgenerator.drop_value (Current)
		end


invariant

	have_expression: expression /= Void

end
