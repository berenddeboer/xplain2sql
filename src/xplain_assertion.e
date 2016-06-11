note

	description: "Describes an Xplain assertion."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2001, Berend de Boer"


class

	XPLAIN_ASSERTION

inherit

	XPLAIN_ABSTRACT_EXTENSION
		rename
			make as make_abstract_assertion,
			representation as abstract_extension_representation
		undefine
			sql_select_name
		redefine
			create_expression,
			set_no_update_optimization
		end

	XPLAIN_TYPE
		rename
			make as make_type
		undefine
			hack_anode,
			sqlcolumndefault
		redefine
			create_expression,
			write_drop,
			sqlcolumnidentifier,
			columndatatype,
			sqlcolumnrequired,
			sqlpkname,
			sqlname,
			sql_select_name
		select
			abstract_representation,
			make_abstract_type
		end

create

	make


feature {NONE} -- creation

	make (
			sqlgenerator: SQL_GENERATOR;
			atype: XPLAIN_TYPE
			aname: STRING;
			arange: like range
			aexpression: XPLAIN_EXTENSION_EXPRESSION)
		require
			valid_args: aname /= Void and
							atype /= Void and
							aexpression /= Void
		do
			type := atype
			range := arange
			expression := aexpression

			-- We don't use `attributes' here, but the invariant is for
			-- it to be non-void, because that makes other routines
			-- easier.
			create  attributes.make

			make_abstract_type (aname, expression.representation (sqlgenerator))

			-- silence compiler, need to assign dummy values
			-- (or an indication of code trouble?):
			create {XPLAIN_PK_I_REPRESENTATION} representation.make (1)
			abstract_extension_representation := representation

			expression.set_extension (Current, atype.sqlname (sqlgenerator))
			type.add_assertion (Current)
			-- Turn on no update optimisation, because either with (left
			-- outer) joins or left outer joins, assertions can always
			-- miss rows if there's a where clause.
			-- So if an assertion is used somewhere, care must be taken
			-- to include it with a left outer join.
			no_update_optimization := True
		end


feature -- Access

	range: detachable XPLAIN_DOMAIN_RESTRICTION
			-- Allowed range


feature -- Status

	is_literal: BOOLEAN
			-- Is assertion basically a constant value?
		do
			Result := expression.is_literal
		end

	is_simple: BOOLEAN
			-- Does this assertion only refer to immediate attributes and
			-- are these attributes data attributes, not assertions
			-- themselves?
		do
			Result := not is_literal and not expression.uses_non_data_attributes
		end

	is_complex: BOOLEAN
			-- Does this assertion uses its when refering to attributes
			-- or does it refer to other assertions of this type?
		do
			Result := expression.uses_non_data_attributes
		end

	is_function: BOOLEAN
			-- Is this assertion a function?
		do
			if attached {XPLAIN_EXTENSION_FUNCTION_EXPRESSION} expression then
				Result := True
			end
		end


feature

	write_drop (sqlgenerator: SQL_GENERATOR)
		do
			-- called via XPLAIN_VIRTUAL_ATTRIBUTE.`write_drop'.
			sqlgenerator.write_drop_assertion (Current)
		end


feature -- Expression builder support

	create_expression (node: XPLAIN_ATTRIBUTE_NAME_NODE): XPLAIN_EXPRESSION
			-- Return a new suitable expression for extension.
			-- Note that the property expression is only valid to build this
			-- extension. When the extension itself is used in an expression,
			-- we need a new expression object.
		do
			create {XPLAIN_ASSERTION_EXPRESSION} Result.make (Current, node)
		end


feature -- Access

	columndatatype (mygenerator: ABSTRACT_GENERATOR): STRING
		do
			-- make sure XPLAIN_ATTRIBUTE_EXPRESSION has some prefix
			-- table, or remove that requirement, because there is no join?? Or
			-- there is, any valid SQL expression is possible for InterBase.
			Result := mygenerator.columndatatype_assertion (Current)
		end

	sqlcolumnidentifier (sqlgenerator: SQL_GENERATOR; role: STRING): STRING
		do
			if sqlgenerator.assert_implemented_as_view (Current) then
				Result := sqlpkname (sqlgenerator)
			else
				Result := sql_select_name (sqlgenerator, role)
			end
		end

	sqlcolumndefault (sqlgenerator: SQL_GENERATOR; an_attribute: XPLAIN_ATTRIBUTE): detachable STRING
		do
		end

	sqlcolumnrequired (sqlgenerator: SQL_GENERATOR; an_attribute: XPLAIN_ATTRIBUTE): detachable STRING
		do
		end

	sql_qualified_name (sqlgenerator: SQL_GENERATOR; prefix_override: detachable STRING): STRING
			-- Name used in select statements
		do
			-- If there is no `prefix_override', no join was used to get
			-- our data, so assume calculated column.
			if attached prefix_override as p then
				Result := sqlgenerator.quote_identifier (prefix_override).twin
			else
				Result := type.quoted_name (sqlgenerator).twin
				--Result := sqlgenerator.quote_identifier (sqlname (sqlgenerator)).twin
			end
			Result.append_character ('.')
			Result.append_string (q_sql_select_name (sqlgenerator, Void))
		end


feature -- SQL code

	sql_select_name (sqlgenerator: SQL_GENERATOR; role: detachable STRING): STRING
			-- Name of base/type/extension when used in a select or order
			-- by statement.
			-- Note that it probably needs to be prefixed by its
			-- temporary table.
		do
			Result := sqlgenerator.make_valid_identifier (name)
		end

	sqlname (sqlgenerator: SQL_GENERATOR): STRING
			-- name as known in sql code
			-- to be overriden, callback into sqlgenerator
		do
			--Result := sqlcolumnidentifier (sqlgenerator, Void)
			Result := sqlgenerator.assertion_name (Current)
		end

	sqlpkname (sqlgenerator: SQL_GENERATOR): STRING
			-- Primary key column name of this type
		do
			Result := type.sqlpkname (sqlgenerator)
		end


feature -- Optimizations

	set_no_update_optimization (a_value: BOOLEAN)
		do
			-- Not supported for assertions
			-- Obviously this means that we need to be written with left
			-- outer joints when applicable (which is always I think,
			-- except perhaps in certain some function cases)
		end

end
