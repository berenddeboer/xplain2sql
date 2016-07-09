note

	description:

		"An assertion used in an expression"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"


class

	XPLAIN_ASSERTION_EXPRESSION


inherit

	XPLAIN_EXPRESSION
		redefine
			add_to_join,
			column_name,
			is_using_other_attributes,
			sqlname
		end


create

	make


feature {NONE} -- Initialization

	make (an_assertion: XPLAIN_ASSERTION; an_anode: like anode)
			-- Initialise.
		require
			assertion_not_void: an_assertion /= Void
			an_anode_not_void: an_anode /= Void
		do
			assertion := an_assertion
			anode := an_anode
			assertion.hack_anode (anode)
		end


feature -- Access

	column_name: STRING
			-- The Xplain based column heading name, if any. It is used
			-- by XML_GENERATOR to give clients some idea what the column
			-- name of a select is going to be.
		do
			Result := assertion.name
		end

	assertion: XPLAIN_ASSERTION
			-- Assertion;
			-- Can be Void in certain cases (when expression is build).

	anode: XPLAIN_ATTRIBUTE_NAME_NODE
			-- The way (its list) this assertion was derived


feature -- Status

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		do
			-- Hmm, were is my invariant that anode.next.next exists???
			Result :=
				attached anode.next as next and then attached next.next as nextnext or else
				not anode.item.is_equal (an_attribute)
		end

	uses_non_data_attributes: BOOLEAN
			-- Does this assertion expression use attributes of its owner
			-- that are other assertions or does it use an its list?
		do
			Result := True
		end

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			-- not applicable here, overriden by descendants
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			-- not applicable here, overriden by descendants
		end


feature -- SQL specifics

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST)
			-- Make sure the its list leading to this assertion is
			-- present as join.
		do
			if
				not sqlgenerator.CalculatedColumnsSupported or else
				assertion.is_complex or else
				assertion.is_function
			then
				join_list.extend (sqlgenerator, anode)
			end
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- The correct representation for this expression.
			-- Note that this feature is only called when this class is
			-- instantiated because an assertion has been used in an expression.
		do
			Result := assertion.expression.representation (sqlgenerator)
		end

	sqlfromaliasname: detachable STRING
			-- Joining with assertion table/view requires an outer join
			-- name, but when building a function assertion only.
		do
			-- not applicable.
			-- Result := ""
		end

	sqlname (sqlgenerator: SQL_GENERATOR): STRING
			-- Try to come up with the most likely column name for this
			-- assertion.
		do
			Result := assertion.sql_select_name (sqlgenerator, Void)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- attributes of the type it has to be prefixed by "new." for
			-- example.
		do
			-- Probably not applicable
			Result := sqlvalue (sqlgenerator)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Assertion when used in get/value statement. Name includes
			-- prefix of table if we have such a prefix.
		do
			check attached anode.last as last then
				Result := assertion.sql_qualified_name (sqlgenerator, last.prefix_table)
			end
			-- Asserts can have partial results when some function is
			-- used as there might be no data in that case.
			if attached {XPLAIN_EXTENSION_FUNCTION_EXPRESSION} assertion.expression as function then
				Result := sqlgenerator.SQLCoalesce + once "(" + Result + once ", " + function.selection.function.sqlextenddefault (sqlgenerator, function.selection.property) + once ")"
			else
				-- This shouldn't happen as it is not a some function so
				-- we always have data, but just emit the value of the
				-- assertion.
				-- In case sqlgenerator doesn't have a coalesce, we won't bother
				if sqlgenerator.SQLCoalesce /= Void then
					Result := sqlgenerator.SQLCoalesce + once "(" + Result + once ", " + assertion.expression.sqlvalue (sqlgenerator) + once ")"
				end
			end
		end


invariant

	assertion_not_void: assertion /= Void
	anode_not_void: anode /= Void
	anode_has_next: attached anode.next

end
