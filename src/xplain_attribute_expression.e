indexing

	description: "Xplain its expression"
	author:	"Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:		"$Date: 2010/02/11 $"
	revision:	"$Revision: #12 $"

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
			sqlinitvalue,
			sqlname
		end

create

	make


feature {NONE} -- Initialization

	make (a_first: XPLAIN_ATTRIBUTE_NAME_NODE) is
			-- Initialize.
		require
			valid_list: a_first /= Void
		do
			first := a_first
		end


feature -- Access

	column_name: STRING is
			-- The name of the last attribute in the attribute its chain.
		do
			Result := first.last.item.full_name
		end

	path_name: STRING is
			-- The path of the its list
		local
			n: XPLAIN_ATTRIBUTE_NAME_NODE
			type: XPLAIN_TYPE
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
			type ?= first.last.item.object
			if type /= Void then
				Result.append_string (once "/@instance")
			end
		end

	first: XPLAIN_ATTRIBUTE_NAME_NODE
			-- First attribute in chain.


feature -- Status

	can_be_null: BOOLEAN is
			-- Can the result of this expression be a Null value?
		do
				check
					have_attribute: first.last.item.attribute /= Void
				end
			Result := not first.last.item.attribute.is_required
		end

	is_logical_expression: BOOLEAN is
		local
			b: XPLAIN_B_REPRESENTATION
		do
			b ?= first.last.item.abstracttype.representation
			Result := b /= Void
		end

	is_specialization: BOOLEAN is
			-- Is this expression an attribute its list and does it refer
			-- to an attribute that is a specialization?
			-- Used for XML generation.
		do
			Result := first.last.item.attribute.is_specialization
		end

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		do
			Result :=
				first.next /= Void or else
				not first.item.is_equal (an_attribute)
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			Result := False
		end


feature -- SQL specifics

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST) is
			-- Generate joins for this attribute chain.
			-- Also set prefix_table for every attribute node,
			-- but only when prefix_table is not set, assume manual
			-- operation then (used to generate correct correlated join
			-- when creating extensions)
		do
			--if first.prefix_table = Void then
				join_list.extend (sqlgenerator, first)
			--end
		end

	exact_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- Most exact representation of this expression, should not
			-- try to accomodate larger values.
		do
			Result := first.last.item.abstracttype.representation
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- Guessed representation that matches this expression.
			-- Used to generate representations for value and extend
			-- statements. As it must be able to accomodate updates, it
			-- is usually wider than required.
			-- Use `exact_reprsentation' to get a more precise representation.
		do
			Result := first.last.item.abstracttype.representation.value_representation (sqlgenerator)
		end

	sqlmaxvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- return the maximum value of this expression according to its type
		do
			Result := first.last.item.abstracttype.representation.max_value (sqlgenerator)
		end

	sqlminvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- return the minimum value of this expression according to its type
		do
			Result := first.last.item.abstracttype.representation.min_value (sqlgenerator)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING is
		do
			Result := sqlgenerator.sqlinitvalue_attribute (Current)
		end

	sqlname (sqlgenerator: SQL_GENERATOR): STRING is
			-- For attributes, the column name of an expression is the
			-- column name used in the table.
		do
			Result := first.last.item.sqlcolumnidentifier (sqlgenerator)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- SQL for name of last attribute in list
		local
			lastnode: XPLAIN_ATTRIBUTE_NAME_NODE
		do
			create Result.make (64)
			-- usually this should be true:
			-- valid_alias: first.last.prefix_table /= Void
			-- for example with get/extend statements
			-- however, for update statements (update t its a = a + 1)
			-- we don't have a prefix nor should we output one.
			if sqlgenerator.InUpdateStatement and then (first.next /= Void or else sqlgenerator.updated_extension /= Void) then
				Result := sqlgenerator.sql_subselect_for_attribute (first)
			else
				lastnode := first.last
				if lastnode.prefix_table /= Void then
					Result.append_string (sqlgenerator.quote_identifier (lastnode.prefix_table))
					Result.append_character ('.')
				end
				Result.append_string (lastnode.item.quoted_name (sqlgenerator))
			end
		end


invariant

	has_first: first /= Void


end
