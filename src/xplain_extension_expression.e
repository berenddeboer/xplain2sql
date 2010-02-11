indexing

	description:

		"Extension expression. Extensions have two faces.%
		%One face is during building extensions, that's done by the %
		%specializations. This one is used when using the extension."

	be_carefull: "[
		This class itself is used when a defined, completed
		extension is used in an expression (created in
		XPLAIN_EXTENSION.create_expression, called when building
		property expressions). Perhaps too cute a trick?
]"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #14 $"


class

	XPLAIN_EXTENSION_EXPRESSION


inherit

	XPLAIN_EXPRESSION
		redefine
			add_to_join,
			column_name,
			is_logical_expression,
			is_using_other_attributes,
			sqlname,
			sql_alias
		end


create

	make


feature {NONE} -- Initialization

	make (an_extension: XPLAIN_ABSTRACT_EXTENSION; an_anode: XPLAIN_ATTRIBUTE_NAME_NODE) is
			-- Extension.
		require
			extension_not_void: an_extension /= Void
			an_anode_not_void: an_anode /= Void
		do
			extension := an_extension
			anode := an_anode
			extension.hack_anode (anode)
		end


feature -- Access

	column_name: STRING is
			-- The Xplain based column heading name, if any. It is used
			-- by XML_GENERATOR to give clients some idea what the column
			-- name of a select is going to be.
		do
			Result := extension.name
		end

	extension: XPLAIN_ABSTRACT_EXTENSION
			-- Extension;
			-- Can be Void in certain cases (when expression is build).

	anode: XPLAIN_ATTRIBUTE_NAME_NODE
			-- The way (its list) this extension was derived


feature -- Status

	is_logical_expression: BOOLEAN is
		local
			b: XPLAIN_B_REPRESENTATION
		do
			b ?= extension.representation
			Result := b /= Void
		end

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		do
			-- Hmm, were is my invariant that anode.next.next exists???
			Result :=
				anode.next.next /= Void or else
				not anode.item.is_equal (an_attribute)
		end

	is_update_optimization_supported: BOOLEAN is
			-- Is this an extension that will benefit from optimized
			-- output in case it is not used in updates?
		do
			Result := False
		end

	uses_non_data_attributes: BOOLEAN is
			-- Does this extension expression use attributes of its owner
			-- that are other assertions or does it use an its list?
		do
			Result := True
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			-- not applicable here, overriden by descendants
		end


feature -- SQL specifics

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST) is
			-- Make sure the its list leading to this extension is
			-- present as join.
		do
				check
					valid_extension: extension /= Void
				end
			join_list.extend (sqlgenerator, anode)
		end

	set_extension (
		an_extension: XPLAIN_ABSTRACT_EXTENSION;
		an_outer_table_name: STRING) is
			-- Set extension when build (during parsing expression is
			-- build first).
		require
			extension_not_void: an_extension /= Void
			outer_table_not_empty: an_outer_table_name /= Void and then not an_outer_table_name.is_empty
		do
			extension := an_extension
		ensure
			extension_set: extension = an_extension
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- The correct representation for this expression.
			-- Note that this feature is only called when this class is
			-- instantiated because an extension has been used in an expression.
		do
			Result := extension.expression.representation (sqlgenerator)
		end

	sqlfromaliasname: STRING is
			-- Joining with extension table/view requires an outer join
			-- name, but when building a function extension only.
		do
			Result := ""
		end

	sqlname (sqlgenerator: SQL_GENERATOR): STRING is
			-- Try to come up with the most likely column name for this
			-- extension.
		do
			Result := extension.sql_select_name (sqlgenerator, Void)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING is
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- attributes of the type it has to be prefixed by "new." for
			-- example.
		do
			-- Probably not applicable
			Result := sqlvalue (sqlgenerator)
		end

	sqlselect (sqlgenerator: SQL_GENERATOR; an_extension: XPLAIN_ABSTRACT_EXTENSION): STRING is
			-- SQL for the full select statement that emits the data used
			-- to create extension.
			-- `an_extension' is not Void if this sqlselect is for an extension.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		do
			-- Not applicable here, but used in descendants.
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Extension when used in get/value statement. Name includes
			-- prefix of table if we have such a prefix.
		do
				check
					valid_extension: extension /= Void
					have_anode: anode /= Void
					anode_has_one_more_item: anode.next /= Void
					-- have_prefix is only true when there were joins, for updates this doesn't hold true.
					-- have_prefix: anode.last.prefix_table /= Void and then not anode.last.prefix_table.is_empty
				end
			if sqlgenerator.InUpdateStatement then
				Result := sqlgenerator.sql_subselect_for_extension (extension)
			else
				Result := extension.sql_qualified_name (sqlgenerator, anode.last.prefix_table)
			end
		end

	sql_alias (sqlgenerator: SQL_GENERATOR): STRING is
			-- Used in `do_do_create_select_list' if output comes from an
			-- optimised extension and therefore doesn't have a nice
			-- colum name. With this the column name can be forced even
			-- if the user doesn't specify " as ".
			-- Void if not applicable.
		do
			Result := extension.sql_alias (sqlgenerator)
		end


end
