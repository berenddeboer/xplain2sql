note

	description: "Xplain abstract object, parent for base, type, value and such"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

deferred class

	XPLAIN_ABSTRACT_OBJECT

inherit

	HASHABLE


feature {NONE} -- Initialization

	make (a_name: STRING; a_representation: XPLAIN_REPRESENTATION)
		require
			valid_name: a_name /= Void and then not a_name.is_empty
			valid_representation: a_representation /= Void
		do
			name := a_name
			representation := a_representation
		end


feature -- Access

	hash_code: INTEGER
		do
			Result := name.hash_code
		end

	name: STRING
			-- Name of this object

	representation: XPLAIN_REPRESENTATION
			-- Domain


feature -- Status

	may_be_redefined: BOOLEAN
			-- Can an object of this type be redefined?
			-- Most objects can be defined just once, such as types, but
			-- values can be given a new definition.
		do
			Result := False
		end


feature -- Expression builder support

	create_expression (node: XPLAIN_ATTRIBUTE_NAME_NODE): detachable XPLAIN_EXPRESSION
			-- Suitable expression for attribute/variable/value/extension
		deferred
		end


feature -- Names

	sqlname (sqlgenerator: SQL_GENERATOR): STRING
			-- Name as known in sql code;
			-- to be overriden, callback into sqlgenerator.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		deferred
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	quoted_name (sqlgenerator: SQL_GENERATOR): STRING
			-- As `sqlname', but quoted (i.e. with double quotes for
			-- example)
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		do
			Result := sqlgenerator.quote_identifier (sqlname (sqlgenerator))
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Drop statement

	write_drop (sqlgenerator: SQL_GENERATOR)
			-- switch into correct sql drop statement
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		deferred
		end


invariant

	name_not_empty: name /= Void and then not name.is_empty
	representation_not_void: representation /= Void

end
