note

	description: "Xplain its expression"
	author:	"Berend de Boer <berend@pobox.com>"

class

	XPLAIN_ATTRIBUTE_EXPRESSION

inherit

	XPLAIN_EXPRESSION
		redefine
			add_to_join,
			can_be_null,
			column_name,
			path_name,
			exact_representation,
			is_logical_expression,
			is_specialization,
			is_using_other_attributes,
			sqlminvalue,
			sqlmaxvalue,
			sqlname
		end

create

	make


feature {NONE} -- Initialization

	make (a_first: XPLAIN_ATTRIBUTE_NAME_NODE)
			-- Initialize.
		require
			valid_list: a_first /= Void
		do
			first := a_first
		end


feature -- Access

	column_name: STRING
			-- The name of the last attribute in the attribute its chain.
		do
			Result := last.item.full_name
		end

	path_name: STRING
			-- The path of the its list
		local
			n: detachable XPLAIN_ATTRIBUTE_NAME_NODE
		do
			from
				Result := first.item.full_name.twin
				n := first.next
			until
				n = Void
			loop
				Result.append_character ('/')
				Result.append_string (n.item.full_name)
				n := n.next
			end
			if attached {XPLAIN_TYPE} last.item.object as type then
				Result.append_string (once "/@instance")
			end
		end

	first: XPLAIN_ATTRIBUTE_NAME_NODE
			-- First attribute in chain.


feature -- Status

	can_be_null: BOOLEAN
			-- Can the result of this expression be a Null value?
		do
				check
					have_attribute: last.item.type_attribute /= Void
				end
			if attached first.last as l and then attached l.item.type_attribute as ta then
				Result := not ta.is_required
			end
		end

	is_logical_expression: BOOLEAN
		do
			if attached first.last as l and then attached l.item.abstracttype as at and then attached {XPLAIN_B_REPRESENTATION} at.representation then
				Result := True
			end
		end

	is_specialization: BOOLEAN
			-- Is this expression an attribute its list and does it refer
			-- to an attribute that is a specialization?
			-- Used for XML generation.
		do
			if attached first.last as l and then attached l.item.type_attribute as ta then
				Result := ta.is_specialization
			end
		end

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		do
			Result :=
				first.next /= Void or else
				not first.item.is_equal (an_attribute)
		end

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			Result := first.next /= Void
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result := False
		end


feature -- SQL specifics

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST)
			-- Generate joins for this attribute chain.
			-- Also set prefix_table for every attribute node,
			-- but only when prefix_table is not set, assume manual
			-- operation then (used to generate correct correlated join
			-- when creating extensions)
		do
			join_list.extend (sqlgenerator, first)
		end

	exact_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- Most exact representation of this expression, should not
			-- try to accomodate larger values.
		do
			Result := last.item.abstracttype.representation
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- Guessed representation that matches this expression.
			-- Used to generate representations for value and extend
			-- statements. As it must be able to accomodate updates, it
			-- is usually wider than required.
			-- Use `exact_reprsentation' to get a more precise representation.
		do
			Result := last.item.abstracttype.representation.value_representation (sqlgenerator)
		end

	sqlmaxvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- return the maximum value of this expression according to its type
		do
			Result := last.item.abstracttype.representation.max_value (sqlgenerator)
		end

	sqlminvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- return the minimum value of this expression according to its type
		do
			Result := last.item.abstracttype.representation.min_value (sqlgenerator)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING
		do
			Result := sqlgenerator.sqlinitvalue_attribute (Current)
		end

	sqlname (sqlgenerator: SQL_GENERATOR): STRING
			-- For attributes, the column name of an expression is the
			-- column name used in the table.
		do
			Result := last.item.sqlcolumnidentifier (sqlgenerator)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- SQL for name of last attribute in list
		do
			create Result.make (64)
			-- usually this should be true:
			-- valid_alias: first.last.prefix_table /= Void
			-- for example with get/extend statements
			-- however, for update statements (update t its a = a + 1)
			-- we don't have a prefix nor should we output one.
			if sqlgenerator.InUpdateStatement and then (attached first.next or else attached sqlgenerator.updated_extension) then
				Result := sqlgenerator.sql_subselect_for_attribute (first)
			else
				check attached first.last as lastnode then
					if attached lastnode.prefix_table as p then
						Result.append_string (sqlgenerator.quote_identifier (p))
						Result.append_character ('.')
					end
					Result.append_string (lastnode.item.quoted_name (sqlgenerator))
				end
			end
		end


feature {NONE} -- Implementation

	last: XPLAIN_ATTRIBUTE_NAME_NODE
			-- `first'.`last';
			-- we assume we are only called in cases where this exist
		require
			first_has_last: attached first.last
		do
			check attached first.last as l then
				Result := l
			end
		end


invariant

	has_first: first /= Void


end
