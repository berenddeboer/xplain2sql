%{
note

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
	%13. 'its' list parsing not strict enough. My accept an %
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
%type <detachable XPLAIN_DOMAIN_RESTRICTION> optional_trajectory
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
%type <detachable XPLAIN_TYPE> initialization
%type <detachable XPLAIN_EXPRESSION> init_specification
%type <XPLAIN_LOGICAL_EXPRESSION> condition
%type <XPLAIN_EXPRESSION> selector
%type <XPLAIN_REPRESENTATION> domain
%type <XPLAIN_PK_REPRESENTATION> identification_domain
%type <STRING> type_name
%type <STRING> base_name
%type <STRING> constant
%type <STRING> type_or_constant
%type <STRING> role
%type <detachable XPLAIN_ATTRIBUTE_NODE> attribute_list
%type <XPLAIN_ATTRIBUTE> definition_attribute
%type <XPLAIN_ATTRIBUTE_NAME> attribute
%type <STRING> name
%type <STRING> text
%type <INTEGER> integer
%type <STRING> real

%type <XPLAIN_EXPRESSION> constant_or_value_expression
%type <XPLAIN_EXPRESSION> number_expression
%type <XPLAIN_EXPRESSION> number_term
%type <XPLAIN_EXPRESSION> number_factor
%type <XPLAIN_LOGICAL_EXPRESSION> constant_logical_expression
%type <XPLAIN_EXPRESSION> constant_logical_term
%type <XPLAIN_EXPRESSION> constant_logical_factor

%type <detachable XPLAIN_ASSERTION> assert_definition
%type <STRING> virtual_attribute

%type <detachable XPLAIN_ATTRIBUTE_NAME_NODE> optional_simple_attribute_list
%type <detachable XPLAIN_ATTRIBUTE_NAME_NODE> simple_attribute_list

%type <detachable XPLAIN_ASSIGNMENT_NODE> assignment_list
%type <XPLAIN_ASSIGNMENT> attribute_assignment
%type <XPLAIN_EXPRESSION> assigned_value
%type <detachable XPLAIN_SUBJECT> subject
%type <detachable XPLAIN_EXPRESSION> idstring
%type <XPLAIN_ATTRIBUTE_NAME> attribute_name
%type <XPLAIN_EXPRESSION> value_definition
%type <detachable XPLAIN_NON_ATTRIBUTE_EXPRESSION> input
%type <detachable XPLAIN_SELECTION_FUNCTION> value_selection_expression
%type <detachable XPLAIN_EXTENSION> extension_expression
%type <XPLAIN_EXTEND_ATTRIBUTE> extend_attribute
%type <detachable XPLAIN_EXTENSION_EXPRESSION> extension_definition
%type <detachable XPLAIN_SELECTION> selection_expression
%type <detachable XPLAIN_SELECTION_LIST> selection_without_set_function
%type <detachable XPLAIN_SORT_NODE> selection_sort_order
%type <detachable XPLAIN_SORT_NODE> sort_order_list
%type <detachable XPLAIN_SELECTION_FUNCTION> selection_with_set_function
%type <XPLAIN_FUNCTION> set_function
%type <detachable XPLAIN_EXPRESSION_NODE> selection_list
-- property_list is actually attached: we error if we can't, but
-- this is not something the compiler can detect
%type <detachable XPLAIN_EXPRESSION_NODE> property_list
%type <detachable XPLAIN_EXPRESSION> property
%type <detachable STRING> optional_new_name
%type <detachable XPLAIN_EXPRESSION> predicate

%type <detachable XPLAIN_ATTRIBUTE_NAME_NODE> optional_procedure_parameters
%type <XPLAIN_ATTRIBUTE_NAME_NODE> procedure_parameter_list
%type <detachable XPLAIN_STATEMENT_NODE> optional_procedure_statement_list
%type <detachable XPLAIN_STATEMENT_NODE> procedure_statement_list
%type <detachable XPLAIN_STATEMENT> procedure_supported_command

%type <detachable XPLAIN_STATEMENT> user_command
%type <detachable XPLAIN_STATEMENT> definition_command
%type <detachable XPLAIN_STATEMENT> command
%type <detachable XPLAIN_STATEMENT> retrieval
%type <detachable XPLAIN_STATEMENT> modification
%type <detachable XPLAIN_STATEMENT> definition
%type <detachable XPLAIN_STATEMENT> deletion
%type <detachable XPLAIN_STATEMENT> type_deletion
%type <detachable XPLAIN_STATEMENT> general_deletion
%type <detachable XPLAIN_CONSTANT_STATEMENT> constant_definition
%type <detachable XPLAIN_CONSTANT_ASSIGNMENT_STATEMENT> constant_assignment
%type <detachable XPLAIN_CASCADE_STATEMENT> cascade
%type <detachable XPLAIN_CASCADE_FUNCTION_EXPRESSION> cascade_definition
%type <XPLAIN_ATTRIBUTE_NAME_NODE> grouping_attribute
%type <detachable XPLAIN_DELETE_STATEMENT> delete
%type <detachable XPLAIN_EXTEND_STATEMENT> extension
%type <detachable XPLAIN_GET_STATEMENT> selection
%type <detachable XPLAIN_STATEMENT> insert
%type <detachable XPLAIN_PROCEDURE_STATEMENT> procedure
%type <INTEGER> procedure_kind
%type <XPLAIN_SQL_STATEMENT> sql
%type <XPLAIN_SQL_STATEMENT> optional_sql
%type <detachable XPLAIN_TYPE> type_definition
%type <detachable XPLAIN_UPDATE_STATEMENT> update
%type <XPLAIN_VALUE_STATEMENT> value
%type <detachable XPLAIN_VALUE_SELECTION_STATEMENT> value_selection

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
				if attached $1 as s then -- because statement support is partial at the moment
					statements.add (s)
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
				if attached $1 as s then -- because statement support is partial at the moment
					statements.add (s)
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
		{ $$ := $1 }
	| constant_assignment
		{ $$ := $1 }
	;

definition
	: type_definition
		{
			if attached $1 as t then
				create {XPLAIN_TYPE_STATEMENT} $$.make (t)
				universe.add (t, Current)
			end
		}
	| base_definition
		{
			create {XPLAIN_BASE_STATEMENT} $$.make ($1)
			if not use_mode then
				sqlgenerator.write_base($1)
			end
			universe.add($1, Current)
		}
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
		{ $$ := $1 }
	| general_deletion
		{ $$ := $1 }
	;

constant_assignment
	: constant '=' '(' { constant_mode := True } constant_or_value_expression ')'
		{
			write_pending_statement
			if attached universe.find_variable($1) as variable then
				if not variable.has_value then
					if not use_mode then
						sqlgenerator.write_constant_assignment (variable, $5)
					end
					variable.set_value ($5)
					create $$.make (variable, $5)
				else
					report_error ("Constant `" + $1 + "' has already been assigned a value.")
					abort
				end
			else
				report_error ("Not a valid constant: " + $1)
				abort
			end
			constant_mode := False
		}
	| constant '=' error
		{
			constant_mode := False
			report_error ("A constant assignment expression should be surrounded by parentheses")
			abort
		}
	;



base_definition
	: XPLAIN_BASE base_name domain
	{
		write_pending_statement
		$$ := new_base ($2, $3, False)
	}
	| XPLAIN_BASE base_name domain XPLAIN_REQUIRED
	{
		write_pending_statement
		$$ := new_base ($2, $3, True)
	}
	| XPLAIN_BASE base_name domain domain_constraint
	{
		write_pending_statement
		$3.set_domain_restriction (sqlgenerator, $4)
		$$ := new_base ($2, $3, False)
	}
	;

type_definition
	: XPLAIN_TYPE type_name identification_domain '=' attribute_list
		{
			write_pending_statement
			if attached $5 as al then
				create $$.make ($2, $3, al)
				pending_type := $$
			end
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
			if attached $3 then
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
			if attached $4 then
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
			if attached myvariable as v then
				if not use_mode then
					sqlgenerator.write_constant (v)
				end
				universe.add(v, Current)
				create $$.make (v)
			end
	}
  ;

type_deletion: XPLAIN_PURGE type_or_constant
	{ write_pending_statement
		if attached get_known_object ($2) as myobject then
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
			if attached subject_type as t and then attached t.find_attribute ($5) as myattribute then
				if immediate_output_mode then
					t.write_drop_attribute	(sqlgenerator, myattribute)
				end
			else
				error_unknown_attribute ($2, $5)
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
			-- silence compiler:
			create {XPLAIN_A_PATTERN} $$.make ("")
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
			-- silence compiler:
			create {XPLAIN_I_NODE} $$.make (0, Void)
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
			$$ := new_logical_expression ($1, once "or", $3)
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
			-- silence compiler, we either return something valid or abort:
			create {XPLAIN_LOGICAL_VALUE_EXPRESSION} $$.make (False)
			if attached subject_type then
				if attached get_object_if_valid_tree ($1) and then attached last_object_in_tree as o then
					-- the last object in the tree knows what expression to build here
					if attached o.create_expression ($1) as e then
						if e.is_logical_expression then
							create {XPLAIN_NOTNOT_EXPRESSION} $$.make (e)
						else
							$$ := e
						end
					end
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
			end
			}
	| XPLAIN_NOT property_name
		{
			if attached subject_type then
				if attached get_object_if_valid_tree ($2) and then attached last_object_in_tree as o and then attached o.create_expression ($2) as e then
					-- the last object in the tree knows what expression to build here
					create {XPLAIN_NOT_EXPRESSION} $$.make (e)
				else
					-- silence compiler, we either return something valid or abort:
					create {XPLAIN_LOGICAL_VALUE_EXPRESSION} $$.make (False)
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
				-- silence compiler, we either return something valid or abort:
				create {XPLAIN_LOGICAL_VALUE_EXPRESSION} $$.make (False)
			end

		}
	| '?' parameter_name
		{
			if is_parameter_declared ($2) then
				create {XPLAIN_PARAMETER_EXPRESSION} $$.make ($2)
			else
				-- silence compiler, we either return something valid or abort:
				create {XPLAIN_LOGICAL_VALUE_EXPRESSION} $$.make (False)
			end
			}
	| XPLAIN_NOT '?' parameter_name
		{
			if is_parameter_declared ($3) then
				create {XPLAIN_PARAMETER_EXPRESSION} $$.make ($3)
				create {XPLAIN_NOT_EXPRESSION} $$.make ($$)
			else
				-- silence compiler, we either return something valid or abort:
				create {XPLAIN_LOGICAL_VALUE_EXPRESSION} $$.make (False)
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
			create {XPLAIN_NOT_EXPRESSION} $$.make (new_logical_infix_expression ($2, $3, $4))
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
		{ create {XPLAIN_LOGINNAME_EXPRESSION} $$ }
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
			if attached subject_type as s then
				if attached get_object_if_valid_tree ($1) and then attached last_object_in_tree as last_object then
					-- the last object in the tree knows what expression to build here
					$$ := last_object.create_expression ($1)
				else
					abort
					-- silence compiler, we either return something valid or abort:
					create {XPLAIN_LOGINNAME_EXPRESSION} $$
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
				-- silence compiler, we either return something valid or abort:
				create {XPLAIN_LOGINNAME_EXPRESSION} $$
			end
		}
	| '-' property_name
		{
			if attached subject_type then
				if attached get_object_if_valid_tree ($2) and then attached last_object_in_tree as last_object then
					-- the last object in the tree knows what expression to build here
					create {XPLAIN_PREFIX_EXPRESSION} $$.make ("-", last_object.create_expression ($2))
				else
					-- silence compiler, we either return something valid or abort:
					create {XPLAIN_LOGINNAME_EXPRESSION} $$
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
				$$ := silence_compiler_expression
			end
		}
	| system_variable
		{ $$ := $1 }

-- put here string functions
	| XPLAIN_COMBINE property_list ')'
		{
			if attached $2 as pl then
				create {XPLAIN_COMBINE_FUNCTION} $$.make (pl)
			else
				$$ := silence_compiler_expression
			end
		}
	--	| XPLAIN_HEAD property_expression ')'
	--	| XPLAIN_TAIL property_expression ')'

-- conversion functions
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

-- date functions
	| XPLAIN_NEWDATE property_expression ',' property_expression ')'
		{
			create {XPLAIN_NEWDATE_FUNCTION} $$.make ($2, $4, newdate_default_days)
		}
	| XPLAIN_NEWDATE property_expression ',' property_expression ',' property_expression ')'
		{
			create {XPLAIN_NEWDATE_FUNCTION} $$.make ($2, $4, $6)
		}

-- mathematical functions
-- TODO

-- enhanced Xplain functions:
	| XPLAIN_ID
		{
			if attached subject_type as t then
				create {XPLAIN_ID_FUNCTION} $$.make (t)
			else
				-- silence compiler, we either return something valid or abort:
				create {XPLAIN_LOGINNAME_EXPRESSION} $$
			end
		}

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
			else
				-- silence compiler, we either return something valid or abort:
				create {XPLAIN_LOGINNAME_EXPRESSION} $$
			end
		}

-- user functions (allows calling custom stored procedures)
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
			if attached subject_type as t and then attached t.find_attribute ($4) as myattribute then
				if attached myattribute.init then
					report_warning (format ("Attribute `$s' already has an initialization expression.", <<myattribute.full_name>>))
				end
				if attached $6 as s then
					if is_init_default then
						myattribute.set_init_default (s)
					else
						myattribute.set_init (s)
					end
				end
				$$ := t
			else
				error_unknown_attribute ($1, $4)
			end
			subject_type := Void
		}
	;

init_specification
	: property_expression
		{ $$ := $1 }
	| '(' logical_expression ')'
		{ $$ := $2 }
	| XPLAIN_CASE selector XPLAIN_OF case_list error
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
			-- silence compiler:
			create {XPLAIN_B_REPRESENTATION} $$
		}
	| error
		{
			report_error ("Representation expected instead of: " + text)
			abort
			-- silence compiler:
			create {XPLAIN_B_REPRESENTATION} $$
		}
	;

identification_domain
	: XPLAIN_A XPLAIN_INTEGER ')'
		{
			create {XPLAIN_PK_A_REPRESENTATION} $$.make ($2)
			create {XPLAIN_A_REFERENCES} dummya.make
			if attached dummya as r then
				$$.set_domain_restriction(sqlgenerator, r)
			end
		}
	| XPLAIN_I XPLAIN_INTEGER ')'
		{
			create {XPLAIN_PK_I_REPRESENTATION} $$.make ($2)
			create {XPLAIN_I_REFERENCES} dummyi.make
			if attached dummyi as r then
				$$.set_domain_restriction(sqlgenerator, r)
			end
		}
	| error
		{
			report_error ("type identification expected instead of: " + text)
			abort
			-- silence compiler:
			create {XPLAIN_PK_I_REPRESENTATION}$$.make (1)
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
		create $$.make (Void, $1)
		if attached get_known_base_or_type ($1) as t then
			-- when self reference, it is valid to be Void
			$$.set_object (t)
		end
	}
	| role '_' name
	{
		create $$.make ($1, $3)
		if attached get_known_base_or_type ($3) as t then
			-- when self reference, it is valid to be Void
			$$.set_object (t)
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
-- definition shared with value statement and via some hacks we try
-- try to dissuade the user from using a constant expression that won't work.

constant_or_value_expression
	: constant_logical_expression
		{ $$ := $1 }
	;

constant_logical_expression
	: constant_logical_term
		{
			if attached {XPLAIN_LOGICAL_EXPRESSION} $1 as dummyl then
				$$ := dummyl
			else
				create $$.make ($1)
			end
		}
	| constant_logical_term XPLAIN_OR constant_logical_expression
		{
			$$ := new_logical_expression ($1, once "or", $3)
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
		$$ := silence_compiler_logical_expression
		-- @@BdB: This seems tricky: I shouldn't be able to assign a
		-- variable to a constant. And it looks like that isn't
		-- forbidden in the following code:
		if attached universe.find_variable ($2) as variable then
			create {XPLAIN_VARIABLE_EXPRESSION} dummye.make (variable)
			if attached dummye as e then
				create {XPLAIN_NOT_EXPRESSION} $$.make (e)
			end
		elseif attached universe.find_value ($2) as value then
			-- not a variable, maybe a value?
			-- depends on context, not checked now
			create {XPLAIN_VALUE_EXPRESSION} dummye.make (value)
			if attached dummye as e then
				create {XPLAIN_NOT_EXPRESSION} $$.make (e)
			end
		else
			report_error ("Not a known variable: " + $2)
			abort
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
		{
			if attached universe.find_variable ($1) as variable then
				create {XPLAIN_VARIABLE_EXPRESSION} $$.make (variable)
			elseif attached universe.find_value ($1) as value then
				if not constant_mode then
					-- not a variable, maybe a value?
					-- depends on context, not checked now
					create {XPLAIN_VALUE_EXPRESSION} $$.make (value)
				else
					report_error ("A constant expression can only use constant, not a variable: " + $1)
					abort
					$$ := silence_compiler_expression
				end
			else
				report_error ("Not a known constant or variable: " + $1)
				abort
				$$ := silence_compiler_expression
			end
		}
	| '?' parameter_name
		{
			if is_parameter_declared ($2) then
				create {XPLAIN_PARAMETER_EXPRESSION} $$.make ($2)
			else
				$$ := silence_compiler_expression
			end
		}

	| XPLAIN_NEWDATE property_expression ',' property_expression ')'
		{
			create {XPLAIN_NEWDATE_FUNCTION} $$.make ($2, $4, newdate_default_days)
		}
	| XPLAIN_NEWDATE property_expression ',' property_expression ',' property_expression ')'
		{
			create {XPLAIN_NEWDATE_FUNCTION} $$.make ($2, $4, $6)
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
			if attached extend_type as et and attached $8 as ed then
				create {XPLAIN_ASSERTION} $$.make (sqlgenerator, et, $5, $6, ed)
				if immediate_output_mode and then
					($$.is_function or else $$.is_complex or else not sqlgenerator.CalculatedColumnsSupported) then
					write_pending_statement
					sqlgenerator.write_assertion ($$)
				end
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
		if attached subject_type as st and attached $7 as al then
			create myindex.make (st, $5, False, False, al)
			if not use_mode and then attached myindex as index then
				sqlgenerator.write_index (index)
			end
		end
	}
  | XPLAIN_UNIQUE XPLAIN_INDEX type_name
	{ write_pending_statement
		subject_type := get_known_type ($3)
	}
	XPLAIN_ITS name '=' simple_attribute_list
	{
		if attached subject_type as st and attached $8 as al then
			create myindex.make (st, $6, True, False, al)
			if not use_mode and then attached myindex as index then
				sqlgenerator.write_index (index)
			end
		end
	}
  | XPLAIN_CLUSTERED XPLAIN_INDEX type_name
	{ write_pending_statement
		subject_type := get_known_type ($3)
	}
	XPLAIN_ITS name '=' simple_attribute_list
	{
		if attached subject_type as st and attached $8 as al then
			create myindex.make (st, $6, False, True, al)
			if not use_mode and then attached myindex as index then
				sqlgenerator.write_index (index)
			end
		end
	}
  | XPLAIN_UNIQUE XPLAIN_CLUSTERED XPLAIN_INDEX type_name
	{ write_pending_statement
		subject_type := get_known_type ($4)
	}
	XPLAIN_ITS name '=' simple_attribute_list
	{
		if attached subject_type as st and attached $9 as al then
			create myindex.make (st, $7, True, True, al)
			if not use_mode and then attached myindex as index then
				sqlgenerator.write_index (index)
			end
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
			check attached subject_type as t then
				if attached t.find_attribute ($1) then
					create $$.make ($1, Void)
				else
					error_unknown_attribute (t.name, $1)
				end
			end
		}
	| attribute ',' simple_attribute_list
		{
			check attached subject_type as t then
				if attached t.find_attribute ($1) then
					create $$.make ($1, $3)
				else
					error_unknown_attribute (t.name, $1)
				end
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
		{ $$ := $1 }
	| modification
		{ $$ := $1 }
	;

modification
	: update
		{ $$ := $1 }
	| delete
		{ $$ := $1 }
	| insert
		{ $$ := $1 }
	| cascade
		{ $$ := $1 }
	;

insert
	: XPLAIN_INSERT subject XPLAIN_ITS assignment_list
		{
			write_pending_statement
			if attached $2 as subject and then attached $4 as al then
				warn_attributes_with_inits (al)
				if not attached subject.identification as identification then
					report_error ("Identification expected after a type name.")
					std.error.put_line ("%NAn identification is the primary key, usually a '*' meaning generate a unique key,")
					std.error.put_line ("but can be a string like %"1%".%N")
					std.error.put_line ("Examples:")
					std.error.put_line ("    insert " + subject.type.name + " * its ...")
					std.error.put_line ("    insert " + subject.type.name + " %"1%" its ...")
					abort
				elseif
					subject.type.representation.is_integer and then
					identification.is_constant and then
					not identification.sqlvalue (sqlgenerator).is_integer then
					report_error (format ("Primary key %"$s%" is not an integer.", <<identification.sqlvalue (sqlgenerator)>>))
					abort
				else
					create {XPLAIN_INSERT_STATEMENT} $$.make (subject.type, identification, al)
					if immediate_output_mode then
						sqlgenerator.write_insert (subject.type, identification, al)
					end
				end
			end
			subject_type := Void
		}
	| XPLAIN_INSERT subject '*' XPLAIN_ITS assignment_list
		{
			write_pending_statement
			if attached $2 as subject and then attached subject.type as mytype then
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
				if attached mytype as t and attached $5 as al then
					create {XPLAIN_INSERT_STATEMENT} $$.make (t, Void, al)
					if immediate_output_mode then
						sqlgenerator.write_insert (t, Void, al)
					end
				end
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
			if attached $2 as swsf and attached $4 as subject then
				create {XPLAIN_GET_INSERT_STATEMENT} $$.make (swsf, subject.type, False, $5)
				if immediate_output_mode then
					$$.write (sqlgenerator)
				end
			end
			subject_type := Void
		}
	| XPLAIN_GET selection_without_set_function XPLAIN_INSERT subject '*' optional_simple_attribute_list
		{
			write_pending_statement
			if attached $2 as swsf and attached $4 as subject then
				if not sqlgenerator.CreateAutoPrimaryKey then
					-- Can't abort as it might be output for a dialect that
					-- doesn't support auto primary keys.
					report_warning ("auto primary key support disabled, but insert with '*' as primary key specified.")
				elseif not subject.type.representation.is_integer
				then
					report_error ("Auto-primary keys on character instance identification not supported.")
					abort
				end
				create {XPLAIN_GET_INSERT_STATEMENT} $$.make (swsf, subject.type, True, $6)
				if immediate_output_mode then
					$$.write (sqlgenerator)
				end
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
				if attached get_known_type ($2) as st and then attached $7 as cd then -- subject_type changed by cascade_definition I think
					create $$.make (sqlgenerator, st, $5, cd)
					if immediate_output_mode then
						$$.write (sqlgenerator)
					end
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
			if attached get_object_if_valid_tree ($3) and attached $1 as sf then
				create {XPLAIN_CASCADE_FUNCTION_EXPRESSION} $$.make (sf, $3)
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
			if attached $2 as s then
				if immediate_output_mode then
					sqlgenerator.write_delete (s, $3)
				end
				create $$.make (s, $3)
			end
			subject_type := Void
		}
	;

subject
	: name idstring
		{
			if attached get_known_type ($1) as t then
				subject_type := t
				if attached {XPLAIN_STRING_EXPRESSION} $2 as my_str and then t.representation.length < my_str.value.count then
					report_error ("Instance identification %"" + my_str.value + "%" does not fit in domain " + t.representation.domain + " of type " + t.name + ".")
					abort
				else
					create {XPLAIN_SUBJECT} $$.make (t, $2)
				end
			else
				report_error ("Type `" + $1 + "' not known.")
				abort
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
			if attached get_known_value ($2) as value then
				create {XPLAIN_VALUE_EXPRESSION} $$.make (value)
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
		if attached $4 as al and attached $2 as s then
			if immediate_output_mode then
				sqlgenerator.write_update (s, al, $5)
			end
			subject_type := Void
			create $$.make (s, al, $5)
		end
	}
	| XPLAIN_UPDATE subject error
		{ report_error ("its expected instead of: '" + text + "'")
		  abort }
	;

attribute_name: name
	{
		create {XPLAIN_ATTRIBUTE_NAME} $$.make (Void, $1)
		if attached subject_type as t then
			if attached t.find_attribute ($$) as myattribute then
				$$.set_attribute (myattribute)
			else
				error_unknown_attribute (t.name, $$)
			end
		end
	}
	| role '_' name
	{
		create {XPLAIN_ATTRIBUTE_NAME} $$.make ($1, $3)
		if attached subject_type as t then
			if attached t.find_attribute ($$) as myattribute then
				$$.set_attribute (myattribute)
			else
				error_unknown_attribute (t.name, $$)
			end
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
			$$ := new_value_statement (sqlgenerator, $2, $4)
			if immediate_output_mode then
				sqlgenerator.write_value ($$.value)
			end
			universe.add ($$.value, Current)
		}
	;

value_definition
	: constant_or_value_expression
		{ $$ := $1 }
	| value_selection_expression
		{
			if attached $1 as e then
				create {XPLAIN_SELECTION_EXPRESSION} $$.make (e)
			else
				$$ := silence_compiler_expression
			end
		}
	| XPLAIN_INSERTED type_name
		{
			if not sqlgenerator.CreateAutoPrimaryKey then
				report_error ("Auto primary key support disabled or not supported. Cannot retrieve auto-generated primary key.")
			end
			if attached get_known_type ($2) as mytype then
				create {XPLAIN_LAST_AUTO_PK_EXPRESSION} $$.make (mytype)
			else
				$$ := silence_compiler_expression
			end
		}
	| input
		{ $$ := silence_compiler_expression }
	| ':' parameter_name
		{ create {XPLAIN_UNMANAGED_PARAMETER_EXPRESSION} $$.make ($2.full_name) }
	| system_variable
		{ $$ := $1 }

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

-- user functions (allows calling custom stored procedures)
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
			if attached get_known_value ($2) as value then
				if immediate_output_mode then
					sqlgenerator.write_select_value (value)
				end
				create $$.make (value)
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
			if $1.property_required = 0 and attached $3 then
				report_error ("Function " + $1.name + " does not allow a property to be present.")
				abort
			elseif $1.property_required = 1 and not attached $3 then
				report_error ("Function " + $1.name + " requires the presence of a property.")
				abort
			elseif attached $2 as s then
				create $$.make ($1, s, $3, $4)
			end
		}
	;


selection
	: XPLAIN_GET selection_expression
	{
		if attached $2 as se then
			create {XPLAIN_GET_STATEMENT} $$.make (se)
			write_pending_statement
			if immediate_output_mode then
				sqlgenerator.write_select (se)
			end
		end
		subject_type := Void
	}
	;

extension
	: XPLAIN_EXTEND extension_expression
		{
			if attached $2 as ee then
				if immediate_output_mode then
					sqlgenerator.write_extend (ee)
				end
				create $$.make (ee)
			end
			subject_type := Void
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
			if attached extend_type as et and attached $6 as ed then
				if et.has_attribute (Void, $4.name) then
					report_error (format ("Cannot extend type `$s' with attribute `$s', because it already has an attribute with that name.", <<$1, $4.name>>))
					abort
				elseif universe.has ($4.name) then
					report_error (format ("There is already an object (constant, value, base, type or procedure) with name `$s'. The name of an extend must be unique to avoid ambiguous expressions.", <<$4.name>>))
					abort
				else
					create $$.make (sqlgenerator, et, $4, ed)
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
		if attached get_object_if_valid_tree ($3) and attached $1 as sf and then attached $3.last as last then
			if last.item.object = extend_type then
				create {XPLAIN_EXTENSION_FUNCTION_EXPRESSION} $$.make (sf, $3)
			else
				check attached last.item.object as object and attached extend_type as et then
					report_error ("Error in per clause. The given type is `" + object.name + "', while the expected type is `" + et.name + "'. Make sure the per property ends in the same type that is being extended.")
				end
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
		{
			report_error("per keyword expected instead of: " + text)
			abort
		}
	;

selection_expression
	: selection_without_set_function
		{ $$ := $1 }
	| selection_with_set_function
		{ $$ := $1 }
	;

selection_without_set_function
	: subject selection_list predicate selection_sort_order
		{
			if attached $1 as s then
				create {XPLAIN_SELECTION_LIST} $$.make (s, $2, $3, $4)
			end
		}
	| text subject selection_list predicate selection_sort_order
		{
			if attached $2 as s then
				create {XPLAIN_SELECTION_LIST} $$.make (s, $3, $4, $5)
				$$.set_identification_text ($1)
			end
		}
	;

selection_sort_order: -- empty
  | XPLAIN_PER sort_order_list
		{ $$ := $2 }
  ;

sort_order_list
	: property_name
		{
			if attached get_object_if_valid_tree ($1) then
				create {XPLAIN_SORT_NODE} $$.make ($1, True, Void)
			end
		}
	| '-' property_name
		{
			if attached get_object_if_valid_tree ($2) then
				create {XPLAIN_SORT_NODE} $$.make ($2, False, Void)
			end
		}
	| property_name ',' sort_order_list
		{
			if attached get_object_if_valid_tree ($1) then
				create {XPLAIN_SORT_NODE} $$.make ($1, True, $3)
			end
		}
	| '-' property_name ',' sort_order_list
		{
			if attached get_object_if_valid_tree ($2) then
				create {XPLAIN_SORT_NODE} $$.make ($2, False, $4)
			end
		}
  ;

selection_with_set_function
	: set_function subject property predicate
		{
			if $1.property_required = 0 and attached $3 then
				report_error ("Function " + $1.name + " does not allow a property to be present.")
				abort
			elseif $1.property_required = 1 and not attached $3 then
				report_error ("Function " + $1.name + " requires the presence of a property.")
				abort
			elseif attached $2 as s then
				create $$.make ($1, s, $3, $4)
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
			if attached $2 as property_list then
				$$ := property_list
				property_list.give_column_names (2) -- first column is always the instance id
			end
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
		name optional_procedure_parameters optional_sql '='
		{
			my_parameters := $4
		}
		optional_procedure_statement_list XPLAIN_END
		{
			procedure_mode := False
			$$ := new_procedure_statement ($3, $4, $1, $8)
			if not $5.sql.is_empty then
				$$.procedure.sql_declare.append_string ($5.sql)
			end
			universe.add ($$.procedure, Current)
			if immediate_output_mode then
				sqlgenerator.write_procedure ($$.procedure)
			end
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

optional_sql
	: -- empty
		{ create {XPLAIN_SQL_STATEMENT} $$.make ("") }
	| sql
		{ $$ := $1 }
	;

optional_procedure_statement_list
	: -- empty
	| procedure_statement_list
		{ $$ := $1 }
	;

procedure_statement_list
	: procedure_supported_command '.'
		{
			if attached $1 as s then create $$.make (s, Void) end
		}
	| procedure_supported_command '.' procedure_statement_list
		{
			if attached $1 as s then create $$.make (s, $3) end
		}
	| sql
		{
			if attached $1 as s then create $$.make (s, Void) end
		}
	| sql procedure_statement_list
		{
			if attached $2 as s then create $$.make ($1, s) end
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

	make_with_file (a_file: KI_CHARACTER_INPUT_STREAM; a_sqlgenerator: SQL_GENERATOR)
		do
			make_scanner_with_file (a_file)
			make (a_sqlgenerator)
		end

	make_with_stdin (a_sqlgenerator: SQL_GENERATOR)
		do
			make_scanner_with_stdin
			make (a_sqlgenerator)
		end


feature {NONE} -- private creation

	make (a_sqlgenerator: SQL_GENERATOR)
		do
			make_parser_skeleton
			create statements.make
			set_sqlgenerator (a_sqlgenerator)
			-- Set some dummy values so we can avoid using detachable
			create {XPLAIN_REQUIRED} dummyrestriction.make (True)
		end


feature {NONE} -- dummy variables to store created objects in

	dummya: detachable XPLAIN_A_REFERENCES
	dummyi: detachable XPLAIN_I_REFERENCES
	dummye: detachable XPLAIN_EXPRESSION
	dummybool: detachable XPLAIN_LOGICAL_VALUE_EXPRESSION
	dummyrestriction: XPLAIN_DOMAIN_RESTRICTION

	last_width: INTEGER
			-- saves latest domain width, for example I2 will save 2 here

feature {NONE} -- local variables, do not survive outside a code block!

	mybase: detachable XPLAIN_BASE
	myvariable: detachable XPLAIN_VARIABLE
	myindex: detachable XPLAIN_INDEX
	current_type_name: detachable STRING
	auto_identifier: BOOLEAN
	my_selection_function: detachable XPLAIN_SELECTION_FUNCTION

	is_init_default: BOOLEAN
			-- Determine if init or init default statement has to be created.


feature {NONE} -- these vars survive a little bit longer

	subject_type: detachable XPLAIN_TYPE  -- used to check if valid attribute
	extend_type: detachable XPLAIN_TYPE   -- used in extend statement
	my_parameters: detachable XPLAIN_ATTRIBUTE_NAME_NODE
			-- List of declared parameters for a procedure

	constant_mode: BOOLEAN
			-- Are we parsing a constant expression?


feature -- Xplain

	statements: XPLAIN_STATEMENTS
			-- All executable statements.


feature {NONE} -- Expression generation

	new_logical_expression (a_left: XPLAIN_EXPRESSION; an_operator: STRING; a_right: XPLAIN_EXPRESSION): XPLAIN_LOGICAL_EXPRESSION
		local
			e: XPLAIN_EXPRESSION
		do
			create {XPLAIN_LOGICAL_INFIX_EXPRESSION} e.make (a_left, an_operator, a_right)
			create Result.make (e)
		end

	new_logical_infix_expression (a_left: XPLAIN_EXPRESSION; an_operator: STRING; a_right: XPLAIN_EXPRESSION): XPLAIN_INFIX_EXPRESSION
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
			r: detachable XPLAIN_INFIX_EXPRESSION
		do
			if an_operator.same_string (once_equal) then
				equal_operator := True
			elseif an_operator.same_string (once_not_equal) then
				not_equal_operator := True
			end
			if equal_operator or else not_equal_operator then
				if a_left.has_wild_card_characters or a_right.has_wild_card_characters then
					if equal_operator then
						create {XPLAIN_LIKE_EXPRESSION} r.make (a_left, a_right)
					else
						create {XPLAIN_NOT_LIKE_EXPRESSION} r.make (a_left, a_right)
					end
				end
			end

			-- Fallback to standard infix expression.
			if not attached r then
				create {XPLAIN_LOGICAL_INFIX_EXPRESSION} r.make (a_left, an_operator, a_right)
			end
			Result := r
		ensure
			new_infix_expression_not_void: Result /= Void
		end


feature -- Code blocks

	new_base (a_name: STRING; a_definition: XPLAIN_REPRESENTATION; a_required: BOOLEAN): XPLAIN_BASE
		local
			r: XPLAIN_DOMAIN_RESTRICTION
		do
			if not attached a_definition.domain_restriction then
				if a_definition.domain.is_equal ("(B)") then
					create {XPLAIN_B_RESTRICTION} r.make (a_required)
				else
					create {XPLAIN_REQUIRED} r.make (a_required)
				end
				a_definition.set_domain_restriction (sqlgenerator, r)
			end
			create Result.make (a_name, a_definition)
		end

	newdate_default_days: XPLAIN_STRING_EXPRESSION
		once
			create {XPLAIN_STRING_EXPRESSION} Result.make ("days")
		end


feature -- Statement generation

	new_procedure_statement (a_name: STRING; a_parameters: detachable XPLAIN_ATTRIBUTE_NAME_NODE; a_procedure_kind: INTEGER; a_statements: detachable XPLAIN_STATEMENT_NODE): XPLAIN_PROCEDURE_STATEMENT
		local
			myprocedure: XPLAIN_PROCEDURE
		do
			create myprocedure.make (a_name, a_parameters, a_procedure_kind, a_statements)
			create Result.make (myprocedure)
		end

	new_value_statement (an_sqlgenerator: SQL_GENERATOR; a_name: STRING; an_expression: XPLAIN_EXPRESSION): XPLAIN_VALUE_STATEMENT
		local
			myvalue: XPLAIN_VALUE
		do
			create myvalue.make (an_sqlgenerator, a_name, an_expression)
			create Result.make (myvalue)
		end


feature -- Silence compiler

	silence_compiler_logical_expression: XPLAIN_LOGICAL_VALUE_EXPRESSION
		once
			create {XPLAIN_LOGICAL_VALUE_EXPRESSION} Result.make (False)
		end

	silence_compiler_expression: XPLAIN_EXPRESSION
		once
			create {XPLAIN_STRING_EXPRESSION} Result.make ("")
		end


feature -- Middleware

	mwgenerator: detachable MIDDLEWARE_GENERATOR

	set_mwgenerator (mwg: MIDDLEWARE_GENERATOR)
		do
			mwgenerator := mwg
		end


feature {NONE} -- Error handling

	error_unknown_attribute (a_type: STRING; an_attribute: XPLAIN_ATTRIBUTE_NAME)
			-- abort with unknown attribute error
		local
			s: STRING
		do
			s := "Type `" + a_type + "' does not have the attribute `"
			if attached an_attribute.role as r then
				s := s + r + "_"
			end
			s := s + an_attribute.name + "'."
			report_error (s)
			abort
		end

feature {NONE} -- pending statements

	pending_type: detachable XPLAIN_TYPE
			-- set for type not yet written

	write_pending_init
		require
			pending_type_written: pending_init = Void or else pending_type = Void
		do
			if attached pending_init as pi then
				if not use_mode then
					sqlgenerator.write_init (pi)
				end
				pending_init := Void
			end
		ensure
			pending_init_void: pending_init = Void
		end

	write_pending_statement
			-- Call this before outputting anything!
		do
			write_pending_type
			write_pending_init
		ensure then
			pending_init_void: pending_init = Void
		end

	write_pending_type
		do
			if attached pending_type as t then
				if not use_mode then
					sqlgenerator.write_type (t)
					if attached mwgenerator as g then
						g.dump_type (t, sqlgenerator)
					end
				end
				pending_type := Void
			end
		ensure
			pending_type_void: pending_type = Void
		end


feature {NONE} -- Checks for validness of parsed code

	get_known_base_or_type (name: STRING): detachable XPLAIN_ABSTRACT_TYPE
			-- Test if known type, but be aware of self-reference.
		do
			Result := universe.find_base_or_type (name)
			if not attached Result and then
				not equal(current_type_name, name) then
				report_error ("Unknown base or type: " + name)
				abort
			end
		end

	get_known_object (name: STRING): detachable XPLAIN_ABSTRACT_OBJECT
			-- Return object, must exist.
		do
			Result := universe.find_object (name)
			if not attached Result then
				report_error ("Not a defined object: " + name)
				abort
			end
		end

	get_known_type (name: STRING): detachable XPLAIN_TYPE
			-- Return the type for `name' or die.
		local
			b: detachable XPLAIN_BASE
		do
			Result := universe.find_type (name)
			if not attached Result then
				b := universe.find_base (name)
				if not attached b then
					report_error ("Type unknown: " + name)
				else
					report_error (format ("`$s' is a base, but a type is expected here.", <<name>>))
				end
				abort
			end
		end

	get_known_value (name: STRING): detachable XPLAIN_VALUE
		do
			Result := universe.find_value (name)
			if not attached Result then
				report_error ("Value unknown: " + name)
				abort
			end
		end

	last_object_in_tree: detachable XPLAIN_ABSTRACT_OBJECT
			-- Set by `get_object_if_valid_tree' to last object in list.

	get_object_if_valid_tree (first: XPLAIN_ATTRIBUTE_NAME_NODE): detachable XPLAIN_ABSTRACT_OBJECT
			-- The object for the first name of this tree, if this
			-- is a valid tree;
			-- Also augment tree with type information.
		require
			first_not_void: first /= Void
			subject_type_set: attached subject_type
		local
			my_attribute: detachable XPLAIN_ATTRIBUTE
			node: detachable XPLAIN_ATTRIBUTE_NAME_NODE
			preceding_type: XPLAIN_TYPE
			atype: detachable XPLAIN_ABSTRACT_TYPE
			valid_attribute: BOOLEAN
			msg: STRING
		do
			last_object_in_tree := Void
			check attached subject_type as my_subject_type then
				if attached first.next then
					-- Something like a its b its c, should all be attributes.
					from
						node := first
						preceding_type := my_subject_type
						valid_attribute := True
					until
						node = Void or
						not valid_attribute
					loop
						my_attribute := preceding_type.find_attribute (node.item)
						if attached my_attribute then
							valid_attribute := True
						end
						if valid_attribute and attached my_attribute as a then
							node.item.set_attribute (a)
							atype := a.abstracttype
							--node.item.set_object (atype)
							if node.next /= Void then
								if attached {XPLAIN_TYPE} atype as t then
									preceding_type := t
								else
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
						check attached my_subject_type.find_attribute (first.item) as a then
							Result := a.abstracttype
						end
					end
				else
					-- Can be value/variable or attribute.
					-- Check attribute first.
					my_attribute := my_subject_type.find_attribute (first.item)
					if attached my_attribute then
						first.item.set_attribute (my_attribute)
						Result := my_attribute.abstracttype
					else
						Result := universe.find_object (first.item.name)
						if attached {XPLAIN_VALUE} Result as value then
							-- variable or constants are OK
							-- I probably don't detect cases
							first.item.set_object (value)
						elseif attached {XPLAIN_VARIABLE} Result as variable then
							first.item.set_object (variable)
						elseif attached Result then
							create msg.make (128)
							msg.append_string ("base/type '")
							if first.item.role /= Void then
								msg.append_string (first.item.role)
								msg.append_string ("_")
							end
							msg.append_string (first.item.name)
							msg.append_string ("' is not an attribute of '")
							msg.append_string (my_subject_type.name)
							msg.append_string ("'%N")
							report_error (msg)
							abort
							Result := Void
						else
							-- Doesn't exist in universe at all
							report_error ( format("`$s' is not an attribute of type `$s', nor a value or constant.", <<first.item.full_name, my_subject_type.name>>))
							abort
							Result := Void
						end
					end
					if attached Result then
						last_object_in_tree := Result
					end
				end
			end
		ensure
			if_not_valid_tree: True -- Warnings are given
			if_valid_tree: True
			-- Result /= Void and object is the object for the first name
			-- in the tree
			last_object_set: Result /= Void implies last_object_in_tree /= Void
		end

	is_parameter_declared (a_name: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Has `a_name' been declared in the parameter list for the
			-- current procedure?
		require
			name_not_empty: a_name /= Void
		do
			Result := attached my_parameters as p and then p.has (a_name)
			if not Result then
				report_error ("Parameter `" + a_name.full_name + "' has not been declared.")
				abort
			end
		end


feature {NONE} -- Checks

	warn_attributes_with_inits (an_assignment_list: XPLAIN_ASSIGNMENT_NODE)
			-- Check if user has specified an attribute for which an init
			-- expression exists. Assignment will be (should be...)
			-- ignored in that case.
		require
			an_assignment_list_not_void: an_assignment_list /= Void
		local
			node: detachable XPLAIN_ASSIGNMENT_NODE
		do
			from
				node := an_assignment_list
			until
				node = Void
			loop
				if
					attached node.item.attribute_name.type_attribute as type_attribute and then
					attached type_attribute.init and then
					not type_attribute.is_init_default
				then
					report_error (format ("Attribute $s has an init expression. Assignment specified in insert will be ignored.%N", <<node.item.attribute_name.full_name>>))
				end
				node := node.next
			end
		end


feature {NONE} -- Once strings

	once_equal: STRING = "="
	once_not_equal: STRING = "<>"


end
