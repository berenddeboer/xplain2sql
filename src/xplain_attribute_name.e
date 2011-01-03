indexing

	description:

		"Describes Xplain names or its lists of Xplain names.%
		%A name can be a base or type optionally prefixed by a role, or a%
		%variable, value or extension.%
		%During parsing a name or list of names (role, name) is build and at%
		%a later time augmented with type info."

	author:		"Berend de Boer <berend@pobox.com>"
	copyright:	"Copyright (c) 1999, Berend de Boer"
	date:			"$Date: 2008/12/15 $"
	revision:	"$Revision: #10 $"


class

	XPLAIN_ATTRIBUTE_NAME

inherit

	ANY
		redefine
			is_equal
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		redefine
			is_equal
		end


create

	make,
	make_from_attribute


feature {NONE} -- Initialization

	make (a_role, a_name: STRING) is
			-- Make with name, attribute not yet known. Don't forget to
			-- call `set_attribute' later.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
			role_void_or_not_empty: a_role = Void or else not a_role.is_empty
		do
			role := a_role
			name := a_name
		end

	make_from_attribute (an_attribute: XPLAIN_ATTRIBUTE) is
			-- Make with given `an_attribute'.
		require
			attribute_not_void: an_attribute /= Void
			atttribute_is_resolved: an_attribute.abstracttype /= Void
		do
			name := an_attribute.name
			role := an_attribute.role
			set_attribute (an_attribute)
		ensure
			attribute_set: type_attribute = an_attribute
		end


feature -- Access

	role: STRING

	name: STRING

	full_name: STRING is
			-- `role'_`name'
		do
			if role = Void then
				Result := name
			else
				Result := role.twin
				Result.append_character ('_')
				Result.append_string (name)
			end
		end


feature -- Change

	set_role (a_role: STRING) is
		do
			role := a_role
		ensure
			definition: role = a_role or else STRING_.same_string (role, a_role)
		end


feature -- Equality

	is_equal (other: like Current): BOOLEAN is
		do
			Result :=
				STRING_.same_string (other.name, name) and then
					((role = Void and other.role = Void) or else
					 (role /= Void and then other.role /= Void and then STRING_.same_string (other.role, role)))
		end


feature -- Type info

	type_attribute: XPLAIN_ATTRIBUTE
			-- Set when attribute of a type.

	object: XPLAIN_ABSTRACT_OBJECT
			-- base or type, this is the only one set when parsing a type
			-- statement. In that case the attribute is not yet known,
			-- because the type has not been created.

	set_attribute (an_attribute: XPLAIN_ATTRIBUTE) is
			-- Set `attribute' and `object' for cases where the actual
			-- attribute of the type is known.
		require
			attribute_not_void: an_attribute /= Void
			atttribute_is_resolved: an_attribute.abstracttype /= Void
		do
			type_attribute := an_attribute
			object := type_attribute.abstracttype
		ensure
			attribute_set: type_attribute = an_attribute
			object_set: object = an_attribute.abstracttype
		end

	set_object (a_object: XPLAIN_ABSTRACT_OBJECT) is
			-- Augment tree with type info.
		require
			valid_object: a_object /= Void
		do
			object := a_object
		ensure
			object_set: object = a_object
		end


feature -- Be more specific about type of attribute

	abstracttype: XPLAIN_ABSTRACT_TYPE is
		do
			Result ?= object
		ensure
			valid_base_or_type_or_extension: Result /= Void
		end

	abstractextension_if_known: XPLAIN_ABSTRACT_EXTENSION is
		do
			Result ?= object
		end

	abstracttype_if_known: XPLAIN_ABSTRACT_TYPE is
		do
			Result ?= object
		end

	type: XPLAIN_TYPE is
			-- `object' cast as Xplain type;
			-- `object' must denote a type.
		do
			Result ?= object
		ensure
			valid_type: Result /= Void
		end

	value: XPLAIN_VALUE is
		do
			Result ?= object
		ensure
			valid_value: Result /= Void
		end

	variable: XPLAIN_VARIABLE is
		do
			Result ?= object
		ensure
			valid_variable: Result /= Void
		end


feature -- for sql conversion

	sqlcolumnidentifier (sqlgenerator: SQL_GENERATOR): STRING is
			-- Name of column, type info must be available.
		require
			type_info_available: object /= Void
		do
			Result := abstracttype.sqlcolumnidentifier (sqlgenerator, role)
		end

	quoted_name	(sqlgenerator: SQL_GENERATOR): STRING is
			-- Return sqlcolumnidentifier, but quoted.
		require
			type_info_available: object /= Void
		do
			Result := sqlgenerator.quote_identifier (sqlcolumnidentifier (sqlgenerator))
		end

	q_sql_select_name (sqlgenerator: SQL_GENERATOR): STRING is
			-- Name to be used in select or order by statement. Should
			-- replace usage of `sqlcolumnidentifier'.
		require
			type_info_available: object /= Void
			is_abstracttype: abstracttype /= Void
		do
			Result := abstracttype.q_sql_select_name (sqlgenerator, role)
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end


invariant

	name_not_empty: name /= Void and then not name.is_empty
	role_void_or_not_empty: role = Void or else not role.is_empty
	attribute_and_object_in_sync: type_attribute /= Void implies type_attribute.abstracttype = object

end
