note

	description:

		"Xplain collection of object (base, type, variable, value)%
		%should be singleton"

	author:     "Berend de Boer <berend@pobox.com>"

class

	XPLAIN_UNIVERSE


inherit

	KL_SHARED_STANDARD_FILES


create

	make


feature -- Initialization

	make
		do
			create objects.make (1024)
		end


feature -- Access

	objects: DS_HASH_TABLE [XPLAIN_ABSTRACT_OBJECT, STRING]
			-- All Xplain objects.


feature -- Commands

	add (object: XPLAIN_ABSTRACT_OBJECT)
			-- Add new object to the universe.
		require
			object_not_void: object /= Void
		do
			if attached find_object (object.name) as o and then o.may_be_redefined then
				-- Don't bother with saying a value is set again.
				-- std.error.put_string ("object already created: ")
				-- std.error.put_string (object.name)
				-- std.error.put_character ('%N')
			else
				objects.force (object, object.name)
			end
		ensure
			object_added: has (object.name)
		end

	delete (object: XPLAIN_ABSTRACT_OBJECT)
			-- Remove `object' from the universe.
		require
			object_not_void: object /= Void
		do
			if find_object (object.name) = Void then
				std.error.put_string ("object to be deleted does not exist in universe: ")
				std.error.put_string (object.name)
				std.error.put_character ('%N')
			else
				objects.remove_found_item
			end
		ensure
			object_removed: not has (object.name)
		end


feature -- Access

	has (object_name: STRING): BOOLEAN
			-- Does an object with name `object_name' exists in the universe?
		require
			object_name_not_empty: object_name /= Void and then not object_name.is_empty
		do
			Result := objects.has (object_name)
		end


feature -- find objects or types

	find_object (name: STRING): detachable XPLAIN_ABSTRACT_OBJECT
			-- Return object if found. Uses `objects'.`search'.
		do
			objects.search (name)
			if objects.found then
				Result := objects.found_item
			end
		ensure
			found_item_set: Result /= Void implies objects.found
		end

	find_base_or_type (name: STRING): detachable XPLAIN_ABSTRACT_TYPE
		do
			if attached {XPLAIN_ABSTRACT_TYPE} find_object (name) as t then
				result := t
			end
		end

	find_base (name: STRING): detachable XPLAIN_BASE
		do
			if attached {XPLAIN_BASE} find_object (name) as b then
				result := b
			end
		end

	find_type (name: STRING): detachable XPLAIN_TYPE
		do
			if attached {XPLAIN_TYPE} find_object (name) as t then
				result := t
			end
		end

	find_value (name: STRING): detachable XPLAIN_VALUE
		do
			if attached {XPLAIN_VALUE} find_object (name) as v then
				result := v
			end
		end

	find_variable (name: STRING): detachable XPLAIN_VARIABLE
		do
			if attached {XPLAIN_VARIABLE} find_object (name) as v then
				result := v
			end
		end


feature {NONE} -- Singleton part

	frozen singleton_memory: XPLAIN_UNIVERSE
		once
			Result := Current
		end


invariant

	is_actually_singleton: Current = singleton_memory
	have_objects: objects /= Void

end
