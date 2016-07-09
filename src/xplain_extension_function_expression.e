note

	description: "Set function extension expression."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"


class

	XPLAIN_EXTENSION_FUNCTION_EXPRESSION

inherit

	XPLAIN_EXTENSION_EXPRESSION
		rename
			make as inherited_make
		redefine
			add_to_join,
			is_nil_expression,
			is_update_optimization_supported,
			representation,
			set_extension,
			sqlfromaliasname,
			sqlselect,
			sqlvalue,
			uses_parameter
		end

create

	make


feature {NONE} -- Initialization

	make (
			a_selection: XPLAIN_SELECTION_FUNCTION;
			a_per_property: XPLAIN_ATTRIBUTE_NAME_NODE)
		require
			selection_not_void: a_selection /= Void
			per_property_not_void: a_per_property /= Void
			void_safe_seems_to_suggest_we_need_last: attached a_per_property.last
		do
			selection := a_selection
			per_property := a_per_property
			sqlfromaliasname := ""
		end


feature -- Access

	per_property: XPLAIN_ATTRIBUTE_NAME_NODE
	selection: XPLAIN_SELECTION_FUNCTION


feature -- Status

	is_nil_expression: BOOLEAN
			-- Is this expression based on the nil function?
			-- All other expressions evaluate to true when stored in a
			-- temporary, except the nil expression, which stores
			-- False. That wrecks havoc with the logical expression
			-- optimisation, so we need to detect that case.
		do
			Result := selection.function.is_nil
		end

	is_update_optimization_supported: BOOLEAN
			-- Is this an extension that will benefit from optimized
			-- output in case it is not used in updates?
		do
			Result := supports_left_outer_join
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result := selection.uses_parameter (a_parameter)
		end


feature -- SQL generation

	set_extension (
		an_extension: XPLAIN_ABSTRACT_EXTENSION;
		an_outer_table_name: STRING)
			-- A `per_property' is nothing more than a where statement.
			-- Build it now we know the expression to which we're tied.
			-- Make sure to retain the original predicate.
		local
			predicate: XPLAIN_INFIX_EXPRESSION
			left_operand,
			right_operand: XPLAIN_ATTRIBUTE_EXPRESSION
			access_type: XPLAIN_ATTRIBUTE_NAME
			access_type_node: XPLAIN_ATTRIBUTE_NAME_NODE
			parenthesis: XPLAIN_PARENTHESIS_EXPRESSION
		do
			precursor (an_extension, an_outer_table_name)
			if not supports_left_outer_join and then attached extension as e then
				sqlfromaliasname := an_outer_table_name
				create left_operand.make (per_property)
				create access_type.make (Void, an_extension.name)
				access_type.set_object (e)
				create access_type_node.make (access_type, Void)
				create right_operand.make (access_type_node)
				right_operand.first.set_prefix_table (an_outer_table_name)
				create predicate.make (left_operand, "=", right_operand)
				if attached selection.predicate as p then
					create parenthesis.make (p)
					create predicate.make (predicate, "and", parenthesis)
				end
				selection.set_predicate (predicate)
			end
		ensure then
			sqlfromaliasname_set: not supports_left_outer_join implies sqlfromaliasname /= Void
		end

	sqlfromaliasname: STRING
			-- Alias to use when generating the function SQL using a
			-- subselect

feature

	add_to_join (sqlgenerator: SQL_GENERATOR; a_join_list: JOIN_LIST)
		do
			if supports_left_outer_join and then attached extension as e then
				a_join_list.add_join_to_aggregate (sqlgenerator, per_property, selection, not e.no_update_optimization)
			else
				-- During creation of extension we have nothing to do.
				-- Everything is described in `selection'.
			end
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- Representation for this expression
		do
			Result := selection.function.representation (sqlgenerator, selection.type, selection.property)
		end

	sqlselect (sqlgenerator: SQL_GENERATOR; an_extension: XPLAIN_ABSTRACT_EXTENSION): STRING
			-- SQL for the full select statement that emits the data used
			-- to create extension.
		do
				check
					extension_not_void: an_extension /= Void
				end
			Result := sqlgenerator.sql_select_for_extension_function (Current, an_extension)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- SQL code to create this extension expression;
			-- Not suitable when using this extension.
		require else
			predicate_build: selection.predicate /= Void
		do
			Result  := sqlgenerator.sql_extension_function (Current)
		end

	supports_left_outer_join: BOOLEAN
			-- Does this expression support being written as a left outer
			-- join instead of a subselect? Left outer joins are faster
			-- with most optimizers.
		do
			if not selection.function.is_some then
				Result := True
			else
				-- The some function can use a left outer join if it returns
				-- max 1 row.
				Result := attached selection.predicate as predicate and then predicate.selects_max_one_row
			end
		end


invariant

	has_per_property: per_property /= Void
	has_selection: selection /= Void

end
