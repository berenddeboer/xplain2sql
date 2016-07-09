note

	description:

		"[
Extension expression. Extensions have two faces.
One face is during building extensions, that's done by the two
specializations of this class. This one is used when using the extension.
]"

	be_carefull: "[
		This class itself is used when a defined, completed
		extension is used in an expression (created in
		XPLAIN_EXTENSION.create_expression, called when building
		property expressions). Perhaps too cute a trick?
]"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"


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

	make (an_extension: XPLAIN_ABSTRACT_EXTENSION; an_anode: XPLAIN_ATTRIBUTE_NAME_NODE)
			-- Extension.
		require
			extension_not_void: an_extension /= Void
			an_anode_not_void: an_anode /= Void
		do
			extension := an_extension
			anode := an_anode
			an_extension.hack_anode (an_anode)
		end


feature -- Access

	column_name: detachable STRING
			-- The Xplain based column heading name, if any. It is used
			-- by XML_GENERATOR to give clients some idea what the column
			-- name of a select is going to be.
		do
			if attached extension as e then
				Result := e.name
			end
		end

	extension: detachable XPLAIN_ABSTRACT_EXTENSION
			-- Extension;
			-- Can be Void in certain cases (when expression is build);
			-- Has to detachable for child classes such as XPLAIN_EXTENSION_EXPRESSION_EXPRESSION

	anode: detachable XPLAIN_ATTRIBUTE_NAME_NODE
			-- The way (its list) this extension was derived;
			-- Has to detachable for child classes such as XPLAIN_EXTENSION_EXPRESSION_EXPRESSION


feature -- Status

	is_logical_expression: BOOLEAN
			-- Is this a logical expression?
		do
			if attached extension as e and then attached {XPLAIN_B_REPRESENTATION} e.representation then
				Result := True
			end
		end

	is_nil_expression: BOOLEAN
			-- Is this expression based on the nil function?
			-- All other expressions evaluate to true when stored in a
			-- temporary, except the nil expression, which stores
			-- False. That wrecks havoc with the logical expression
			-- optimisation, so we need to detect that case.
		do
			Result := False
		end

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		do
			-- Hmm, were is my invariant that anode.next.next exists???
			Result :=
				(attached anode as n and then
				 attached n.next as next and then
				 attached next.next) or else
				(attached anode as n and then not n.item.is_equal (an_attribute))
		end

	is_update_optimization_supported: BOOLEAN
			-- Is this an extension that will benefit from optimized
			-- output in case it is not used in updates?
		do
			Result := False
		end

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			-- not applicable here, overriden by descendants
		end

	uses_non_data_attributes: BOOLEAN
			-- Does this extension expression use attributes of its owner
			-- that are other assertions or does it use an its list?
		do
			Result := True
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			-- not applicable here, overriden by descendants
		end


feature -- SQL specifics

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST)
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
		an_outer_table_name: STRING)
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

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- The correct representation for this expression.
			-- Note that this feature is only called when this class is
			-- instantiated because an extension has been used in an expression.
		do
			check attached extension as e then
				Result := e.expression.representation (sqlgenerator)
			end
		end

	sqlfromaliasname: STRING
			-- Joining with extension table/view requires an outer join
			-- name, but when building a function extension only.
		do
			Result := ""
		end

	sqlname (sqlgenerator: SQL_GENERATOR): detachable STRING
			-- Try to come up with the most likely column name for this
			-- extension.
		do
			if attached extension as e then
				Result := e.sql_select_name (sqlgenerator, Void)
			end
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- attributes of the type it has to be prefixed by "new." for
			-- example.
		do
			-- Probably not applicable
			Result := sqlvalue (sqlgenerator)
		end

	sqlselect (sqlgenerator: SQL_GENERATOR; an_extension: XPLAIN_ABSTRACT_EXTENSION): STRING
			-- SQL for the full select statement that emits the data used
			-- to create extension.
			-- `an_extension' is not Void if this sqlselect is for an extension.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		do
			-- Not applicable here, but used in descendants.
			Result := ""
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Extension when used in get/value statement. Name includes
			-- prefix of table if we have such a prefix.
		do
			check attached extension as e and then attached anode as n and then attached n.last as last then
				-- have_prefix is only true when there were joins, for updates this doesn't hold true.
				-- have_prefix: anode.last.prefix_table /= Void and then not anode.last.prefix_table.is_empty
				if sqlgenerator.InUpdateStatement then
					Result := sqlgenerator.sql_subselect_for_extension (e)
				else
					Result := e.sql_qualified_name (sqlgenerator, last.prefix_table)
				end
			end
		end

	sql_alias (sqlgenerator: SQL_GENERATOR): detachable STRING
			-- Used in `do_do_create_select_list' if output comes from an
			-- optimised extension and therefore doesn't have a nice
			-- colum name. With this the column name can be forced even
			-- if the user doesn't specify " as ".
			-- Void if not applicable.
		do
			if attached extension as e then
				Result := e.sql_alias (sqlgenerator)
			end
		end


end
