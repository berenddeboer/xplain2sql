%{
indexing

	description:

		"XPLain parser%
		%%
		%Parser derived from Xplain 5.8 manual%
		%(not yet complete, but we're getting there)%
		%%
		%Standard Xplain deviations:%
		%1. Supports additional representations for memo fields, %
		%   picture fields, .... %
		%2. Date field includes time.%
		%3. Supports renaming columns by using the `as' keyword."

	known_bugs:
	"3. Error reporting can be improved.%
	%4. No cascade support.%
	%5. Certain types of expressions are not always allowed, this is %
	%   not checked (use of values or constants for example).%
	%   A constant expression also accepts values if previously defined. %
	%   Should only accept constants.%
	%7. check constraint is not supported.%
	%9. purging inits is not yet supported.%
	%10. input is not supported.%
	%11. case keyword in inheritance not supported.%
	%12. It seems we're more strict in ordering of types than Xplain.%
	%    Generally, a type should exist, before you can use it as an %
	%    attribute.%
	%13. 'its' list parsing not strict enough. Accepts some times an %
	%    attribute that is not correct. Probably dumps core later...%
	%15. names are case-sensitive, but should not be.%
	%16. No newline keyword support (parse as string??).%
	%17. Extend with explicitly given domain not supported.%
	%18. Doesn't check if a column used as boolean is really a boolean.%
	%    So 'get person where name' is ok.%
	%19. When there is an init for an attribute, no value is allowed %
	%    in insert. This is not checked although the input is overwritten.%
	%21. Don't put comments between a type and an init (default), else%
	%    the init (defaults) are silently ignored (2005-12-01: works slightly better now).%
	%23. update allows update a * its attr = 1, shouldn't allow *."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999-2007 Berend de Boer, see forum.txt"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #17 $"


class

	XPLAIN_PARSER


inherit

	YY_PARSER_SKELETON
		rename
			make as make_parser_skeleton
		undefine
			report_error
		end

	XPLAIN_SCANNER
		rename
			make_with_file as make_scanner_with_file,
			make_with_stdin as make_scanner_with_stdin
		redefine
			write_pending_statement
		end

	XPLAIN_UNIVERSE_ACCESSOR
		export
			{NONE} all
		end


create

	make_with_file,
	make_with_stdin


%}

-- Xplain keywords
%token XPLAIN_AND XPLAIN_ANY XPLAIN_AS XPLAIN_ASSERT
%token XPLAIN_BASE
%token XPLAIN_CASCADE XPLAIN_CASE XPLAIN_CHECK XPLAIN_CONSTANT
%token XPLAIN_COUNT
%token XPLAIN_DATABASE XPLAIN_DEFAULT XPLAIN_DELETE
%token XPLAIN_ECHO XPLAIN_ELSE XPLAIN_END XPLAIN_EXTEND
%token XPLAIN_FALSE XPLAIN_GET
%token XPLAIN_IF XPLAIN_INIT XPLAIN_INPUT
%token XPLAIN_INSERT XPLAIN_ITS
%token XPLAIN_LOGINNAME XPLAIN_MAX XPLAIN_MIN
%token XPLAIN_NEWLINE XPLAIN_NIL XPLAIN_NOT XPLAIN_NULL
%token XPLAIN_OF XPLAIN_OR
%token XPLAIN_PER XPLAIN_PURGE
%token XPLAIN_SOME XPLAIN_SYSTEMDATE
%token XPLAIN_THEN XPLAIN_TOTAL XPLAIN_TRUE XPLAIN_TYPE
%token XPLAIN_UPDATE
%token XPLAIN_VALUE
%token XPLAIN_WITH XPLAIN_WHERE

-- Xplain string functions
%token XPLAIN_COMBINE XPLAIN_HEAD XPLAIN_TAIL

-- Xplain date functions
%token XPLAIN_DAYF XPLAIN_ISDATE XPLAIN_MONTHF XPLAIN_NEWDATE XPLAIN_TIMEDIF
%token XPLAIN_WDAYF XPLAIN_YEARF

-- Xplain conversion functions
%token XPLAIN_DATEF XPLAIN_INTEGERF XPLAIN_REALF XPLAIN_STRINGF

-- Xplain mathematical functions
%token XPLAIN_POW XPLAIN_ABS XPLAIN_MAXF XPLAIN_MINF XPLAIN_SQRT XPLAIN_EXP
%token XPLAIN_LN XPLAIN_LOG10
%token XPLAIN_SIN XPLAIN_COS XPLAIN_TAN
%token XPLAIN_ASIN XPLAIN_ACOS XPLAIN_ATAN
%token XPLAIN_SINH XPLAIN_COSH XPLAIN_TANH
%token XPLAIN_ASINH XPLAIN_ACOSH XPLAIN_ATANH


-- enhanced Xplain keywords (support for Nulls, oops)
%token XPLAIN_CLUSTERED XPLAIN_ENDPROC
%token XPLAIN_INDEX XPLAIN_INSERTED
%token XPLAIN_OPTIONAL
%token XPLAIN_PROCEDURE XPLAIN_PATH_PROCEDURE XPLAIN_RECOMPILED_PROCEDURE XPLAIN_TRIGGER_PROCEDURE
%token XPLAIN_REQUIRED XPLAIN_UNIQUE

-- enhanced Xplain functions
%token XPLAIN_ID

-- SQL
%token <STRING> LITERAL_SQL

-- Xplain basic datatypes
%token <STRING> XPLAIN_IDENTIFIER
%token <STRING> XPLAIN_STRING     -- character string
%token <STRING> XPLAIN_DOUBLE     -- double precision number
%token <INTEGER> XPLAIN_INTEGER   -- integer

-- Xplain nonterminal types
%type <STRING> script_start
%type <STRING> database_name
%type <XPLAIN_BASE> base_definition
%type <XPLAIN_DOMAIN_RESTRICTION> optional_trajectory
%type <XPLAIN_DOMAIN_RESTRICTION> domain_constraint
%type <XPLAIN_DOMAIN_RESTRICTION> enumeration
%type <XPLAIN_A_NODE> string_enumeration
%type <XPLAIN_I_NODE> integer_enumeration
%type <XPLAIN_DOMAIN_RESTRICTION> trajectory
%type <STRING> lower_border
%type <STRING> upper_border
%type <STRING> pattern
%type <STRING> plus_or_minus
%type <STRING> mult_or_div
%type <XPLAIN_LOGICAL_EXPRESSION> logical_expression
%type <XPLAIN_EXPRESSION> logical_factor
%type <XPLAIN_EXPRESSION> logical_term
%type <STRING> relation
%type <XPLAIN_LOGICAL_VALUE_EXPRESSION> logical_value
%type <XPLAIN_SYSTEM_EXPRESSION> system_variable
%type <XPLAIN_EXPRESSION> property_expression
%type <XPLAIN_EXPRESSION> property_term
%type <XPLAIN_EXPRESSION> property_factor
%type <STRING> numeric
%type <XPLAIN_ATTRIBUTE_NAME_NODE> property_name
%type <XPLAIN_ATTRIBUTE_NAME> any_name
%type <XPLAIN_ATTRIBUTE_NAME> parameter_name
%type <XPLAIN_TYPE> initialization
%type <XPLAIN_EXPRESSION> init_specification
%type <XPLAIN_LOGICAL_EXPRESSION> condition
%type <XPLAIN_EXPRESSION> selector
%type <XPLAIN_REPRESENTATION> domain
%type <XPLAIN_PK_REPRESENTATION> identification_domain
%type <STRING> type_name
%type <STRING> base_name
%type <STRING> constant
%type <STRING> type_or_constant
%type <STRING> role
%type <XPLAIN_ATTRIBUTE_NODE> attribute_list
%type <XPLAIN_ATTRIBUTE> definition_attribute
%type <XPLAIN_ATTRIBUTE_NAME> attribute
%type <STRING> name
%type <STRING> text
%type <INTEGER> integer
%type <STRING> real

%type <XPLAIN_EXPRESSION> constant_expression
%type <XPLAIN_EXPRESSION> number_expression
%type <XPLAIN_EXPRESSION> number_term
%type <XPLAIN_EXPRESSION> number_factor
%type <XPLAIN_LOGICAL_EXPRESSION> constant_logical_expression
%type <XPLAIN_EXPRESSION> constant_logical_term
%type <XPLAIN_EXPRESSION> constant_logical_factor

%type <XPLAIN_ASSERTION> assert_definition
%type <STRING> virtual_attribute

%type <XPLAIN_ATTRIBUTE_NAME_NODE> optional_simple_attribute_list
%type <XPLAIN_ATTRIBUTE_NAME_NODE> simple_attribute_list

%type <XPLAIN_ASSIGNMENT_NODE> assignment_list
%type <XPLAIN_ASSIGNMENT> attribute_assignment
%type <XPLAIN_EXPRESSION> assigned_value
%type <XPLAIN_SUBJECT> subject
%type <XPLAIN_EXPRESSION> idstring
%type <XPLAIN_ATTRIBUTE_NAME> attribute_name
%type <XPLAIN_EXPRESSION> value_definition
%type <XPLAIN_SELECTION_FUNCTION> value_selection_expression
%type <XPLAIN_EXTENSION> extension_expression
%type <XPLAIN_EXTEND_ATTRIBUTE> extend_attribute
%type <XPLAIN_EXTENSION_EXPRESSION> extension_definition
%type <XPLAIN_SELECTION> selection_expression
%type <XPLAIN_SELECTION_LIST> selection_without_set_function
%type <XPLAIN_SORT_NODE> selection_sort_order
%type <XPLAIN_SORT_NODE> sort_order_list
%type <XPLAIN_SELECTION_FUNCTION> selection_with_set_function
%type <XPLAIN_FUNCTION> set_function
%type <XPLAIN_EXPRESSION_NODE> selection_list
%type <XPLAIN_EXPRESSION_NODE> property_list
%type <XPLAIN_EXPRESSION> property
%type <STRING> optional_new_name
%type <XPLAIN_EXPRESSION> predicate

%type <XPLAIN_ATTRIBUTE_NAME_NODE> optional_procedure_parameters
%type <XPLAIN_ATTRIBUTE_NAME_NODE> procedure_parameter_list
%type <XPLAIN_STATEMENT_NODE> optional_procedure_statement_list
%type <XPLAIN_STATEMENT_NODE> procedure_statement_list
%type <XPLAIN_STATEMENT> procedure_supported_command

%type <XPLAIN_STATEMENT> user_command
%type <XPLAIN_STATEMENT> definition_command
%type <XPLAIN_STATEMENT> command
%type <XPLAIN_STATEMENT> definition
%type <XPLAIN_CONSTANT_STATEMENT> constant_definition
%type <XPLAIN_CONSTANT_ASSIGNMENT_STATEMENT> constant_assignment
%type <XPLAIN_CASCADE_STATEMENT> cascade
%type <XPLAIN_CASCADE_FUNCTION_EXPRESSION> cascade_definition
%type <XPLAIN_ATTRIBUTE_NAME_NODE> grouping_attribute
%type <XPLAIN_DELETE_STATEMENT> delete
%type <XPLAIN_EXTEND_STATEMENT> extension
%type <XPLAIN_GET_STATEMENT> selection
%type <XPLAIN_STATEMENT> insert
%type <XPLAIN_PROCEDURE_STATEMENT> procedure
%type <INTEGER> procedure_kind
%type <XPLAIN_SQL_STATEMENT> sql
%type <XPLAIN_TYPE_STATEMENT> type_definition
%type <XPLAIN_UPDATE_STATEMENT> update
%type <XPLAIN_VALUE_STATEMENT> value
%type <XPLAIN_VALUE_SELECTION_STATEMENT> value_selection

-- representation tokens

%token XPLAIN_A XPLAIN_B XPLAIN_C XPLAIN_D XPLAIN_I XPLAIN_M XPLAIN_P XPLAIN_R
%token XPLAIN_T

-- Xplain precedence

%left XPLAIN_OR
%left XPLAIN_AND
%left '=' XPLAIN_NE '<' '>' XPLAIN_LE XPLAIN_GE
%left '+' '-'
%left '*' '/' '%' -- '
%left XPLAIN_DOTDOT
%right XPLAIN_NOT

-- three reduce/reduce conflicts
%expect 3

%%
--------------------------------------------------------------------------------


database_use
	: script_start optional_user_command_list XPLAIN_END '.'
		{
			write_pending_statement
			sqlgenerator.write_end ($1)
		}
	| script_start optional_user_command_list XPLAIN_END '.' XPLAIN_END error
		{
			report_error ("Additional end detected after parsing the end belonging to the database command.")
			abort
		}
	| script_start optional_user_command_list XPLAIN_END '.' error
		{
			report_error ("Additional input after end of database.: " + text)
			abort
			}
	| error
		{
			report_error ("Script should start with the 'database' command instead of: " + text)
			abort
		}
	;

script_start
	: XPLAIN_DATABASE database_name '.'
		{
			sqlgenerator.write_use_database ($2)
			$$ := $2
		}
	;

database_name
	: name
		{ $$ := $1 }
	;

optional_user_command_list
	: -- empty
	| user_command_list
	;

user_command_list
	: user_command '.'
		{
			if not use_mode then
				if $1 /= Void then -- because statement support is partial at the moment
					statements.add ($1)
				end
			end
		}
	| sql
		 { statements.add ($1) }
	| sql user_command_list
		 { statements.add ($1) }
	| user_command '.' user_command_list
		{
			if not use_mode then
				if $1 /= Void then -- because statement support is partial at the moment
					statements.add ($1)
				end
			end
		}
	| error
		{
			if equal (text, "end") then
				report_error ("Unexpected 'end'. '.' missing?")
				abort
			elseif equal (text, "") then
				report_error ("Unexpected end of input. 'end.' missing?")
				abort
			else
				report_error ("Unknown or unexpected command: " + text)
				abort
			end
		}
  ;

user_command
	: definition_command
		 { $$ := $1 }
	| command
		 { $$ := $1 }
	| procedure
		 { $$ := $1 }
	;


------------------
-- data definition
------------------

definition_command
	: definition
		{ $$ := $1 }
	| deletion
	| constant_assignment
		{ $$ := $1 }
	;

definition
	: type_definition
		{ $$ := $1 }
	| base_definition
	| init_definition
	| default_definition
	| constant_definition
		{ $$ := $1 }
-- not in Xplain 5.8
	| assert_definition
	| check_definition
-- xplain2sql extensions
	| index_definition
	;

deletion
	: type_deletion
	| general_deletion
	;

constant_assignment
	: constant '=' '(' constant_expression ')'
		{ write_pending_statement
			myvariable := universe.find_variable($1)
			if myvariable = Void then
				report_error ("Not a valid variable: " + $1)
				abort
			else
				if not use_mode then
					sqlgenerator.write_constant_assignment (myvariable, $4)
				end
				myvariable.set_value ($4)
			end
			create $$.make (myvariable, $4)
		}
	| constant '=' error
		{
			report_error ("A constant assignment expression should be surrounded by parentheses")
			abort
		}
	;



base_definition
	: XPLAIN_BASE base_name domain
	{
		write_pending_statement
		if $3.domain.is_equal ("(B)") then
			create {XPLAIN_B_RESTRICTION} dummyrestriction.make (False)
		else
			create {XPLAIN_REQUIRED} dummyrestriction.make (False)
		end
		$3.set_domain_restriction (sqlgenerator, dummyrestriction)
		create {XPLAIN_BASE} $$.make ($2, $3)
		if not use_mode then
			sqlgenerator.write_base($$)
		end
		universe.add($$)
	}
	| XPLAIN_BASE base_name domain XPLAIN_REQUIRED
	{
		write_pending_statement
		if $3.domain.is_equal ("(B)") then
			create {XPLAIN_B_RESTRICTION} dummyrestriction.make (True)
		else
			create {XPLAIN_REQUIRED} dummyrestriction.make (True)
		end
		$3.set_domain_restriction (sqlgenerator, dummyrestriction)
		create {XPLAIN_BASE} $$.make ($2, $3)
		if not use_mode then
			sqlgenerator.write_base($$)
		end
		universe.add($$)
	}
	| XPLAIN_BASE base_name domain domain_constraint
	{ write_pending_statement
		$3.set_domain_restriction (sqlgenerator, $4)
		create {XPLAIN_BASE} $$.make ($2, $3)
		if not use_mode then
			sqlgenerator.write_base($$)
		end
		universe.add ($$)
	}
	;

type_definition
	: XPLAIN_TYPE type_name identification_domain '=' attribute_list
		{
			write_pending_statement
			create mytype.make ($2, $3, $5)
			universe.add (mytype)
			pending_type := mytype
			create $$.make (mytype)
		}
	;

init_definition
	: XPLAIN_INIT
		{ is_init_default := False }
	initialization
		{
			if pending_init /= $3 then
				write_pending_init
			end
			if $3 /= Void then
				pending_init := $3
			end
		}
	;

default_definition
	: XPLAIN_INIT XPLAIN_DEFAULT
		{ is_init_default := True }
	initialization
		{
			if pending_init /= $4 then
				write_pending_init
			end
			if $4 /= Void then
				pending_init := $4
			end
		}
	;

constant_definition
	: XPLAIN_CONSTANT constant domain
		{
			write_pending_statement
			create {XPLAIN_REQUIRED} dummyrestriction.make (False)
			$3.set_domain_restriction (sqlgenerator, dummyrestriction)
			create myvariable.make ($2, $3)
			if not use_mode then
				sqlgenerator.write_constant (myvariable)
			end
			universe.add(myvariable)
			create $$.make (myvariable)
	}
  ;

type_deletion: XPLAIN_PURGE type_or_constant
	{ write_pending_statement
		myobject := get_known_object ($2)
		if myobject /= Void then
			if immediate_output_mode then
				sqlgenerator.write_drop (myobject)
			end
			universe.delete (myobject)
		end
	}
  ;

general_deletion
	: XPLAIN_PURGE type_name { subject_type := get_known_type ($2) }
	XPLAIN_ITS attribute_name
		{
			write_pending_statement
			myattribute := subject_type.find_attribute ($5)
			if myattribute = Void then
				error_unknown_attribute ($2, $5)
			else
				if immediate_output_mode then
					subject_type.write_drop_attribute	(sqlgenerator, myattribute)
				end
			end
		}
	| XPLAIN_PURGE XPLAIN_INIT type_name { subject_type := get_known_type ($3) }
	XPLAIN_ITS attribute_name
		{ report_warning ("Purging of inits is not yet supported.") }
	;


domain_constraint
	: '=' enumeration
		{ $$ := $2 }
	| pattern
		{ create {XPLAIN_A_PATTERN} $$.make ($1) }
	| trajectory
		{ $$ := $1 }
	| error
		{
			report_error ("Domain restriction not supported for this data type or error in domain restriction definition.")
			abort
		}
	;

enumeration
	: string_enumeration
		{ create {XPLAIN_A_ENUMERATION} $$.make ($1) }
	| integer_enumeration
		{ create {XPLAIN_I_ENUMERATION} $$.make ($1) }
	;

string_enumeration
	: text
		{ create {XPLAIN_A_NODE} $$.make ($1, void) }
	| text ',' string_enumeration
		{ create {XPLAIN_A_NODE} $$.make ($1, $3) }
	;

integer_enumeration
	: integer
		{ create {XPLAIN_I_NODE} $$.make ($1, Void) }
	| integer ',' integer_enumeration
		{ create {XPLAIN_I_NODE} $$.make ($1, $3) }
	| integer XPLAIN_DOTDOT error
		{
			report_error ("An integer enumeration cannot contain a %"..%". If you want to specify a trajectory, the format should be (I2) (1..*) for example.")
			abort
		}
	;

trajectory
	: '(' lower_border XPLAIN_DOTDOT upper_border ')'
		{
			if $2.is_integer and then $4.is_integer then
				if $2.to_integer > $4.to_integer then
					report_error ("Trajectory's lower value " + $2 + " is more than the upper value " + $4 + ".")
					abort
				end
			end
			create {XPLAIN_TRAJECTORY} $$.make ($2, $4)
		}
	;

lower_border
	: numeric
		{ $$ := $1 }
	| '*'
		{
			create $$.make_filled ('9', last_width)
			$$.insert_character ('-', 1)
		}
	;

upper_border
	: numeric
		{ $$ := $1 }
	| '*'
		{ create $$.make_filled ('9', last_width) }
	;

pattern
	: text -- test if valid pattern?
		{ $$ := $1 }
	;

plus_or_minus: '+'
	{ $$ := "+" }
  | '-'
	{ $$ := "-" }
  ;

mult_or_div: '*'
	{ $$ := "*" }
  | '/'
	{ $$ := "/" }
  | '%' --'
	{ $$ := "%%" }
  ;

logical_expression
	: logical_term  XPLAIN_OR logical_expression
	{
		  create {XPLAIN_LOGICAL_INFIX_EXPRESSION} dummye.make ($1, once "or", $3)
		  create $$.make (dummye)
	}
	| logical_term
		{
			create $$.make ($1)
		}
	;

logical_term
	: logical_factor XPLAIN_AND logical_term
		{ create {XPLAIN_LOGICAL_INFIX_EXPRESSION} $$.make ($1, once "and", $3) }
	| logical_factor
		{ $$ := $1 }
	;

-- property_name is the source of one reduce/reduce conflict
-- because we can also have property_expression with also have a property_name
-- term.
-- The second is logical_value which also occurs in both places
-- The third is the parameter name.
logical_factor
	: property_name
		{
			if subject_type /= Void then
				myobject := get_object_if_valid_tree ($1)
				if myobject /= Void then
					-- the last object in the tree knows what expression to build here
					dummye := last_object_in_tree.create_expression ($1)
					if dummye.is_logical_expression then
						create {XPLAIN_NOTNOT_EXPRESSION} $$.make (dummye)
					else
						$$ := dummye
					end
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
			end
			}
	| XPLAIN_NOT property_name
		{
			if subject_type /= Void then
				myobject := get_object_if_valid_tree ($2)
				if myobject /= Void then
					-- the last object in the tree knows what expression to build here
					dummye := last_object_in_tree.create_expression ($2)
					create {XPLAIN_NOT_EXPRESSION} $$.make (dummye)
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
			end

		}
	| '?' parameter_name
		{
			if is_parameter_declared ($2) then
				create {XPLAIN_PARAMETER_EXPRESSION} $$.make ($2)
			end
			}
	| XPLAIN_NOT '?' parameter_name
		{
			if is_parameter_declared ($3) then
				create {XPLAIN_PARAMETER_EXPRESSION} $$.make ($3)
				create {XPLAIN_NOT_EXPRESSION} $$.make ($$)
			end
			}
	| property_expression '=' XPLAIN_NULL
		{ create {XPLAIN_EQ_NULL_EXPRESSION} $$.make ($1) }
	| property_expression XPLAIN_NE XPLAIN_NULL
		{ create {XPLAIN_NE_NULL_EXPRESSION} $$.make ($1) }
	| property_expression relation property_expression
		{
			$$ := new_logical_infix_expression ($1, $2, $3)
		}
	| XPLAIN_NOT property_expression relation property_expression
		{
			dummye := new_logical_infix_expression ($2, $3, $4)
			create {XPLAIN_NOT_EXPRESSION} $$.make (dummye)
		}
	| '(' logical_expression ')'
		{ create {XPLAIN_PARENTHESIS_EXPRESSION} $$.make ($2) }
	| XPLAIN_NOT '(' logical_expression ')'
		{ create {XPLAIN_PARENTHESIS_EXPRESSION} $$.make ($3)
		  create {XPLAIN_NOT_EXPRESSION} $$.make ($$) }
	| logical_value
		{ $$ := $1 }
	| XPLAIN_NOT logical_value
		{ create {XPLAIN_NOT_EXPRESSION} $$.make ($2) }
  ;

relation: '<'
	{ $$ := "<" }
  | XPLAIN_LE
	{ $$ := "<=" }
  | '>'
	{ $$ := ">" }
  | XPLAIN_GE
	{ $$ := ">=" }
  | '='
	{ $$ := "=" }
  | XPLAIN_NE
	{ $$ := "<>" }
  ;

logical_value
  : XPLAIN_TRUE
	{ create {XPLAIN_LOGICAL_VALUE_EXPRESSION} $$.make (True) }
  | XPLAIN_FALSE
	{ create {XPLAIN_LOGICAL_VALUE_EXPRESSION} $$.make (False) }
  ;

system_variable
	: XPLAIN_SYSTEMDATE
		{ create {XPLAIN_SYSTEMDATE_EXPRESSION} $$ }
	| XPLAIN_LOGINNAME
		{ create {XPLAIN_LOGINNAME_EXPRESSION}$$ }
	;

property_expression
	: property_term plus_or_minus property_expression
		{ create {XPLAIN_INFIX_EXPRESSION} $$.make ($1, $2, $3) }
	| property_term
		{ $$ := $1 }
	| XPLAIN_IF condition XPLAIN_THEN property_expression XPLAIN_ELSE property_expression
		{ create {XPLAIN_IF_EXPRESSION} $$.make ($2, $4, $6) }
	;

property_term
	: property_factor mult_or_div property_term
		{ create {XPLAIN_INFIX_EXPRESSION} $$.make ($1, $2, $3) }
	| property_factor
		{ $$ := $1 }
	;

property_factor
	: property_name
		{
			-- we have something here that can be an
			-- attribute/extension/value/variable.
			-- let's get the correct object associated with this tree
			if subject_type /= Void then
				myobject := get_object_if_valid_tree ($1)
				if myobject /= Void then
					-- the last object in the tree knows what expression to build here
					$$ := last_object_in_tree.create_expression ($1)
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
			end
		}
	| '-' property_name
		{
			if subject_type /= Void then
				myobject := get_object_if_valid_tree ($2)
				if myobject /= Void then
					-- the last object in the tree knows what expression to build here
					dummye := last_object_in_tree.create_expression ($2)
					create {XPLAIN_PREFIX_EXPRESSION} $$.make ("-", dummye)
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
			end
		}
	| system_variable
		{ $$ := $1 }

-- put here string functions
	| XPLAIN_COMBINE property_list ')'
		{
			create {XPLAIN_COMBINE_FUNCTION} $$.make ($2)
		}
--	| XPLAIN_HEAD property_expression ')'
--	| XPLAIN_TAIL property_expression ')'

-- and conversion functions
	| XPLAIN_DATEF property_expression ')'
		{
			create {XPLAIN_DATEF_FUNCTION} $$.make ($2)
		}
	| XPLAIN_INTEGERF property_expression ')'
		{
			create {XPLAIN_INTEGER_FUNCTION} $$.make ($2)
		}
	| XPLAIN_REALF property_expression ')'
		{
			create {XPLAIN_REAL_FUNCTION} $$.make ($2)
		}
	| XPLAIN_STRINGF property_expression ')'
		{
			create {XPLAIN_STRING_FUNCTION} $$.make ($2)
		}

-- and mathematical functions

		-- enhanced Xplain functions:
	| XPLAIN_ID
		{ create {XPLAIN_ID_FUNCTION} $$.make (subject_type) }

	| '(' property_expression ')'
		{ create {XPLAIN_PARENTHESIS_EXPRESSION} $$.make ($2) }
	| '-' '(' property_expression ')'
		{ create {XPLAIN_PARENTHESIS_EXPRESSION} $$.make ($3)
		  create {XPLAIN_PREFIX_EXPRESSION} $$.make ("-", $$) }
	| text
		{ create {XPLAIN_STRING_EXPRESSION} $$.make ($1) }
	| numeric
		{ create {XPLAIN_NUMBER_EXPRESSION} $$.make ($1) }
	| logical_value
		{ $$ := $1 }
	| ':' any_name
		{ create {XPLAIN_UNMANAGED_PARAMETER_EXPRESSION} $$.make ($2.full_name) }
	| '?' parameter_name
		{
			if is_parameter_declared ($2) then
				create {XPLAIN_PARAMETER_EXPRESSION} $$.make ($2)
			end
			}

		-- user functions
	| '$' name '(' ')'
		{
			create {XPLAIN_USER_FUNCTION} $$.make ($2, Void)
		}
	| '$' name '(' property_list ')'
		{
			create {XPLAIN_USER_FUNCTION} $$.make ($2, $4)
		}

		-- any SQL expression
	| LITERAL_SQL
		{ create {XPLAIN_SQL_EXPRESSION} $$.make ($1) }
	;

numeric: integer
	{ $$ := $1.out }
  | real
	{ $$ := $1 }
  ;

property_name
	: any_name
		{ create $$.make ($1, Void) }
	| any_name XPLAIN_ITS property_name
		{ create $$.make ($1, $3) }
	;

-- allow attributes, constant or values
any_name
	: name
		{ create $$.make (Void, $1) }
	| role '_' name
		{ create $$.make ($1, $3) }
	;

parameter_name
	: attribute
		{ $$ := $1 }
	;

initialization: type_name
		{ subject_type := get_known_type ($1) }
	XPLAIN_ITS attribute_name '=' init_specification
		{
			myattribute := subject_type.find_attribute ($4)
			if myattribute = Void then
				error_unknown_attribute ($1, $4)
			else
				if myattribute.init /= Void then
					report_warning (format ("Attribute `$s' already has an initialization expression.", <<myattribute.full_name>>))
				end
				if is_init_default then
					myattribute.set_init_default ($6)
				else
					myattribute.set_init ($6)
				end
				$$ := subject_type
			end
			subject_type := Void
		}
	;

init_specification
	: property_expression
		{ $$ := $1 }
	| '(' logical_expression ')'
		{ $$ := $2 }
	| XPLAIN_CASE selector XPLAIN_OF case_list
	;

condition
	: logical_expression
		{ $$ := $1 }
	;

selector
	: property_expression
		{ $$ := $1 }
	;

case_list
	: element_list default_element
	;

element_list: element ';'
  | element_list element
  ;

element: label ':' init_specification
  ;

label: integer
  | text
  ;

default_element: XPLAIN_DEFAULT ':' init_specification
  ;

domain
	: XPLAIN_A XPLAIN_INTEGER ')'
		{
			last_width := $2
			create {XPLAIN_A_REPRESENTATION} $$.make (last_width)
		}
	| XPLAIN_B ')'
		{ create {XPLAIN_B_REPRESENTATION} $$ }
	| XPLAIN_C XPLAIN_INTEGER ')'
		{
			last_width := $2
			create {XPLAIN_C_REPRESENTATION} $$.make (last_width)
		}
	| XPLAIN_D ')'
		{ create {XPLAIN_D_REPRESENTATION} $$ }
	| XPLAIN_I XPLAIN_INTEGER ')'
		{
			last_width := $2
			create {XPLAIN_I_REPRESENTATION} $$.make ($2)
		}
	| XPLAIN_M ')'
		{ create {XPLAIN_M_REPRESENTATION} $$ }
	| XPLAIN_P ')'
		{ create {XPLAIN_P_REPRESENTATION} $$ }
	| XPLAIN_R XPLAIN_INTEGER ',' XPLAIN_INTEGER ')'
		{
			last_width := $2
			create {XPLAIN_R_REPRESENTATION} $$.make ($2, $4)
		}
	| XPLAIN_T ')'
		{ create {XPLAIN_T_REPRESENTATION} $$ }
	| XPLAIN_R XPLAIN_INTEGER error
		{
			report_error ("Comma expected in R representation instead of: " + text)
			abort
		}
	| error
		{
			report_error ("Representation expected instead of: " + text)
			abort
		}
	;

identification_domain
	: XPLAIN_A XPLAIN_INTEGER ')'
		{
			create {XPLAIN_PK_A_REPRESENTATION} $$.make ($2)
			create {XPLAIN_A_REFERENCES} dummya.make
			$$.set_domain_restriction(sqlgenerator, dummya)
		}
	| XPLAIN_I XPLAIN_INTEGER ')'
		{
			create {XPLAIN_PK_I_REPRESENTATION}$$.make ($2)
			create {XPLAIN_I_REFERENCES} dummyi.make
			$$.set_domain_restriction(sqlgenerator, dummyi)
		}
	| error
		{
			report_error ("type identification expected instead of: " + text)
			abort
		}
	;

type_name
	: name
		{ $$ := $1; current_type_name := $1 }
	;

base_name: name
	{ $$ := $1 }
	;

constant: name
	{ $$ := $1 }
	;

type_or_constant: name
	{ $$ := $1 }
	;

role: name
	{ $$ := $1 }
	;

attribute_list
	: definition_attribute
		{ create {XPLAIN_ATTRIBUTE_NODE} $$.make ($1, Void) }
	| definition_attribute ',' attribute_list
		{ create {XPLAIN_ATTRIBUTE_NODE} $$.make ($1, $3) }
	| definition_attribute error
		{
			report_error ("comma or dot expected instead of: " + text)
			abort
		}
  ;

definition_attribute: '[' attribute ']'
	{ create {XPLAIN_ATTRIBUTE} $$.make (
			$2.role, $2.abstracttype_if_known,
			True, sqlgenerator.check_if_required ($2.abstracttype_if_known),
			True, False) }
  | attribute
	{ create {XPLAIN_ATTRIBUTE} $$.make (
			$1.role, $1.abstracttype_if_known,
			True, sqlgenerator.check_if_required ($1.abstracttype_if_known),
			False, False) }
  | XPLAIN_OPTIONAL attribute
	{ create {XPLAIN_ATTRIBUTE} $$.make (
			$2.role, $2.abstracttype_if_known,
		True, False, False, False) }
  | XPLAIN_REQUIRED attribute
	{ create {XPLAIN_ATTRIBUTE} $$.make (
			$2.role, $2.abstracttype_if_known,
			True, True, False, False) }
  | XPLAIN_UNIQUE attribute
	{ create {XPLAIN_ATTRIBUTE} $$.make (
		$2.role, $2.abstracttype_if_known,
		True, True, False, True) }
  ;

-- attribute is like attribute_name, but type is not (yet) known
attribute
	: name
	{
		myabstracttype := get_known_base_or_type ($1)
		create $$.make (Void, $1)
		if myabstracttype /= Void then
			-- when self reference, it is valid to be Void
			$$.set_object (myabstracttype)
		end
	}
	| role '_' name
	{
		myabstracttype := get_known_base_or_type ($3)
		create $$.make ($1, $3)
		if myabstracttype /= Void then
			-- when self reference, it is valid to be Void
			$$.set_object (myabstracttype)
		end
	}
	;

name
	: XPLAIN_IDENTIFIER
		{ $$ := $1 }
	| XPLAIN_IDENTIFIER name
		{ $$  := $1 + " " + $2 }
	;

text: XPLAIN_STRING
	{ $$ := $1 }
	;

integer: XPLAIN_INTEGER
	{ $$ := $1 }
	;

--date: XPLAIN_INTEGER
--  ;

real: XPLAIN_DOUBLE
	{ $$ := $1 }
	;


-- following not in Xplain 5.8

constant_expression
	: constant_logical_expression
		{ $$ := $1 }
	;

constant_logical_expression
	: constant_logical_term
		{
			dummyl ?= $1
			if dummyl = Void then
				create $$.make ($1)
			else
				$$ := dummyl
			end
		}
	| constant_logical_term XPLAIN_OR constant_logical_expression
		{
			create {XPLAIN_LOGICAL_INFIX_EXPRESSION} dummye.make ($1, "or", $3)
			create $$.make (dummye)
		}
	;

constant_logical_term
	: constant_logical_factor
		{ $$ := $1 }
	| constant_logical_factor XPLAIN_AND constant_logical_term
		{ create {XPLAIN_LOGICAL_INFIX_EXPRESSION} $$.make ($1, "and", $3) }
	;

constant_logical_factor
	: '(' constant_logical_expression ')'
		{ create {XPLAIN_PARENTHESIS_EXPRESSION} $$.make ($2) }
	| XPLAIN_NOT '(' constant_logical_expression ')'
		{ create {XPLAIN_PARENTHESIS_EXPRESSION} $$.make ($3)
		  create {XPLAIN_NOT_EXPRESSION} $$.make ($$) }
	| number_expression
		{ $$ := $1 }
	| XPLAIN_NOT constant
	{
		-- @@BdB: This seems tricky: I shouldn't be able to assign a
		-- variable to a constant. And it looks like that isn't
		-- forbidden in the following code:
		myvariable := universe.find_variable ($2)
		if myvariable = Void then
			-- not a variable, maybe a value?
			-- depends on context, not checked now
			myvalue := universe.find_value ($2)
			if myvalue = Void then
				report_error ("Not a known variable: " + $2)
				abort
			else
				create {XPLAIN_VALUE_EXPRESSION} dummye.make (myvalue)
				create {XPLAIN_NOT_EXPRESSION} $$.make (dummye)
			end
		else
			create {XPLAIN_VARIABLE_EXPRESSION} dummye.make (myvariable)
			create {XPLAIN_NOT_EXPRESSION} $$.make (dummye)
		end
	}
	| text
		{ create {XPLAIN_STRING_EXPRESSION} $$.make ($1) }
	| logical_value
		{ $$ := $1 }
	| XPLAIN_NOT logical_value
		{ create {XPLAIN_NOT_EXPRESSION} $$.make ($2) }
	| number_expression relation number_expression
		{
			create {XPLAIN_LOGICAL_INFIX_EXPRESSION} $$.make ($1, $2, $3)
		}
-- parsed through above relation
--  | string_variable relation string_variable
	;

number_expression
	: number_expression '+' number_term
		{ create {XPLAIN_INFIX_EXPRESSION} $$.make ($1, "+", $3) }
	| number_expression '-' number_term
		{ create {XPLAIN_INFIX_EXPRESSION} $$.make ($1, "-", $3) }
	| number_term
		{ $$ := $1 }
	;

number_term
	: number_term '*' number_factor
		{ create {XPLAIN_INFIX_EXPRESSION} $$.make ($1, "*", $3) }
	| number_term '/' number_factor
		{ create {XPLAIN_INFIX_EXPRESSION} $$.make ($1, "/", $3) }
	| number_factor
		{ $$ := $1 }
	;

number_factor
	: '(' number_expression ')'
		{ create {XPLAIN_PARENTHESIS_EXPRESSION} $$.make ($2) }
	| numeric
	{ create {XPLAIN_NUMBER_EXPRESSION} $$.make ($1) }
	| '-' number_factor
	{ create {XPLAIN_PREFIX_EXPRESSION} $$.make ("-", $2) }
	| constant
	{ myvariable := universe.find_variable ($1)
		if myvariable = Void then
			-- not a variable, maybe a value?
			-- depends on context, not checked now
			myvalue := universe.find_value ($1)
			if myvalue = Void then
				report_error ("Not a known variable: " + $1)
				abort
			else
				create {XPLAIN_VALUE_EXPRESSION} $$.make (myvalue)
			end
		else
			create {XPLAIN_VARIABLE_EXPRESSION} $$.make (myvariable)
		end
	}
	;


-- assert and check not in Xplain 5.8
-- these are static constraints (assert) and dynamic constraints
-- (init [default] and check)

optional_trajectory
	: --- empty
	| trajectory { $$ := $1 }
	;

assert_definition: XPLAIN_ASSERT type_name XPLAIN_ITS
		{
			extend_type := get_known_type ($2)
			subject_type := extend_type            -- in case of expression extension
			last_width := 1 -- hack, incorrect restriction for assert, must base * on max width of expression
		}
	virtual_attribute optional_trajectory '=' extension_definition
		{
			create {XPLAIN_ASSERTION} $$.make (sqlgenerator, extend_type, $5, $6, $8)
			if immediate_output_mode and then
				($$.is_function or else $$.is_complex or else not sqlgenerator.CalculatedColumnsSupported) then
				write_pending_statement
				sqlgenerator.write_assertion ($$)
			end
		}
	| XPLAIN_ASSERT type_name XPLAIN_WITH error
		{
			report_error ("Please use its instead of with.")
			abort
		}
	| XPLAIN_ASSERT virtual_value domain_constraint '=' value_definition
		{
			report_warning ("Virtual value assertion not yet supported. No code will be generated.")
		}
	;

virtual_attribute: name
	{ $$ := $1 }
  ;

virtual_value: name
	{ $$ := $1 }
  ;

check_definition: XPLAIN_CHECK error
  ;


index_definition:
	XPLAIN_INDEX type_name
	{ write_pending_statement
		subject_type := get_known_type ($2)
	}
	XPLAIN_ITS name '=' simple_attribute_list
	{
		create myindex.make (subject_type, $5, False, False, $7)
		if not use_mode then
			sqlgenerator.write_index (myindex)
		end
	}
  | XPLAIN_UNIQUE XPLAIN_INDEX type_name
	{ write_pending_statement
		subject_type := get_known_type ($3)
	}
	XPLAIN_ITS name '=' simple_attribute_list
	{
		create myindex.make (subject_type, $6, True, False, $8)
		if not use_mode then
			sqlgenerator.write_index (myindex)
		end
	}
  | XPLAIN_CLUSTERED XPLAIN_INDEX type_name
	{ write_pending_statement
		subject_type := get_known_type ($3)
	}
	XPLAIN_ITS name '=' simple_attribute_list
	{
		create myindex.make (subject_type, $6, False, True, $8)
		if not use_mode then
			sqlgenerator.write_index (myindex)
		end
	}
  | XPLAIN_UNIQUE XPLAIN_CLUSTERED XPLAIN_INDEX type_name
	{ write_pending_statement
		subject_type := get_known_type ($4)
	}
	XPLAIN_ITS name '=' simple_attribute_list
	{
		create myindex.make (subject_type, $7, True, True, $9)
		if not use_mode then
			sqlgenerator.write_index (myindex)
		end
	}
	;

optional_simple_attribute_list
	: -- empty
	| XPLAIN_ITS simple_attribute_list { $$ := $2 }
	;

simple_attribute_list
	: attribute
		{
			myattribute := subject_type.find_attribute ($1)
			if myattribute = Void then
				error_unknown_attribute (subject_type.name, $1)
			else
			  create $$.make ($1, Void)
			end
		}
	| attribute ',' simple_attribute_list
		{
			myattribute := subject_type.find_attribute ($1)
			if myattribute = Void then
				error_unknown_attribute (subject_type.name, $1)
			else
				create $$.make ($1, $3)
			end
		}
	| attribute error
		{
			report_error ("comma or dot expected instead of: " + text)
			abort
		}

	;


--------------------
-- data manipulation
--------------------


command
	: retrieval
	| modification
	;

modification
	: update
	| delete
	| insert
	| cascade
	;

insert
	: XPLAIN_INSERT subject XPLAIN_ITS assignment_list
		{
			write_pending_statement
			mytype := $2.type
			warn_attributes_with_inits ($4)
			if
				$2.identification = Void
			then
				report_error ("Identification expected.")
				abort
			elseif
				mytype.representation.is_integer and then
				$2.identification.is_constant and then
				not $2.identification.sqlvalue (sqlgenerator).is_integer
			then
				report_error (format ("Primary key %"$s%" is not an integer.", <<$2.identification.sqlvalue (sqlgenerator)>>))
				abort
			else
				create {XPLAIN_INSERT_STATEMENT} $$.make (mytype, $2.identification, $4)
				if immediate_output_mode then
					sqlgenerator.write_insert (mytype, $2.identification, $4)
				end
			end
			subject_type := Void
		}
	| XPLAIN_INSERT subject '*' XPLAIN_ITS assignment_list
		{
			write_pending_statement
			mytype := $2.type
			if not sqlgenerator.CreateAutoPrimaryKey
			then
				-- Can't abort as it might be output for a dialect that
				-- doesn't support auto primary keys.
				report_warning ("auto primary key support disabled, but insert with '*' as primary key specified.")
			elseif
				not mytype.representation.is_integer
			then
				report_error ("Auto-primary keys on character instance identification not supported.")
				abort
			end
			create {XPLAIN_INSERT_STATEMENT} $$.make (mytype, Void, $5)
			if immediate_output_mode then
				sqlgenerator.write_insert (mytype, Void, $5)
			end
			subject_type := Void
		}
	| XPLAIN_INSERT subject error
		{
			report_error ("its expected instead of: '" + text + "'")
			abort
		}
	| XPLAIN_GET selection_without_set_function XPLAIN_INSERT subject optional_simple_attribute_list
		{
			write_pending_statement
			mytype := $4.type
			create {XPLAIN_GET_INSERT_STATEMENT} $$.make ($2, mytype, False, $5)
			if immediate_output_mode then
				$$.write (sqlgenerator)
			end
			subject_type := Void
		}
	| XPLAIN_GET selection_without_set_function XPLAIN_INSERT subject '*' optional_simple_attribute_list
		{
			write_pending_statement
			mytype := $4.type
			if not sqlgenerator.CreateAutoPrimaryKey
			then
				-- Can't abort as it might be output for a dialect that
				-- doesn't support auto primary keys.
				report_warning ("auto primary key support disabled, but insert with '*' as primary key specified.")
			elseif
				not mytype.representation.is_integer
			then
				report_error ("Auto-primary keys on character instance identification not supported.")
				abort
			end
			create {XPLAIN_GET_INSERT_STATEMENT} $$.make ($2, mytype, True, $6)
			if immediate_output_mode then
				$$.write (sqlgenerator)
			end
			subject_type := Void
		}
	;

assignment_list
	: attribute_assignment
		{ create {XPLAIN_ASSIGNMENT_NODE} $$.make ($1, Void) }
	| attribute_assignment ',' assignment_list
		{ create {XPLAIN_ASSIGNMENT_NODE} $$.make ($1, $3) }
	| attribute_assignment error
		{
			report_error ("comma or dot expected instead of: " + text)
			abort
		}
	;

attribute_assignment
	: attribute_name '=' assigned_value
		{ create {XPLAIN_ASSIGNMENT} $$.make ($1, $3) }
	;

assigned_value
	: property_expression
		{ $$ := $1 }
	| '(' logical_expression ')'
		{ $$ := $2 }
	;

cascade
	: XPLAIN_CASCADE name XPLAIN_ITS
		{
			subject_type := get_known_type ($2)
		}
		attribute_name '=' cascade_definition
		{
			if $7 /= Void then
				subject_type := get_known_type ($2) -- subject_type changed by cascade_definition I think
				create $$.make (sqlgenerator, subject_type, $5, $7)
				if immediate_output_mode then
					$$.write (sqlgenerator)
				end
			end
		}
		-- to check:
		-- `attribute_name' should occur in `property_expressoion'
		-- `name' should have same type as type(s) listed in `grouping_attribute'
	;

-- @@BdB: can be just set_function I think, because any is ok according to
-- modeling II
cascade_definition
	: selection_with_set_function XPLAIN_PER grouping_attribute
		{
			myobject := get_object_if_valid_tree ($3)
			if myobject /= Void then
				create {XPLAIN_CASCADE_FUNCTION_EXPRESSION} $$.make ($1, $3)
			end
		}
	| property_expression
	| '(' logical_expression ')'
	;

-- @@BdB: grouping can be multiple property names, separated by comma
-- Still have to figure out what that means exactly
grouping_attribute
	: property_name
		{ $$ := $1 }
	;

delete: XPLAIN_DELETE subject predicate
	{
		write_pending_statement
		if immediate_output_mode then
			sqlgenerator.write_delete ($2, $3)
		end
		subject_type := Void
		create $$.make ($2, $3)
	}
	;

subject
	: name idstring
		{
			subject_type := get_known_type ($1)
			if subject_type = Void then
				report_error ("Type `" + $1 + "' not known.")
				abort
			else
				my_str ?= $2
				if my_str /= Void and then subject_type.representation.length < my_str.value.count then
					report_error ("Instance identification %"" + my_str.value + "%" does not fit in domain " + subject_type.representation.domain + " of type " + subject_type.name + ".")
					abort
				else
					create {XPLAIN_SUBJECT} $$.make (subject_type, $2)
				end
			end
		}
	;

idstring
	: -- empty
	| text
		{
			-- number or string
			if $1.is_integer then
				create {XPLAIN_NUMBER_EXPRESSION} $$.make ($1)
			else
				create {XPLAIN_STRING_EXPRESSION} $$.make ($1)
			end
		}
	| '?' parameter_name
		{
			if is_parameter_declared ($2) then
				create {XPLAIN_PARAMETER_EXPRESSION} $$.make ($2)
			end
		}
	| '(' name ')'
		{
			myvalue := get_known_value ($2)
			if myvalue /= Void then
				create {XPLAIN_VALUE_EXPRESSION} $$.make (myvalue)
			end
		}
	| '(' error
		{
			report_error ("name of a value expected instead of: " + text)
			abort
		}
	;

update
	: XPLAIN_UPDATE subject	XPLAIN_ITS assignment_list predicate
	{
		write_pending_statement
		if immediate_output_mode then
			sqlgenerator.write_update ($2, $4, $5)
		end
		subject_type := Void
		create $$.make ($2, $4, $5)
	}
	| XPLAIN_UPDATE subject error
		{ report_error ("its expected instead of: '" + text + "'")
		  abort }
	;

attribute_name: name
	{
		create {XPLAIN_ATTRIBUTE_NAME} $$.make (Void, $1)
		myattribute := subject_type.find_attribute ($$)
		if myattribute = Void then
			error_unknown_attribute (subject_type.name, $$)
		else
			$$.set_attribute (myattribute)
		end
	}
	| role '_' name
	{
		create {XPLAIN_ATTRIBUTE_NAME} $$.make ($1, $3)
		myattribute := subject_type.find_attribute ($$)
		if myattribute = Void then
			error_unknown_attribute (subject_type.name, $$)
		else
			$$.set_attribute (myattribute)
		end
	}
	;

retrieval: selection
	| extension
	| value
	| echo
-- not in Xplain 5.8
	| value_selection
	;

value
	: XPLAIN_VALUE name '=' value_definition
		{
			write_pending_statement
			create myvalue.make (sqlgenerator, $2, $4)
			if immediate_output_mode then
				sqlgenerator.write_value (myvalue)
			end
			universe.add (myvalue)
			create $$.make (myvalue)
		}
	;

value_definition
	: constant_expression
		{ $$ := $1 }
	| value_selection_expression
		{ create {XPLAIN_SELECTION_EXPRESSION} $$.make ($1) }
	| XPLAIN_INSERTED type_name
		{
			mytype := get_known_type ($2)
			if not sqlgenerator.CreateAutoPrimaryKey then
				report_error ("Auto primary key support disabled or not supported. Cannot retrieve auto-generated primary key.")
			end
			if mytype /= Void then
				create {XPLAIN_LAST_AUTO_PK_EXPRESSION} $$.make (mytype)
			end
		}
	| input
	| ':' parameter_name
		{ create {XPLAIN_UNMANAGED_PARAMETER_EXPRESSION} $$.make ($2.full_name) }
	| system_variable
		{ $$ := $1 }
	| '?' parameter_name
		{
			if is_parameter_declared ($2) then
				create {XPLAIN_PARAMETER_EXPRESSION} $$.make ($2)
			end
			}

		-- conversion functions
	| XPLAIN_DATEF value_definition ')'
		{
			create {XPLAIN_DATEF_FUNCTION} $$.make ($2)
		}
	| XPLAIN_INTEGERF value_definition ')'
		{
			create {XPLAIN_INTEGER_FUNCTION} $$.make ($2)
		}
	| XPLAIN_REALF value_definition ')'
		{
			create {XPLAIN_REAL_FUNCTION} $$.make ($2)
		}
	| XPLAIN_STRINGF value_definition ')'
		{
			create {XPLAIN_STRING_FUNCTION} $$.make ($2)
		}

		-- user functions
	| '$' name '(' ')'
		{
			create {XPLAIN_USER_FUNCTION} $$.make ($2, Void)
		}
	| '$' name '(' property_list ')'
		{
			create {XPLAIN_USER_FUNCTION} $$.make ($2, $4)
		}
	| LITERAL_SQL
		{ create {XPLAIN_SQL_EXPRESSION} $$.make ($1) }
	;

value_selection
	: XPLAIN_VALUE name
		{
			write_pending_statement
			myvalue := get_known_value ($2)
			if myvalue /= Void then
				if immediate_output_mode then
					sqlgenerator.write_select_value (myvalue)
				end
				create $$.make (myvalue)
			end
		}
	;

input
	: XPLAIN_INPUT domain
		{
			report_error ("Input not yet supported.")
			abort
		}
	| input domain text
		{
			report_error ("Input not yet supported.")
			abort
		}
	;

value_selection_expression
	: set_function subject property predicate
		 {
			if $1.property_required = 0 and $3 /= Void then
				report_error ("Function " + $1.name + " does not allow a property to be present.")
				abort
			elseif $1.property_required = 1 and $3 = Void then
				report_error ("Function " + $1.name + " requires the presence of a property.")
				abort
			else
				create $$.make ($1, $2, $3, $4)
			end
		}
	;


selection
	: XPLAIN_GET selection_expression
	{
		create {XPLAIN_GET_STATEMENT} $$.make ($2)
		write_pending_statement
		if immediate_output_mode then
			sqlgenerator.write_select ($2)
		end
		subject_type := Void
	}
	;

extension
	: XPLAIN_EXTEND extension_expression
		{
			if immediate_output_mode then
				sqlgenerator.write_extend ($2)
			end
			subject_type := Void
			create $$.make ($2)
		}
	;

extension_expression
	: name XPLAIN_WITH
		{
			write_pending_statement
			extend_type := get_known_type ($1)
			subject_type := extend_type -- in case of expression extension
			}
	extend_attribute '=' extension_definition
		{
			if extend_type.has_attribute (Void, $4.name) then
				report_error (format ("Cannot extend type `$s' with attribute `$s', because it already has an attribute with that name.", <<$1, $4.name>>))
				abort
			else
				if universe.has ($4.name) then
					report_error (format ("There is already an object (constant, value, base, type or procedure) with name `$s'. The name of an extend must be unique to avoid ambiguous expressions.", <<$4.name>>))
					abort
				else
					create $$.make (sqlgenerator, extend_type, $4, $6)
					--extend_type.add_extension ($$)
				end
			end
		}
	| name XPLAIN_ITS
		{
			report_error ("Use with instead of its in the extend expression.")
			abort
		}
	;

extend_attribute
	: name
		{ create $$.make ($1, Void) }
	| name domain
		{ create $$.make ($1, $2); $2.set_domain_restriction (sqlgenerator, dummyrestriction) }
	;

extension_definition
	: property_expression
		{ create {XPLAIN_EXTENSION_EXPRESSION_EXPRESSION} $$.make ($1) }
	| '(' logical_expression ')'
		{ create {XPLAIN_EXTENSION_EXPRESSION_EXPRESSION} $$.make ($2) }
	| selection_with_set_function XPLAIN_PER property_name
	{ -- check per attribute tree for validness
		myobject := get_object_if_valid_tree ($3)
		if myobject /= Void then
			if $3.last.item.object = extend_type then
				create {XPLAIN_EXTENSION_FUNCTION_EXPRESSION} $$.make ($1, $3)
			else
				report_error ("Error in per clause. The given type is `" + $3.last.item.object.name + "', while the expected type is `" + extend_type.name + "'. Make sure the per property ends in the same type that is being extended.")
				abort
			end

-- 			mytype ?= $3.last.item.object
-- 			if mytype /= Void then
-- 				create {XPLAIN_EXTENSION_FUNCTION_EXPRESSION} $$.make ($1, $3)
-- 			else
-- 				report_error ("Per property must be a type, cannot be a base.")
-- 				abort
-- 			end
		end
	}
	| selection_with_set_function error
	{ report_error("per keyword expected instead of: " + text)
		abort }
	;

selection_expression
	: selection_without_set_function
		{ $$ := $1 }
	| selection_with_set_function
		{ $$ := $1 }
	;

selection_without_set_function
	: subject selection_list predicate selection_sort_order
		{ create {XPLAIN_SELECTION_LIST} $$.make ($1, $2, $3, $4)
		}
	| text subject selection_list predicate selection_sort_order
		{
		  create {XPLAIN_SELECTION_LIST} $$.make ($2, $3, $4, $5)
			$$.set_identification_text ($1)
		}
	;

selection_sort_order: -- empty
  | XPLAIN_PER sort_order_list
		{ $$ := $2 }
  ;

sort_order_list
	: property_name {
		myobject := get_object_if_valid_tree ($1)
		if myobject /= Void then
			create {XPLAIN_SORT_NODE} $$.make ($1, True, Void)
		end }
	| '-' property_name {
		myobject := get_object_if_valid_tree ($2)
		if myobject /= Void then
			create {XPLAIN_SORT_NODE} $$.make ($2, False, Void)
		end }
	| property_name ',' sort_order_list	{
		myobject := get_object_if_valid_tree ($1)
		if myobject /= Void then
			create {XPLAIN_SORT_NODE} $$.make ($1, True, $3)
		end }
	| '-' property_name ',' sort_order_list {
		myobject := get_object_if_valid_tree ($2)
		if myobject /= Void then
			create {XPLAIN_SORT_NODE} $$.make ($2, False, $4)
		end }
  ;

selection_with_set_function
	: set_function subject property predicate
		{
			if $1.property_required = 0 and $3 /= Void then
				report_error ("Function " + $1.name + " does not allow a property to be present.")
				abort
			elseif $1.property_required = 1 and $3 = Void then
				report_error ("Function " + $1.name + " requires the presence of a property.")
				abort
			else
				create $$.make ($1, $2, $3, $4)
			end
		}
	;

set_function: XPLAIN_MAX
	{ create {XPLAIN_MAX_FUNCTION} $$ }
  | XPLAIN_MIN
	{ create {XPLAIN_MIN_FUNCTION} $$ }
  | XPLAIN_TOTAL
	{ create {XPLAIN_TOTAL_FUNCTION} $$ }
  | XPLAIN_COUNT
	{ create {XPLAIN_COUNT_FUNCTION} $$ }
  | XPLAIN_ANY
	{ create {XPLAIN_ANY_FUNCTION} $$ }
  | XPLAIN_NIL
	{ create {XPLAIN_NIL_FUNCTION} $$ }
  | XPLAIN_SOME
	{ create {XPLAIN_SOME_FUNCTION} $$ }
  ;

-- put string_function through math function here
-- string_function:
-- conversion_function:
-- date_function:
-- mathematical_function:

selection_list
	: -- empty
	| XPLAIN_ITS property_list
		{
			$$ := $2
			$$.give_column_names (2) -- first column is always the instance id
		}
	;

property_list
	: property_expression optional_new_name
		{ create $$.make ($1, $2, Void) }
	| property_expression optional_new_name ',' property_list
		{ create $$.make ($1, $2, $4) }
	| property_expression optional_new_name ',' XPLAIN_ITS
		{
			report_error ("its keyword should not appear after comma. Remove it.")
			abort
		}
	| property_expression optional_new_name ',' ','
		{
			report_error ("Superfluous comma detected. Remove it.")
			abort
		}
	;

property
	: -- empty
	| XPLAIN_ITS property_expression
		{ $$ := $2 }
	;

optional_new_name
	: -- empty
	| XPLAIN_AS name
		{ $$ := $2 }
	| XPLAIN_AS XPLAIN_STRING
		{
			report_error ("The as keyword should be followed by a name (my name) or a quoted name (`my new name'), not by a string.")
			abort
		}
	;

predicate
	: -- empty
	| XPLAIN_WHERE logical_expression
		{ $$ := $2 }
	;

echo
	: XPLAIN_ECHO XPLAIN_STRING
	{
		if not use_mode then
			sqlgenerator.echo($2)
			sqlgenerator.write_echo($2)
		end
	}
	;


--------------------
-- stored procedure
--------------------

procedure
	: procedure_kind
		{
			write_pending_statement
			procedure_mode := True
		}
		name optional_procedure_parameters '='
		{
			my_parameters := $4
		}
		optional_procedure_statement_list XPLAIN_END
		{
			procedure_mode := False
			create myprocedure.make ($3, $4, $1, $7)
			universe.add (myprocedure)
			if immediate_output_mode then
				sqlgenerator.write_procedure (myprocedure)
			end
			create $$.make (myprocedure)
		}
	;

procedure_kind
	: XPLAIN_PROCEDURE { $$ := 0 }
	| XPLAIN_RECOMPILED_PROCEDURE { $$ := 1 }
	| XPLAIN_TRIGGER_PROCEDURE { $$ := 2 }
	| XPLAIN_PATH_PROCEDURE { $$ := 3 }
	;

optional_procedure_parameters
	: -- empty
	| XPLAIN_WITH procedure_parameter_list
		{ $$ := $2 }
	;

procedure_parameter_list
	: attribute
		{ create $$.make ($1, Void) }
	| attribute ',' procedure_parameter_list
		{ create $$.make ($1, $3) }
	;

optional_procedure_statement_list
	: -- empty
	| procedure_statement_list
		{ $$ := $1 }
	;

procedure_statement_list
	: procedure_supported_command '.'
		{
			create $$.make ($1, Void)
		}
	| procedure_supported_command '.' procedure_statement_list
		{
			create $$.make ($1, $3)
		}
	| sql
		{
			create $$.make ($1, Void)
		}
	| sql procedure_statement_list
		{
			create $$.make ($1, $2)
		}
	| error
		{
			if equal (text, "end") then
				report_error ("Unexpected 'end' in stored procedure. '.' missing in last statement?")
				abort
			else
				report_error ("Stumbled upon: " + text)
				abort
		end
		}
	| XPLAIN_BASE error
		{ report_error ("A base statement cannot appear in a procedure."); abort }
	| XPLAIN_TYPE error
		{ report_error ("A type statement cannot appear in a procedure."); abort }
	| XPLAIN_ASSERT error
		{ report_error ("An assert statement cannot appear in a procedure."); abort }
	| XPLAIN_INIT error
		{ report_error ("An init statement cannot appear in a procedure."); abort }
	| XPLAIN_PROCEDURE error
		{ report_error ("A procedure statement cannot appear in a procedure."); abort }
	;

procedure_supported_command
	: extension
		{ $$ := $1 }
	| delete
		{ $$ := $1 }
	| insert
		{ $$ := $1 }
	| selection
		{ $$ := $1 }
	| update
		{ $$ := $1 }
	| value
		{ $$ := $1 }
	| value_selection
		{ $$ := $1 }
	;


--------------------
-- literal sql
--------------------

sql
	: LITERAL_SQL
		{
			create $$.make ($1)
			if immediate_output_mode then
				sqlgenerator.write_sql ($1)
			end
		}
	;

--------------------------------------------------------------------------------
%%

feature -- Initialization

	make_with_file (a_file: KI_CHARACTER_INPUT_STREAM; a_sqlgenerator: SQL_GENERATOR) is
		require
			sqlgenerator_not_void: a_sqlgenerator /= Void
		do
			make_scanner_with_file (a_file)
			make (a_sqlgenerator)
		end

	make_with_stdin (a_sqlgenerator: SQL_GENERATOR) is
		require
			sqlgenerator_not_void: a_sqlgenerator /= Void
		do
			make_scanner_with_stdin
			make (a_sqlgenerator)
		end


feature {NONE} -- private creation

	make (a_sqlgenerator: SQL_GENERATOR) is
		do
			make_parser_skeleton
			create statements.make
			set_sqlgenerator (a_sqlgenerator)
		end


feature {NONE} -- dummy variables to store created objects in

	dummya: XPLAIN_A_REFERENCES
	dummyi: XPLAIN_I_REFERENCES
	dummye: XPLAIN_EXPRESSION
	dummyl: XPLAIN_LOGICAL_EXPRESSION
	dummybool: XPLAIN_LOGICAL_VALUE_EXPRESSION
	dummyrestriction: XPLAIN_DOMAIN_RESTRICTION

	last_width: INTEGER
			-- saves latest domain width, for example I2 will save 2 here

feature {NONE} -- local variables, do not survive outside a code block!

	myobject: XPLAIN_ABSTRACT_OBJECT
	myabstracttype: XPLAIN_ABSTRACT_TYPE
	mytype: XPLAIN_TYPE
	myvariable: XPLAIN_VARIABLE
	myvalue: XPLAIN_VALUE
	myattribute: XPLAIN_ATTRIBUTE
	myindex: XPLAIN_INDEX
	myprocedure: XPLAIN_PROCEDURE
	current_type_name: STRING
	auto_identifier: BOOLEAN
	my_selection_function: XPLAIN_SELECTION_FUNCTION
	my_str: XPLAIN_STRING_EXPRESSION

	is_init_default: BOOLEAN
			-- Determine if init or init default statement has to be created.


feature {NONE} -- these vars survive a little bit longer

	subject_type: XPLAIN_TYPE  -- used to check if valid attribute
	extend_type: XPLAIN_TYPE   -- used in extend statement
	my_parameters: XPLAIN_ATTRIBUTE_NAME_NODE
			-- List of declared parameters for a procedure

feature -- Xplain

	statements: XPLAIN_STATEMENTS
			-- All executable statements.


feature {NONE} -- Expression generation

	new_logical_infix_expression (a_left: XPLAIN_EXPRESSION; an_operator: STRING; a_right: XPLAIN_EXPRESSION): XPLAIN_INFIX_EXPRESSION is
			-- Create a new infix expression. It's main purpose is to
			-- determine when to use the like operator instead of the '='
			-- operator.
		require
			valid_left: a_left /= Void
			valid_right: a_right /= Void
			operator_not_empty: an_operator /= Void and then not an_operator.is_empty
		local
			equal_operator,
			not_equal_operator: BOOLEAN
		do
			if an_operator.is_equal (once_equal) then
				equal_operator := True
			elseif an_operator.is_equal (once_not_equal) then
				not_equal_operator := True
			end
			if equal_operator or else not_equal_operator then
				if a_left.has_wild_card_characters or a_right.has_wild_card_characters then
					if equal_operator then
						create {XPLAIN_LIKE_EXPRESSION} Result.make (a_left, a_right)
					else
						create {XPLAIN_NOT_LIKE_EXPRESSION} Result.make (a_left, a_right)
					end
				end
			end

			-- Fallback to standard infix expression.
			if Result = Void then
				create {XPLAIN_LOGICAL_INFIX_EXPRESSION} Result.make (a_left, an_operator, a_right)
			end
		ensure
			new_infix_expression_not_void: Result /= Void
		end


feature -- Middleware

	mwgenerator: MIDDLEWARE_GENERATOR

	set_mwgenerator (mwg: MIDDLEWARE_GENERATOR) is
		do
			mwgenerator := mwg
		end


feature {NONE} -- Error handling

	error_unknown_attribute (a_type: STRING; an_attribute: XPLAIN_ATTRIBUTE_NAME) is
			-- abort with unknown attribute error
		local
			s: STRING
		do
			s := "Type `" + a_type + "' does not have the attribute `"
			if an_attribute.role /= Void then
				s := s + an_attribute.role + "_"
			end
			s := s + an_attribute.name + "'."
			report_error (s)
			abort
		end

feature {NONE} -- pending statements

	pending_type: XPLAIN_TYPE
			-- set for type not yet written

	write_pending_init is
		require
			pending_type_written: pending_init = Void or else pending_type = Void
		do
			if pending_init /= Void then
				if not use_mode then
					sqlgenerator.write_init (pending_init)
				end
				pending_init := Void
			end
		ensure
			pending_init_void: pending_init = Void
		end

	write_pending_statement is
			-- Call this before outputting anything!
		do
			write_pending_type
			write_pending_init
		ensure then
			pending_init_void: pending_init = Void
		end

	write_pending_type is
		do
			if pending_type /= Void then
				if not use_mode then
					sqlgenerator.write_type (pending_type)
					if mwgenerator /= Void then
						mwgenerator.dump_type (pending_type, sqlgenerator)
					end
				end
				pending_type := Void
			end
		ensure
			pending_type_void: pending_type = Void
		end


feature {NONE} -- Checks for validness of parsed code

	get_known_base_or_type (name: STRING): XPLAIN_ABSTRACT_TYPE is
			-- Test if known type, but be aware of self-reference.
		do
			Result := universe.find_base_or_type (name)
			if Result = Void and then
				not equal(current_type_name, name) then
				report_error ("Unknown base or type: " + name)
				abort
			end
		end

	get_known_object (name: STRING): XPLAIN_ABSTRACT_OBJECT is
			-- Return object, must exist.
		do
			Result := universe.find_object (name)
			if Result = Void then
				report_error ("Not a defined object: " + name)
				abort
			end
		end

	get_known_type (name: STRING): XPLAIN_TYPE is
			-- Return the type for `name' or die.
		local
			b: XPLAIN_BASE
		do
			Result := universe.find_type (name)
			if Result = Void then
				b := universe.find_base (name)
				if b = Void then
					report_error ("Type unknown: " + name)
				else
					report_error (format ("`$s' is a base, but a type is expected here.", <<name>>))
				end
				abort
			end
		end

	get_known_value (name: STRING): XPLAIN_VALUE is
		do
			Result := universe.find_value (name)
			if Result = Void then
				report_error ("Value unknown: " + name)
				abort
			end
		end

	last_object_in_tree: XPLAIN_ABSTRACT_OBJECT
			-- Set by `get_object_if_valid_tree' to last object in list.

	get_object_if_valid_tree (first: XPLAIN_ATTRIBUTE_NAME_NODE): XPLAIN_ABSTRACT_OBJECT is
			-- The object for the first name of this tree, if this
			-- is a valid tree;
			-- Also augment tree with type information.
		require
			first_not_void: first /= Void
			subject_type_set: subject_type /= Void
		local
			my_attribute: XPLAIN_ATTRIBUTE
			value: XPLAIN_VALUE
			variable: XPLAIN_VARIABLE
			node: XPLAIN_ATTRIBUTE_NAME_NODE
			preceding_type: XPLAIN_TYPE
			atype: XPLAIN_ABSTRACT_TYPE
			valid_attribute: BOOLEAN
			msg: STRING
		do
			last_object_in_tree := Void
			if first.next /= Void then
				-- Something like a its b its c, should all be attributes.
				from
					node := first
					preceding_type := subject_type
					valid_attribute := True
				until
					node = Void or
					not valid_attribute
				loop
					my_attribute := preceding_type.find_attribute (node.item)
					valid_attribute := my_attribute /= Void
					if valid_attribute then
						node.item.set_attribute (my_attribute)
						atype := my_attribute.abstracttype
						--node.item.set_object (atype)
						if node.next /= Void then
							preceding_type ?= atype
							if preceding_type = Void then
								-- we've a base here (but missed extension
								-- because it's a type, need to fix this)
								valid_attribute := False
								report_error ("A base cannot have attributes. Base name is: " + node.item.name)
								abort
							end
						end
					else -- type doesn't have this attribute
						valid_attribute := False
						report_error ("Type " + preceding_type.name + " doesn't have the attribute: " + node.item.name)
						abort
					end
					node := node.next
				end
				if valid_attribute then
					last_object_in_tree := atype
					Result := subject_type.find_attribute (first.item).abstracttype
				end
			else
				-- Can be value/variable or attribute.
				-- Check attribute first.
				my_attribute := subject_type.find_attribute (first.item)
				if my_attribute = Void then
					Result := universe.find_object (first.item.name)
					if Result = Void then
						report_error ( format("`$s' is not an attribute of type `$s', nor a value or constant.", <<first.item.name, subject_type.name>>))
						abort
					else
						-- check if value/variable
						value ?= Result
						variable ?= Result
						if value = Void and then variable = Void then
							create msg.make (128)
							msg.append_string ("base/type '")
							if first.item.role /= Void then
								msg.append_string (first.item.role)
								msg.append_string ("_")
							end
							msg.append_string (first.item.name)
							msg.append_string ("' is not an attribute of '")
							msg.append_string (subject_type.name)
							msg.append_string ("'%N")
							report_error (msg)
							abort
							Result := Void
						else
							first.item.set_object (Result)
						end
					end
				else
					first.item.set_attribute (my_attribute)
					Result := my_attribute.abstracttype
				end
				if Result /= Void then
					last_object_in_tree := Result
				end
			end
		ensure
			if_not_valid_tree: True -- Warnings are given
			if_valid_tree: True
			-- Result /= Void and object is the object for the first name
			-- in the tree
			last_object_set: Result /= Void implies last_object_in_tree /= Void
		end

	is_parameter_declared (a_name: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Has `a_name' been declared in the parameter list for the
			-- current procedure?
		require
			name_not_empty: a_name /= Void
		do
			Result := my_parameters /= Void and then my_parameters.has (a_name)
			if not Result then
				report_error ("Parameter `" + a_name.full_name + "' has not been declared.")
				abort
			end
		end


feature {NONE} -- Checks

	warn_attributes_with_inits (an_assignment_list: XPLAIN_ASSIGNMENT_NODE) is
			-- Check if user has specified an attribute for which an init
			-- expression exists. Assignment will be (should be...)
			-- ignored in that case.
		require
			an_assignment_list_not_void: an_assignment_list /= Void
		local
			node: XPLAIN_ASSIGNMENT_NODE
		do
			from
				node := an_assignment_list
			until
				node = Void
			loop
				if
					node.item.attribute_name.type_attribute.init /= Void and then
					not node.item.attribute_name.type_attribute.is_init_default
				then
					report_error (format ("Attribute $s has an init expression. Assignment specified in insert will be ignored.%N", <<node.item.attribute_name.full_name>>))
				end
				node := node.next
			end
		end


feature {NONE} -- Once strings

	once_equal: STRING is "="
	once_not_equal: STRING is "<>"


invariant

	have_sqlgenerator: sqlgenerator /= Void
	have_statements: statements /= Void

end
