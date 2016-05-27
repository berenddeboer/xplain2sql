note

	description: "Xplain type"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #12 $"


class

	XPLAIN_TYPE

inherit

	XPLAIN_ABSTRACT_TYPE
		rename
			representation as abstract_representation,
			make as make_abstract_type
		end


create

	make


feature {NONE} -- Initialization

	make (aname: STRING; arepresentation: XPLAIN_PK_REPRESENTATION; a_attributes: XPLAIN_ATTRIBUTE_NODE)
		require
			valid_attributes: -- every attribute has abstracttype /= Void
			-- when it is Void, it's a self reference
		local
			id_restriction: XPLAIN_IDENTIFICATION_RESTRICTION
			node: XPLAIN_ATTRIBUTE_NODE
		do
			make_abstract_type (aname, arepresentation)
			representation := arepresentation
			id_restriction ?= representation.domain_restriction
			id_restriction.set_owner (Current)

			create  attributes.make
			-- add `a_attributes' to `attributes'
			-- any attribute where abstracttype is Null, is a self reference,
			-- fix that here
			from
				node := a_attributes
			until
				node = Void
			loop
				if node.item.abstracttype = Void then
					node.item.set_abstracttype (Current)
				end
				attributes.put_last (node.item)
				node := node.next
			end
		end


feature -- Access

	representation: XPLAIN_PK_REPRESENTATION
			-- Primary key domain

	attributes: DS_LINKED_LIST [XPLAIN_ATTRIBUTE]
			-- Attributes of this type


feature -- make sure unique names can be generated

	constraint_number: INTEGER

	next_constraint_number
		do
			constraint_number := constraint_number + 1
		end


feature -- purge type

	write_drop (sqlgenerator: SQL_GENERATOR)
		do
			sqlgenerator.drop_table (Current)
		end

	write_drop_attribute (sqlgenerator: SQL_GENERATOR; an_attribute: XPLAIN_ATTRIBUTE)
			-- Remove attribute from type and write SQL code to remove it.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
			valid_attribute: attributes.has (an_attribute)
		do
			an_attribute.write_drop (sqlgenerator, Current)
			attributes.delete (an_attribute)
		ensure
			not_an_attribute: not attributes.has (an_attribute)
		end


feature -- SQL access

	columndatatype (mygenerator: ABSTRACT_GENERATOR): STRING
		do
			Result := mygenerator.columndatatype_type (Current)
		end

feature -- SQL code

	sqlcolumnidentifier (sqlgenerator: SQL_GENERATOR; role: STRING): STRING
		do
			Result := sqlgenerator.sqlcolumnidentifier_type (Current, role)
		end

	sqlcolumndefault (sqlgenerator: SQL_GENERATOR; an_attribute: XPLAIN_ATTRIBUTE): STRING
		do
			Result := sqlgenerator.sqlcolumndefault_type (an_attribute)
		end

	sqlcolumnrequired (sqlgenerator: SQL_GENERATOR; an_attribute: XPLAIN_ATTRIBUTE): STRING
		do
			Result := sqlgenerator.sqlcolumnrequired_type (an_attribute)
		end

feature -- Type specific sql converter wrappers

	sqlpkname (sqlgenerator: SQL_GENERATOR): STRING
			-- Return primary key column name of this type.
		do
			Result := sqlgenerator.table_pk_name (Current)
		end

	q_sqlpkname (sqlgenerator: SQL_GENERATOR): STRING
			-- Quoted `sqlpkname'.
		do
			Result := sqlgenerator.quote_identifier (sqlpkname (sqlgenerator))
		end

	sqltablename (sqlgenerator: SQL_GENERATOR): STRING
			-- Return actual table name of this type.
		do
			Result := sqlgenerator.create_table_name (Current)
		end

	sqlname (sqlgenerator: SQL_GENERATOR): STRING
			-- The identifier to reference this type in sql;
			-- use it in select statements and such.
		do
			Result := sqlgenerator.table_name (Current)
		end

feature -- questions about the type itself

	contains_one_is_a_relation: BOOLEAN
			-- used when generating primary key for a specialization
		local
			number_of_specializations: INTEGER
		do
			from
				attributes.start
				number_of_specializations := 0
			until
				attributes.after or else number_of_specializations > 1
			loop
				if attributes.item_for_iteration.is_specialization then
					number_of_specializations := number_of_specializations + 1
				end
				attributes.forth
			end
			Result := number_of_specializations = 1
		end

	generalization: XPLAIN_TYPE
		require
			has_single_supertype: contains_one_is_a_relation
		do
			from
				attributes.start
			until
				attributes.after or else Result /= Void
			loop
				if attributes.item_for_iteration.is_specialization then
					Result ?= attributes.item_for_iteration.abstracttype
				end
				attributes.forth
			end
		end

	has_auto_pk (sqlgenerator: SQL_GENERATOR): BOOLEAN
			-- Is the instance identification auto-generated?
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		do
			Result := sqlgenerator.table_has_auto_pk (Current)
		ensure
			must_be_integer:  Result implies representation.is_integer
		end

	has_non_constant_init: BOOLEAN
			-- Is there an attribute with an init that is not a constant?
		do
			from
				attributes.start
			until
				Result or else attributes.after
			loop
				Result :=
					attributes.item_for_iteration.init /= Void and then
					not attributes.item_for_iteration.init.is_constant
				attributes.forth
			end
		end

	has_non_literal_init: BOOLEAN
			-- Is there an attribute with an init that is not literal?
		do
			from
				attributes.start
			until
				Result or else attributes.after
			loop
				Result :=
					attributes.item_for_iteration.init /= Void and then
					not attributes.item_for_iteration.init.is_literal
				attributes.forth
			end
		end

	has_updatable_attributes: BOOLEAN
			-- Are there attributes that can be set by an update
			-- statement?
		do
			Result := not attributes.is_empty
		end


feature -- Attribute handling

	find_attribute (attribute_name: XPLAIN_ATTRIBUTE_NAME): XPLAIN_ATTRIBUTE
			-- Attribute if type has an attribute with this name
		require
			valid_attribute_name: attribute_name /= Void
		do
			from
				attributes.start
			until
				attributes.after or else
				(equal (attributes.item_for_iteration.name, attribute_name.name) and
				 equal (attributes.item_for_iteration.role, attribute_name.role))
			loop
				attributes.forth
			end
			if not attributes.after then
				Result := attributes.item_for_iteration
			end
		end

	has_attribute (a_role, a_name: STRING): BOOLEAN
			-- Has this type an attribute by this role and name?
		local
			an: XPLAIN_ATTRIBUTE_NAME
		do
			create an.make (a_role, a_name)
			Result := find_attribute (an) /= Void
		end



feature {XPLAIN_EXTENSION} -- Extend type

	add_extension (an_extension: XPLAIN_EXTENSION)
			-- Temporary attribute, defined by extend. It's the
			-- responsibility of the extend to add the extension to its
			-- type.
		require
			valid_extension: an_extension /= Void
			extension_for_this_type: an_extension.type = Current
		local
			my_attribute: XPLAIN_EXTENSION_ATTRIBUTE
		do
			create my_attribute.make (an_extension)
			attributes.put_last (my_attribute)
		ensure
			attribute_added: has_attribute (Void, an_extension.name)
		end


feature {XPLAIN_EXTEND_STATEMENT} -- Extend type

	remove_extension (extension: XPLAIN_EXTENSION)
			-- Drop extension from type.
		require
			valid_extension: extension /= Void
		local
			found: BOOLEAN
		do
			from
				attributes.start
			until
				attributes.after or else
				found
			loop
				found :=
					attributes.item_for_iteration.is_extension and then
					attributes.item_for_iteration.abstracttype = extension
				if not found then
					attributes.forth
				end
			end
			if found then
				attributes.remove_at
			end
		end

feature -- Virtual attributes

	add_assertion (assertion: XPLAIN_ASSERTION)
			-- Computed attribute, defined by assert.
		require
			valid_assertion: assertion /= Void
		local
			my_attribute: XPLAIN_VIRTUAL_ATTRIBUTE
		do
			create my_attribute.make (assertion)
			attributes.put_last (my_attribute)
		end


feature -- Specific cursors

	new_all_attributes_cursor (sqlgenerator: SQL_GENERATOR): DS_BILINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			-- Cursor for all attributes present in a `create table'
			-- statement according to `sqlgenerator' settings and
			-- possibilities, except the primary key column.
			-- Currently it includes the extended columns, that might be
			-- incorrect. Have to check the sources.
		require
			valid_sqlgenerator: sqlgenerator /= Void
		do
			create {XPLAIN_ALL_ATTRIBUTES_CURSOR [XPLAIN_ATTRIBUTE]} Result.make (Current, sqlgenerator)
		ensure
			result_not_void: Result /= Void
		end

	new_data_attributes_cursor (sqlgenerator: SQL_GENERATOR): DS_BILINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			-- Cursor for columns that can be updated. This excludes
			-- calculated columns (assertions). Extended columns can be
			-- updated, but are excluded. There might be constraints in
			-- the data columns (like inits) that prevent inserts or
			-- updates, but those columns are still included.
		require
			valid_sqlgenerator: sqlgenerator /= Void
		do
			create {XPLAIN_DATA_ATTRIBUTES_CURSOR} Result.make (Current, sqlgenerator)
		ensure
			result_not_void: Result /= Void
		end

	new_init_attributes_cursor (sqlgenerator: SQL_GENERATOR): DS_BILINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			-- Cursor for attributes with initialization.
		require
			valid_sqlgenerator: sqlgenerator /= Void
		do
			create {XPLAIN_INIT_ATTRIBUTES_CURSOR [XPLAIN_ATTRIBUTE]} Result.make (Current, sqlgenerator)
		ensure
			result_not_void: Result /= Void
		end


invariant

	attributes_not_void: attributes /= Void
	-- valid_attributes: attributes /= Void implies for all attributes: attribute.owner = Current

end
