note

	description: "Node in a tree, basically XPLAIN_NODE, but can branch."

	author:     "Berend de Boer <berend@pobox.com>"

class

	JOIN_TREE_NODE

inherit

	KL_IMPORTED_STRING_ROUTINES

create

	make

feature {NONE} -- Initialisation

	make (
		an_item: detachable XPLAIN_ATTRIBUTE_NAME_NODE;
		an_is_upward_join,
		an_is_forced_left_outer_join,
		an_is_forced_inner_join: BOOLEAN)
			-- Prepare node in tree
		do
			item := an_item
			is_upward_join := an_is_upward_join
			is_forced_left_outer_join := an_is_forced_left_outer_join
			is_forced_inner_join := an_is_forced_inner_join
			create next.make
		end

feature -- Tree querying

	found_immediate_child: detachable JOIN_TREE_NODE
			-- Last node found by `has_immediate_child'

	get_immediate_child (anode: XPLAIN_ATTRIBUTE_NAME_NODE; an_is_upward_join: BOOLEAN): detachable JOIN_TREE_NODE
			-- The child where `anode' is an item
		require
			has_child: has_immediate_child (anode, an_is_upward_join)
		do
			if has_immediate_child (anode, an_is_upward_join) and attached found_immediate_child as child then
				Result := child
			end
		end

	has_immediate_child (anode: XPLAIN_ATTRIBUTE_NAME_NODE; an_is_upward_join: BOOLEAN): BOOLEAN
			-- Does `anode' exist in our `next' list?
		require
			valid_node: anode /= Void
		do
			found_immediate_child := Void
			from
				next.start
			until
				next.after or else
				(next.item_for_iteration.item.item.is_equal (anode.item) and then
				 an_is_upward_join = next.item_for_iteration.is_upward_join)
			loop
				next.forth
			end
			Result := not next.after and then next.item_for_iteration.item.item.is_equal (anode.item) and then an_is_upward_join = next.item_for_iteration.is_upward_join
			if Result then
				found_immediate_child := next.item_for_iteration
			end
		ensure
			found_child_set: Result implies attached found_immediate_child
			no_false_positives: not has_children implies not Result
		end

	has_children: BOOLEAN
			-- Does the tree have children?
		do
			-- For a normal attribute list it would be enough to look at
			-- next, for for a reversed list (upward join used in
			-- extends) we also need to check if any attributes of the
			-- type are used, else it will not be joined
			-- because the code assumes the first type (which is now the
			-- last) is always joined.
			Result :=
				not next.is_empty
-- 				or else
-- 				(other_items /= Void and then not other_items.is_empty)
		end

feature -- Tree changing

	append_child (anode: XPLAIN_ATTRIBUTE_NAME_NODE; an_is_upward_join, an_is_forced_left_outer_join, an_is_forced_inner_join: BOOLEAN)
			-- Make anode a child.
		require
			not_child: not has_immediate_child (anode, an_is_upward_join)
		local
			jnode: JOIN_TREE_NODE
		do
			create jnode.make (anode, an_is_upward_join, an_is_forced_left_outer_join, an_is_forced_inner_join)
			next.put_last (jnode)
		ensure
			can_be_found: has_immediate_child (anode, an_is_upward_join)
		end

	add_additional_item (anode: XPLAIN_ATTRIBUTE_NAME_NODE)
			-- Add more name nodes to this level, we need to keep track
			-- of them to be able to set their prefix properly.
		require
			has_node: anode /= Void
			is_really_additional: anode /= item and then other_items /= Void implies not other_items.has (anode)
		do
			if other_items = Void then
				create other_items.make
			end
			other_items.put_last (anode)
		ensure
			item_added: other_items.has (anode)
		end


feature -- JOIN_NODE generation

	generate_join_nodes (
			sqlgenerator: SQL_GENERATOR;
			aggregate: XPLAIN_TYPE;
			aggregate_alias: STRING): detachable JOIN_NODE
			-- Return JOIN_NODEs for self and any children.
			-- Also set prefix for all managed XPLAIN_ATTRIBUTE_NAME_NODE.
		require
			has_sqlgenerator: sqlgenerator /= Void
			has_aggregate: aggregate /= Void
			has_aggregate_alias: aggregate_alias /= Void and then not aggregate_alias.is_empty
			has_something_to_add: item /= Void or else has_children
		local
			join: JOIN
			my_attribute: XPLAIN_TYPE
			attribute_alias: STRING
			aggregate_fk: STRING
			first,
			next_join_nodes: detachable JOIN_NODE
		do
			if has_children then
				if attached item and attached item.item.type_attribute as type_attribute then
					my_attribute := item.item.type
					attribute_alias := alias_name (sqlgenerator, my_attribute)
					if is_upward_join then
						aggregate_fk := aggregate.sqlcolumnidentifier (sqlgenerator, item.item.role)
					else
						aggregate_fk := item.item.sqlcolumnidentifier (sqlgenerator)
					end
					create join.make (
						type_attribute,
						my_attribute,
						attribute_alias,
						aggregate,
						aggregate_alias,
						aggregate_fk,
						is_upward_join,
						is_forced_left_outer_join,
						is_forced_inner_join)
					create first.make (join, Void)
					increment_usage (my_attribute)
					set_prefix_table (aggregate_alias)
				else
					-- This is the root node, clear table_counter
					table_counter.wipe_out
					increment_usage (aggregate)
					set_prefix_table (aggregate_alias)
					my_attribute := aggregate
					attribute_alias := aggregate_alias
				end
				from
					next.start
				until
					next.after
				loop
					next_join_nodes := next.item_for_iteration.generate_join_nodes (
						sqlgenerator,
						my_attribute,
						attribute_alias)
					if first = Void then
						first := next_join_nodes
					else
						first.last.set_next (next_join_nodes)
					end
					next.forth
				end
				Result := first
			else
				set_prefix_table (aggregate_alias)
			end
		ensure
			join_node_returned_if_not_leave: has_children implies Result /= Void
			--join_node_returned_if_not_leave: next.is_empty = (Result = Void)
			all_items_are_prefixed: have_all_items_a_prefix
		end

feature {NONE} -- Implementation

	alias_name (sqlgenerator: SQL_GENERATOR; type: XPLAIN_TYPE): STRING
			-- Valid and unique sql identifier to use as alias for this
			-- table;
			-- preferably the alias should equal the table.
		require
			have_sqlgenerator: sqlgenerator /= Void
			have_type: type /= Void
		do
			Result := type.sqlname (sqlgenerator)
			table_counter.search (type)
			if table_counter.found then
				Result := Result.twin
				Result.append_string (table_counter.found_item.out)
			end
		ensure
			name_returned: Result /= Void and then not Result.is_empty
		end

	increment_usage (a_type: XPLAIN_TYPE)
			-- Make a note that this table has been used once more in the
			-- join list.
		require
			type_not_void: a_type /= Void
		do
			table_counter.search (a_type)
			if table_counter.found then
				table_counter.replace (table_counter.found_item + 1, a_type)
			else
				table_counter.put (1, a_type)
			end
		end

	set_prefix_table (prefix_table: STRING)
			-- Set prefix for all items to to `prefix_table'
		require
			have_prefix: prefix_table /= Void and then not prefix_table.is_empty
		do
			if item /= Void then
				item.set_prefix_table (prefix_table)
			end
			if other_items /= Void then
				from
					other_items.start
				until
					other_items.after
				loop
					other_items.item_for_iteration.set_prefix_table (prefix_table)
					other_items.forth
				end
			end
		ensure
			all_items_are_prefixed: have_all_items_a_prefix
		end

	table_counter: DS_HASH_TABLE [INTEGER, XPLAIN_TYPE]
			-- Count how often a table has been used.
		once
			create Result.make (64)
		end

feature -- Debugging

	have_all_items_a_prefix: BOOLEAN
			-- Do all items have a prefix?
		do
			Result := item = Void or else item.prefix_table /= Void
			if Result then
				if other_items /= Void then
					from
						other_items.start
					until
						not Result or else
						other_items.after
					loop
						Result := other_items.item_for_iteration.prefix_table /= Void
						other_items.forth
					end
				end
			end
		end

	print_tree (indent: INTEGER)
			-- Print join tree to stdout, for debug purposes only.
		local
			spaces: STRING
		do
			create spaces.make_filled (' ', indent)
			print (spaces)
			if item = Void then
				print ("root%N")
			else
				print (item.prefix_table)
				print (".")
				print (item.item.full_name)
				print ("%N")
			end
			if other_items /= Void then
				from
					other_items.start
				until
					other_items.after
				loop
					print (spaces)
					print (other_items.item_for_iteration.prefix_table)
					print (".")
					print (other_items.item_for_iteration.item.full_name)
					print ("%N")
					other_items.forth
				end
			end
			from
				next.start
			until
				next.after
			loop
				next.item_for_iteration.print_tree (indent + 2)
				next.forth
			end
		end

feature -- Access

	is_forced_left_outer_join: BOOLEAN

	is_forced_inner_join: BOOLEAN
			-- We can force inner join when there is a predicate on an
			-- existential extend. That's an optimisation which is
			-- enabled in some cases.

	is_upward_join: BOOLEAN
			-- Is join actually upward instead of downward?

	item: detachable XPLAIN_ATTRIBUTE_NAME_NODE

	other_items: detachable DS_LINKED_LIST [XPLAIN_ATTRIBUTE_NAME_NODE]

feature {JOIN_LIST} -- Chain

	next: DS_LINKED_LIST [JOIN_TREE_NODE]

invariant

	next_list_exists: next /= Void

end
