note

	description: "Xplain base for virtual or extended attributes.%
	%Specializes into a virtual attribute or extension."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999-2007, Berend de Boer"


deferred class

	XPLAIN_ABSTRACT_EXTENSION


inherit

	XPLAIN_ABSTRACT_TYPE
		redefine
			hack_anode
		end


feature -- SQL

	sql_qualified_name (sqlgenerator: SQL_GENERATOR; prefix_override: detachable STRING): STRING
			-- Name used in select statements. prefix overrides the
			-- default prefix, used when joining the extend table more
			-- than one time.
		require
			have_sqlgenerator: sqlgenerator /= Void
		deferred
		ensure
			have_name: Result /= Void and then not Result.is_empty
		end

	sql_alias (sqlgenerator: SQL_GENERATOR): detachable STRING
			-- Used in `do_do_create_select_list' if output comes from an
			-- optimised extension and therefore doesn't have a nice
			-- colum name. With this the column name can be forced even
			-- if the user doesn't specify " as ".
			-- Void if not applicable.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		do
		end


feature -- Access

	type: XPLAIN_TYPE
			-- The type that is extended

	expression: XPLAIN_EXTENSION_EXPRESSION
			-- Extension definition


feature

	hack_anode (anode: XPLAIN_ATTRIBUTE_NAME_NODE)
			-- Add one more item to the `anode' chain.
		local
			next_node: XPLAIN_ATTRIBUTE_NAME_NODE
			next_name: XPLAIN_ATTRIBUTE_NAME
		do
			-- if `anode' is now used in a join, it will join all tables
			-- up to the owner (type) of this extension. We need to make `anode'
			-- one item longer (due to JOIN_LIST restrictions) to have
			-- possibility to add the extension table.
			create next_name.make (Void, name)
			next_name.set_object (Current)
			create next_node.make (next_name, Void)
			if attached anode as n and then attached n.last as last and then attached next_node as nn then
				last.set_next (nn)
			end
		ensure then
			anode_has_next: attached anode.next
		end


feature -- Optimizations

	no_update_optimization: BOOLEAN
			-- Extension is not updated, so enable optimization

	set_no_update_optimization (a_value: BOOLEAN)
		require
			supported: expression.is_update_optimization_supported
		local
			an: XPLAIN_ATTRIBUTE_NAME
		do
			no_update_optimization := a_value
			-- For no update optimisation as not all extended values are in
			-- the temporary table, so we have to mark this attribute as
			-- not required, which will cause a left outer join.
			if no_update_optimization then
				create an.make (Void, name)
				if attached type.find_attribute (an) as a then
					a.set_required (False)
				end
				-- Note that for performance reasons a join is greatly
				-- preferred, so in the actual select we turn this into a
				-- join for any/nil functions when possible.
			end
		end


end
