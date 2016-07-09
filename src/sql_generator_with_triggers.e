note

	description:

		"SQL dialect which has support for triggers. Used to implement init [default]"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"


deferred class

	SQL_GENERATOR_WITH_TRIGGERS


inherit

	SQL_GENERATOR
		redefine
			sqlcolumnrequired_base,
			sqlcolumnrequired_type
		end


feature -- init [default] options

	ChecksNullAfterTrigger: BOOLEAN
			-- Does this dialect check for nulls in columns after a
			-- trigger has been fired?
		once
			-- A proper dialect checks for nulls after the trigger has
			-- been fired.
			Result := True
		end


feature -- write

	write_init (type: XPLAIN_TYPE)
		do
			if init_necessary (type) then
				create_init (type)
			end
		end


feature -- create

	create_init (type: XPLAIN_TYPE)
			-- Generate sql code to give attributes of type a default value.
		require
			valid_type: type /= Void
			there_are_inits: -- at least one attribute of type has init /= Void
		deferred
		end


feature -- generation of init [default] expressions

	init_forced_default (an_attribute: XPLAIN_ATTRIBUTE): BOOLEAN
			-- Does this attribute have an init that has to be converted
			-- to a after-insert style trigger?
			-- In that case the column should either be optional or there
			-- should be a default, because the trigger is only called if
			-- the constraints are satisfied.
		do
			Result :=
				not ChecksNullAfterTrigger and then
				attached an_attribute.init as init and then
				not an_attribute.is_init_default and then
				not init.is_constant and then
				(not ExpressionsInDefaultClauseSupported or else not init.is_literal)
		end

	init_forced_null (an_attribute: XPLAIN_ATTRIBUTE): BOOLEAN
			-- Does this attribute have a init default that has to be
			-- converted to a after-insert style trigger?
			-- To be able to distinguish if a user has supplied a value,
			-- the column must allow nulls if triggers are used because
			-- most dialects check null status before the trigger is
			-- activiated and will raise an error.
			-- Override this feature for dialects that do it properly and
			-- check null status after the trigger has been fired.
		do
			Result :=
				not ChecksNullAfterTrigger and then
				attached an_attribute.init as init and then
				an_attribute.is_init_default and then
				not init.is_constant and then
				(not ExpressionsInDefaultClauseSupported or else not init.is_literal)
		end

	sql_init_expression (an_attribute: XPLAIN_ATTRIBUTE): STRING
			-- SQL code that initialises a single column and takes care
			-- if the init is a default or not
		require
			an_attribute_not_void: an_attribute /=  Void
			attribute_has_init: attached an_attribute.init
		do
			create Result.make (64)
			if CoalesceSupported and then attached SQLCoalesce as coalesce then
				if an_attribute.is_init_default then
					Result.append_string (format ("$s(new.$s, ", <<coalesce, an_attribute.q_sql_select_name (Current)>>))
				end
			end
			Tab.append_string ("  ")
			if attached an_attribute.init as init then
				Result.append_string (init.sqlinitvalue (Current))
			end
			Tab.remove_tail (2)
			if CoalesceSupported then
				if an_attribute.is_init_default then
					Result.append_character (')')
				end
			end
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_init_infix_expression (a_left: XPLAIN_EXPRESSION; an_operator: STRING; a_right: XPLAIN_EXPRESSION): STRING
			-- SQL expression for multiplication/division, etc when used
			-- in an init expression. Most SQL dialects want to see
			-- special code when referencing attributes for example,
			-- i.e. prefixed with "new.".
		require
			valid_left: a_left /= Void
			valid_right: a_right /= Void
			operator_not_empty: an_operator /= Void and then not an_operator.is_empty
		local
			left_value,
			right_value: STRING
sql_operator: STRING
		do
			left_value := a_left.sqlinitvalue (Current)
			right_value := a_right.sqlinitvalue (Current)
			sql_operator := an_operator
			create Result.make (2 + left_value.count + 1 + sql_operator.count + 1 + right_value.count + 2)
			Result.append_character ('(')
			Result.append_string (left_value)
			Result.append_character (' ')
			Result.append_string (sql_operator)
			Result.append_character (' ')
			Result.append_string (right_value)
			Result.append_character (')')
		ensure
			sql_infix_expression_not_empty: Result /= Void and then not Result.is_empty
		end

	sqlinitvalue_attribute (expression: XPLAIN_ATTRIBUTE_EXPRESSION): STRING
			-- SQL to select the new value of attribute (singleton
			-- select); Most dialects treat selecting columns of a just
			-- inserted row specially, they want to see it prefixed by
			-- "new." for example. Also walking an its chain usually
			-- requires a subselect clause.
			-- This SQL can appear inside an expression (init sales its
			-- discount = price * 0.10 for example).
		require
			expression_not_void: expression /= Void
		local
			join_list: JOIN_LIST
		do
			create Result.make (128)
			-- try to minimize the need to create singleton selects
			if expression.first.next = Void then
				Result.append_string (new_row_prefix + expression.first.item.q_sql_select_name (Current))
			else
				-- Result := sql_singleton_select (expression)
				-- create a (select .. from .. where ..)

				-- We make sure that the join list starts with the
				-- attribute and doesn't join from `type' because its rows
				-- are not yet visible.
				create join_list.make (expression.first.item.type)
				join_list.extend (Current, expression.first.next)
				join_list.finalize (Current)
				Result.append_string ("(select ")
				Result.append_string (expression.sqlvalue (Current))
				Result.append_string (" from ")
				Result.append_string (join_list.base_aggregate.quoted_name (Current))
				if join_list.first = Void then
					Result.append_character ('%N')
					Result.append_string (Tab)
					Result.append_string ("where%N")
				else
					Result.append_character (' ')
					Result.append_string (sql_select_joins (join_list))
					Result.append_character ('%N')
					Result.append_string (Tab)
					Result.append_string (Tab)
					Result.append_string ("and%N")
				end
				Result.append_string (Tab)
				Result.append_string (Tab)
				Result.append_character ('(')
				Result.append_string (join_list.base_aggregate.quoted_name (Current))
				Result.append_character ('.')
				Result.append_string (quote_identifier(join_list.base_aggregate.sqlpkname (Current)))
				Result.append_string (" = ")
				Result.append_string (new_row_prefix)
				Result.append_string (expression.first.item.q_sql_select_name (Current))
				Result.append_string ("))")
			end
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sqlinitvalue_if (expression: XPLAIN_IF_EXPRESSION): STRING
			-- SQL code to emit if expression is an if-then-else statement.
		do
			Result := "case when " + expression.condition.sqlinitvalue (Current) + " then " + expression.then_specification.sqlinitvalue (Current) + " else " + expression.else_specification.sqlinitvalue (Current) + " end"
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	sql_init_combine_expression (a_list: XPLAIN_EXPRESSION_NODE): STRING
			-- SQL expression to combine strings in an init expression
		require
			list_not_empty: a_list /= Void
		local
			n: detachable XPLAIN_EXPRESSION_NODE
		do
			create Result.make (64)
			Result.append_string (sql_string_combine_start)
			from
				n := a_list
			until
				n = Void
			loop
				Result.append_string (n.item.sqlinitvalue (Current))
				n := n.next
				if n /= Void then
					Result.append_string (sql_string_combine_separator)
				end
			end
			Result.append_string (sql_string_combine_end)
		ensure
			sql_combine_expression_not_empty: Result /= Void and then not Result.is_empty
		end

	new_row_prefix: STRING
			-- Prefix to access new rows in a trigger
		once
			Result := "new."
		end


feature -- Cast expressions

	sql_init_cast_to_date (an_expression: XPLAIN_EXPRESSION): STRING
			-- SQL expression to cast `an_expression' to a date
		do
			Result := do_sql_cast_to_date (an_expression.sqlinitvalue (Current))
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_init_cast_to_integer (an_expression: XPLAIN_EXPRESSION): STRING
			-- SQL expression to cast `an_expression' to an integer
		do
			Result := do_sql_cast_to_integer (an_expression.sqlinitvalue (Current))
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_init_cast_to_real (an_expression: XPLAIN_EXPRESSION): STRING
			-- SQL expression to cast `an_expression' to a real
		do
			Result := do_sql_cast_to_real (an_expression.sqlinitvalue (Current))
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_init_cast_to_string (an_expression: XPLAIN_EXPRESSION): STRING
			-- SQL expression to cast `an_expression' to a string
		do
			Result := do_sql_cast_to_string (an_expression.sqlinitvalue (Current))
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end


feature -- generate columns either base or type columns

	sqlcolumnrequired_base (an_attribute: XPLAIN_ATTRIBUTE): READABLE_STRING_GENERAL
			-- Produce null or not null status of a column that is a base
		do
			if init_forced_null (an_attribute) then
				Result := column_null_or_not_null (False)
			else
				Result := precursor (an_attribute)
			end
		end

	sqlcolumnrequired_type (an_attribute: XPLAIN_ATTRIBUTE): READABLE_STRING_GENERAL
			-- Produce null or not null status of a column that refers to a type
		do
			if init_forced_null (an_attribute) then
				Result := column_null_or_not_null (False)
			else
				Result := precursor (an_attribute)
			end
		end


end
