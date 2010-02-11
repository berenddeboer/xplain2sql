indexing

	description: "Describes a single join statement"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"


class

	JOIN

create

	make


feature {NONE} -- Initialization

	make (
		an_actual_attribute: XPLAIN_ATTRIBUTE;
		aattribute: XPLAIN_TYPE; aattribute_alias_name: STRING
		aaggregate: XPLAIN_TYPE; aaggregate_alias_name: STRING
		aaggregate_fk: STRING;
		an_is_upward_join,
		an_is_forced_left_outer_join: BOOLEAN) is
				-- Initialize.
		require
			an_actual_attribute_not_void: an_actual_attribute /= Void
			need_attribute: aattribute /= Void
			type_of_actual_attribute: an_actual_attribute.abstracttype = aattribute
			need_attribute_alias: aattribute_alias_name /= Void and then not aattribute_alias_name.is_empty
			need_aggregate: aaggregate /= Void
			need_aggregate_alias: aaggregate_alias_name /= Void and then not aaggregate_alias_name.is_empty
			join_different_tables: not aattribute_alias_name.is_equal (aaggregate_alias_name)
		do
			actual_attribute := an_actual_attribute
			attribute := aattribute
			attribute_alias_name := aattribute_alias_name
			aggregate := aaggregate
			aggregate_alias_name := aaggregate_alias_name
			aggregate_fk := aaggregate_fk
			is_upward_join := an_is_upward_join
			is_forced_left_outer_join := an_is_forced_left_outer_join
		end

feature -- SQL code

	attribute_table_name (sqlgenerator: SQL_GENERATOR): STRING is
			-- SQL table name of attribute type
		do
			Result := attribute.sqltablename (sqlgenerator)
		ensure
			have_table_name: Result /= Void and then not Result.is_empty
		end

	attribute_pk (sqlgenerator: SQL_GENERATOR): STRING is
			-- Primary key of attribute type
		do
			Result := attribute.sqlpkname (sqlgenerator)
		ensure
			have_pk: Result /= Void and then not Result.is_empty
		end


feature -- Access

	actual_attribute: XPLAIN_ATTRIBUTE
			-- The attribute in `aggregate' that is `attribute'

	attribute: XPLAIN_TYPE
			-- Resolved attribute of `aggregate'

	attribute_alias_name: STRING
	aggregate: XPLAIN_TYPE
			-- The container type

	aggregate_alias_name: STRING
	aggregate_fk: STRING


feature -- Status

	is_inner_join: BOOLEAN is
			-- Generate an inner join?
		do
			Result :=
				not is_forced_left_outer_join and then
				actual_attribute.is_required
		end

	is_forced_left_outer_join: BOOLEAN
			-- Is left outer join forced?

	is_upward_join: BOOLEAN
			-- Is join actually upward instead of the usual downward?


invariant

	has_alias: attribute_alias_name /= Void and then not attribute_alias_name.is_empty
	has_aggregate_alias: aggregate_alias_name /= Void and then not aggregate_alias_name.is_empty
	join_different_tables: not attribute_alias_name.is_equal (aggregate_alias_name)
	have_aggregate_foreign_key: aggregate_fk /= Void and then not aggregate_fk.is_empty
	has_attribute: attribute /= Void
	has_aggregate: aggregate /= Void

end
