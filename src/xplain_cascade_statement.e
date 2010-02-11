indexing

	description: "Describes the Xplain cascade statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2004, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"

class

	XPLAIN_CASCADE_STATEMENT


inherit

	XPLAIN_STATEMENT


create

	make


feature {NONE} -- Initialization

	make (sqlgenerator: SQL_GENERATOR; a_subtype: XPLAIN_TYPE; a_cascade_attribute: like cascade_attribute; a_definition: like definition) is
		require
			subtype: a_subtype /= Void
			cascade_attribute_not_void: a_cascade_attribute /= Void
			definition_not_void: a_definition /= Void
			--same_type_if_function: a_subtype = a_definition.selection.type
		local
			counter_expression: XPLAIN_NUMBER_EXPRESSION
			counter_value: XPLAIN_VALUE
			round_visited: XPLAIN_EXTENSION
			round_visited_expression: XPLAIN_EXTENSION_EXPRESSION_EXPRESSION
			this_round: XPLAIN_EXTENSION
			this_round_expression: XPLAIN_EXTENSION_FUNCTION_EXPRESSION
			this_round_selection: XPLAIN_SELECTION_FUNCTION
			nil_function: XPLAIN_NIL_FUNCTION
			round_visited_subject: XPLAIN_SUBJECT
			this_round_value: XPLAIN_EXTENSION_EXPRESSION
			this_round_attribute_name: XPLAIN_ATTRIBUTE_NAME
			this_round_attribute_name_node: XPLAIN_ATTRIBUTE_NAME_NODE
			increment_counter: XPLAIN_VALUE
			increment_counter_expression: XPLAIN_INFIX_EXPRESSION
			one_expression: XPLAIN_NUMBER_EXPRESSION
			counter_current_value: XPLAIN_VALUE_EXPRESSION
			round_visited_assigment: XPLAIN_ASSIGNMENT
			round_visited_assignment_node: XPLAIN_ASSIGNMENT_NODE
			round_visited_attribute_name: XPLAIN_ATTRIBUTE_NAME
			where_this_round: XPLAIN_NOTNOT_EXPRESSION
			current_round_function: XPLAIN_ANY_FUNCTION
			from_node_attribute: XPLAIN_ATTRIBUTE
			from_node_attribute_name: XPLAIN_ATTRIBUTE_NAME
			from_node_attribute_name_node: XPLAIN_ATTRIBUTE_NAME_NODE
			current_round_property: XPLAIN_ATTRIBUTE_EXPRESSION
			current_round_selection: XPLAIN_SELECTION_FUNCTION
			current_round_expression: XPLAIN_EXTENSION_FUNCTION_EXPRESSION
			current_round: XPLAIN_EXTENSION
			current_round_where: XPLAIN_INFIX_EXPRESSION
			round_visited_attribute_name_node: XPLAIN_ATTRIBUTE_NAME_NODE
			round_visited_value: XPLAIN_EXTENSION_EXPRESSION
			finished: XPLAIN_VALUE
			finished_selection: XPLAIN_SELECTION_FUNCTION
			finished_expression: XPLAIN_EXTENSION_FUNCTION_EXPRESSION
			first_path_value: XPLAIN_EXTENSION_EXPRESSION
			previous_first_path_expression: XPLAIN_EXTENSION_EXPRESSION_EXPRESSION
			previous_firsth_path: XPLAIN_EXTENSION
		do
			subtype := a_subtype
			cascade_attribute := a_cascade_attribute
			definition := a_definition

			-- Create the Xplain statements that perform the cascade

			-- Nodes to skip (no path leading to it):
			-- 1. value counter = 0.
			create counter_expression.make (counter_initial_value)
			create counter_value.make (sqlgenerator, counter_name, counter_expression)
			create counter_statement.make (counter_value)

			-- 2. extend node with round visited = counter.
			create round_visited_expression.make (counter_expression)
			-- FIX COMPILE: create round_visited.make (sqlgenerator, subtype, round_visited_name, round_visited_expression)
			create round_visited_statement.make (round_visited)

			-- 3. extend node with this round =
			--      nil arc
			--      per to_node.
			-- @@BdB: problem detected: what if this set is empty?
			create nil_function
			create this_round_selection.make (nil_function, definition.selection.subject, Void, Void)
			create this_round_expression.make (this_round_selection, definition.grouping_attributes)
			-- FIX COMPILE: create this_round.make (sqlgenerator, subtype, this_round_name, this_round_expression)
			create first_round_statement.make (this_round)

			-- repeat until finished:

			-- 1. value counter = counter + 1.
			-- One problem here is that xplain2sql now substitutes the
			-- value for counter instead of using the variable, have to
			-- correct this when running a loop.
			create counter_current_value.make (counter_value)
			create one_expression.make (counter_increment_value)
			create increment_counter_expression.make (counter_current_value, "+", one_expression)
			create increment_counter.make (sqlgenerator, counter_name, increment_counter_expression)
			create increment_value_statement.make (increment_counter)

			-- Mark the nodes that have been visited in the previous round.
			-- 2. update node its round visited = counter
			--      where
			--        this round.
			create round_visited_attribute_name.make (Void, round_visited_name)
			round_visited_attribute_name.set_attribute (subtype.find_attribute (round_visited_attribute_name))
			create round_visited_assigment.make (round_visited_attribute_name, counter_current_value)
			create round_visited_assignment_node.make (round_visited_assigment, Void)
			create this_round_attribute_name.make (Void, this_round_name)
			this_round_attribute_name.set_object (this_round)
			create this_round_attribute_name_node.make (this_round_attribute_name, Void)
			create this_round_value.make (this_round, this_round_attribute_name_node)
			create where_this_round.make (this_round_value)
			create round_visited_subject.make (subtype, Void)
			create update_round_visited_statement.make (round_visited_subject, round_visited_assignment_node, where_this_round)

			-- Have to remove temporary table, or update it if that is supported.
			-- 3. purge node its this round.

			-- Mark the nodes that we will visit this round:
			-- 4. extend node with this round =
			--      any arc its from_node
			--        where
			--          round visited = counter
			--        per to_node.
			create current_round_function
			-- This might be pretty hard to figure out: need to find the cycle
			-- or the link node in the expression. Hardcoded for now...
			create from_node_attribute_name.make ("from", subtype.name)
			from_node_attribute := definition.selection.subject.type.find_attribute (from_node_attribute_name)
			create from_node_attribute_name.make_from_attribute (from_node_attribute)
			create from_node_attribute_name_node.make (from_node_attribute_name, Void)
			create current_round_property.make (from_node_attribute_name_node)
			create round_visited_attribute_name_node.make (round_visited_attribute_name, Void)
			create round_visited_value.make (round_visited, round_visited_attribute_name_node)
			create current_round_where.make (round_visited_value, "=", counter_current_value)
			create current_round_selection.make (current_round_function, definition.selection.subject, current_round_property, current_round_where)
			create current_round_expression.make (current_round_selection, definition.grouping_attributes)
			-- FIX COMPILE: create current_round.make (sqlgenerator, subtype, this_round_name, current_round_expression)
			create current_round_statement.make (current_round)

			-- Are we finished?
			-- value finished =
			--   nil node
			--   where
			--     this round.
			create finished_selection.make (nil_function, round_visited_subject, Void, Void)
			create finished_expression.make (finished_selection, round_visited_attribute_name_node)
			create finished.make (sqlgenerator, "finished", finished_expression)
			create finished_statement.make (finished)

			-- Save contents `first path' so we can update it
			-- extend node with previous first path = first path.
			-- TODO: working on this below, doesn't yet compile
-- 			create first_path_value.make (first_path, first_path_attribute_name_node)
-- 			create previous_first_path_expression.make (first_path_value)
-- 			create previous_firsth_path.make (sqlgenerator, subtype, "previous first path", previous_first_path_expression)
-- 			create previous_first_path_statement.make (previous_firsth_path)
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR) is
			-- Write output according to this generator.
		do
			--a_generator.write_cascade (subtype, cascade_attribute, definition)

			-- 1. value counter = 0.
			counter_statement.write (a_generator)

			-- 2. extend node with round visited = counter.
			round_visited_statement.write (a_generator)

			-- 3. extend node with this round =
			--      nil arc
			--      per to_node.
			first_round_statement.write (a_generator)

			-- repeat until finished:
			-- 1. value counter = counter + 1.
			increment_value_statement.write (a_generator)

			-- Mark the nodes that have been visited in the previous round.
			-- 2. update node its round visited = counter
			--      where
			--        this round.
			update_round_visited_statement.write (a_generator)

			-- Mark the nodes that we will visit this round:
			-- 3. extend node with this round =
			--      any arc its from_node
			--        where
			--          round visited = counter
			--        per to_node.
			current_round_statement.write (a_generator)

			-- Are we finished?
			-- value finished =
			--   nil node
			--   where
			--     this round.
			finished_statement.write (a_generator)
			-- Should quit if finished
		end


feature --  Warnings

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Is parameter `a_parameter' used by this statement?
		do
			-- TODO: probably not complete
			Result := definition.uses_parameter (a_parameter)
		end


feature -- Access

	cascade_attribute: XPLAIN_ATTRIBUTE_NAME
			-- Attribute that is updated cascadedly

	definition: XPLAIN_CASCADE_FUNCTION_EXPRESSION

	subtype: XPLAIN_TYPE
			-- Type that is updated


feature {NONE} -- Xplain statements

	counter_statement: XPLAIN_VALUE_STATEMENT
			-- Counts the number of rounds we've done

	increment_value_statement: XPLAIN_VALUE_STATEMENT
			-- Increment counter by one

	round_visited_statement: XPLAIN_EXTEND_STATEMENT
			-- Indicates for every node in what round it was visited;
			-- Every nodes should be visited just once, if we visit a
			-- node twice, we have a circular reference.

	first_round_statement: XPLAIN_EXTEND_STATEMENT
			-- Nodes to be visited in the first round

	current_round_statement: XPLAIN_EXTEND_STATEMENT
			-- Nodes to be visited in the current round

	update_round_visited_statement: XPLAIN_UPDATE_STATEMENT
			-- Update the round visited extended attribute

	finished_statement: XPLAIN_VALUE_STATEMENT
			-- Determine if finished

	previous_first_path_statement: XPLAIN_EXTEND_STATEMENT


feature {NONE} -- Once strings used in building the Xplain statements

	counter_increment_value: STRING is "1"

	counter_initial_value: STRING is "0"

	counter_name: STRING is "counter"

	round_visited_name: STRING is "round visited"

	this_round_name: STRING is "this round"


invariant

	subtype: subtype /= Void
	cascade_attribute_not_void: cascade_attribute /= Void
	counter_statement_not_void: counter_statement /= Void
	round_visited_statement_not_void: round_visited_statement /= Void
	first_round_statement_not_void: first_round_statement /= Void
	current_round_statement_not_void: current_round_statement /= Void

end
