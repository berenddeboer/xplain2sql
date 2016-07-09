note

	description: "Xplain underlying type. Specializes into a base, type%
	%virtual attribute or extension."
	author:		"Berend de Boer <berend@pobox.com>"


deferred class

	XPLAIN_ABSTRACT_TYPE

inherit

	XPLAIN_ABSTRACT_OBJECT


feature

	create_expression (node: XPLAIN_ATTRIBUTE_NAME_NODE): XPLAIN_EXPRESSION
			-- return suitable expression for attribute
		do
			create {XPLAIN_ATTRIBUTE_EXPRESSION} Result.make (node)
		end

	hack_anode (anode: XPLAIN_ATTRIBUTE_NAME_NODE)
			-- extensions must hack `anode' to add their extension table to
			-- the list. Perhaps there is a cleaner design, but that
			-- escapes me now.
		require
			have_anode: anode /= Void
		do
			-- nothing
		end


feature -- deferred ones, should call routine in ABSTRACT_GENERATOR

	columndatatype (mygenerator: ABSTRACT_GENERATOR): STRING
			-- data type of name/type
		deferred
		ensure
			valid_string: Result /= Void
		end


feature -- obsolete deferred ones, should call routine in SQL_GENERATOR

	sqlcolumnidentifier (sqlgenerator: SQL_GENERATOR; role: detachable STRING): STRING
			-- name of base/type when used as a column in a create table
			-- or select statement
		deferred
		ensure
			valid_string: Result /= Void
		end

	sqlcolumndefault (sqlgenerator: SQL_GENERATOR; an_attribute: XPLAIN_ATTRIBUTE): detachable STRING
			-- defaults at base/type level if any. Return Void if none
		deferred
		end

	sqlcolumnrequired (sqlgenerator: SQL_GENERATOR; an_attribute: XPLAIN_ATTRIBUTE): READABLE_STRING_GENERAL
			-- null or not null in create table statement. Return Void to
			-- use database default
		deferred
		end


feature -- new deferred ones, should call routine in SQL_GENERATOR

	q_sql_insert_name (sqlgenerator: SQL_GENERATOR; role: detachable STRING): STRING
			-- quoted variant of `sql_insert_name'
		require
			has_generator: sqlgenerator /= Void
		do
			Result := sqlgenerator.quote_identifier (sql_insert_name (sqlgenerator, role))
		ensure
			valid_string: Result /= Void
		end

	q_sql_select_name (sqlgenerator: SQL_GENERATOR; role: detachable STRING): STRING
			-- quoted variant of `sql_select_name'
		require
			has_generator: sqlgenerator /= Void
		do
			Result := sqlgenerator.quote_identifier (sql_select_name (sqlgenerator, role))
		ensure
			valid_string: Result /= Void
		end

	sql_insert_name (sqlgenerator: SQL_GENERATOR; role: detachable STRING): STRING
			-- Name of base/type/extension when used in an update statement.
		require
			has_generator: sqlgenerator /= Void
		do
			Result := sql_select_name (sqlgenerator, role)
		ensure
			valid_string: Result /= Void
		end

	sql_select_name (sqlgenerator: SQL_GENERATOR; role: detachable STRING): STRING
			-- Name of base/type/extension when used in a select or order
			-- by statement.
			-- Note that for a base you still will need to prefix it with
			-- its table alias.
		require
			has_generator: sqlgenerator /= Void
		do
			Result := sqlcolumnidentifier (sqlgenerator, role)
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_update_name (sqlgenerator: SQL_GENERATOR; role: detachable STRING): STRING
			-- Name of base/type/extension when used in an update statement.
		require
			has_generator: sqlgenerator /= Void
		do
			Result := sql_select_name (sqlgenerator, role)
		ensure
			valid_string: Result /= Void
		end

end
