indexing

	description: "SQL join builder."

	how_it_works:
	"This object expects to be passed one or more its chains.%
	%From this it builds a tree structure, trying to make a path as long as%
	%possible. As soon as `finalize' is called, all passed attributes are%
	%given their proper alias."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #5 $"


class

	JOIN_LIST


create

	make


feature {NONE} -- Initialization

	make (a_base_aggregate: XPLAIN_TYPE) is
			-- Initialize.
		require
			valid_aggregate: a_base_aggregate /= Void
		do
			base_aggregate := a_base_aggregate
			create root.make (Void, False, False, False)
			debug ("xplain2sql_join")
				print (once "%NCreating the longest chains of attributes possible.%NThe result of this process is a tree structure.%N")
			end
		end


feature -- Access

	base_aggregate: XPLAIN_TYPE
			-- the table name after the from statement.

	first: JOIN_NODE is
			--- First JOIN to output to SQL or Void if there are no joins
		require
			finalized_called: is_finalized
		do
			Result := my_first
		end


feature -- Status

	existential_join_optimisation: BOOLEAN is
			-- Set when a join to an extend that was derived by creating
			-- a partial table can be fuly joined instead of left outer
			-- joined. That greatly improves performance.
			-- Currently only extend with a boolean value can be
			-- optimised, i..e derived via a logical expression or using
			-- an any/nil function.
		do
			Result := existential_join_optimisation_count = 1
		end

	is_empty: BOOLEAN is
			-- Is there nothing to join?
		require
			finalized_called: is_finalized
		do
			Result := my_first = Void
		end

	is_finalized: BOOLEAN
			-- Has `finalize' been called?


feature -- Change

	enable_existential_join_optimisation is
			-- Allow simple stack-wise enabling/disable of existential
			-- join optimisation.
		do
			existential_join_optimisation_count := existential_join_optimisation_count + 1
		end

	disable_existential_join_optimisation is
			-- Allow simple stack-wise enabling/disable of existential
			-- join optimisation.
		do
			existential_join_optimisation_count := existential_join_optimisation_count - 1
		ensure
			disabled: not existential_join_optimisation
		end


feature {NONE} -- chain handling

	root: JOIN_TREE_NODE

	my_first: JOIN_NODE
			-- Set by `finalize'

	force_left_outer_join: BOOLEAN
			-- Force left outer join, used with generating SQL for a
			-- function that can use left outer join and group by

	is_upward_join: BOOLEAN
			-- Should `extend' treat the join as a join upward? It will
			-- generate a left outer join in that case.


feature -- Main commands

	add_join_to_aggregate (
		sqlgenerator: SQL_GENERATOR
		a_per_property: XPLAIN_ATTRIBUTE_NAME_NODE
		a_selection: XPLAIN_SELECTION_FUNCTION;
		a_force_left_outer_join: BOOLEAN) is
			-- Add a join to a type that has this type as an
			-- aggregate. This allows certain functions to use (left outer)
			-- joins which are usually much faster with current
			-- optimizers.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
			a_per_property_not_void: a_per_property /= Void
			a_selection_not_void: a_selection /= Void
		local
			attr: XPLAIN_ATTRIBUTE
			aname: XPLAIN_ATTRIBUTE_NAME
			anode: XPLAIN_ATTRIBUTE_NAME_NODE
			save_base_aggregate: XPLAIN_TYPE
			save_root: JOIN_TREE_NODE
			dummy: XPLAIN_ATTRIBUTE_NAME_NODE
		do
			-- The first task is to create a join from the lowest table
			-- (the table in the from clause) all the way up to the
			-- highest table (a_selection.subject.type) using the per clause.
			-- It is an upward instead of the usual downward join.
			is_upward_join := True
			force_left_outer_join := a_force_left_outer_join
			create attr.make (Void, a_selection.subject.type, False, not a_force_left_outer_join, False, False)
			create aname.make_from_attribute (attr)
			create anode.make (aname, a_per_property)
			-- Revert the list, so we have an upward join.
			anode := revert_alist (anode)
			-- After reversing we need to pickup the role items from the
			-- next item. Because of the upward join the role to use is
			-- actually from the previous item, not from the current
			-- item.
			copy_role_to_next (anode)
			-- Don't actually include the last node (which now has become
			-- the first), because it will be in the from clause, so we
			-- shouldn't join that.
			anode := anode.next
			-- We want to join up to the last, which won't happen,
			-- because the last attribute is supposed to be part of the
			-- previous (a reference or a base). But our last attribute
			-- is a type and we want it joined, so we just add the first
			-- attribute of that type.
			create aname.make_from_attribute (a_selection.subject.type.attributes.first)
			create dummy.make (aname, Void)
			anode.last.set_next (dummy)
			extend (sqlgenerator, anode)
			is_upward_join := False
			debug ("xplain2sql_join")
				print ("Upward join from " + base_aggregate.name + " up to " + a_selection.subject.type.name + " finished.%N")
			end

			-- Upward join finished. Now join all the other strands to
			-- the chain we have created, but they should be normal
			-- downward joins. But all left outer, because the upward
			-- join was left outer.
			-- Because we have reversed the list, we must make the last
			-- item (the top of the join) in the list our base aggregate
			-- as we are now joining downward again.
			save_root := root
			save_base_aggregate := base_aggregate
			base_aggregate := a_selection.subject.type
			from
				root := root.next.last
			until
				root.next.last.next.is_empty
			loop
				root := root.next.last
			end
			debug ("xplain2sql_join")
				print ("Doing any necessary downward joins.%N")
				print ("New base aggregate is " + base_aggregate.name + ".%N")
			end
				check
					new_base_aggregate_is_top_type: base_aggregate.name.is_equal (a_selection.subject.type.name)
				end
			a_selection.add_to_join (sqlgenerator, Current)
			base_aggregate := save_base_aggregate
			root := save_root
			force_left_outer_join := False
		end

	extend (
			sqlgenerator: SQL_GENERATOR
			attribute_list: XPLAIN_ATTRIBUTE_NAME_NODE) is
			-- Add more joins if somewhere in attribute_list a chain is
			-- not in the joins already present.
		require
			have_sqlgenerator: sqlgenerator /= Void
			have_attribute_list: attribute_list /= Void
			not_finalized: not is_finalized
		local
			anode: XPLAIN_ATTRIBUTE_NAME_NODE
			jnode: JOIN_TREE_NODE
			indent: INTEGER
			spaces: STRING
		do
			debug ("xplain2sql_join")
				print (once "  root%N")
				indent := 4
			end
			if attribute_list.next = Void then
				debug ("xplain2sql_join")
					print (once "    " + attribute_list.item.full_name + " (immediate attribute)%N")
				end
				-- Only a single attribute, still have to set the alias.
				attribute_list.set_prefix_table (base_aggregate.sqlname (sqlgenerator))
			else
				-- Else walk the tree to find the longest strand contained
				-- in `attribute_list' and append the other items from
				-- there.
				from
					anode := attribute_list
					jnode := root
				until
					anode = Void
				loop
					debug ("xplain2sql_join")
						if jnode.item /= Void then
							create spaces.make_filled (' ', indent)
							print (spaces)
							indent := indent + 2
							print (jnode.item.item.name + " (descending)%N")
						end
					end
					if jnode.has_immediate_child (anode, is_upward_join) then
						-- Add leaf of attribute list to tree so it gets a prefix.
						jnode := jnode.found_immediate_child
						jnode.add_additional_item (anode)
					else
						debug ("xplain2sql_join")
							create spaces.make_filled (' ', indent)
							print (spaces)
							print (anode.item.full_name + " (strand extended)%N")
						end
						jnode.append_child (anode, is_upward_join, force_left_outer_join, existential_join_optimisation and then anode.item.attribute /= Void and then anode.item.attribute.is_logical_extension)
						jnode := jnode.get_immediate_child (anode, is_upward_join)
					end
					anode := anode.next
				end
			end
		end

	finalize (sqlgenerator: SQL_GENERATOR) is
			-- Generate the join statements by appending JOIN classes to
			-- the `first' property.
		require
			not_finalized: not is_finalized
		do
			debug ("xplain2sql_join")
				print (once "Assigning aliases to joined tables.%N")
			end
			if root.has_children then
				my_first := root.generate_join_nodes (
					sqlgenerator,
					base_aggregate,
					base_aggregate.sqlname (sqlgenerator))
				debug ("xplain2sql_join")
					print_tree
				end
			end
			is_finalized := True
		ensure
			finalized: is_finalized
		end

	optimize_joins (a_predicate: XPLAIN_EXPRESSION) is
		do
		end


feature -- Debug

	print_tree is
			-- Print the attribute chains, debug purposes only
		do
			debug ("xplain2sql_join")
				if root.has_children then
					print ("%N@@@ tree%N")
					root.print_tree (2)
				end
			end
		end


feature {NONE} -- Implementation

	existential_join_optimisation_count: INTEGER

	copy_role_to_next (anode: XPLAIN_ATTRIBUTE_NAME_NODE) is
		do
			if anode.next /= Void then
				copy_role_to_next (anode.next)
				anode.next.item.set_role (anode.item.role)
			end
		end

	revert_alist (anode: XPLAIN_ATTRIBUTE_NAME_NODE): XPLAIN_ATTRIBUTE_NAME_NODE is
		local
			last: XPLAIN_ATTRIBUTE_NAME_NODE
		do
			if anode.next = Void then
				create Result.make (anode.item, Void)
			else
				Result := revert_alist (anode.next)
				create last.make (anode.item, Void)
				Result.last.set_next (last)
			end
		end


invariant

	have_from_table: base_aggregate /= Void
	existential_join_optimisation_count_not_too_large: existential_join_optimisation_count <= 1

end
