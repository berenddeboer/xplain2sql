indexing

	description:

		"Describes an Xplain extension.%
		%An extension has two faces: a build-face when the extension%
		%is calculated, and a use-face where it is used."
	author:		"Berend de Boer <berend@pobox.com>"
	copyright:	"Copyright (c) 1999, Berend de Boer"
	date:			"$Date: 2010/02/11 $"
	revision:	"$Revision: #12 $"

class

	XPLAIN_EXTENSION

inherit

	XPLAIN_ABSTRACT_EXTENSION
		rename
			make as make_abstract_extension,
			representation as abstract_extension_representation
		undefine
			create_expression,
			quoted_name,
			sql_insert_name,
			sql_select_name
		redefine
			sql_alias
		end

	XPLAIN_TYPE
		rename
			make as make_type
		undefine
			hack_anode
		redefine
			create_expression,
			write_drop,
			sqlcolumnidentifier,
			columndatatype,
			sqlcolumnrequired,
			sqlpkname,
			sqlname,
			quoted_name,
			sql_insert_name,
			sql_select_name
		select
			abstract_representation,
			make_abstract_type
		end


create

	make


feature {NONE} -- Initialization

	make (sqlgenerator: SQL_GENERATOR; a_type: XPLAIN_TYPE; an_attribute: XPLAIN_EXTEND_ATTRIBUTE; a_expression: XPLAIN_EXTENSION_EXPRESSION) is
			-- Extend `a_type' with attribute `aname' using expression
			-- `aexpression'
		require
			valid_args:
				an_attribute /= Void and
				a_type /= Void and
				a_expression /= Void
		local
			r: XPLAIN_REPRESENTATION
		do
			type := a_type
			expression := a_expression

			-- We don't use `attributes' here, but the invariant is for
			-- it to be non-void, because that makes other routines
			-- easier.
			-- Perhaps XPLAIN_EXTENSION must inherit from
			-- XPLAIN_ABSTRACT_TYPE instead of XPLAIN_TYPE??
			create  attributes.make
			-- use abstract_representation when seen as base
			if an_attribute.domain = Void then
				r := expression.representation (sqlgenerator)
			else
				r := an_attribute.domain
			end
			make_abstract_type (an_attribute.name, r)
			-- use representation when seen as type
			representation := type.representation
			expression.set_extension (Current, OuterTableName)
			type.add_extension (Current)
		ensure
			type_set: type = a_type
		end

	OuterTableName: STRING is "access_type"


feature -- Expression builder support

	create_expression (node: XPLAIN_ATTRIBUTE_NAME_NODE): XPLAIN_EXPRESSION is
			-- Return a new suitable expression for extension.
			-- Note that the property expression is only valid to build this
			-- extension. When the extension itself is used in an expression,
			-- we need a new expression object.
		do
			create {XPLAIN_EXTENSION_EXPRESSION} Result.make (Current, node)
		end


feature -- Access

	columndatatype (mygenerator: ABSTRACT_GENERATOR): STRING is
			-- Representation when used as base.
		do
			Result := abstract_representation.datatype (mygenerator)
		end

	sqlcolumnidentifier (sqlgenerator: SQL_GENERATOR; role: STRING): STRING is
			-- return name used for joins
		do
			Result := sqlpkname (sqlgenerator)
		end

	sqlcolumnrequired (sqlgenerator: SQL_GENERATOR; attribute: XPLAIN_ATTRIBUTE): STRING is
		do
			Result := Void -- not applicable
		end

	sql_qualified_name (sqlgenerator: SQL_GENERATOR; prefix_override: STRING): STRING is
			-- Extension specific column name used in subselects
		local
			function: XPLAIN_EXTENSION_FUNCTION_EXPRESSION
		do
			if prefix_override = Void then
				Result := sqlgenerator.quote_identifier (sqlname (sqlgenerator)).twin
			else
				Result := sqlgenerator.quote_identifier (prefix_override).twin
			end
			Result.append_character ('.')
			Result.append_string (q_sql_select_name (sqlgenerator, Void))
			if no_update_optimization then
					check
						supported: sqlgenerator.CoalesceSupported
						left_outer_join_supported: True
					end
				function ?= expression
				if function /= Void then
					Result := sqlgenerator.SQLCoalesce + once "(" + Result + once ", " + function.selection.function.sqlextenddefault (sqlgenerator, function.selection.property) + once ")"
				else
					Result := sqlgenerator.SQLCoalesce + once "(" + Result + once ", " + sqlgenerator.SQLFalse + once ")"
				end
			end
		end

	sql_alias (sqlgenerator: SQL_GENERATOR): STRING is
			-- Used in `do_do_create_select_list' if output comes from an
			-- optimised extension and therefore doesn't have a nice
			-- colum name. With this the column name can be forced even
			-- if the user doesn't specify " as ".
			-- Void if not applicable.
		do
			if no_update_optimization then
				Result := sql_select_name (sqlgenerator, Void)
			end
		end


feature -- SQL code

	sql_insert_name (sqlgenerator: SQL_GENERATOR; role: STRING): STRING is
			-- Name of base/type/extension when used in an update statement.
		do
			Result := sqlgenerator.make_valid_identifier (name)
		end

	sql_select_name (sqlgenerator: SQL_GENERATOR; role: STRING): STRING is
			-- Name of base/type/extension when used in a select or order
			-- by statement.
			-- Note that it probably needs to be prefixed by its
			-- temporary table.
		do
			Result := sqlgenerator.make_valid_identifier (name)
		end

	sqlname (sqlgenerator: SQL_GENERATOR): STRING is
			-- Name of table (view?) where extension is stored
		do
			Result := sqlgenerator.extension_name (Current)
		end

	sqlpkname (sqlgenerator: SQL_GENERATOR): STRING is
			-- Primary key column name of this type
		do
			Result := type.sqlpkname (sqlgenerator)
		end

	quoted_name (sqlgenerator: SQL_GENERATOR): STRING is
			-- As `sqlname', but quoted (i.e. with double quotes for example)
			-- quoted here is different from `sqlname', bad fix
		do
			Result :=
				sqlgenerator.TemporaryTablePrefix +
				sqlgenerator.quote_identifier (sqlname (sqlgenerator))
		end


feature -- purge extension

	write_drop (sqlgenerator: SQL_GENERATOR) is
		do
			-- can we drop an extension??
			-- sqlgenerator.drop_extension (Current)
		end


invariant

	-- this is only true when this statement has been executed, not for
	-- example when it's in a procedure and it's effect has been
	-- undone:
	--type_has_extension: type.has_attribute (Void, name)

end
