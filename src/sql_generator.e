note

	description:

		"Called from xplain scanner and parser to produce SQL Output%
		%Is the most common denominator of all SQL Dialects%
		%(more or less ANSI-92).%
		%If necessary, can be overriden to support other RDBMS's.%
		%Use SQL_GENERATOR_ANSI to generate ANSI output"

	Known_bugs:
		"1. Identifier with spaces not always correctly handled.%
		%2. Datatype of character values is hardcoded to varchar(250).%
		%7. extend with min/max not always correct: should return maximum %
		%   value for extend data type, now does only 32-bit integers.%
		%8. inherited key support is weak. If inherited key, should skip column %
		%   that is inherited in inserts. Also insert/update sp generation%
		%   bad.%
		%9. asserts can only contain columns that are in table itself. Other%
		%   forms can be specified in Xplain, but are not supported. You get a%
		%   warning though.%
		%11. if a type has been extended, a get t does not output the%
		%    extend columns, you have to provide an explicit list of%
		%    attributes in that case."

	author:	"Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999-2014, Berend de Boer, see forum.txt"


deferred class

	SQL_GENERATOR


inherit

	ABSTRACT_GENERATOR
		redefine
			columndatatype_base,
			columndatatype_type,
			columndatatype_assertion
		end

	XPLAIN_UNIVERSE_ACCESSOR

	ST_FORMATTING_ROUTINES
		export
			{NONE} all;
			{ANY} valid_format_and_parameters
		end

	KL_SHARED_STANDARD_FILES
		export
			{NONE} all
		end

	KL_IMPORTED_STRING_ROUTINES


feature {NONE} -- Initialization

	make
		do
			-- domain options
			DomainsEnabled := True

			-- table options
			AttributeRequiredEnabled := True
			AutoPrimaryKeyEnabled := True
			SetDatabaseEnabled := True
			StoredProcedureEnabled := True
			IdentifierWithSpacesEnabled := True
			TimestampEnabled := False
			ViewsEnabled := False
			ExtendIndex := True

			create declared_values.make_equal (8)
		end


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		deferred
		ensure
			have_name: Result /= Void and then not Result.is_empty
		end

feature -- Text output options

	Tab: STRING = "  " -- a tab is 2 spaces

	TabTab: STRING
		once
			Result := Tab + Tab
		end


feature -- SQL Comments

	OneLineCommentPrefix: detachable STRING once Result := "--" end
	MultiLineCommentPrefix: STRING once Result := "/*" end
	MultiLineCommentPostfix: STRING once Result :=	"*/" end

	NoOneLineCommentsSupported: BOOLEAN
		once Result := OneLineCommentPrefix = Void end

feature -- Command separation

	CommandSeparator: STRING
		once
			Result := ";"
		ensure
			no_new_line_allowed: -- Result.index_of('%N') = 0
		end

feature -- Identifiers

	MaxConstraintIdentifierLength: INTEGER
		do
			Result := MaxIdentifierLength
		ensure
			max_identifier_length_positive: Result > 0
		end

	IdentifierWithSpacesSupported: BOOLEAN
			-- Are spaces allowed in names?
		once
			Result := False
		end

	IdentifierWithSpacesEnabled: BOOLEAN


feature -- Database options

	SetDatabaseEnabled: BOOLEAN
			-- Output code for Xplain's database command.


feature -- Domain options

	DomainsSupported: BOOLEAN
			-- Does this dialect support creation of user defined data types?
		once
			Result := True
		end

	DomainsEnabled: BOOLEAN

	CreateDomains: BOOLEAN
		once
			Result := DomainsSupported and DomainsEnabled
		end

	DomainCheckSupported: BOOLEAN
			-- can constraints be attached to domains
		once Result := True end

	CreateDomainCheck: BOOLEAN
			-- attach constraints to domain
		once
			Result := CreateDomains and DomainCheckSupported
		end

	DomainNullDefault: BOOLEAN once Result := False end
			-- return True if domains/UDT's are Null when nothing specified
	DomainNullAllowed: BOOLEAN once Result := True end
	DomainNotNullAllowed: BOOLEAN once Result	:= True end

	DomainNamePrefix: STRING once Result := "T" end


feature -- Table options

	AttributeRequiredEnabled: BOOLEAN
			-- Xplain requires a value for every attribute when
			-- inserting things. This means that every column is not
			-- null.
			-- When this option is False, every column may be Null.

	AutoPrimaryKeySupported: BOOLEAN
			-- Does this dialect support auto-generated primary keys?
		once
			Result := False
		end

	AutoPrimaryKeyEnabled: BOOLEAN
			-- Has user enabled creation of auto-generated primary keys?

	CreateAutoPrimaryKey: BOOLEAN
			-- Should auto-generated primary keys be created?
		once
			Result := AutoPrimaryKeySupported and AutoPrimaryKeyEnabled
		end

	ExpressionsInDefaultClauseSupported: BOOLEAN
			-- Does the SQL dialect support expressions (1 + 1 for
			-- example) in the default clause?
			-- MySQL 5 is an example of a database that doesn't.
		once
			Result := True
		end

	PrimaryKeyConstraint: STRING
		once
			Result := "not null primary key"
		end

	AutoPrimaryKeyConstraint: STRING
			-- The SQL that enables an autoincrementing primary key
		once
			Result := PrimaryKeyConstraint
		end

	sequence_name_format: STRING = "$s_$s_seq"
			-- Format of name of generated sequence if a dialect has the
			-- concept of sequences and names for sequences

	sequence_name_format_one_parameter: BOOLEAN
			-- Does `sequence_name_format' take just the primary key
			-- column name as parameter?

	ConstraintNameSupported: BOOLEAN
		once
			Result := True
		end

	CheckConstraintSupported: BOOLEAN
		once
			Result := True
		end

	UniqueConstraintSupported: BOOLEAN
			-- is the unique constraint (keyword) supported
		once
			Result := True
		end

	InlineUniqueConstraintSupported: BOOLEAN
			-- can we use unique directly after the column or should it be separate
		once
			Result := True
		ensure
			consistent: Result implies UniqueConstraintSupported
		end

	OldConstraintNames: BOOLEAN
			-- Use old-style constraint names

	TimestampDatatype: STRING once Result := "timestamp" end

	TimestampSupported: BOOLEAN
			-- Does this dialect support the creation of time stamps in a table?
		once
			Result := False
		end

	TimestampEnabled: BOOLEAN

	CreateTimestamp: BOOLEAN
		do
			Result :=
				TimestampSupported and TimestampEnabled
		end

	StoredProcedureEnabled: BOOLEAN
			-- Option that can be enabled/disabled by the user.

	ViewColumnsSupported: BOOLEAN
			-- Does the dialect require a list of columns after the view
			-- name?
		do
			Result := True
		end

	ViewsSupported: BOOLEAN
			-- Does this backend support views?
		once
			Result := True
		end

	ViewsEnabled: BOOLEAN

	CreateViews: BOOLEAN
			-- Should a view be written for every type?
		do
			Result := ViewsSupported and ViewsEnabled
		end

	CreateViewSQL: STRING
			-- SQL statement to start creating a view; should end with
			-- some form of space
		once
			Result := "create view "
		ensure
			not_empty: Result /= Void and then not Result.is_empty
			ends_with_space: not Result.is_empty implies Result.item (Result.count).is_space
		end

	TemporaryTablesSupported: BOOLEAN
			-- Does this dialect support the 'create temporary table'?
		once
			Result := False
		end

	CreateTemporaryTableStatement: STRING
			-- The create statement to start creating a temporary table.
		once
			if TemporaryTablesSupported then
				Result := "create temporary table"
			else
				Result := "create table"
			end
		ensure
			CreateTemporaryTableStatement_not_empty: Result /= Void and then not Result.is_empty
		end

	FinishTemporaryTableStatement: STRING
			-- String to output when temporary table definition is finished
		do
			Result := ""
		ensure
			not_void: Result /= Void
		end

	FinishTemporaryValueTableStatement: STRING
			-- Oracle doesn't like alter tables when using on commit
			-- preserve rows
		do
			Result := FinishTemporaryTableStatement
		ensure
			not_void: Result /= Void
		end

	TemporaryTablePrefix: STRING
			-- Optional prefix for temporary tables, should include a '.'
			-- if that is the separator.
		do
			Result := ""
		ensure
			TemporaryTablePrefix_not_void: Result /= Void
		end

	TableNamePrefix: STRING once Result := "T" end

	primary_key_format: STRING = "id_$s"
			-- Format of primary key of a table

	ColumnNullDefault: BOOLEAN once Result := True end
	ColumnNullAllowed: BOOLEAN once Result := True end
	ColumnNotNullAllowed: BOOLEAN once Result := True end


feature -- init [default] options

	init_necessary (type: XPLAIN_TYPE): BOOLEAN
			-- Does `type' has an init that cannot be solved with a
			-- default clause in the create table statement.
		require
			type_not_void: type /= Void
		do
			Result :=
				(not ExpressionsInDefaultClauseSupported and then type.has_non_constant_init) or else
				type.has_non_literal_init
		end


feature -- extend options

	CreateExtendIndex: BOOLEAN
		do
			Result := ExtendIndexSupported and then ExtendIndex
		end

	ExtendIndex: BOOLEAN
			-- Create an index on the primary key if a temporary table is
			-- created for an extend.

	ExtendIndexSupported: BOOLEAN
		do
			-- Default was True, now made false so we can set the primary
			-- key constraint, which might actually work better for
			-- subsequent retrievals and in particular where we have to
			-- insert missing rows (see `sql_extend_insert_missing_rows')
			Result := False
		end

	can_write_extend_as_view (an_extension: XPLAIN_EXTENSION): BOOLEAN
		require
			extension_not_void: an_extension /= Void
		do
			Result := ViewsSupported
		end


feature -- Constants and values

	ConstantTableName: STRING = "XplainConstant"

	CreateTemporaryValueTable: BOOLEAN
		do
			Result := TemporaryTablesSupported
		end

	ValueTableName: STRING
		once
			if CreateTemporaryValueTable then
				Result := TemporaryTablePrefix + "XplainValue"
			else
				Result := "XplainValue"
			end
		end


feature -- Stored procedure options

	CreateStoredProcedure: BOOLEAN
			-- Should insert/update or delete stored procedures be
			-- created?
		deferred
		end

	NamedParametersSupported: BOOLEAN
			-- Can stored procedures use named parameters?
		deferred
		ensure
			consistent: Result implies StoredProcedureSupported
		end

	SupportsDomainsInStoredProcedures: BOOLEAN
			-- Notably InterBase 4 supports domains, but not as the type of
			-- parameters in a stored procedure.
		deferred
		ensure
			supports_stored_procedures: Result implies StoredProcedureSupported
			supports_domains: Result implies DomainsSupported
		end

	StoredProcedureSupported: BOOLEAN
			-- Are stored procedures supported?
		deferred
		end


feature -- index options

	IndexSupported: BOOLEAN
			-- sql generator has index support
		once
			Result := True
		end

	CreateIndex: BOOLEAN
		once
			Result := IndexSupported
		end

	ClusteredIndexSupported: BOOLEAN
			-- sql generator can create clustered indexes
		once
			Result := False
		end


feature -- select options

	ANSI92JoinsSupported: BOOLEAN
		once
			Result := True
		end

	ExistentialFromNeeded: BOOLEAN
			-- Is a from clause in a selection statement required?
			-- It's better if you don't need it. Define
			-- `ExistentialFromTable' for a work around.
		once
			Result := True
		end

	ExistentialFromTable: detachable STRING
			-- Name of the dual table (Oracle) or sysibm.sysdumm1 (DB2)
			-- to be used in a select statement where a from is required;
			-- The name of the get table is used when this routine
			-- returns Void. And that will generally not work.
		require
			from_needed: ExistentialFromNeeded
		do
		end


feature -- insert options

	SupportsDefaultValues: BOOLEAN
			-- Does the dialect supports the 'default values' clause in an
			-- insert statement?
		do
			Result := True
		end


feature -- update options

	SupportsQualifiedSetInUpdate: BOOLEAN
			-- Can column names in set expression be qualified?
			-- This must be done in certain cases to avoid ambiguous updates.
		do
			Result := False
		end

	SupportsJoinInUpdate: BOOLEAN
			-- Does this dialect support joins in an update
			-- statement?
		do
			Result := False
		end


feature -- purge options

	DropColumnSupported: BOOLEAN
			-- Does this dialect support dropping of columns?
		once
			Result := True
		end


feature -- Booleans

	SQLTrue: STRING once Result := "True" end
	SQLFalse: STRING once Result := "False" end

	SupportsTrueBoolean: BOOLEAN
			-- Does this dialect support first-class Booleans?
			-- Or do they have to be emulated?
			-- Interestingly, most dialects don't support it.
		do
			Result := True
		end


feature -- Date/time

	TimeZoneEnabled: BOOLEAN
			-- Emit datetime with timezone

	minimum_date_value: STRING
		once
			Result := "0001-01-01"
		end


feature -- Strings

	sql_string_combine_start: STRING
		once
			Result := ""
		ensure
			sql_string_combine_start_not_void: Result /= Void
		end

	sql_string_combine_separator: STRING
		once
			Result := ", "
		ensure
			sql_string_combine_separator_not_void: Result /= Void
		end

	sql_string_combine_end: STRING
		once
			Result := ""
		ensure
			sql_string_combine_end_not_void: Result /= Void
		end

	sql_like_operator: STRING
			-- Preferably a case-insensitive like operator
		once
			Result := "like"
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end


feature -- min/max

	SQLMinInt: STRING = "-2147483647"
	SQLMaxInt: STRING =	"2147483647"


feature -- Numeric precision

	max_numeric_precision: INTEGER
			-- Maximum precision of the numeric data type
		once
			Result := 28
		ensure
			positive: Result > 0
		end


feature -- functions

	SQLCoalesce: STRING
		once
			Result := "coalesce"
		end

	CoalesceSupported: BOOLEAN
		once
			Result := SQLCoalesce /= Void
		end


feature -- Assertions

	AssertEnabled: BOOLEAN

	CreateAssert: BOOLEAN
		once
			Result :=
				(CalculatedColumnsSupported or else ViewsSupported) and
				AssertEnabled
		end

	asserted_format_string: detachable STRING
		require
			assert_supported: CalculatedColumnsSupported
		do
		ensure
			correct_string: Result /= Void and then not Result.is_empty
		end


feature -- Public local state

	InUpdateStatement: BOOLEAN
			-- When in update statement generate subselects for complex
			-- expressions or extensions if joins are not supported

	ValueTableCreated: BOOLEAN
	ConstantTableCreated: BOOLEAN


feature {NONE} -- Implementation

	declared_values: DS_HASH_TABLE [XPLAIN_VALUE, STRING]
			-- List of declared values

	update_type: detachable XPLAIN_TYPE
			-- Hack to pass the type to get proper subselects in
			-- `sql_subselect_for_attribute'

	WhereWritten: BOOLEAN
			-- Is the where keyword of the SQL statement written?


feature -- Interactive i/o

	echo (str: STRING)
			-- output to stderr
		do
			std.error.put_string (str)
			std.error.put_string ("%N")
		end

feature -- Comments

	write_one_line_comment (line: STRING)
			-- write a one line comment, convert to multi line comment if
			-- target sql doesn't support one line comments
		require
			something_to_comment: line /= Void
		local
			line_starts_with_space: BOOLEAN
		do
			if NoOneLineCommentsSupported then
				std.output.put_string (MultiLineCommentPrefix)
			elseif attached OneLineCommentPrefix as p then
				std.output.put_string (p)
			end
			line_starts_with_space :=
				line.count > 0 and
				line.item (1) = ' '
			if not line_starts_with_space then
				std.output.put_string (" ")
			end
			std.output.put_string (line)
			if NoOneLineCommentsSupported then
				std.output.put_string (" ")
				std.output.put_string (MultiLineCommentPostfix)
			end
			std.output.put_character('%N')
		end

feature -- Convert Xplain definition to sql, you usually do not redefine these

	write_assertion (an_assertion: XPLAIN_ASSERTION)
		require
			assertion_not_void: an_assertion /= Void
		do
			if CreateAssert and then ViewsSupported then
				create_assertion (an_assertion)
			end
		end

	write_base (base: XPLAIN_BASE)
		do
			if CreateDomains then
				create_domain (base)
			end
		end

	write_constant (constant: XPLAIN_VARIABLE)
		do
			create_constant (constant)
		end

	write_constant_assignment (constant: XPLAIN_VARIABLE; expression: XPLAIN_EXPRESSION)
		do
			create_constant_assignment (constant, expression)
		end

	write_delete (subject: XPLAIN_SUBJECT; predicate: detachable XPLAIN_EXPRESSION)
			-- Code for delete statement.
		do
			create_delete (subject, predicate)
		end

	write_drop (object: XPLAIN_ABSTRACT_OBJECT)
		do
			object.write_drop (Current)
		end

	write_drop_assertion (an_assertion: XPLAIN_ASSERTION)
		require
			an_assertion_not_void: an_assertion /= Void
		do
			create_drop_assertion (an_assertion)
		end

	write_drop_column (a_type: XPLAIN_TYPE; an_attribute: XPLAIN_ATTRIBUTE)
			-- Drop a column from a table.
		require
			type_not_void: a_type /= Void
			type_has_attribute: a_type.attributes.has (an_attribute)
			not_extension: not an_attribute.is_extension
		do
			create_drop_column (a_type, an_attribute)
		end

	write_drop_extension (an_extension: XPLAIN_EXTENSION)
			-- Drop the extension.
		require
			extension_not_void: an_extension /= Void
		do
			create_drop_extension (an_extension)
		end

	write_echo (str: STRING)
			-- output string while parsing sql script
		do
			create_echo (str)
		end

	write_end (database: STRING)
			-- The final end.
		do
			create_end (database)
		end

	write_extend (extension: XPLAIN_EXTENSION)
			-- Code for extend statement.
		do
			if can_write_extend_as_view (extension) then
				create_extend_view (extension)
			else
				create_extend (extension)
			end
			if CreateExtendIndex then
				create_extend_create_index (extension)
			end
		end

	write_get_insert (
		a_selection: XPLAIN_SELECTION_LIST
		an_insert_type: XPLAIN_TYPE
		an_auto_primary_key: BOOLEAN
		an_assignment_list: detachable XPLAIN_ATTRIBUTE_NAME_NODE)
			-- Get into a table.
		do
			create_get_insert (a_selection, an_insert_type, an_auto_primary_key, an_assignment_list)
		end

	write_index (index: XPLAIN_INDEX)
		require
			valid_index: index /= Void
		do
			if CreateIndex then
				create_index (index)
			end
		end

	write_init (type: XPLAIN_TYPE)
			-- If necessary, emit initialisations that cannot be supprted
			-- by a DEFAULT clause in the CREATE TABLE statement.
		require
			valid_type: type /= Void
		deferred
		end

	write_insert (type: XPLAIN_TYPE; id: detachable XPLAIN_EXPRESSION; assignment_list: XPLAIN_ASSIGNMENT_NODE)
		do
			create_insert (type, id, assignment_list)
		end

	write_procedure (procedure: XPLAIN_PROCEDURE)
			-- Write a stored procedure.
		deferred
		end

	write_select (selection: XPLAIN_SELECTION)
			-- Write various select statements.
		do
			selection.write_select (Current)
		end

	write_select_function (selection_list: XPLAIN_SELECTION_FUNCTION)
			-- Write get with function.
		do
			create_select_function (selection_list)
		end

	write_select_instance (selection_list: XPLAIN_SELECTION_INSTANCE)
		require
			select_list_not_void: selection_list /= Void
		do
			create_select_instance (selection_list)
		end

	write_select_list (selection_list: XPLAIN_SELECTION_LIST)
			-- Write get with zero or more attributes.
		do
			create_select_list (selection_list)
		end

	write_select_value (a_value: XPLAIN_VALUE)
			-- Write statement to display value content.
		do
			create_select_value (a_value)
		end

	write_sql (sql: STRING)
			-- Literal SQL.
		do
			std.output.put_string (sql)
			std.output.put_character ('%N')
		end

	write_type (type: XPLAIN_TYPE)
		do
			drop_table_if_exist (type)
			create_table (type)
			if CreateViews then
				create_view (type)
			end
			if type.has_auto_pk (Current) then
				create_primary_key_generator (type)
			end
			forbid_update_of_primary_key (type)
		end

	write_update (
			subject: XPLAIN_SUBJECT;
			assignment_list: XPLAIN_ASSIGNMENT_NODE;
			predicate: detachable XPLAIN_EXPRESSION)
		do
			create_update (subject, assignment_list, predicate)
		end

	write_use_database (database: STRING)
		require
			valid_name: database /= Void
		do
			if SetDatabaseEnabled then
				create_use_database (database)
			end
		end

	write_value (value: XPLAIN_VALUE)
		do
			create_value (value)
		end


feature {NONE} -- Actual creation of sql statements, you may redefine these

	create_assertion (an_assertion: XPLAIN_ASSERTION)
		require
			assertion_not_void: an_assertion /= Void
			view_supported: ViewsSupported
		do
			-- view part
			std.output.put_character ('%N')
			drop_view_if_exist (an_assertion.sqlname (Current));
			std.output.put_character ('%N')
			std.output.put_string (CreateViewSQL)
			std.output.put_string (quote_valid_identifier (an_assertion.sqlname (Current)))
			if ViewColumnsSupported then
				std.output.put_string (" (")
				std.output.put_string (an_assertion.type.q_sqlpkname (Current))
				std.output.put_string (", ")
				std.output.put_string (quote_valid_identifier (an_assertion.name))
				std.output.put_character (')')
			end
			std.output.put_string (" as%N")

			-- select part
			std.output.put_string (an_assertion.expression.sqlselect (Current, an_assertion))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_character ('%N')
		end

	create_constant (variable: XPLAIN_VARIABLE)
			-- Emit code to define an Xplain constant.
		require
			valid_variable: variable /= Void
		do
			std.output.put_character ('%N')
			if not ConstantTableCreated then
				std.output.put_string ("create table ")
				std.output.put_string (ConstantTableName)
				std.output.put_string (" (")
			else
				std.output.put_string ("alter table ")
				std.output.put_string (ConstantTableName)
				std.output.put_string (" add ")
			end
			std.output.put_string (quote_identifier (constant_identifier (variable)))
			std.output.put_string (" ")
			std.output.put_string (variable.representation.datatype(Current))
			if not ConstantTableCreated then
				std.output.put_string (")")
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
				std.output.put_string ("insert into ")
				std.output.put_string (ConstantTableName)
				std.output.put_string (" values (Null)")
				ConstantTableCreated := True
			end
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_constant_assignment (variable: XPLAIN_VARIABLE; expression: XPLAIN_EXPRESSION)
			-- Emit code to assign a value to a previously created Xplain
			-- constant.
		do
			std.output.put_character ('%N')
			std.output.put_string ("update ")
			std.output.put_string (ConstantTableName)
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("set ")
			std.output.put_string (quote_identifier (constant_identifier (variable)))
			std.output.put_string (" = ")
			std.output.put_string (expression.outer_sqlvalue (Current))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_delete (subject: XPLAIN_SUBJECT; predicate: detachable XPLAIN_EXPRESSION)
			-- Emit SQL delete statement.
		require
			subject_not_void: subject /= Void
		local
			join_list: JOIN_LIST
		do
			std.output.put_character ('%N')
			std.output.put_string ("delete from ")
			std.output.put_string (quote_identifier (subject.type.sqlname (Current)))
			-- Create join list
			create join_list.make (subject.type)
			if predicate /= Void then
				predicate.add_to_join (Current, join_list)
			end
			join_list.finalize (Current)

			if join_list.first = Void then
				-- Standard delete
				create_predicate (subject, predicate)
			else
				-- Use subselects to retrieve rows which must be deleted
				std.output.put_character ('%N')
				std.output.put_string (Tab)
				std.output.put_string ("where ")
				std.output.put_string (subject.type.q_sqlpkname (Current))
				std.output.put_string (" in (%N")
				std.output.put_string ("select ")
				std.output.put_string (subject.type.quoted_name (Current))
				std.output.put_character ('.')
				std.output.put_string (subject.type.q_sqlpkname (Current))
				std.output.put_character ('%N')
				std.output.put_string (Tab)
				std.output.put_string ("from ")
				std.output.put_string (subject.type.quoted_name (Current))
				std.output.put_string (sql_select_joins (join_list))
				create_predicate (subject, predicate)
				std.output.put_character (')')
			end
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_domain (base: XPLAIN_BASE)
		require
			sql_with_domains: DomainsSupported
		do
			std.output.put_string ("create domain ")
			std.output.put_string (quote_identifier (domain_identifier (base)))
			std.output.put_string (" as ")
			std.output.put_string (base.representation.datatype (Current))
			if attached domain_null_or_not_null (base.representation.domain_restriction) as s then
				std.output.put_string (" ")
				std.output.put_string (s)
			end
			if attached base.representation.domain_restriction as domain_restriction and then attached domain_restriction.sqldomainconstraint (Current, "value") as s then
				std.output.put_string (" check ")
				std.output.put_string (s)
			end
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_drop_assertion (an_assertion: XPLAIN_ASSERTION)
		require
			an_assertion_not_void: an_assertion /= Void
		do
			std.output.put_string (once "drop view ")
			std.output.put_string (an_assertion.quoted_name (Current))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_drop_column (a_type: XPLAIN_TYPE; an_attribute: XPLAIN_ATTRIBUTE)
			-- Drop a column from a table.
		require
			type_not_void: a_type /= Void
			type_has_attribute: a_type.attributes.has (an_attribute)
			not_extension: not an_attribute.is_extension
		do
			drop_column (a_type.quoted_name (Current), an_attribute.sql_select_name (Current))
		end

	create_drop_extension (an_extension: XPLAIN_EXTENSION)
			-- Drop the extension.
		require
			extension_not_void: an_extension /= Void
		do
			drop_temporary_table_if_exist (an_extension)
		end

	create_echo (str: STRING)
			-- Output string while parsing sql script.
		do
			-- default is not supported
		end

	create_end (database: STRING)
		do
			-- do nothing for most databases
		end

	create_extend (extension: XPLAIN_EXTENSION)
			-- Code to create the temporary table to hold the extension and
			-- fill it.
		require
			valid_extension: extension /= Void
		local
			emulate_coalesce: BOOLEAN
		do
			-- create (temporary) table for extension
			std.output.put_character ('%N')
			drop_temporary_table_if_exist (extension)
			create_extend_create_table (extension)
			std.output.put_character ('%N')

			-- insert into part
			std.output.put_string (once "insert into ")
			std.output.put_string (TemporaryTablePrefix)
			std.output.put_string (quote_identifier (extension.sqlname (Current)))
			std.output.put_string (once " (")
			std.output.put_string (quote_identifier (extension.type.sqlpkname (Current)))
			std.output.put_string (once ", ")
			std.output.put_string (extension.q_sql_insert_name (Current, Void))
			std.output.put_string (once ")%N")
			std.output.put_string (Tab)

			-- select part
			std.output.put_string (extension.expression.sqlselect (Current, extension))
			std.output.put_string (CommandSeparator)
			std.output.put_string (once "%N%N")

			if attached {XPLAIN_EXTENSION_FUNCTION_EXPRESSION} extension.expression as function_expression then
				emulate_coalesce :=
					function_expression /= Void and then
					function_expression.selection.function.needs_coalesce and then
					not CoalesceSupported
				if emulate_coalesce then
					std.output.put_string ("update ")
					std.output.put_string (TemporaryTablePrefix)
					std.output.put_string (quote_identifier (extension.sqlname (Current)))
					std.output.put_character ('%N')
					std.output.put_string (Tab)
					std.output.put_string ("set ")
					std.output.put_string (extension.q_sql_insert_name (Current, Void))
					std.output.put_string (" = ")
					std.output.put_string (function_expression.selection.function.sqlextenddefault (Current, function_expression.selection.property))
					std.output.put_character ('%N')
					std.output.put_string (Tab)
					std.output.put_string ("where%N")
					std.output.put_string (Tab)
					std.output.put_string (Tab)
					std.output.put_string (extension.q_sql_insert_name (Current, Void))
					std.output.put_string (" is null")
					std.output.put_string (CommandSeparator)
					std.output.put_string ("%N%N")
				end
			end
		end

		create_extend_create_table (extension: XPLAIN_EXTENSION)
			-- Output sql code to create a separate table to hold the
			-- extension.
		require
			extension_not_void: extension /= Void
		do
			std.output.put_string (CreateTemporaryTableStatement)
			std.output.put_character (' ')
			-- I do this in XPLAIN_EXTENSION.quoted_name...
			--std.output.put_string (TemporaryTablePrefix)
			std.output.put_string (extension.quoted_name (Current))
			std.output.put_string (" (%N")
			std.output.put_string (Tab)
			std.output.put_string (extension.type.q_sqlpkname (Current))
			std.output.put_character (' ')
			std.output.put_string (extension.type.columndatatype (Current))
			std.output.put_string (once " not null")
			if not CreateExtendIndex then
				std.output.put_string (" primary key")
			end
			std.output.put_string (",%N")
			std.output.put_string (Tab)
			std.output.put_string (quote_valid_identifier (extension.name))
			std.output.put_character (' ')
			std.output.put_string (extension.columndatatype (Current))
			std.output.put_character (')')
			std.output.put_string (FinishTemporaryTableStatement)
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_extend_create_index (an_extension: XPLAIN_EXTENSION)
			-- Output SQL code to add an index to the temporary table
			-- that holds the extension. Some tests indicated that it was
			-- faster to create an index after having filled the table,
			-- than having a primary key on that table.
		require
			extension_not_void: an_extension /= Void
			may_create: CreateExtendIndex
		local
			a_table_name,
			a_index_name,
			a_pk_name: STRING
		do
			a_table_name := an_extension.quoted_name (Current)
			a_index_name := extension_index_name (an_extension)
			a_pk_name := an_extension.q_sqlpkname (Current)
			std.output.put_string (format ("create unique index $s on $s ($s)", <<a_index_name, a_table_name, a_pk_name>>))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_extend_view (an_extension: XPLAIN_EXTENSION)
			-- Write extend as a view.
		require
			extension_not_void: an_extension /= Void
			view_supported: ViewsSupported
		do
			-- view part
			std.output.put_character ('%N')
			drop_view_if_exist (an_extension.sqlname (Current));
			std.output.put_character ('%N')
			std.output.put_string (CreateViewSQL)
			std.output.put_string (quote_valid_identifier (an_extension.sqlname (Current)))
			if ViewColumnsSupported then
				std.output.put_string (" (")
				std.output.put_string (an_extension.type.q_sqlpkname (Current))
				std.output.put_string (", ")
				std.output.put_string (quote_valid_identifier (an_extension.name))
				std.output.put_character (')')
			end
			std.output.put_string (" as%N")

			-- select part
			std.output.put_string (an_extension.expression.sqlselect (Current, an_extension))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_character ('%N')
		end

	create_get_insert (
		a_selection: XPLAIN_SELECTION_LIST
		an_insert_type: XPLAIN_TYPE
		an_auto_primary_key: BOOLEAN
		an_assignment_list: detachable XPLAIN_ATTRIBUTE_NAME_NODE)
			-- Emit insert into table (column, ...) select.
		require
			selection_not_void: a_selection /= Void
			insert_type_not_void: an_insert_type /= Void
		local
			node: detachable XPLAIN_ATTRIBUTE_NAME_NODE
			is_integer_id: BOOLEAN
			self_insert: BOOLEAN
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
		do
			self_insert := a_selection.type = an_insert_type
			-- insert into statement itself
			std.output.put_string ("%Ninsert into ")
			std.output.put_string (an_insert_type.quoted_name (Current))
			if self_insert or else attached an_assignment_list then
				std.output.put_string (" (")
			end

			-- name of columns which are inserted
			if not an_auto_primary_key then
				std.output.put_string (quote_identifier (table_pk_name (an_insert_type)))
				if an_assignment_list /= Void then
					std.output.put_string (", ")
				end
			end
			if attached an_assignment_list then
				from
					node := an_assignment_list
				until
					not attached node
				loop
					std.output.put_string (node.item.quoted_name (Current))
					node := node.next
					if attached node then
						std.output.put_string (", ")
					end
				end
			elseif self_insert then
				from
					cursor := an_insert_type.new_data_attributes_cursor (Current)
					cursor.start
				until
					cursor.after
				loop
					check attached cursor.item.abstracttype as abstracttype then
						std.output.put_string (abstracttype.sqlcolumnidentifier (Current, cursor.item.role))
					end
					cursor.forth
					if not cursor.after then
						std.output.put_character (',')
						std.output.put_character (' ')
					end
				end
			end
			if self_insert or else attached an_assignment_list then
				std.output.put_character (')')
			end

			-- select statement
			do_create_select_list (a_selection, self_insert)

			-- On some systems, auto-generated primary keys and user
			-- supplied identifications don't work well together. Output
			-- some code to correct the sitation, if possible.
			if CreateAutoPrimaryKey then
				if not an_auto_primary_key then
					is_integer_id := not an_insert_type.representation.write_with_quotes
					if is_integer_id then
						-- TODO: we don't know the value here
						--create_sync_auto_generated_primary_key_with_supplied_value (an_insert_type, an_id.sqlvalue (Current).to_integer)
					end
				end
			end
		end

	create_index (index: XPLAIN_INDEX)
			-- create the index statement
		local
			anode: detachable XPLAIN_ATTRIBUTE_NAME_NODE
		do
			std.output.put_string ("create ")
			if index.is_unique then
				std.output.put_string ("unique ")
			end
			if ClusteredIndexSupported and then index.is_clustered then
				std.output.put_string ("clustered ")
			end
			std.output.put_string ("index ")
			std.output.put_string (quote_identifier(index_name (index)))
			std.output.put_string (" on ")
			std.output.put_string (index.type.quoted_name (Current))
			std.output.put_string (" (")
			from
				anode := index.first_attribute
			until
				anode = Void
			loop
				std.output.put_string (anode.item.quoted_name (Current))
				anode := anode.next
				if anode /= Void then
					std.output.put_string (", ")
				end
			end
			std.output.put_character (')')
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_insert (type: XPLAIN_TYPE; id: detachable XPLAIN_EXPRESSION; assignment_list: XPLAIN_ASSIGNMENT_NODE)
			-- Generate SQL insert statement. If id not Void, it contains
			-- a user supplied instance identification.
		require
			valid_type: type /= Void
			assignment_list_not_void: assignment_list /= Void
		local
			output_identifier_column: BOOLEAN
			node: detachable XPLAIN_ASSIGNMENT_NODE
			is_integer_id: BOOLEAN
		do
			-- insert into statement itself
			std.output.put_string ("%Ninsert into ")
			std.output.put_string (quote_identifier (type.sqlname (Current)))
			std.output.put_string (" (")

			-- name of columns which are inserted
			output_identifier_column := attached id
			if output_identifier_column then
				std.output.put_string (quote_identifier (table_pk_name (type)))
				if assignment_list /= Void then
					std.output.put_string (", ")
				end
			end
			from
				node := assignment_list
			until
				node = Void
			loop
				std.output.put_string (quote_identifier (node.item.attribute_name.sqlcolumnidentifier (Current)))
				node := node.next
				if node /= Void then
					std.output.put_string (", ")
				end
			end
			std.output.put_string (")")
			std.output.put_character ('%N')
			std.output.put_string (Tab)

			-- actual values
			std.output.put_string ("values (")
			if output_identifier_column and then attached id as identification then
				std.output.put_string (identification.sqlvalue (Current))
				if attached assignment_list then
					std.output.put_string (", ")
				end
			end
			from
				node := assignment_list
			until
				node = Void
			loop
				std.output.put_string (node.item.expression.outer_sqlvalue (Current))
				node := node.next
				if node /= Void then
					std.output.put_string (", ")
				end
			end
			std.output.put_string (")")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')

			-- On some systems, auto-generated primary keys and user
			-- supplied identifications don't work well together. Output
			-- some code to correct the sitation, if possible.
			if CreateAutoPrimaryKey then
				if id /= Void and then id.is_constant then
					is_integer_id := not type.representation.write_with_quotes
					if is_integer_id then
						if id.sqlvalue (Current).to_integer > 0 then
							create_sync_auto_generated_primary_key_with_supplied_value (type, id.sqlvalue (Current).to_integer)
						end
					end
				end
			end
		end

	create_predicate (subject: XPLAIN_SUBJECT; predicate: detachable XPLAIN_EXPRESSION)
			-- generate a where clause
		require
			subject_not_void: subject /= Void
			cursor_start: -- we're at the end of the last generated line
		do
			std.output.put_string (sql_predicate (subject, predicate))
		ensure
			cursor_at_end: True -- end of last generated line
			local_state_reset: not WhereWritten
		end

	create_primary_key_generator (type: XPLAIN_TYPE)
			-- Dialects that need some sort of sequence + before/after
			-- insert trigger to handle auto-generated primary keys.
		require
			auto_pk: AutoPrimaryKeySupported
			type_not_void: type /= Void
			integer_primary_key: type.representation.is_integer
		deferred
		end

	create_select_function (selection_list: XPLAIN_SELECTION_FUNCTION)
			-- Output a select function that returns a scalar value.
		require
			select_list_not_void: selection_list /= Void
		do
			-- Just output the subselect
			std.output.put_string (sql_select_function_as_subselect (selection_list))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_select_instance (selection_list: XPLAIN_SELECTION_INSTANCE)
		require
			select_list_not_void: selection_list /= Void
		do
			std.output.put_string (sql_select_instance (selection_list))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_select_list (selection_list: XPLAIN_SELECTION_LIST)
		do
			do_create_select_list (selection_list, False)
		end

	do_create_select_list (selection_list: XPLAIN_SELECTION_LIST; a_self_insert: BOOLEAN)
			-- Insert a blank line and output the familiar select statement.
		require
			selection_list_not_void: selection_list /= Void
		local
			type: XPLAIN_TYPE
			snode: detachable XPLAIN_SORT_NODE
		do
			-- upper aggregate
			type := selection_list.type

			-- start select statement
			std.output.put_character ('%N')
			do_do_create_select_list (selection_list, a_self_insert)

			-- order by clause
			std.output.put_string (Tab)
			std.output.put_string (once "order by")
			if selection_list.sort_order = Void then
				std.output.put_character ('%N')
				std.output.put_string (Tab)
				std.output.put_string (Tab)
				std.output.put_string (type.quoted_name (Current))
				std.output.put_character ('.')
				std.output.put_string (type.q_sqlpkname (Current))
				std.output.put_string (once " asc")
			else
				from
					snode := selection_list.sort_order
				until
					not attached snode
				loop
					std.output.put_character ('%N')
					std.output.put_string (Tab)
					std.output.put_string (Tab)
					check attached snode.item.last as sort_attribute and then attached sort_attribute.prefix_table as p then
						std.output.put_string (quote_identifier (p))
						std.output.put_character ('.')
						std.output.put_string (sort_attribute.item.q_sql_select_name (Current))
						if snode.ascending then
							std.output.put_string (" asc")
						else
							std.output.put_string (" desc")
						end
					end
					snode := snode.next
					if attached snode then
						std.output.put_character (',')
					end
				end
			end

			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	do_do_create_select_list (selection_list: XPLAIN_SELECTION_LIST; a_self_insert: BOOLEAN)
			-- Select statement without order by and without command separator.
		require
			selection_list_not_void: selection_list /= Void
		local
			enode: detachable XPLAIN_EXPRESSION_NODE
			type: XPLAIN_TYPE
			join_list: JOIN_LIST
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			table_alias: STRING
		do
			-- upper aggregate
			type := selection_list.type

			-- build list of all tables to join
			create join_list.make (type)
			selection_list.add_to_join (Current, join_list)
			join_list.finalize (Current)

			-- start select statement
			std.output.put_string ("select")

			-- column list
			if selection_list.expression_list = Void then
				if a_self_insert then
					std.output.put_character (' ')
					from
						table_alias := selection_list.type.quoted_name (Current)
						cursor := type.new_data_attributes_cursor (Current)
						cursor.start
					until
						cursor.after
					loop
						std.output.put_string (table_alias)
						std.output.put_character ('.')
						check attached cursor.item.abstracttype as abstracttype then
							std.output.put_string (abstracttype.sqlcolumnidentifier (Current, cursor.item.role))
						end
						cursor.forth
						if not cursor.after then
							std.output.put_character (',')
							std.output.put_character (' ')
						end
					end
				else
					std.output.put_character (' ')
					std.output.put_string (selection_list.type.quoted_name (Current))
					std.output.put_string (once ".*")
				end
			else
				std.output.put_character ('%N')
				if attached selection_list.identification_text as id then
					std.output.put_string (Tab)
					std.output.put_string (Tab)
					std.output.put_string (once "'")
					std.output.put_string (id)
					std.output.put_string (once "',%N")
				end
				if not a_self_insert then
					std.output.put_string (Tab)
					std.output.put_string (Tab)
					std.output.put_string (type.quoted_name (Current))
					std.output.put_string (".")
					std.output.put_string (type.q_sqlpkname (Current))
				end
				if not selection_list.show_only_identifier_column then
					from
						if not a_self_insert then
							std.output.put_string (once ",%N")
						end
						std.output.put_string (Tab)
						std.output.put_string (Tab)
						enode := selection_list.expression_list
					until
						enode = Void
					loop
						std.output.put_string (enode.item.outer_sqlvalue (Current))
						if attached enode.new_name as n then
							std.output.put_string (once " as ")
							std.output.put_string (quote_valid_identifier (n))
						else
							if attached enode.item.sql_alias (Current) as column_alias then
								std.output.put_string (once " as ")
								std.output.put_string (quote_identifier (column_alias))
							end
						end
						enode := enode.next
						if enode /= Void then
							std.output.put_string (once ",%N")
							std.output.put_string (Tab)
							std.output.put_string (Tab)
						end
					end
				end
			end
			std.output.put_character ('%N')
			std.output.put_string (Tab)

			-- join clause
			std.output.put_string (once "from ")
			std.output.put_string (type.quoted_name (Current))
			std.output.put_string (sql_select_joins (join_list))

			create_predicate (selection_list.subject, selection_list.predicate)
			std.output.put_character ('%N')
		end

	create_select_value (a_value: XPLAIN_VALUE)
			-- Xplain value statement that returns the value of `a_value'.
		require
			valid_value: a_value /= Void
			declared: is_value_declared (a_value)
		do
			create_select_value_outside_sp (a_value)
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_select_value_outside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL that returns the value when asked for that value
			-- outside a stored procedure.
			-- Should not emit `CommandSeparator'.
		require
			valid_value: a_value /= Void
			declared: is_value_declared (a_value)
			--outside_sp: not is_stored_procedure
		do
			std.output.put_string (format ("select $s from $s", <<a_value.quoted_name (Current), ValueTableName>>))
		end

	create_sync_auto_generated_primary_key_with_supplied_value (type: XPLAIN_TYPE; user_identification: INTEGER)
			-- On some systems, auto-generated primary keys and user
			-- supplied identifications don't work well together. Output
			-- some code to correct the situation, if possible for `type'
			-- and the integer `user_identification'.
			-- This output does only have to work in a single-user case.
			-- Of course, if correcting the auto-generated primary key
			-- can be done automatically and multi-user safe, that is
			-- to be preferred.
		require
			auto_pk_support: AutoPrimaryKeySupported
			type_not_void: type /= Void
			valid_identification: user_identification > 0
		do
			-- do nothing
		end

	create_table (type: XPLAIN_TYPE)
			-- Generate SQL create table statement.
		local
			cursor: DS_LINEAR_CURSOR [XPLAIN_ATTRIBUTE]
			s: detachable STRING
			null_keyword: READABLE_STRING_GENERAL
			column_name: STRING
		do
			-- create table statement
			std.output.put_character ('%N')
			std.output.put_string ("create table ")
			std.output.put_string (quote_identifier (type.sqltablename(Current)))
			std.output.put_string (" (")
			std.output.put_character ('%N')
			std.output.put_string (Tab)

			-- decide if table gets its own primary key or may inherit it
			-- in case of single inheritance
			std.output.put_string (quote_identifier (type.sqlpkname (Current)))
			std.output.put_string (" ")
			std.output.put_string (type.representation.pkdatatype (Current))

			-- Write table columns
			-- this "all" cursors skips all columns for which we cannot
			-- or should not (if inheriting key) produce output.
			from
				cursor := type.new_all_attributes_cursor (Current)
				cursor.start
			until
				cursor.after
			loop
				std.output.put_string (",%N")
				std.output.put_string (Tab)

				-- write column and datatype
				check attached cursor.item.abstracttype as abstracttype then
					column_name := abstracttype.sqlcolumnidentifier (Current, cursor.item.role)
					std.output.put_string (quote_identifier (column_name))
					std.output.put_string (" ")
					-- columndatatype is either a domain type or a standard
					-- data type. If it is a domain type, make sure it is quoted.
					std.output.put_string (abstracttype.columndatatype (Current))

					-- write default, first check if a simple init expression
					-- is defined.
					s := abstracttype.sqlcolumndefault (Current, cursor.item)
					-- If not we need a default to allow a trigger to fill in
					-- the details after the actual insert. It seems the check
					-- constraint doesn't fire until the triggers have been
					-- processed, so we do not need to take domain
					-- restrictions into account here.
					if s = Void and then init_forced_default (cursor.item) then
						s := abstracttype.representation.default_value
					end
					if s /= Void then
						std.output.put_character ('%N')
						std.output.put_string (Tab)
						std.output.put_string (Tab)
						std.output.put_string ("default ")
						std.output.put_string (s)
					end

					-- write null / not null
					null_keyword := abstracttype.sqlcolumnrequired (Current, cursor.item)
					if not null_keyword.is_empty then
						std.output.put_character (' ')
						std.output.put_string (null_keyword.out)
					end

					-- Write unique, no conflict with check constraint??
					-- Also if self reference and specialization, the column
					-- won't be required, so at least InterBase rejects the
					-- unique constraint in that case. Have to check other
					-- databases.
					if
						cursor.item.is_unique or else
						cursor.item.is_specialization and cursor.item.is_required then
						if UniqueConstraintSupported and
							InlineUniqueConstraintSupported then
							std.output.put_string(" unique")
						end
					end

					-- write references and check constraint, if any
					if attached  abstracttype.representation.domain_restriction as domain_restriction and then attached domain_restriction.sqlcolumnconstraint (Current, column_name) as ss then
						std.output.put_character ('%N')
						std.output.put_string (Tab)
						std.output.put_string (Tab)
						if ConstraintNameSupported then
							if OldConstraintNames then
								type.next_constraint_number
							end
							std.output.put_string ("constraint ")
							std.output.put_string (quote_identifier (column_constraint_name (type, cursor.item)))
							std.output.put_character (' ')
						end
						std.output.put_string (ss)
					end
				end

				cursor.forth

			end

			if CreateTimestamp then
				std.output.put_string (",%N")
				std.output.put_string (Tab)
				std.output.put_string (quote_identifier (table_ts_name (type)))
				std.output.put_string (" ")
				std.output.put_string (TimestampDatatype)
				std.output.put_string (" not null")
			end

			-- write unique constraints for brain dead dialects that don't
			-- support inlined uniques
			if UniqueConstraintSupported and not InlineUniqueConstraintSupported then
				from
					cursor := type.new_data_attributes_cursor (Current)
					cursor.start
				until
					cursor.after
				loop
					if cursor.item.is_unique or else cursor.item.is_specialization then
						check attached cursor.item.abstracttype as abstracttype then
							std.output.put_string (",%N")
							std.output.put_string (Tab)
							std.output.put_string("unique (")
							column_name := abstracttype.sqlcolumnidentifier (Current, cursor.item.role)
							std.output.put_string (quote_identifier(column_name))
							std.output.put_string(")")
						end
					end
					cursor.forth
				end
			end

			-- that's it
			std.output.put_string(")")
			std.output.put_string(CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_character ('%N')
		end

	create_update (
			subject: XPLAIN_SUBJECT;
			assignment_list: XPLAIN_ASSIGNMENT_NODE;
			predicate: detachable XPLAIN_EXPRESSION)
		require
			subject_not_void: subject /= Void
			assignment_list_not_void: assignment_list /= Void
		local
			node: detachable XPLAIN_ASSIGNMENT_NODE
			have_non_extended_columns: BOOLEAN
			extension_subject: XPLAIN_SUBJECT
			update_needs_join: BOOLEAN
			join_list: detachable JOIN_LIST
			attribute_node: XPLAIN_ATTRIBUTE_NAME_NODE
			extension_expression: XPLAIN_EXTENSION_EXPRESSION
		do
			-- Need this for dialects that don't support complex updates.
			update_type := subject.type

			-- First update the extended columns.
			-- No other order is really safe (we really need to check if any of
			-- the updated columns are also used in the update, and
			-- should forbid that). Doing this first helps to determine
			-- if we have non-extended columns.
			-- Hmm, same problem also with normal attributes: if you use
			-- an attribute that is also updated, you can get unexpected
			-- results. Just forbid those occurrences.
			from
				node := assignment_list
			until
				node = Void
			loop
				if attached node.item.attribute_name.type_attribute as type_attribute and then
					type_attribute.is_extension and then
					attached {XPLAIN_EXTENSION} node.item.attribute_name.object as extension then
					updated_extension := extension
					-- @@BdB: Should output subselects when referring to
					-- (extended) attributes of type. This code allows
					-- dialects which supports join in the update to work
					-- fine.
					-- Also make sure to avoid joining when the updated
					-- extension is only updated with a literal value. And
					-- no, your so called SQL optimizer doesn't detect that
					-- case (because of the join).
					update_needs_join :=
						(not node.item.expression.is_literal and then
						 node.item.expression.is_using_other_attributes (node.item.attribute_name)) or else
						 (predicate /= Void and then predicate.is_using_other_attributes (node.item.attribute_name))
					if update_needs_join then
						create join_list.make (subject.type)
						-- First we need to make sure the extension is properly
						-- joined to the type.
						create attribute_node.make (node.item.attribute_name, Void)
						create extension_expression.make (extension, attribute_node)
						extension_expression.add_to_join (Current, join_list)
						-- Next join any stuff needed by the assignment expression.
						node.item.expression.add_to_join (Current, join_list)
						-- And then the predicate.
						if predicate /= Void then
							predicate.add_to_join (Current, join_list)
						end
						join_list.finalize (Current)
					end
					InUpdateStatement := not SupportsJoinInUpdate

					std.output.put_character ('%N')
					std.output.put_string (once "update ")
					output_update_extend_join_clause (subject, extension, join_list)
					std.output.put_character ('%N')
					std.output.put_string (Tab)
					std.output.put_string (once "set")
					std.output.put_character ('%N')
					std.output.put_string (Tab)
					std.output.put_string (Tab)
					if SupportsQualifiedSetInUpdate and then update_needs_join then
						std.output.put_string (extension.quoted_name (Current))
						std.output.put_character ('.')
					end
					std.output.put_string (extension.q_sql_select_name (Current, node.item.attribute_name.role))
					std.output.put_string (once " = ")
					std.output.put_string (node.item.expression.outer_sqlvalue (Current))
					-- Support for TSQL/PostgreSQL from clause
					if update_needs_join and then SupportsJoinInUpdate and then attached join_list as jl then
						output_update_extend_from_clause (subject, jl)
					end

					create extension_subject.make (extension, subject.identification)
					create_predicate (extension_subject, predicate)
					std.output.put_string (CommandSeparator)
					std.output.put_character ('%N')
					InUpdateStatement := False
				else
					have_non_extended_columns := True
				end
				node := node.next
			end
			updated_extension := Void

			if have_non_extended_columns then
				InUpdateStatement := not SupportsJoinInUpdate

				if SupportsJoinInUpdate then
					create join_list.make (subject.type)
					-- Next join any stuff needed by the assignments.
					from
						node := assignment_list
					until
						node = Void
					loop
						node.item.expression.add_to_join (Current, join_list)
						node := node.next
					end
					-- And then the predicate.
					if predicate /= Void then
						predicate.add_to_join (Current, join_list)
					end
					join_list.finalize (Current)
				end

				std.output.put_character ('%N')
				std.output.put_string (once "update ")
				if attached join_list as jl then
					output_update_join_clause (subject, jl)
				end
				std.output.put_character ('%N')
				std.output.put_string (Tab)
				std.output.put_string (once "set")
				std.output.put_character ('%N')
				from
					node := assignment_list
				until
					not attached node
				loop
					check attached node.item.attribute_name.type_attribute as type_attribute then
						if not type_attribute.is_extension then
							std.output.put_string (Tab)
							std.output.put_string (Tab)
							if SupportsQualifiedSetInUpdate and then attached join_list as jl and then not jl.is_empty then
								std.output.put_string (subject.type.quoted_name (Current))
								std.output.put_character ('.')
							end
							std.output.put_string (quote_identifier (node.item.attribute_name.sqlcolumnidentifier (Current)))
							std.output.put_string (once " = ")
							std.output.put_string (node.item.expression.outer_sqlvalue (Current))
						end
					end
					node := node.next
					if attached node then
						std.output.put_string (once ",%N")
					end
				end

				-- Emit TSQL specific way to join tables in an update
				if SupportsJoinInUpdate and then attached join_list as jl and then not jl.is_empty then
					output_update_from_clause (subject, jl)
				end
				-- TODO: if its list appears only in predicate, I can do a
				-- trick like `create_delete', i.e. use a subselect.
				create_predicate (subject, predicate)
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
				InUpdateStatement := False
			end
			update_type := Void
		ensure
			updated_extension_void: updated_extension = Void
			not_in_update: not InUpdateStatement
		end

	create_use_database (database: STRING)
			-- Start using a certain database.
		require
			valid_database: database /= Void
		deferred
		end

	frozen create_value (value: XPLAIN_VALUE)
			-- Output sql code to create a value and store an expression in it.
		require
			valid_value: value /= Void
		do
			optional_create_value_declare (value)
			create_value_assign (value)
		end

	optional_create_value_declare (a_value: XPLAIN_VALUE)
			-- Emit code to declare the value if it does not already
			-- exist. If it exists and its data type is changed,
			-- redeclare it.
		require
			value_not_void: a_value /= Void
		do
			if is_value_declared (a_value) then
				if is_value_data_type_changed (a_value) then
					drop_value (a_value)
					create_value_declare (a_value)
				end
			else
				create_value_declare (a_value)
			end
		end

	create_value_declare (a_value: XPLAIN_VALUE)
			-- Emit code to declare the value if it does not already
			-- exist. If it exists and its data type is changed,
			-- redeclare it.
		require
			value_not_void: a_value /= Void
			not_declared: not is_value_declared (a_value)
		do
			create_value_declare_outside_sp (a_value)
			declared_values.force (a_value, a_value.name)
		ensure
			declared: is_value_declared (a_value)
		end

	create_value_declare_outside_sp (a_value: XPLAIN_VALUE)
			-- Emit SQL code to declare `a_value' outside a stored procedure.
		require
			value_not_void: a_value /= Void
			not_declared: not is_value_declared (a_value)
			--outside_sp: not is_stored_procedure
		do
			std.output.put_character ('%N')
			if not ValueTableCreated then
				create_value_create_table (a_value)
			else
				create_value_alter_table (a_value)
			end
		end

	create_value_alter_table (value: XPLAIN_VALUE)
			-- Output sql code to alter the value table with a new
			-- column, if that value does not already exist.
		require
			value_not_void: value /= Void
			table_does_exist: ValueTableCreated
		do
			std.output.put_string ("alter table ")
			std.output.put_string (ValueTableName)
			std.output.put_string (" add ")
			std.output.put_string (value.quoted_name (Current))
			std.output.put_character (' ')
			std.output.put_string (value.representation.datatype (Current))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_value_create_table (value: XPLAIN_VALUE)
			-- Output sql code to create a table to hold values.
		require
			value_not_void: value /= Void
			table_does_not_exist: not ValueTableCreated
		do
			if CreateTemporaryValueTable then
				std.output.put_string (CreateTemporaryTableStatement)
			else
				std.output.put_string (once "create table")
			end
			std.output.put_character (' ')
			std.output.put_string (ValueTableName)
			std.output.put_character ('(')
			std.output.put_string (value.quoted_name (Current))
			std.output.put_character (' ')
			std.output.put_string (value.representation.datatype (Current))
			std.output.put_character (')')
			if CreateTemporaryValueTable then
				if not FinishTemporaryValueTableStatement.is_empty then
					std.output.put_character (' ')
					std.output.put_string (FinishTemporaryValueTableStatement)
				end
			end
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_string (once "insert into ")
			std.output.put_string (ValueTableName)
			std.output.put_string (once " values (Null)")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			ValueTableCreated := True
		ensure
			table_does_exist: ValueTableCreated
		end

	create_value_assign (a_value: XPLAIN_VALUE)
		require
			value_not_void: a_value /= Void
			declared: is_value_declared (a_value)
		do
			create_value_assign_outside_sp (a_value)
		end

	create_value_assign_outside_sp (a_value: XPLAIN_VALUE)
			-- Assign a value to `a_value' outside a stored procedure.
		require
			value_not_void: a_value /= Void
			declared: is_value_declared (a_value)
			--outside_sp: not is_stored_procedure
		do
			std.output.put_string ("update ")
			std.output.put_string (ValueTableName)
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string ("set ")
			std.output.put_string (a_value.quoted_name (Current))
			std.output.put_string (" = (")
			std.output.put_string (a_value.expression.outer_sqlvalue (Current))
			std.output.put_character (')')
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_view (type: XPLAIN_TYPE)
		require
			type_not_void: type /= Void
			views: ViewsSupported
		do
			std.output.put_character ('%N')
			std.output.put_string (CreateViewSQL)
			std.output.put_string (type.quoted_name (Current))
			std.output.put_string (" as %N")
			std.output.put_string (Tab)
			std.output.put_string ("select * from ")
			std.output.put_string (quote_identifier (type.sqltablename (Current)))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	forbid_update_of_primary_key (type: XPLAIN_TYPE)
			-- Generate code, if necessary, that forbids updating of the
			-- primary key column of the table generated for `type'.
		require
			type_not_void: type /= Void
		do
			-- nothing
		end


feature -- Drop statements, should fail gracefully if things are not supported

	drop_column (tablename, columnname: STRING)
			-- Generate code to drop some column from some table
			-- used to purge attributes/variable/values.
			-- Table name should be quoted, column name should be unquoted.
		do
			if DropColumnSupported then
				std.output.put_string ("alter table ")
				std.output.put_string (tablename)
				std.output.put_string (" drop column ")
				std.output.put_string (quote_identifier (columnname))
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			else
				write_one_line_comment ("alter table " + tablename + " drop column " + quote_identifier (columnname))
				std.error.put_string ("Removing columns is not supported by this dialect.%N")
			end
		ensure
			no_no_columns: -- what happens if table doesn't have any columns any more??
		end

	drop_constant (a_constant: XPLAIN_VARIABLE)
			-- Remove constant.
		require
			constant_not_void: a_constant /= Void
		do
			std.output.put_character ('%N')
			drop_column (ConstantTableName, constant_identifier (a_constant))
		end

	drop_domain (base: XPLAIN_BASE)
		do
			if CreateDomains then
				std.output.put_character ('%N')
				std.output.put_string ("drop domain ")
				std.output.put_string (quote_identifier(domain_identifier(base)))
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			end
		end

	drop_primary_key_generator (type: XPLAIN_TYPE)
		require
			auto_pk: AutoPrimaryKeySupported
		deferred
		end

	drop_procedure (procedure: XPLAIN_PROCEDURE)
			-- Drop procedure `procedure'.
		require
			procedure_not_void: procedure /= Void
		deferred
		end

	drop_table (type: XPLAIN_TYPE)
			-- Drop table, primary key generator and such.
		require
			type_not_void: type /= Void
		do
			std.output.put_character ('%N')
			if CreateAutoPrimaryKey then
				drop_primary_key_generator (type)
			end
			if CreateViews then
				std.output.put_string ("drop view ")
				std.output.put_string (quote_identifier (type.sqlname (Current)))
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			end
			std.output.put_string ("drop table ")
			std.output.put_string (quote_identifier (type.sqltablename (Current)))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	drop_table_if_exist (type: XPLAIN_TYPE)
			-- Generate a statement that drops this table, but only if it exists.
			-- No warning must be generated if the table does not exist at
			-- run-time.
		require
			type_not_void: type /= Void
		do
			-- assume this is not supported
		end

	drop_temporary_table_if_exist (extension: XPLAIN_EXTENSION)
			-- Drop the temporary table created for `extension'.
			-- Usually, implemention of this method is a hack. It should
			-- not be needed if a dialect supports temporary tables.
		require
			extension_not_void: extension /= Void
		do
			-- ignore
		end

	drop_value (a_value: XPLAIN_VALUE)
			-- Remove value.
		require
			value_not_void: a_value /= Void
			declared: is_value_declared (a_value)
		do
			std.output.put_character ('%N')
			drop_column (ValueTableName, a_value.sqlname (Current))
			declared_values.remove (a_value.name)
		ensure
			not_declared: not is_value_declared (a_value)
		end

	drop_view_if_exist (a_name: STRING)
			-- Generate a statement that drops a view table, but only if
			-- it exists, no warning must be generated if the table does
			-- not exist at run-time.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			-- assume this is not supported
		end


feature -- ANSI SQL type specification for Xplain types

	datatype_char (representation: XPLAIN_C_REPRESENTATION): STRING
		do
			Result := "character(" + representation.length.out + ")"
		end

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING
		once
			Result := "integer"
		end

	datatype_numeric (representation: XPLAIN_R_REPRESENTATION): STRING
			-- Exact numeric data type.
		local
			precision, scale: INTEGER
		do
			precision := representation.before + representation.after
			scale := representation.after
			if precision > max_numeric_precision then
				std.error.put_string ("Too large real representation detected: ")
				std.error.put_integer (precision)
				std.error.put_string ("%NRepresentation truncated to ")
				std.error.put_integer (max_numeric_precision)
				std.error.put_character ('%N')
				scale := max_numeric_precision
			end
			Result := "numeric(" + precision.out + "," + scale.out + ")"
		end

	datatype_pk_char (representation: XPLAIN_PK_A_REPRESENTATION): STRING
		do
			Result :=
				datatype_varchar (representation) +
				" " +
				PrimaryKeyConstraint
		end

	datatype_pk_int (representation: XPLAIN_PK_I_REPRESENTATION): STRING
		do
			if CreateAutoPrimaryKey then
				Result :=
					datatype_int (representation) +
					" " +
					AutoPrimaryKeyConstraint
			else
				Result :=
					datatype_int (representation) +
					" " +
					PrimaryKeyConstraint
			end
		end

	datatype_varchar (representation: XPLAIN_A_REPRESENTATION): STRING
		do
			Result := "character varying(" + representation.length.out + ")"
		end


feature -- Generate constraints definitions

	sqlcheck_between (trajectory: XPLAIN_TRAJECTORY; column_name: STRING): STRING
			-- Portable SQL code for the SQL between statement;
			-- attempts to avoid output of decimal digits if this is not
			-- applicable.
		do
			Result := format ("($s between $s and $s)",
									<<column_name, trajectory.min, trajectory.max>>)
		end

	sqlcheck_boolean (restriction: XPLAIN_B_RESTRICTION; column_name: STRING): detachable STRING
			-- SQL code for domain restriction for booleans
		do
			-- Not implemented it seems??
			Result := Void
		end

	sqlcheck_in (list: XPLAIN_ENUMERATION_NODE [ANY]; column_name: STRING): STRING
		local
			s: STRING
			node: XPLAIN_ENUMERATION_NODE[ANY]
			stop: BOOLEAN
		do
			s := "(" + column_name + " in ("
			from
				node := list
				s := s + node.to_sqlcode (Current)
			until
				stop
			loop
				if attached node.next as next then
					node := next
					s := s + ", " + next.to_sqlcode (Current)
				else
					stop := True
				end
			end
			s := s + "))"
			Result := s
		end

	sqlcheck_like (a_pattern: XPLAIN_A_PATTERN; a_column_name: STRING): STRING
		require
			column_name_not_empty: a_column_name /= Void and then not a_column_name.is_empty
		do
			Result := format ("($s like '$s')", <<a_column_name, a_pattern.pattern>>)
		end

	sqlcheck_notempty (a_pattern: XPLAIN_DOMAIN_RESTRICTION; a_column_name: STRING): STRING
		require
			column_name_not_empty: a_column_name /= Void and then not a_column_name.is_empty
		do
			Result := format ("($s <> '')", <<a_column_name>>)
		end

feature -- Expression that returns the contents of a variable/value

	sqlgetvalue (a_value: XPLAIN_VALUE): STRING
			-- SQL expression to retrieve the value of a value
		require
			valid: a_value /= Void
		do
			Result := sqlgetvalue_outside_sp (a_value)
		ensure
			sqlgetvalue_not_empty: Result /= Void and then not Result.is_empty
		end


	sqlgetvalue_outside_sp (a_value: XPLAIN_VALUE): STRING
			-- SQL expression to retrieve the value of a value
		require
			valid: a_value /= Void
			--outside_sp: not is_stored_procedure
		do
			Result := format ("(select $s from $s)", <<a_value.quoted_name (Current), ValueTableName>>)
			-- Literal support for variables disabled as it could have
			-- unexpected side effects when Xplain is combined with
			-- SQL. Also wouldn't work inside loops for example if updated.
-- 			if value.expression.is_literal then
-- 				Result := value.expression.sqlvalue (Current)
-- 			else
-- 				Result := format ("(select $s from $s)", <<value.quoted_name (Current), ValueTableName>>)
-- 			end
		ensure
			sql_not_empty: Result /= Void and then not Result.is_empty
		end

	sqlgetconstant (variable: XPLAIN_VARIABLE): STRING
			-- SQL expression to retrieve the value of a constant
		do
			if attached variable.value as value then
				if value.is_literal then
					Result := value.sqlvalue (Current)
				else
					Result := "(select " + variable.quoted_name (Current) + " from " + ConstantTableName + ")"
				end
			else
				std.error.put_string (format("The value of constant '$s' has not yet been set.%N", <<variable.name>>))
				Result := "no value"
			end
		end


feature -- generate columns either base or type columns

	sqlcolumnidentifier_base (base: XPLAIN_BASE; role: detachable STRING): STRING
			-- Column name for a `base'
		require
			base_not_void: base /= Void
		local
			s: STRING
		do
			if role = Void then
				s := base.name
			else
				create s.make (role.count + 1 + base.name.count)
				s.append_string (role)
				s.append_character ('_')
				s.append_string (base.name)
			end
			Result := make_valid_identifier (s)
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sqlcolumnidentifier_type (type: XPLAIN_TYPE; role: detachable STRING): STRING
			-- Column name for a `type'
		require
			type_not_void: type /= Void
		local
			s: STRING
		do
			if role = Void then
				s := table_pk_name(type)
			else
				s := role + "_" + type.sqlname(Current)
			end
			Result := make_valid_identifier (s)
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	columndatatype_base (base: XPLAIN_BASE): STRING
			-- should return a quoted name if necessary
		do
			if CreateDomains then
				Result := quote_identifier (domain_identifier (base))
			else
				Result := base.representation.datatype (Current)
			end
		end

	columndatatype_type (type: XPLAIN_TYPE): STRING
		do
			Result := type.representation.datatype (Current)
		end

	columndatatype_assertion (assertion: XPLAIN_ASSERTION): STRING
			-- Data type of assertion; data type is implicit so this
			-- returns a valid SQL expression like "computed by price *
			-- amount"
		do
			if attached asserted_format_string as f then
				Result := format (f, <<assertion.expression.sqlvalue (Current)>>)
			else
				Result := precursor (assertion)
			end
		end

	sqlcolumndefault_base (an_attribute: XPLAIN_ATTRIBUTE): detachable STRING
			-- Produce SQL that defines the default for a base column
		do
			if
				attached an_attribute.init as init and then
				(init.is_constant or else
				 (ExpressionsInDefaultClauseSupported and then init.is_literal))
			then
				Result := init.sqlvalue (Current)
			end
		end

	sqlcolumndefault_type (an_attribute: XPLAIN_ATTRIBUTE): detachable STRING
			-- Produce SQL that defines default for a type column
		do
			if attached an_attribute.init as init and then init.is_literal then
				Result := init.sqlvalue (Current)
			end
		end

	sqlcolumnrequired_base (an_attribute: XPLAIN_ATTRIBUTE): READABLE_STRING_GENERAL
			-- Produce null or not null status of a column that is a base
		do
			if an_attribute.overrule_required then
				Result := column_null_or_not_null (an_attribute.is_required)
			else
				if not CreateDomains then
					check attached an_attribute.abstracttype as abstracttype and then attached abstracttype.representation.domain_restriction as domain_restriction then
						Result := column_null_or_not_null (domain_restriction.required)
					end
				else
					Result := ""
				end
			end
		end

	sqlcolumnrequired_type (an_attribute: XPLAIN_ATTRIBUTE): READABLE_STRING_GENERAL
			-- Produce null or not null status of a column that refers to a type
		do
			if an_attribute.overrule_required then
				Result := column_null_or_not_null (an_attribute.is_required)
			else
				check attached an_attribute.abstracttype as abstracttype and then attached abstracttype.representation.domain_restriction as domain_restriction then
					Result := column_null_or_not_null (domain_restriction.required)
				end
			end
		end

	init_forced_default (an_attribute: XPLAIN_ATTRIBUTE): BOOLEAN
			-- Does this attribute have an init that has to be converted
			-- to a after-insert style trigger?
		require
			attribute_not_void: an_attribute /= Void
		deferred
		end

	init_forced_null (an_attribute: XPLAIN_ATTRIBUTE): BOOLEAN
			-- Does this attribute have a init default that has to be
			-- converted to a after-insert style trigger?
		require
			attribute_not_void: an_attribute /= Void
		deferred
		end


feature -- Functions

	sqlfunction_any: STRING once Result := SQLTrue end
	sqlfunction_count: STRING once Result := "count" end
	sqlfunction_max: STRING once Result := "max" end
	sqlfunction_min: STRING once Result := "min" end
	sqlfunction_nil: STRING once Result := SQLFalse end
	sqlfunction_some: STRING once Result := "" end
	sqlfunction_total: STRING once Result := "sum" end


feature -- ANSI niladic functions

	sqlsysfunction_current_timestamp: STRING
		once
			Result := "CURRENT_TIMESTAMP"
		end

	sqlsysfunction_system_user: STRING
		once
			Result := "SYSTEM_USER"
		end


feature -- Return sql code

	sql_expression_as_boolean_value (expression: XPLAIN_EXPRESSION): STRING
			-- Return SQL code for expression that is a logical
			-- expression. For SQL dialects that don't support Booleans,
			-- it might need to map the Boolean result to a 'T' or 'F'
			-- value.
		require
			expression_not_void: expression /= Void
		do
			Result := expression.sqlvalue (Current)
		ensure
			not_void: Result /= Void
		end

	sql_extension_function (an_expression: XPLAIN_EXTENSION_FUNCTION_EXPRESSION): STRING
		require
			expression_not_void: an_expression /= Void
		do
			if an_expression.supports_left_outer_join then
				Result := sql_select_function_as_left_outer_join (an_expression)
			else
				Result := once "(" + sql_select_function_as_subselect (an_expression.selection) + once ")"
			end
		end

	sql_infix_expression (a_left: XPLAIN_EXPRESSION; an_operator: STRING; a_right: XPLAIN_EXPRESSION): STRING
			-- SQL expression for multiplication/division, etc.
		require
			valid_left: a_left /= Void
			valid_right: a_right /= Void
			operator_not_empty: an_operator /= Void and then not an_operator.is_empty
		local
			left_value,
			right_value: STRING
		do
			if
				an_operator.is_equal (once "+") and then
				(a_left.is_string_expression or else a_right.is_string_expression)
			then
				left_value := a_left.sqlvalue (Current)
				right_value := a_right.sqlvalue (Current)
				create Result.make (left_value.count + 10 + right_value.count)
				Result.append_string (sql_string_combine_start)
				Result.append_string (left_value)
				Result.append_string (sql_string_combine_separator)
				Result.append_string (right_value)
				Result.append_string (sql_string_combine_end)
			else
				left_value := a_left.sqlvalue (Current)
				right_value := a_right.sqlvalue (Current)
				create Result.make (left_value.count + 1 + an_operator.count + 1 + right_value.count)
				Result.append_string (left_value)
				Result.append_character (' ')
				Result.append_string (an_operator)
				Result.append_character (' ')
				Result.append_string (right_value)
			end
		ensure
			sql_infix_expression_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_infix_expression_as_wildcard (a_left: XPLAIN_EXPRESSION; an_operator: STRING; a_right: XPLAIN_EXPRESSION): STRING
			-- SQL infix expression when a wildcard is involved
		require
			valid_left: a_left /= Void
			valid_right: a_right /= Void
			operator_not_empty: an_operator /= Void and then not an_operator.is_empty
		local
			left_value,
			right_value: STRING
		do
			left_value := a_left.sqlvalue_as_wildcard (Current)
			right_value := a_right.sqlvalue_as_wildcard (Current)
			create Result.make (left_value.count + 1 + an_operator.count + 1 + right_value.count)
			Result.append_string (left_value)
			Result.append_character (' ')
			Result.append_string (an_operator)
			Result.append_character (' ')
			Result.append_string (right_value)
		ensure
			sql_infix_expression_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_combine_expression (a_list: XPLAIN_EXPRESSION_NODE): STRING
			-- SQL expression to combine strings
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
				Result.append_string (n.item.sqlvalue (Current))
				n := n.next
				if n /= Void then
					Result.append_string (sql_string_combine_separator)
				end
			end
			Result.append_string (sql_string_combine_end)
		ensure
			sql_combine_expression_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_combine_expression_as_wildcard (a_list: XPLAIN_EXPRESSION_NODE): STRING
			-- SQL expression to combine strings, potentially resulting
			-- in a wildcard
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
				Result.append_string (n.item.sqlvalue_as_wildcard (Current))
				n := n.next
				if n /= Void then
					Result.append_string (sql_string_combine_separator)
				end
			end
			Result.append_string (sql_string_combine_end)
		ensure
			sql_combine_expression_as_wildcard_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_not_expression (expression: XPLAIN_EXPRESSION): STRING
			-- Return the SQL code that this `expression' is not True.
		do
			if SupportsTrueBoolean then
				Result := format ("(not $s)", <<expression.sqlvalue (Current)>>)
			else
				Result := format ("($s = $s)", <<expression.sqlvalue (Current), SQLFalse>>)
			end
		ensure
			sql_not_expression_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_notnot_expression (expression: XPLAIN_EXPRESSION): STRING
			-- Return the SQL code that this `expression' is True.
		do
			if SupportsTrueBoolean then
				Result := expression.sqlvalue (Current)
			else
				Result := format ("($s = $s)", <<expression.sqlvalue (Current), SQLTrue>>)
			end
		ensure
			sql_notnot_expression_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_predicate (subject: XPLAIN_SUBJECT; predicate: detachable XPLAIN_EXPRESSION): STRING
			-- Generate a where clause.
		require
			subject_not_void: subject /= Void
		local
			code: STRING
			surround_with_parentheses: BOOLEAN
		do
			create code.make (64)

			if attached subject.identification as identification then
				-- support for get type "1"
				if WhereWritten then
					code.append_string (once " and %N")
				else
					code.append_character ('%N')
					code.append_string (Tab)
					code.append_string (once "where%N")
					WhereWritten := True
				end
				code.append_string (Tab)
				code.append_string (Tab)
				code.append_string (quote_identifier (subject.type.sqlname (Current)))
				code.append_character ('.')
				code.append_string (quote_identifier (subject.type.sqlpkname (Current)))
				code.append_string (once " = ")
				code.append_string (identification.sqlvalue (Current))
			end

			if predicate /= Void then
				if WhereWritten then
					-- remainig clause can contain ors so make sure we
					-- employ parenthesis to and properly
					code.append_string (once " and")
					--surround_with_parentheses := subject.identification /= Void
					surround_with_parentheses := WhereWritten
				else
					code.append_character ('%N')
					code.append_string (Tab)
					code.append_string (once "where")
				end
				code.append_string ("%N" + Tab + Tab)
				if surround_with_parentheses then
					code.append_character ('(')
				end
				code.append_string (predicate.sqlvalue (Current))
				if surround_with_parentheses then
					code.append_character (')')
				end
			end
			Result := code
			WhereWritten := False -- reset local state
		ensure
			valid_result: Result /= Void
			local_state_reset: not WhereWritten
		end

	sql_last_auto_generated_primary_key	(type: XPLAIN_TYPE): STRING
			-- Return code to get the last auto-generated primary key for
			-- `type'. Certain SQL dialects can only return the last
			-- generated key, so this code is not guaranteed to be `type'
			-- specific.
		do
			-- Instead of requiring AutoPrimaryKeySupported we attempt to
			-- fail gracefully, helps in running my test scripts against
			-- all supported dialects.
			if not AutoPrimaryKeySupported then
				std.error.put_string ("Cannot return last auto-generated primary key, because this dialect does not support auto-generated primary keys.%N")
			end
			Result := "0"
		ensure
			not_void: Result /= Void
		end

	sql_select_for_extension_expression (an_expression: XPLAIN_EXTENSION_EXPRESSION): STRING
			-- SQL for the full select statement that emits the data used
			-- to create an extension based on an attribute expression.
		local
			join_list: JOIN_LIST
			table_alias: STRING
			optimised: BOOLEAN
		do
			check attached an_expression.extension as extension and then attached extension.type as type then
			optimised := an_expression.is_logical_expression and extension.no_update_optimization

			-- build join statements (applies only to expression extension)
			create join_list.make (type)
			if optimised then
				-- an_expression is used in where clause
				join_list.enable_existential_join_optimisation
			end
			an_expression.add_to_join (Current, join_list)
			join_list.finalize (Current)

			create Result.make (256)
			if not an_expression.sqlfromaliasname.is_empty then
				table_alias := quote_identifier (an_expression.sqlfromaliasname)
			else
				table_alias := type.quoted_name (Current)
			end
			Result.append_string (once "select ")
			Result.append_string (table_alias)
			Result.append_character ('.')
			Result.append_string (type.q_sqlpkname (Current))
			Result.append_string (once ", ")
			if an_expression.is_logical_expression and extension.no_update_optimization then
				Result.append_string (SQLTrue)
			else
				Result.append_string (an_expression.sqlvalue (Current))
			end
			Result.append_character ('%N')
			Result.append_string (Tab)
			Result.append_string (once "from ")
			Result.append_string (type.quoted_name (Current))
			if not an_expression.sqlfromaliasname.is_empty then
				Result.append_character (' ')
				Result.append_string (table_alias)
			end
			Result.append_string (sql_select_joins (join_list))
			if optimised then
				Result.append_character ('%N')
				Result.append_string (Tab)
				Result.append_string (once "where%N")
				Result.append_string (TabTab)
				Result.append_string (an_expression.sqlvalue (Current))
			end
			end
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	sql_select_for_extension_function (an_expression: XPLAIN_EXTENSION_FUNCTION_EXPRESSION; an_extension: XPLAIN_ABSTRACT_EXTENSION): STRING
			-- SQL for the full select statement that emits the data used
			-- to create an extension based on a function.
		require
			expression_not_void: an_expression /= Void
			extension_not_void: an_extension /= Void
		do
			-- It's better to use (left outer) joins these days, so if
			-- possible, we'll use that.
			if an_expression.supports_left_outer_join then
				Result := do_sql_select_for_extension_function (an_expression, an_extension)
			else
				Result := sql_select_for_extension_expression (an_expression)
			end
		end

	do_sql_select_for_extension_function (an_expression: XPLAIN_EXTENSION_FUNCTION_EXPRESSION; an_extension: XPLAIN_ABSTRACT_EXTENSION): STRING
			-- SQL for the full select statement that emits the data used
			-- to create an extension based on a function.
		require
			expression: an_expression /= Void
			extension_not_void: an_extension /= Void
			--2008-10-10: I think they're now?
			--predicate_not_supported: an_expression.selection.predicate = Void
		local
			type: XPLAIN_TYPE
			join_list: JOIN_LIST
			use_where_clause: BOOLEAN
			group_by_elimination: BOOLEAN
			distinct_elimination: BOOLEAN
		do
			check attached an_expression.per_property.last as last then
			type := last.item.type

			-- build join statements (applies only to expression extension)
			create join_list.make (type)
			an_expression.add_to_join (Current, join_list)
			join_list.finalize (Current)
			-- We prefer to append the where clause to the "on" part, but
			-- that's only possible if the where clause doesn't have an
			-- its (or an extend attribute, but that's also caught by
			-- this test).
			use_where_clause := attached an_expression.selection.predicate as predicate and then predicate.uses_its
			--use_where_clause := True

			-- Code
			create Result.make (256)
			Result.append_string (once "select ")
			if an_expression.selection.function.is_existential then
				distinct_elimination :=
					not attached an_expression.per_property.next and then
					attached an_expression.per_property.item.type_attribute as ta and then
					ta.is_specialization
				if not distinct_elimination then
					Result.append_string (once "distinct ")
				end
			end
			Result.append_string (type.quoted_name (Current))
			Result.append_character ('.')
			Result.append_string (type.q_sqlpkname (Current))
			Result.append_string (once ", ")
			Result.append_string (an_expression.sqlvalue (Current))
			Result.append_character ('%N')
			Result.append_string (Tab)
			Result.append_string (once "from ")
			Result.append_string (type.quoted_name (Current))
			Result.append_string (sql_select_joins (join_list))
			-- With a where clause we get only some rows from `type', not all...
			-- So that's why we add the where parts to the on clause if
			-- that's possible
			if not use_where_clause then
				WhereWritten := True
			end
			Result.append_string (sql_predicate (an_expression.selection.subject, an_expression.selection.predicate))

			-- If we join to a single specialization, we do not need the
			-- group by as there is only 0 or 1 row.
			-- Note that we should actually only come here if the group
			-- by can be eliminated. It just looks faster if SQL doesn't
			-- have to count all the rows, if we are only interested in
			-- existence. But the code is still here in case we want to
			-- experiment with it.
			-- Note 2: there is some indication that the generated code
			-- with a group by is incorrect. Try it with the Drupal Focus
			-- process, the list of my processes is wrong on that case.
			-- This seems to happen when an extend with a where clause is
			-- used, and the extend is updated. A left outer join is used
			-- in that case, but it counts entirely different things in
			-- this case.
			group_by_elimination :=
				an_expression.selection.function.is_existential
			if not group_by_elimination then
				Result.append_character ('%N')
				Result.append_string (Tab)
				Result.append_string (once "group by%N")
				Result.append_string (TabTab)
				Result.append_string (type.quoted_name (Current))
				Result.append_character ('.')
				Result.append_string (type.q_sqlpkname (Current))
			end

			-- Unfortunately with a where clause we miss certain rows, so
			-- they need to be added to the temporary table if the extend
			-- will be updated. If the extend is not updated, we use an
			-- optimisation to avoid this, i.e. use joins to create the
			-- temporary table, and left outer joins when using the temporary
			-- table.
			if use_where_clause and not an_extension.no_update_optimization then
				Result.append_string (CommandSeparator)
				Result.append_character ('%N')
				Result.append_character ('%N')
				Result.append_string (sql_extend_insert_missing_rows (an_expression, an_extension))
			end
			end
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	sql_extend_insert_missing_rows (an_expression: XPLAIN_EXTENSION_FUNCTION_EXPRESSION; an_extension: XPLAIN_ABSTRACT_EXTENSION): STRING
			-- An extend with a where clause will make the initial insert
			-- into the temporary table to be only a partial on. Missing
			-- rows are added here. But MySQL does not support self
			-- selects against tempory tables so for MySQL it's a two
			-- step process.
		require
			expression: an_expression /= Void
			extension_not_void: an_extension /= Void
			per_property_has_last: attached an_expression.per_property.last
		local
			type: XPLAIN_TYPE
		do
			check attached an_expression.per_property.last as last then
			type := last.item.type
			create Result.make (512)
			Result.append_string (once "insert into ")
			Result.append_string (TemporaryTablePrefix)
			Result.append_string (quote_identifier (an_extension.sqlname (Current)))
			Result.append_string (once " (")
			Result.append_string (quote_identifier (an_extension.type.sqlpkname (Current)))
			Result.append_string (once ", ")
			Result.append_string (an_extension.q_sql_insert_name (Current, Void))
			Result.append_string (once ")%N")
			Result.append_string (Tab)
			Result.append_string (once "select ")
			Result.append_string (type.q_sqlpkname (Current))
			Result.append_string (once ", ")
			Result.append_string (an_expression.selection.function.sqlextenddefault (Current, an_expression))
			Result.append_string (once " from ")
			Result.append_string (type.quoted_name (Current))
			Result.append_string (once " where ")
			Result.append_string (type.q_sqlpkname (Current))
			Result.append_string (once " not in (select ")
			Result.append_string (quote_identifier (an_extension.type.sqlpkname (Current)))
			Result.append_string (once " from ")
			Result.append_string (TemporaryTablePrefix)
			Result.append_string (quote_identifier (an_extension.sqlname (Current)))
			Result.append_string (once ")")
			end
		end

	sql_select_function_as_subselect (selection_list: XPLAIN_SELECTION_FUNCTION): STRING
			-- Full sql code for a subselect with function;
			-- Code is not surrounded by any parentheses.
		require
			selection_list_not_void: selection_list /= Void
		local
			join_list: JOIN_LIST
			code: STRING
			surround_column_with_parentheses: BOOLEAN
			from_table: detachable STRING
			surround_function_with_coalesce: BOOLEAN
			column_name: STRING
		do
			create code.make (128)

			-- build join statements
			create join_list.make (selection_list.type)
			selection_list.add_to_join (Current, join_list)
			join_list.finalize (Current)

			-- start select statement.
			code.append_character ('%N')
			code.append_string (once "select ")

			-- The first important distinction is if the SQL function can
			-- return a Null value or not. If so, we need to surround it
			-- with coalesce so we always get a scalar value. Matter of
			-- fact, only count and some do not need it.
			surround_function_with_coalesce :=
				CoalesceSupported and then
				selection_list.function.needs_coalesce
			if surround_function_with_coalesce then
				code.append_string (SQLCoalesce)
				code.append_character ('(')
				if selection_list.function.is_existential and then ExistentialFromNeeded then
					-- I'm unsure here if I do this of we `can_be_null'?
					-- Or if it is needed. Anyway, most dialects have a
					-- dual table, and else I should create/emit one with
					-- Xplain I suppose.
					code.append_string (once "(select ")
				end
			end

			-- The second is if the SQL function can return more then one
			-- value, in that case we need to limit it. Only the
			-- conversion for the some function needs that. The any or
			-- nil might need it in case we have to output a from clause
			-- for this select statement.
			if selection_list.function.needs_limit (Current) then
				code.append_string (sql_select_function_limit_before (selection_list))
			end

			if selection_list.function.is_existential then
				if CoalesceSupported and not ExistentialFromNeeded then
					code.append_string (once "(select ")
				end
			end
			code.append_string (selection_list.function.sqlfunction (Current))
			if selection_list.function.is_existential then
				code.append_character ('%N')
				code.append_string (Tab)
				if ExistentialFromNeeded then
					code.append_string (once "from ")
					from_table := ExistentialFromTable
					if from_table = Void then
						code.append_string (selection_list.type.quoted_name (Current))
					else
						code.append_string (from_table)
					end
					code.append_character ('%N')
					code.append_string (Tab)
				end
				code.append_string (once "where exists (%N" + Tab + "select ")
			else
				code.append_character (' ')
			end

			-- Output for the column that is counted/maxed/etc
			surround_column_with_parentheses :=
				not selection_list.function.needs_limit (Current) and
				not selection_list.function.is_existential
			if surround_column_with_parentheses then
				code.append_character ('(')
			end
			if not attached selection_list.property as property then
				if selection_list.function.needs_limit (Current) then
					if not selection_list.function.is_existential then
						-- for the some function we need the instance identifier
						code.append_string (selection_list.type.quoted_name (Current))
						code.append_character ('.')
						code.append_string (selection_list.type.q_sqlpkname (Current))
					else
						-- but for any/nil we can get away with emiting a
						-- constant. This is mainly for MySQL which is quite
						-- a bit faster if you don't specify a column. But
						-- could have used a '*' as well, MySQL treats that
						-- the same as a constant. But just in case any
						-- other dialect finds a constant faster, we specify
						-- a constant here.
						code.append_character ('1')
					end
				else
					code.append_character ('*')
				end
			else
				if selection_list.function.needs_distinct then
					code.append_string (once "distinct ")
				end
				if CoalesceSupported and then property.can_be_null then
					code.append_string (SQLCoalesce)
					code.append_character ('(')
				end
				code.append_string (property.sqlvalue (Current))
				if CoalesceSupported and then property.can_be_null then
					code.append_string (once ", ")
					code.append_string (selection_list.function.sqlextenddefault (Current, selection_list.property))
					code.append_character (')')
				end
			end
			if surround_column_with_parentheses then
				code.append_character (')')
			end

			-- If in coalesce, output the coalesced value, but only if
			-- we're not producing an existence test.
			if not selection_list.function.is_existential then
				if surround_function_with_coalesce then
					code.append_string (once ", ")
					code.append_string (selection_list.function.sqlextenddefault (Current, selection_list.property))
					code.append_character (')')
				end
				code.append_string (once " as ")
				if not attached selection_list.property as property then
					column_name := selection_list.function.name + once " " + selection_list.subject.type.sqlname (Current)
				else
					if attached property.column_name as c then
						column_name := selection_list.function.name + once " " + c
					else
						column_name := selection_list.function.name
					end
				end
				code.append_string (quote_valid_identifier (column_name))
			end

			-- write from/join clause
			code.append_character ('%N')
			code.append_string (Tab)
			code.append_string (once "from ")
			code.append_string (quote_identifier(selection_list.type.sqlname (Current)))
			code.append_string (sql_select_joins (join_list))

			-- write where
			code.append_string (sql_predicate (selection_list.subject, selection_list.predicate))

			if selection_list.function.is_existential then
				code.append_character (')')
				-- For the existence test, we have to close the coalesce.
				-- The assumption is that we wrote a coalesce in the first place.
				if surround_function_with_coalesce then
					-- close the subselect
					code.append_character (')')
					code.append_string (once ", ")
					code.append_string (selection_list.function.sqlextenddefault (Current, selection_list.property))
					code.append_character (')')
					code.append_string (once " as ")
					code.append_string (quote_valid_identifier (selection_list.function.name + " " + selection_list.subject.type.name))
				end
				-- I don't think you want this code.
				-- Emit a dual table if a dialect doesn't have one.
				if ExistentialFromNeeded and then CoalesceSupported then
					code.append_string (once " from ")
					from_table := ExistentialFromTable
					if from_table = Void then
						code.append_string (selection_list.type.quoted_name (Current))
					else
						code.append_string (from_table)
					end
				end
			end
			if selection_list.function.needs_limit (Current) then
				code.append_string (sql_select_function_limit_after)
			end

			Result := code
		end

	sql_select_function_as_left_outer_join (an_expression: XPLAIN_EXTENSION_FUNCTION_EXPRESSION): STRING
			-- SQL expression for this Xplain function, does not include
			-- the left outer join code which should be added by the
			-- statements that can have an XPLAIN_SELECTION_FUNCTION.
		require
			expression_not_void: an_expression /= Void
			supports_left_outer_join: an_expression.supports_left_outer_join
		local
			surround_column_with_parentheses: BOOLEAN
			surround_function_with_coalesce: BOOLEAN
			selection_list: XPLAIN_SELECTION_FUNCTION
		do
			selection_list := an_expression.selection
			create Result.make (128)

			-- The first important distinction is if the SQL function can
			-- return a Null value or not. If so, we need to surround it
			-- with coalesce so we always get a scalar value. Matter of
			-- fact, only count and some do not need it.
			-- Because any/nil is implemented with count they don't need it either.
			surround_function_with_coalesce :=
				CoalesceSupported and then
				selection_list.function.needs_coalesce and then
				(not selection_list.function.is_existential)
			if surround_function_with_coalesce then
				Result.append_string (SQLCoalesce)
				Result.append_character ('(')
			end

			-- The second is if the SQL function can return more then one
			-- value, in that case we need to limit it. Only the
			-- conversion for the some function needs that. The any or
			-- nil might need it in case we have to output a from clause
			-- for this select statement.
			if not selection_list.function.is_existential and then selection_list.function.needs_limit (Current) then
				Result.append_string (sql_select_function_limit_before (selection_list))
			end

			if selection_list.function.is_existential and then attached an_expression.extension as extension and then extension.no_update_optimization then
				Result.append_string (selection_list.function.sqlfunction (Current))
			else
				if selection_list.function.is_existential then
					Result.append_string (once "case ")
					Result.append_string (once "when")
				else
					Result.append_string (selection_list.function.sqlfunction (Current))
				end

				Result.append_character (' ')

				-- Output for the column that is counted/maxed/etc
				surround_column_with_parentheses :=
					not selection_list.function.needs_limit (Current)
				if surround_column_with_parentheses then
					Result.append_character ('(')
				end
				if not attached selection_list.property as property then
					if selection_list.function.property_required = 0 then
						Result.append_character ('*')
					else
						-- for the some/count function we need the instance identifier
						Result.append_string (selection_list.type.quoted_name (Current))
						Result.append_character ('.')
						Result.append_string (selection_list.type.q_sqlpkname (Current))
					end
				else
					if selection_list.function.needs_distinct then
						Result.append_string (once "distinct ")
					end
					if CoalesceSupported and then property.can_be_null then
						Result.append_string (SQLCoalesce)
						Result.append_character ('(')
					end
					Result.append_string (property.sqlvalue (Current))
					if CoalesceSupported and then property.can_be_null then
						Result.append_string (once ", ")
						Result.append_string (selection_list.function.sqlextenddefault (Current, selection_list.property))
						Result.append_character (')')
					end
				end
				if surround_column_with_parentheses then
					Result.append_character (')')
				end

				-- If in coalesce, output the coalesced value, but only if
				-- we're not producing an existence test.
				if surround_function_with_coalesce then
					Result.append_string (once ", ")
					Result.append_string (selection_list.function.sqlextenddefault (Current, selection_list.property))
					Result.append_character (')')
				elseif selection_list.function.is_existential then
					Result.append_string (once " is null")
					Result.append_string (once " then ")
					Result.append_string (selection_list.function.sqlextenddefault (Current, selection_list.property))
					Result.append_string (once " else ")
					Result.append_string (selection_list.function.sqlfunction (Current))
					Result.append_string (once " end")
				end
			end
		end

	sql_select_function_limit_before (selection_list: XPLAIN_SELECTION_FUNCTION): STRING
			-- Code that limits a select to return a single value. Output
			-- is placed in front of the select statement.
			-- Returns empty for no output.
		once
			-- You probably don't want this result if you implement
			-- `sqlfunction_some'.
			Result := "distinct "
		ensure
			not_void: Result /= Void
		end

	sql_select_function_limit_after: STRING
			-- Code that limits a select to return a single value. Output
			-- is placed after the select statement.
			-- Returns empty for no output.
		once
			Result := ""
		ensure
			result_not_void: Result /= Void
		end

	sql_select_instance (selection_list: XPLAIN_SELECTION_INSTANCE): STRING
		-- Return sql code for select of a single instance.
		require
			valid_selection: selection_list /= Void
		local
			join_list: JOIN_LIST
			code: STRING
			type: XPLAIN_TYPE
		do
			create code.make (128)
			type := selection_list.type

			-- build join statements
			create join_list.make (selection_list.type)
			selection_list.add_to_join (Current, join_list)
			join_list.finalize (Current)

			-- start select statement
			code.append_character ('%N')
			code.append_string ("select ")
			code.append_string (selection_list.property.sqlvalue (Current))

			-- write from/join clause
			code.append_string ("%N" + Tab + "from ")
			code.append_string (quote_identifier (selection_list.type.sqlname (Current)))
			code.append_string (sql_select_joins (join_list))

			-- where instance
			if WhereWritten then
				code.append_string (" and%N")
			else
				code.append_character ('%N')
				code.append_string (Tab + "where%N")
			end
			code.append_string (Tab + Tab)
			code.append_string (quote_identifier(type.sqlname (Current)))
			code.append_string (".")
			code.append_string (quote_identifier(type.sqlpkname (Current)))
			code.append_string (" = ")
			check attached selection_list.subject.identification as identification then
				if type.representation.write_with_quotes then
					code.append_string ("'")
					code.append_string (identification.sqlvalue (Current))
					code.append_string ("'")
				else
					code.append_string (identification.sqlvalue (Current))
				end
			end
			Result := code
			WhereWritten := False
		ensure
			local_state_reset: not WhereWritten
		end

	sql_select_joins (join_list: JOIN_LIST): STRING
			-- SQL join statement either in the new ANSI SQL 92 form or
			-- in the older format
		require
			valid_join_list: join_list /= Void
			finalized: join_list.is_finalized
		do
			if ANSI92JoinsSupported then
				Result := sql_select_joins_ansi92 (join_list)
			else
				Result := sql_select_joins_oldstyle (join_list)
			end
		end

	sql_select_joins_ansi92 (join_list: JOIN_LIST): STRING
			-- `join_list' as ANSI-92 style join statements
		require
			cursos_pos: True -- at end of line
			valid_join_list: join_list /= Void
		local
			jnode: detachable JOIN_NODE
			tablename,
			alias_name: STRING
			code: STRING
		do
			create code.make (128)
			from
				jnode := join_list.first
			until
				jnode = Void
			loop
				code.append_string (once "%N" + Tab)
				if jnode.item.is_inner_join then
					code.append_string (once "inner join ")
				else
					code.append_string (once "left outer join ")
				end
				tablename := jnode.item.aggregate_attribute.quoted_name (Current)
				code.append_string (tablename)
				alias_name := quote_identifier (jnode.item.attribute_alias_name)
				if not STRING_.same_string (tablename, alias_name) then
					-- only write alias when not equal to table/view name
					code.append_character (' ')
					code.append_string (alias_name)
				end
				code.append_string (once " on%N")
				code.append_string (Tab)
				code.append_string (Tab)
				code.append_string (quote_identifier (jnode.item.attribute_alias_name))
				code.append_character ('.')
				if jnode.item.is_upward_join then
					code.append_string (quote_identifier (jnode.item.aggregate_fk))
				else
					code.append_string (quote_identifier (jnode.item.aggregate_attribute.sqlpkname (Current)))
				end
				code.append_string (once " = ")
				code.append_string (quote_identifier (jnode.item.aggregate_alias_name))
				code.append_character ('.')
				if jnode.item.is_upward_join then
					code.append_string (quote_identifier (jnode.item.aggregate.sqlpkname (Current)))
				else
					code.append_string (quote_identifier (jnode.item.aggregate_fk))
				end
				jnode := jnode.next
			end
			Result := code
		ensure
			cursos_pos: -- cursor after last generated character
		end

	sql_select_joins_oldstyle (join_list: JOIN_LIST): STRING
			-- return old style join statements
		require
			cursos_pos: True -- at end of line
			valid_join_list: join_list /= Void
		local
			jnode: detachable JOIN_NODE
			tablename: STRING
			code: STRING
		do
			create code.make (512)

			-- write from clause
			from
				jnode := join_list.first
			until
				jnode = Void
			loop
				code := code + ", "
				tablename := jnode.item.aggregate_attribute.sqlname (Current)
				code := code + quote_identifier(tablename)
				if not equal(tablename, jnode.item.attribute_alias_name) then
					-- only write alias when not equal to table/view name
					code := code + " "
					code := code + quote_identifier(jnode.item.attribute_alias_name)
				end
				jnode := jnode.next
			end

			-- write where clause
			from
				jnode := join_list.first
				if jnode /= Void then
					code := code + "%N" + Tab + "where%N" + Tab + Tab + "("
					WhereWritten := True -- no conflict when writing predicate
				end
			until
				jnode = Void
			loop
				code := code + quote_identifier(jnode.item.attribute_alias_name)
				code := code + "."
				code := code + quote_identifier(jnode.item.aggregate_attribute.sqlpkname (Current))
				code := code + " = "
				code := code + quote_identifier(jnode.item.aggregate_alias_name)
				code := code + "."
				code := code + quote_identifier(jnode.item.aggregate_fk)
				jnode := jnode.next
				if jnode /= Void then
					code := code + " and%N" + Tab + Tab
				else
					code := code + ")"
				end
			end

			Result := code
		ensure
			cursos_pos: -- cursor after last generated character
		end

	sql_subselect_for_attribute (an_its_list: XPLAIN_ATTRIBUTE_NAME_NODE): STRING
			-- SQL code to return a complex attribute using a subselect;
			-- Used in update statements for dialects that don't support
			-- complex updates.
		require
			list_not_void: an_its_list /= Void
			--is_list: an_its_list.next /= Void
		local
			join_list: JOIN_LIST
		do
			create Result.make (512)
			Result.append_string (once "( select ")
			check attached update_type as ut then
				if attached an_its_list.next as n and then attached an_its_list.last as last then
					create join_list.make (an_its_list.item.type)
					join_list.extend (Current, n)
					join_list.finalize (Current)
						check attached last.prefix_table as p then
					Result.append_string (quote_identifier (p))
						end
					Result.append_character ('.')
					Result.append_string (last.item.quoted_name (Current))
					Result.append_string (once " from ")
					Result.append_string (an_its_list.item.type.quoted_name (Current))
					Result.append_string (sql_select_joins (join_list))
					Result.append_string (once " where ")
					Result.append_string (an_its_list.item.type.quoted_name (Current))
					Result.append_character ('.')
					Result.append_string (an_its_list.item.type.q_sqlpkname (Current))
					Result.append_string (once " = ")
					if attached updated_extension as ue then
						Result.append_string (ue.quoted_name (Current))
						Result.append_character ('.')
						Result.append_string (ut.q_sql_select_name (Current, Void))
					else
						Result.append_string (ut.quoted_name (Current))
						Result.append_character ('.')
						Result.append_string (an_its_list.item.q_sql_select_name (Current))
					end
				else
					-- If there's no list and we still come here, an extension
					-- is updated with an attribute.
					check attached updated_extension as ue then
						Result.append_string (an_its_list.item.quoted_name (Current))
						Result.append_string (once " from ")
						Result.append_string (ut.quoted_name (Current))
						Result.append_string (once " where ")
						Result.append_string (ut.q_sql_select_name (Current, Void))
						Result.append_string (once " = ")
						Result.append_string (ue.quoted_name (Current))
						Result.append_character ('.')
						Result.append_string (ut.q_sql_select_name (Current, Void))
					end
				end
			end
			Result.append_string (once " )")
		end

	sql_subselect_for_extension (extension: XPLAIN_ABSTRACT_EXTENSION): STRING
			-- Extension value using subselect to join to type
		do
			create Result.make (512)
			Result.append_string ("( select ")
			Result.append_string (extension.sql_qualified_name (Current, Void))
			Result.append_string (" from ")
			--Result.append_string (TemporaryTablePrefix)
			Result.append_string (extension.quoted_name (Current))
			Result.append_character (' ')
			Result.append_string (quote_identifier (extension.sqlname (Current)))
			Result.append_string (" where ")
			Result.append_string (extension.quoted_name (Current))
			Result.append_character('.')
			Result.append_string (quote_identifier (extension.sqlcolumnidentifier (Current, Void)))
			Result.append_string (" = ")
			-- Distinguish between the case of updating an extension
			-- table with another extension or updating the type with an
			-- extension.
			if not attached updated_extension as ue then
				Result.append_string (extension.type.quoted_name (Current))
			else
				Result.append_string (ue.quoted_name (Current))
			end
			Result.append_character('.')
			Result.append_string (quote_identifier (extension.type.sqlpkname (Current)))
			Result.append_string (" )")
		end


feature -- Some sp functions that are needed by clients

	sp_define_in_param (name: STRING): STRING
			-- Return `name' formatted as an sp input parameter, as it
			-- should appear in the header/definition of a stored
			-- procedure.
			-- Certain dialects have conventions for this like using a
			-- '@' in front of every identifier. Spaces and such should
			-- be removed if necessary, or the entry should be quoted if
			-- that is supported for sp's.
		require
			named_parameters_supported: NamedParametersSupported
			name_not_empty: name /= Void and then not name.is_empty
		deferred
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_define_param_name (name: STRING): STRING
			-- Return `name' formatted as the name of the parameter as it
			-- appears in the header, and hopefully as it is known to
			-- clients. It must be quoted, if it can be quoted.
		require
			name_not_empty: name /= Void and then not name.is_empty
		deferred
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_delete_name (type: XPLAIN_TYPE): STRING
			-- Name of stored procedure that deletes an instance of a type
		require
			type_not_void: type /= Void
		deferred
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_function_type_for_selection (selection: XPLAIN_SELECTION; an_emit_path: BOOLEAN): STRING
			-- The function type for output of a get statement.
			-- Required for PostgreSQL output.
		require
			selection_not_void: selection /= Void
		do
			Result := selection.sp_function_type (Current, an_emit_path)
		ensure
			function_type_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_function_type_for_selection_list (selection: XPLAIN_SELECTION_LIST; an_emit_path: BOOLEAN): STRING
			-- The function type for output of a get statement.
			-- Required for PostgreSQL output.
		require
			selection_not_void: selection /= Void
		do
			-- Implement in PostgreSQL
			Result := ""
		ensure
			function_type_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_function_type_for_selection_value (a_column_name: STRING; a_representation: XPLAIN_REPRESENTATION; an_emit_path: BOOLEAN): STRING
			-- The function type for output of a get statement.
			-- Required for PostgreSQL output.
		require
			column_name_not_empty: a_column_name /= Void and then not a_column_name.is_empty
			representation_not_void: a_representation /= Void
		do
			-- Implement in PostgreSQL
			Result := ""
		ensure
			function_type_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_insert_name (type: XPLAIN_TYPE): STRING
			-- Name of stored procedure that inserts an instance of a type
		require
			type_not_void: type /= Void
		deferred
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_name (name: STRING): STRING
			-- Turn an Xplain name into a stored procedure name.
		require
			name_not_empty: name /= Void and then not name.is_empty
		deferred
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_prefix: STRING = "sp_"
			-- Prefix for `sp_name'

	sp_update_name (type: XPLAIN_TYPE): STRING
			-- Name of stored procedure that updates an instance of a type
		require
			type_not_void: type /= Void
		deferred
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	sp_use_param (name: STRING): STRING
			-- Return stored procedure parameter `name' formatted
			-- according to the dialects convention when using
			-- parameters in sql code. It is usually prefixed by '@' or
			-- ':'.
			-- Spaces and such should be removed if necessary, or the
			-- entry should be quoted if that is supported for sp's.
		require
			name_not_empty: name /= Void and then not name.is_empty
		deferred
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Identifiers

	make_valid_identifier (name: STRING): STRING
			-- The valid identifier for a given Xplain name;
			-- override when certain `name's conflict with keywords, even
			-- when quoted.
		require
			name_not_empty: name /= Void and then not name.is_empty
		do
			if IdentifierWithSpacesSupported then
				if name.count > MaxIdentifierLength then
					Result := name.substring (1, MaxIdentifierLength)
				else
					Result := name
				end
			else
				Result := no_space_identifier (name)
			end
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	make_valid_constraint_identifier (name: STRING): STRING
			-- Return a valid identifier for a constraint.
		local
			s: STRING
		do
			if name.count > MaxConstraintIdentifierLength then
				s := name.substring (1, MaxConstraintIdentifierLength)
			else
				s := name
			end
			Result := make_valid_identifier (s)
		end

	quote_identifier (an_identifier: STRING): STRING
			-- `an_identifier', optionally surrounded by quotes if
			-- identifier contains spaces and rdbms supports spaces in
			-- identifiers;
			-- does not necessarily return a new identifier, so clone
			-- when necessary.
		require
			valid_identifier:
				an_identifier /= Void and then
				not an_identifier.is_empty and then
				STRING_.same_string (an_identifier, make_valid_identifier (an_identifier))
		do
			Result := an_identifier
		ensure
			quote_identifier_not_empty: Result /= Void and then not Result.is_empty
			no_spaces: not IdentifierWithSpacesEnabled implies not Result.has (' ')
		end

	quote_valid_identifier (identifier: STRING): STRING
			-- Make identifier valid, and quote it.
		require
			identifier_not_empty:
				identifier /= Void and then
				not identifier.is_empty
		do
			Result := quote_identifier (make_valid_identifier (identifier))
		ensure
			quote_identifier_not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Formatting numbers

	double_to_string (d: DOUBLE): STRING
			-- convert double to string, output only decimal digits if necessary
		local
			s: STRING
		do
			s := format (once "$.4f", <<d>>)
			if s.substring (s.count - 4, s.count).is_equal (once ".0000") then
				s := format (once "$.0f", <<d>>)
			end
			Result := s
		end


feature -- Domain specific methods

	domain_identifier (base: XPLAIN_BASE): STRING
		local
			s: STRING
		do
			s := DomainNamePrefix + base.name
			Result := make_valid_identifier(s)
		end

	domain_null_or_not_null (domain_restriction: detachable XPLAIN_DOMAIN_RESTRICTION): detachable STRING
			-- will this domain be null or not null?
		require
			supported: DomainsSupported
		local
			required: BOOLEAN
		do
			if domain_restriction = Void then
				required := not DomainNullDefault
			else
				required := domain_restriction.required
			end
			if required then
				if DomainNullDefault then
					Result := "not null"
				else
					if DomainNotNullAllowed then
						Result := "not null"
					else
						Result := Void
					end
				end
			else
				if DomainNullAllowed then
					Result := "null"
				else
					Result := Void
				end
			end
		ensure
			valid_response: Result = Void or else
								equal(Result,"null") or else
								equal(Result, "not null")

		end

feature -- Table specific methods

	check_if_required (type: detachable XPLAIN_ABSTRACT_TYPE): BOOLEAN
			-- returns True if it is a good thing to make this base/type
			-- a required attribute.
			-- Xplain doesn't have Nulls, but for blobs it's best to
			-- allow them to be Null, to save disk space
		do
			if not attached type then
				Result := False -- assume it's a self reference
			elseif type.representation.is_blob (Current) then
				Result := False
			else
				Result := AttributeRequiredEnabled
			end
		end

	constraint_names: DS_SET [STRING]
			-- List of generated constraint names.
		once
			create { DS_HASH_SET [STRING] } Result.make_equal (256)
		ensure
			constraint_names_not_void: Result /= Void
		end

	create_table_name (type: XPLAIN_TYPE): STRING
			-- Table identifier to use in create table statement
		local
			s: STRING
		do
			if not CreateViews then
				result := make_valid_identifier (type.name)
			else
				s := TableNamePrefix
				s := s + type.name
				Result := make_valid_identifier(s)
			end
		end

	table_name (type: XPLAIN_TYPE): STRING
			-- Table identifier to use in select/insert/etc statements
		do
			if CreateViews then
				Result := make_valid_identifier(type.name)
			else
				Result := create_table_name (type)
			end
		end

	table_pk_name (type: XPLAIN_TYPE): STRING
		require
			type_not_void: type /= Void
		local
			s: STRING
		do
			s := format (primary_key_format, <<type.name>>)
			Result := make_valid_identifier (s)
		ensure
			table_pk_name_not_empty: Result /= Void and then not Result.is_empty
		end

	table_has_auto_pk (type: XPLAIN_TYPE): BOOLEAN
			-- Does this type have an auto-generated primary key?
		require
			type_not_void: type /= Void
		do
			Result :=
				CreateAutoPrimaryKey and then
				type.representation.is_integer
		end

	table_ts_name (type: XPLAIN_TYPE): STRING
			-- Name of the timestamp column
		require
			type_not_void: type /= Void
			timestamp_ok: CreateTimestamp
		do
			Result := make_valid_identifier ("ts_" + type.sqlname (Current))
		ensure
			table_ts_name_not_empty: Result /= Void and then not Result.is_empty
			valid_identifier: equal (Result, make_valid_identifier (Result))
		end

	column_constraint_name (owner: XPLAIN_TYPE; an_attribute: XPLAIN_ATTRIBUTE): STRING
			-- A unique constraint name. If called twice, a different
			-- name could be returned.
			-- That it is unique should be guaranteed by a
			-- caller. Somewhere the `owner'.`constraint_number' thing
			-- should be incremented at the right times.
		require
			have_owner: owner /= Void
			have_attribute: an_attribute /= Void
		local
			s: STRING
		do
			if OldConstraintNames then
				s := "c" + owner.constraint_number.out
				s.append_character ('_')
				s.append_string (owner.name)
				s.append_character ('_')
				if an_attribute.role /= Void then
					s.append_string (an_attribute.role)
					s.append_character ('_')
				end
				s.append_string (an_attribute.name)
				Result := make_valid_constraint_identifier (s)
			else
				s := "c_" + owner.name
				s.append_character ('_')
				if an_attribute.role /= Void then
					s.append_string (an_attribute.role)
					s.append_character ('_')
				end
				s.append_string (an_attribute.name)
				Result := make_valid_constraint_identifier (s)
				if constraint_names.has (Result) then
					from
					until
						not constraint_names.has (Result)
					loop
						owner.next_constraint_number
						s := "c" + owner.constraint_number.out
						s.append_character ('_')
						s.append_string (owner.name)
						s.append_character ('_')
						if an_attribute.role /= Void then
							s.append_string (an_attribute.role)
							s.append_character ('_')
						end
						s.append_string (an_attribute.name)
						Result := make_valid_constraint_identifier (s)
					end
				end
				constraint_names.force (Result)
			end
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	column_null_or_not_null (required: BOOLEAN): READABLE_STRING_GENERAL
			-- return null or not null, to be used when creating a column,
			-- or empty string if not applicable
		do
			if required then
				if ColumnNullDefault then
					Result := "not null"
				else
					if ColumnNotNullAllowed then
						Result := "not null"
					else
						Result := ""
					end
				end
			else
				if ColumnNullDefault then
					if ColumnNullAllowed then
						Result := "null"
					else
						Result := ""
					end
				else
					Result := "null"
				end
			end
		ensure
			valid_response:
				Result = Void or else
				equal (Result, "null") or else
				equal (Result, "not null")
		end

	sqlcolumnconstraint_base (restriction: XPLAIN_DOMAIN_RESTRICTION
									column_name: STRING): detachable STRING
			-- return base column constraint except if constraint already
			-- specified on domain
		do
			if not CreateDomainCheck then
				if CheckConstraintSupported then
					if attached restriction.sqldomainconstraint (Current, quote_identifier (column_name)) as s then
						Result := "check " + s
					else
						Result := Void
					end
				else
					Result := Void
				end
			else
				Result := Void
			end
		end

	sqlcolumnconstraint_type (restriction: XPLAIN_DOMAIN_RESTRICTION; type: XPLAIN_TYPE): STRING
			-- returns a references constraint
			-- should reference the view or table? Probably depends on
			-- security model
		do
			Result := "references " + quote_identifier (type.sqltablename (Current)) + " (" + quote_identifier (type.sqlpkname (Current)) + ")"
		end


feature -- Index name

	index_name (index: XPLAIN_INDEX): STRING
		do
			Result := "idx_" + index.type.sqlname (Current) + "_" + index.name
			Result := make_valid_identifier (Result)
		end


feature -- Variable specific features

	constant_identifier (variable: XPLAIN_VARIABLE): STRING
		require
			variable_not_void: variable /= Void
		do
			Result := make_valid_identifier (variable.name)
		ensure
			name_not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Value specific features

	is_value_data_type_changed (a_value: XPLAIN_VALUE): BOOLEAN
			-- Is value's representation different from the declared
			-- representation?
		require
			value_not_void: a_value /= Void
			declared: is_value_declared (a_value)
		local
			old_data_type,
			new_data_type: STRING
		do
			old_data_type := declared_values.item (a_value.name).representation.datatype (Current)
			new_data_type := a_value.representation.datatype (Current)
			Result := not old_data_type.is_equal (new_data_type)
		end

	is_value_declared (a_value: XPLAIN_VALUE): BOOLEAN
			-- Is value already declared?
		require
			value_not_void: a_value /= Void
		do
			Result := declared_values.has (a_value.name)
		end

	value_identifier (a_value: XPLAIN_VALUE): STRING
			-- Value identifier, unquoted
		require
			value_not_void: a_value /= Void
		do
			Result := make_valid_identifier (a_value.name)
		ensure
			value_identifier_not_empty: Result /= Void and then not Result.is_empty
		end

	quoted_value_identifier (a_value: XPLAIN_VALUE): STRING
			-- Value identifier, quoted
		require
			value_not_void: a_value /= Void
		do
			Result := quote_identifier (a_value.sqlname (Current))
		ensure
			quoted_value_identifier_not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Value representations

	value_representation_boolean: XPLAIN_B_REPRESENTATION
		local
			restriction: XPLAIN_REQUIRED
		once
			create Result
			create restriction.make (False)
			Result.set_domain_restriction (Current, restriction)
		ensure
			value_representation_boolean_not_void: Result /= Void
			has_domain_restriction: Result.domain_restriction /= Void
		end

	value_representation_char (a_minimum_length: INTEGER): XPLAIN_A_REPRESENTATION
			-- Representation for value with a character expression.
		require
			minimum_length_positive: a_minimum_length > 0
		local
			length: INTEGER
			restriction: XPLAIN_REQUIRED
		do
			if a_minimum_length < 250 then
				-- 250 character should be enough for everybody :-)
				length := 250
			else
				length := a_minimum_length
			end
			create {XPLAIN_A_REPRESENTATION} Result.make (length)
			create restriction.make (False)
			Result.set_domain_restriction (Current, restriction)
		ensure
			value_representation_char_not_void: Result /= Void
			has_domain_restriction: Result.domain_restriction /= Void
		end

	value_representation_current_timestamp: XPLAIN_D_REPRESENTATION
		local
			restriction: XPLAIN_REQUIRED
		once
			create Result
			create restriction.make (False)
			Result.set_domain_restriction (Current, restriction)
		ensure
			value_representation_current_timestamp_not_void: Result /= Void
			has_domain_restriction: Result.domain_restriction /= Void
		end

	value_representation_date: XPLAIN_D_REPRESENTATION
		local
			restriction: XPLAIN_REQUIRED
		once
			create Result
			create restriction.make (False)
			Result.set_domain_restriction (Current, restriction)
		ensure
			value_representation_date_not_void: Result /= Void
			has_domain_restriction: Result.domain_restriction /= Void
		end

	value_representation_float: XPLAIN_F_REPRESENTATION
		local
			restriction: XPLAIN_REQUIRED
		do
			create Result
			create restriction.make (False)
			Result.set_domain_restriction (Current, restriction)
		ensure
			value_representation_float_not_void: Result /= Void
			has_domain_restriction: Result.domain_restriction /= Void
		end

	value_representation_integer (a_minimum_length: INTEGER): XPLAIN_I_REPRESENTATION
		local
			length: INTEGER
			restriction: XPLAIN_REQUIRED
		do
			if a_minimum_length < 9 then
				length := 9
			else
				length := a_minimum_length
			end
			create Result.make (length)
			create restriction.make (False)
			Result.set_domain_restriction (Current, restriction)
		ensure
			value_representation_integer_not_void: Result /= Void
			has_domain_restriction: Result.domain_restriction /= Void
		end

	value_representation_money: XPLAIN_M_REPRESENTATION
		local
			restriction: XPLAIN_REQUIRED
		once
			create Result
			create restriction.make (False)
			Result.set_domain_restriction (Current, restriction)
		ensure
			value_representation_money_not_void: Result /= Void
			has_domain_restriction: Result.domain_restriction /= Void
		end

	value_representation_system_user: XPLAIN_A_REPRESENTATION
		once
			Result := value_representation_char (64)
		ensure
			value_representation_system_user_not_void: Result /= Void
			has_domain_restriction: Result.domain_restriction /= Void
		end

	value_representation_text: XPLAIN_T_REPRESENTATION
			-- Representation for value with a character expression.
		local
			restriction: XPLAIN_REQUIRED
		once
			create {XPLAIN_T_REPRESENTATION} Result
			create restriction.make (False)
			Result.set_domain_restriction (Current, restriction)
		ensure
			value_representation_text_not_void: Result /= Void
			has_domain_restriction: Result.domain_restriction /= Void
		end


feature -- Cast expressions

	sql_cast_to_date (an_expression: XPLAIN_EXPRESSION): STRING
			-- SQL expression to cast `an_expression' to a date
		do
			Result := do_sql_cast_to_date (an_expression.sqlvalue (Current))
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_cast_to_integer (an_expression: XPLAIN_EXPRESSION): STRING
			-- SQL expression to cast `an_expression' to an integer
		do
			Result := do_sql_cast_to_integer (an_expression.sqlvalue (Current))
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_cast_to_real (an_expression: XPLAIN_EXPRESSION): STRING
			-- SQL expression to cast `an_expression' to a real
		do
			Result := do_sql_cast_to_real (an_expression.sqlvalue (Current))
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end

	sql_cast_to_string (an_expression: XPLAIN_EXPRESSION): STRING
			-- SQL expression to cast `an_expression' to a string
		do
			Result := do_sql_cast_to_string (an_expression.sqlvalue (Current))
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end


feature {NONE} -- Cast expressions implementation

	do_sql_cast_to_date (an_sql_expression: STRING): STRING
			-- SQL expression to cast `an_expression' to a date
		require
			an_sql_expression_not_empty: an_sql_expression /= Void and then not an_sql_expression.is_empty
		local
			v: XPLAIN_REPRESENTATION
		do
			v := value_representation_date
			Result := "cast (" + an_sql_expression + " as " + v.datatype (Current) + ")"
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end

	do_sql_cast_to_integer (an_sql_expression: STRING): STRING
			-- SQL expression to cast `an_expression' to an integer
		require
			an_sql_expression_not_empty: an_sql_expression /= Void and then not an_sql_expression.is_empty
		local
			v: XPLAIN_REPRESENTATION
		do
			v := value_representation_integer (9)
			Result := "cast (" + an_sql_expression + " as " + v.datatype (Current) + ")"
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end

	do_sql_cast_to_real (an_sql_expression: STRING): STRING
			-- SQL expression to cast `an_expression' to a real
		require
			an_sql_expression_not_empty: an_sql_expression /= Void and then not an_sql_expression.is_empty
		local
			v: XPLAIN_REPRESENTATION
		do
			v := value_representation_float
			Result := "cast (" + an_sql_expression + " as " + v.datatype (Current) + ")"
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end

	do_sql_cast_to_string (an_sql_expression: STRING): STRING
			-- SQL expression to cast `an_expression' to a string
		require
			an_sql_expression_not_empty: an_sql_expression /= Void and then not an_sql_expression.is_empty
		local
			v: XPLAIN_REPRESENTATION
		do
			v := value_representation_char (250)
			Result := "cast (" + an_sql_expression + " as " + v.datatype (Current) + ")"
			-- Rely on SQL to set default width of varchar?
			-- Seems to work for PostgreSQL and MSSQL
			-- Result := "cast (" + an_expression.sqlvalue (Current) + " as varchar)"
		ensure
			cast_not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Date functions

	sql_newdate (a_date, a_number, a_part: XPLAIN_EXPRESSION): STRING
		do
			std.error.put_string ("newdate function is not supported by this dialect.%N")
			Result := a_date.sqlvalue (Current)
		end


feature -- Extension specific methods

	extension_index_name (an_extension: XPLAIN_EXTENSION): STRING
			-- Name of index on temporary table to speed up join to that table
		require
			extension_not_void: an_extension /= Void
		do
			Result := quote_valid_identifier ("idx_" + an_extension.type.name + "_" + an_extension.name)
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	extension_name (an_extension: XPLAIN_EXTENSION): STRING
			-- Name of temporary table where extension is stored
		require
			extension_not_void: an_extension /= Void
		do
			Result := make_valid_identifier (an_extension.type.name + "_" + an_extension.name)
		ensure
			valid_identifier: equal (Result, make_valid_identifier (Result))
		end

	updated_extension: detachable XPLAIN_EXTENSION
			-- Set inside `create_update' when this extension is being
			-- updated. Can be used in `sqlvalue' to return an
			-- unqualified expression when the extensions value itself is
			-- used. Not all dialects support qualified attribute names
			-- in expressions so we have to suppress them.


feature {NONE} -- Update SQL

	output_update_from_clause (a_subject: XPLAIN_SUBJECT; a_join_list: JOIN_LIST)
			-- Some dialects support a from + join clause in an update
			-- statement. This gives that dialects a chance to write that
			-- clause so updates can refer to any attribute without using
			-- subselects. For Transact-SQL that's good for the performance.
		require
			supported: SupportsJoinInUpdate
			subject_not_void: a_subject /= Void
			has_joins: a_join_list /= Void and then not a_join_list.is_empty
		do
			-- do nothing
		end

	output_update_extend_from_clause (a_subject: XPLAIN_SUBJECT; a_join_list: JOIN_LIST)
			-- TSQL/PostgreSQL specific call to do
			-- `output_update_extend_join_clause'.
		require
			supported: SupportsJoinInUpdate
			subject_not_void: a_subject /= Void
			has_joins: a_join_list /= Void and then a_join_list.first /= Void
		do
			-- do nothing
		end

	output_update_extend_join_clause (a_subject: XPLAIN_SUBJECT; an_extension: XPLAIN_EXTENSION; a_join_list: detachable JOIN_LIST)
			-- Output from clause and optional join to necessary tables
			-- when updating extended table.
			-- If a dialect doesn't support it, just the update for the
			-- extended table is emitted and it will need subselects to
			-- retrieve other pieces of data.
		require
			subject_not_void: a_subject /= Void
			extension_not_void: an_extension /= Void
		do
			std.output.put_string (an_extension.quoted_name (Current))
		end

	output_update_join_clause (a_subject: XPLAIN_SUBJECT; a_join_list: detachable JOIN_LIST)
			-- Output join to necessary tables for an update statement.
			-- If a dialect doesn't support it, just the update for
			-- the extended table is emitted and it will need
			-- subselects to retrieve other pieces of data.
		require
			subject_not_void: a_subject /= Void
			join_list_not_void: SupportsJoinInUpdate implies a_join_list /= Void
		do
			std.output.put_string (a_subject.type.quoted_name (Current))
		end


feature -- Assertion specific methods

	assert_implemented_as_view (an_assertion: XPLAIN_ASSERTION): BOOLEAN
		require
			views_supported: ViewsSupported
		do
			Result :=
				(not CalculatedColumnsSupported) or else
				(an_assertion.is_complex) or else
				(an_assertion.is_function)
		end

	assertion_name (an_assertion: XPLAIN_ASSERTION): STRING
			-- Name of temporary table where extension is stored
		require
			assertion_not_void: an_assertion /= Void
		do
			Result := make_valid_identifier (an_assertion.type.name + "_" + an_assertion.name)
		ensure
			valid_identifier: equal (Result, make_valid_identifier (Result))
		end


feature -- Literal

	as_string (s: STRING): STRING
			-- Return `s' as string by surrounding it with quotes. Makes
			-- sure `s' is properly quoted, so don't use together with
			-- `safe_string'!
		local
			safe: STRING
		do
			if s /= Void and then not s.is_empty then
				safe := safe_string (s)
				create Result.make (1 + safe.count + 1)
				Result.append_character ('%'')
				Result.append_string (safe)
				Result.append_character ('%'')
			else
				Result := "''"
			end
		end

	safe_string (s: STRING): STRING
			-- Make sure the ' character in `s', if any, is properly quoted.
		require
			s_not_empty: s /= Void and then not s.is_empty
		local
			p: INTEGER
		do
			p := s.index_of ('%'', 1)
			if p = 0 then
				Result := s
			else
				Result := s.twin
				from
				until
					p = 0
				loop
					Result.insert_character ('%'', p)
					if p + 2 > Result.count then
						p := 0
					else
						p := Result.index_of ('%'', p+2)
					end
				end
			end
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end


feature -- Options

	set_options (
			AAssertEnabled,
			AAttributeRequiredEnabled,
			AAutoPrimaryKeyEnabled,
			AExtendIndex,
			ANoStoredProcedurePrefix,
			AOldConstraintNames,
			ASetDatabaseEnabled,
			AStoredProcedureEnabled,
			AIdentifierWithSpacesEnabled,
			ATimestampEnabled,
			ATimeZoneEnabled,
			AViewsEnabled: BOOLEAN)
			-- Set SQL generator options.
		do
			AssertEnabled := AAssertEnabled
			AttributeRequiredEnabled := AAttributeRequiredEnabled
			AutoPrimaryKeyEnabled := AAutoPrimaryKeyEnabled
			ExtendIndex := AExtendIndex
			OldConstraintNames := AOldConstraintNames
			SetDatabaseEnabled := ASetDatabaseEnabled
			StoredProcedureEnabled := AStoredProcedureEnabled
			IdentifierWithSpacesEnabled := AIdentifierWithSpacesEnabled
			TimestampEnabled := ATimestampEnabled
			TimeZoneEnabled := ATimeZoneEnabled
			ViewsEnabled := AViewsEnabled
			if ANoStoredProcedurePrefix then
				sp_prefix.wipe_out
			end
		end

	set_primary_key_format (a_primary_key_format: STRING)
			-- Set `primary_key_format'.
		require
			not_empty: a_primary_key_format /= Void and then not a_primary_key_format.is_empty
			valid_format: valid_format_and_parameters (a_primary_key_format, <<"test">>)
		do
			primary_key_format.wipe_out
			primary_key_format.append_string (a_primary_key_format)
		ensure
			set: STRING_.same_string (primary_key_format, a_primary_key_format)
		end

	set_sequence_name_format (a_sequence_name_format: STRING)
			-- Set `sequence_name_format'.
		require
			not_empty: a_sequence_name_format /= Void and then not a_sequence_name_format.is_empty
		do
			sequence_name_format.wipe_out
			sequence_name_format.append_string (a_sequence_name_format)
			sequence_name_format_one_parameter := not valid_format_and_parameters (a_sequence_name_format, <<"test", "id_test">>)
		ensure
			set: STRING_.same_string (sequence_name_format, a_sequence_name_format)
		end

invariant

	timestamp_implies_named_parameters: CreateTimestamp implies NamedParametersSupported
	declared_values_not_void: declared_values /= Void
	generate_subselects_only_when_joins_are_not_supported: InUpdateStatement implies not SupportsJoinInUpdate

end
