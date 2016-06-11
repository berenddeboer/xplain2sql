%{
note

  description:

	"Scanner for Xplain ddl parsers%
	%Rewritten from a Delphi 4.0 scanner.%
	%Traces of this go back go versions created in 1994."

  known_bugs:
  "1. Seems /* .. */ style comments not parsed correctly?? Maybe remove %
  %   such style comments."

  author:     "Berend de Boer <berend@pobox.com>"

deferred class XPLAIN_SCANNER

inherit

	YY_COMPRESSED_SCANNER_SKELETON
		rename
			make as make_compressed_scanner_skeleton,
			make_with_file as make_compressed_scanner_skeleton_with_file
		redefine
			wrap
		end

	XPLAIN_TOKENS
		export
			{NONE} all
		end

	UT_CHARACTER_CODES
		export {NONE} all
		end

	KL_SHARED_EXCEPTIONS
		export
			{NONE} all
		end

	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end

	ST_FORMATTING_ROUTINES
		export
			{NONE} all
		end


%}

%option outfile="xplain_scanner.e"
%option nocase-sensitive line

%x comment
%x comment_sql
%x cond_literal_sql

%%

----------/** Separators **/----------------------------------------------------

[ \t\n\r]+    -- Ignore white space


----------/** Xplain comments which are ignored **/-----------------------------

"//".*\n?      |
"/*".*\n?      -- ignore comments


----------/** Xplain comments which are dumped to the output file **/-----------

"#"               |
"--"              set_start_condition (comment_sql)
<comment_sql>[^\n\r]* {
						if pending_init = Void then
							write_pending_statement
						end
						if immediate_output_mode then
							sqlgenerator.write_one_line_comment(text)
						end
						}
<comment_sql>\r   { -- ignore cr's
						}
<comment_sql>\n   {
						set_start_condition (INITIAL)
						}


----------/** Literal SQL, just echo it **/-------------------------------------

"{"                      {
								 write_pending_statement
								 set_start_condition (cond_literal_sql)
								 my_sql := ""
								 }
<cond_literal_sql>[^}\n\r]* { -- Eat anything that's not a '}'
								 my_sql.append_string (text)
								 }
<cond_literal_sql>\n     {
								 my_sql.append_character ('%N')
								 }
<cond_literal_sql>\r     { -- ignore cr's
								 }
<cond_literal_sql>"}"    { set_start_condition (INITIAL); last_token := LITERAL_SQL; last_string_value := my_sql; }


----------/** Xplain representations **/----------------------------------------

"(A"          conditional_parse_domain (XPLAIN_A)
"(B"          conditional_parse_domain (XPLAIN_B)
"(C"          conditional_parse_domain (XPLAIN_C)
"(D"          conditional_parse_domain (XPLAIN_D)
"(I"          conditional_parse_domain (XPLAIN_I)
"(M"          conditional_parse_domain (XPLAIN_M)
"(P"          conditional_parse_domain (XPLAIN_P)
"(R"          conditional_parse_domain (XPLAIN_R)
"(T"          conditional_parse_domain (XPLAIN_T)


----------/** Xplain symbols **/------------------------------------------------

"-"         last_token := Minus_code
"+"         last_token := Plus_code
"*"         last_token := Star_code
"/"         last_token := Slash_code
"="         last_token := Equal_code; expect_domain := False
">"         last_token := Greater_than_code
"<"         last_token := Less_than_code
"<>"        last_token := XPLAIN_NE
"."         last_token := Dot_code; expect_domain := False
".."        last_token := XPLAIN_DOTDOT
">="        last_token := XPLAIN_GE
"<="        last_token := XPLAIN_LE
","         last_token := Comma_code
":"         last_token := Colon_code
"("         last_token := Left_parenthesis_code
")"         last_token := Right_parenthesis_code


----------/** Xplain keywords **/-----------------------------------------------

"and"         |
"and"/([ ]+[0-9][ 0-9]*) { last_token := XPLAIN_AND }
"any"         { last_token := XPLAIN_ANY }
"as"          { last_token := XPLAIN_AS }
"assert"      { last_token := XPLAIN_ASSERT }
"base"        { last_token := XPLAIN_BASE; expect_domain := True }
"cascade"     { last_token := XPLAIN_CASCADE }
"case"        { last_token := XPLAIN_CASE }
"check"       { last_token := XPLAIN_CHECK }
"clustered"   { last_token := XPLAIN_CLUSTERED }
"constant"    { last_token := XPLAIN_CONSTANT; expect_domain := True }
"count"       { last_token := XPLAIN_COUNT }
"database"    { last_token := XPLAIN_DATABASE }
"default"     { last_token := XPLAIN_DEFAULT }
"delete"      { last_token := XPLAIN_DELETE }
"echo"        { last_token := XPLAIN_ECHO }
"else"          |
"else"/([ ]+[0-9][ 0-9]*) { last_token := XPLAIN_ELSE }
"end"         { last_token := XPLAIN_END }
"endproc"     { last_token := XPLAIN_ENDPROC }
"extend"      { last_token := XPLAIN_EXTEND; expect_domain := True }
"false"       { last_token := XPLAIN_FALSE }
"get"         { last_token := XPLAIN_GET }
"if"          |
"if"/([ ]+[0-9][ 0-9]*) { last_token := XPLAIN_IF }
"index"       { last_token := XPLAIN_INDEX }
"init"        { last_token := XPLAIN_INIT }
"input"       { last_token := XPLAIN_INPUT }
"insert"      { last_token := XPLAIN_INSERT }
"inserted"    { last_token := XPLAIN_INSERTED }
"its"         { last_token := XPLAIN_ITS }
"loginname"   { last_token := XPLAIN_LOGINNAME }
"max"         { last_token := XPLAIN_MAX }
"min"         { last_token := XPLAIN_MIN }
"newline"     { last_token := XPLAIN_NEWLINE }
"nil"         { last_token := XPLAIN_NIL }
"not"         |
"not"/([ ]+[0-9][ 0-9]*) { last_token := XPLAIN_NOT }
"null"        { last_token := XPLAIN_NULL }
"of"          { last_token := XPLAIN_OF }
"optional"    { last_token := XPLAIN_OPTIONAL }
"or"          |
"or"/([ ]+[0-9][ 0-9]*) { last_token := XPLAIN_OR }
"per"         { last_token := XPLAIN_PER }
"procedure"   { last_token := XPLAIN_PROCEDURE }
"purge"       { last_token := XPLAIN_PURGE }
"path"[ \t\n\r]+"procedure" { last_token := XPLAIN_PATH_PROCEDURE }
"recompiled"[ \t\n\r]+"procedure" { last_token := XPLAIN_RECOMPILED_PROCEDURE }
"trigger"[ \t\n\r]+"procedure" { last_token := XPLAIN_TRIGGER_PROCEDURE }
"required"    { last_token := XPLAIN_REQUIRED }
"some"        { last_token := XPLAIN_SOME }
"systemdate"  { last_token := XPLAIN_SYSTEMDATE }
"then"          |
"then"/([ ]+[0-9][ 0-9]*) { last_token := XPLAIN_THEN }
"total"       { last_token := XPLAIN_TOTAL }
"true"        { last_token := XPLAIN_TRUE }
"type"        { last_token := XPLAIN_TYPE; expect_domain := True }
"unique"      { last_token := XPLAIN_UNIQUE }
"update"      { last_token := XPLAIN_UPDATE }
"value"       { last_token := XPLAIN_VALUE }
"with"        { last_token := XPLAIN_WITH }
"where"       { last_token := XPLAIN_WHERE }


----------/** Xplain string functions **/--------------------------------------

"combine"[ \t\r\n]*"("   { last_token := XPLAIN_COMBINE }
"head"[ \t\r\n]*"("      { last_token := XPLAIN_HEAD }
"tail"[ \t\r\n]*"("      { last_token := XPLAIN_TAIL }


----------/** Xplain conversion functions **/----------------------------------

"datef"[ \t\r\n]*"("     { last_token := XPLAIN_DATEF }
"integer"[ \t\r\n]*"("   { last_token := XPLAIN_INTEGERF }
"real"[ \t\r\n]*"("      { last_token := XPLAIN_REALF }
"string"[ \t\r\n]*"("    { last_token := XPLAIN_STRINGF }


----------/** Xplain date functions **/----------------------------------------

"dayf"[ \t\r\n]*"("      { last_token := XPLAIN_DAYF }
"isdate"[ \t\r\n]*"("    { last_token := XPLAIN_ISDATE }
"monthf"[ \t\r\n]*"("    { last_token := XPLAIN_MONTHF }
"newdate"[ \t\r\n]*"("   { last_token := XPLAIN_NEWDATE }
"timedif"[ \t\r\n]*"("   { last_token := XPLAIN_TIMEDIF }
"yearf"[ \t\r\n]*"("     { last_token := XPLAIN_YEARF }
"wdayf"[ \t\r\n]*"("     { last_token := XPLAIN_WDAYF }


----------/** Xplain mathematical functions **/--------------------------------

"pow"[ \t\r\n]*"("       { last_token := XPLAIN_POW }
"abs"[ \t\r\n]*"("       { last_token := XPLAIN_ABS }
"max"[ \t\r\n]*"("       { last_token := XPLAIN_MAXF }
"min"[ \t\r\n]*"("       { last_token := XPLAIN_MINF }
"sqrt"[ \t\r\n]*"("       { last_token := XPLAIN_SQRT }
"exp"[ \t\r\n]*"("       { last_token := XPLAIN_EXP }
"ln"[ \t\r\n]*"("       { last_token := XPLAIN_LN }
"log10"[ \t\r\n]*"("       { last_token := XPLAIN_LOG10 }
"sin"[ \t\r\n]*"("       { last_token := XPLAIN_SIN }
"cos"[ \t\r\n]*"("       { last_token := XPLAIN_COS }
"tan"[ \t\r\n]*"("       { last_token := XPLAIN_TAN }
"asin"[ \t\r\n]*"("       { last_token := XPLAIN_ASIN }
"acos"[ \t\r\n]*"("       { last_token := XPLAIN_ACOS }
"atan"[ \t\r\n]*"("       { last_token := XPLAIN_ATAN }
"sinh"[ \t\r\n]*"("       { last_token := XPLAIN_SINH }
"cosh"[ \t\r\n]*"("       { last_token := XPLAIN_COSH }
"tanh"[ \t\r\n]*"("       { last_token := XPLAIN_TANH }
"asinh"[ \t\r\n]*"("       { last_token := XPLAIN_ASINH }
"acosh"[ \t\r\n]*"("       { last_token := XPLAIN_ACOSH }
"atanh"[ \t\r\n]*"("       { last_token := XPLAIN_ATANH }


----------/** enhanced Xplain functions **/------------------------------------

"id"[ \t\r\n]*"("[ \t\r\n]*")"     { last_token := XPLAIN_ID }


----------/** Xplain identifiers (parts) --**/---------------------------------

[a-zA-Z][a-zA-Z0-9]*([ ]+[0-9][ 0-9]*)?  {
		  last_token := XPLAIN_IDENTIFIER
		  last_string_value := text
		  last_string_value.right_adjust
		}

-- names quoted within `' are taken verbatim
\`[^']+\'                {
		 last_token := XPLAIN_IDENTIFIER
		 last_string_value := text.substring(2, text.count-1)
	}

-- '
----------/** Xplain basic datatypes **/---------------------------------------

\"([^\"]|\"\")*\" {
	if text.count = 2 then
		last_string_value := ""
	else
		last_string_value := unquote_string (text.substring(2, text.count-1))
	end
	last_token := XPLAIN_STRING
	}
-- "
[-]?[0-9]+ {
	last_token := XPLAIN_INTEGER
	last_integer_value := text.to_integer
	}
[-]?[0-9]+\.[0-9]+ {
	last_token := XPLAIN_DOUBLE
	last_string_value := text
	}


----------/** preprocessor statements **/--------------------------------------

".include" { preprocessor_include }
".use"     { preprocessor_use }


--------------------------------------------------------------------------------

<<EOF>>   {
	terminate
	std.output.put_string("%N")
	}
.  last_token := text_item (1).code

--------------------------------------------------------------------------------
%%

feature {NONE} -- Initialization

	make_with_file (a_file: KI_CHARACTER_INPUT_STREAM)
		local
			state: XPLAIN_SCANNER_STATE
		do
			do_make
			make_compressed_scanner_skeleton_with_file (a_file)
			create state.make_file (input_buffer, a_file.name)
			saved_state.put_last (state)
		ensure
			has_state: not saved_state.is_empty
		end

	make_with_stdin
		local
			state: XPLAIN_SCANNER_STATE
		do
			do_make
			create state.make_stdin (input_buffer)
			saved_state.put_last (state)
		ensure
			has_state: not saved_state.is_empty
		end


feature {NONE} -- Initialization

	do_make
			-- Create a new Xplain scanner.
		do
			make_compressed_scanner_skeleton
			create saved_state.make
			my_sql := ""
			last_string_value := ""
		end

	execute
			-- Analyze files `arguments (1..argument_count)'.
		local
			j, n: INTEGER
			a_filename: STRING
			a_file: KL_TEXT_INPUT_FILE
		do
			make_compressed_scanner_skeleton
			n := Arguments.argument_count
			if n = 0 then
				std.error.put_string ("usage: xplain_scanner filename ...%N")
				Exceptions.die (1)
			else
				from j := 1 until j > n loop
					a_filename := Arguments.argument (j)
					create a_file.make (a_filename)
					a_file.open_read
					if a_file.is_open_read then
						set_input_buffer (new_file_buffer (a_file))
						scan
						a_file.close
					else
						std.error.put_string ("xplain_scanner: cannot read %'")
						std.error.put_string (a_filename)
						std.error.put_string ("%'%N")
					end
					j := j + 1
				end
			end
		end


feature -- Scanning specials

	expect_domain: BOOLEAN
			-- internal state to see a (A or (V only as domain when needed.

	conditional_parse_domain (token: INTEGER)
			-- call when scanner thinks domain is being parsed
		do
			if expect_domain then
				read_character
				inspect
					last_character
				when '0'..'9',')' then
				  less (2) -- back character just read
				  last_token := token
				else
					less (1) -- no domain, eat up only '('
					last_token := Left_parenthesis_code
				end
				expect_domain := False
			else
				less (1) -- no domain, eat up only '('
				last_token := Left_parenthesis_code
			end
		end


feature -- Error handling

	report_error (a_message: STRING)
			-- Print error message.
		local
		  state: XPLAIN_SCANNER_STATE
		do
			if saved_state.is_empty then
				std.error.put_string (a_message)
			else
				state := saved_state.last
				if attached state.filename as fn then
					std.error.put_string (fn)
					std.error.put_string (", line ")
				else
					std.error.put_string ("line ")
				end
				std.error.put_integer (line)
				std.error.put_string (", column ")
				std.error.put_integer (column)
				std.error.put_string (": ")
				std.error.put_string (a_message)
			end
			std.error.put_character ('%N')
		end

	report_warning (a_message: STRING)
			-- Print error message.
		local
		  state: XPLAIN_SCANNER_STATE
		do
			std.error.put_string ("Warning: ")
			if saved_state.is_empty then
				std.error.put_string (a_message)
			else
				state := saved_state.last
				if attached state.filename as fn then
					std.error.put_string (fn)
					std.error.put_string (", line ")
				else
					std.error.put_string ("line ")
				end
				std.error.put_integer (line)
				std.error.put_string (", column ")
				std.error.put_integer (column)
				std.error.put_string (": ")
				std.error.put_string (a_message)
			end
			std.error.put_character ('%N')
		end


feature -- dirty, should be implemented by parser

	pending_init: detachable XPLAIN_TYPE
			-- set if for a type inits need to be processed

	write_pending_statement
		do
			-- ignore
		end


feature -- Outside

	sqlgenerator: SQL_GENERATOR

	set_sqlgenerator (sqlg: SQL_GENERATOR)
		do
			sqlgenerator := sqlg
		end


feature {NONE} -- .include/.use support

	saved_state: DS_LINKED_LIST [XPLAIN_SCANNER_STATE]

	make_relative_path (name: STRING): STRING
			-- `name' if an absolute path, else `name' relative from
			-- currently parsed filename
		require
			name_not_empty: name /= Void and then not name.is_empty
		do
			if attached saved_state.last.directory as current_dir then
				if name.item (1) = '/' then
					Result := name
				else
					Result := current_dir + name
				end
			else
				Result := name
			end
		end

	use_mode: BOOLEAN
			-- We're in use mode if there is a single .use mode on the
			-- stack.
		local
			c: DS_BILINEAR_CURSOR [XPLAIN_SCANNER_STATE]
		do
			c := saved_state.new_cursor
			from
				c.finish
			until
				Result or else
				c.before
			loop
				Result := c.item.use_mode
				c.back
			end
		end

	wrap: BOOLEAN
			-- Should we continue at EOF?
			-- We do, unless no more state.
		do
			write_pending_statement
			saved_state.remove_last
			if saved_state.is_empty then
				Result := True
			else
				set_input_buffer (saved_state.last.input_buffer)
			end
		ensure then
			definition: Result implies not old saved_state.is_empty
		end

	procedure_mode: BOOLEAN
			-- Set when creating a stored procedure to delay output of code.

	immediate_output_mode: BOOLEAN
			-- True if output should be generated immediately. Until full
			-- AST building is in place, we need this trick.
		do
			Result := not use_mode and then not procedure_mode
		end


feature {NONE} -- Implementation

	my_sql: STRING

	unquote_string (s: STRING): STRING
			-- Make sure a quoted double quote in `s' is unquoted.
		require
			s_not_void: s /= Void
		local
			i: INTEGER
		do
			Result := s.twin
			if not Result.is_empty then
				from
					i := 1
				invariant
					Result.count >= 1
				until
					i >= Result.count
				loop
					if
						Result.item (i) = '%"' and then
						Result.item (i + 1) = '%"'
					then
						Result.remove (i)
					end
					i := i + 1
				variant
					Result.count - (i - 1)
				end
			end
		ensure
			unquote_string_not_void: Result /= Void
			unquote_string_not_empty: not s.is_empty implies not Result.is_empty
		end


feature {NONE} -- Preprocessor commands

	preprocessor_include
		local
			include_name: STRING
			included_file: KL_TEXT_INPUT_FILE
			state: XPLAIN_SCANNER_STATE
		do
			read_token
			if last_token = XPLAIN_STRING then
				include_name := make_relative_path (last_string_value)
				create included_file.make (include_name)
				included_file.open_read
				if included_file.is_open_read then
					set_input_buffer (new_file_buffer (included_file))
					create state.make_include (input_buffer, include_name)
					saved_state.put_last (state)
				else
					report_error (format ("Included file $s skipped, because it could not be opened.", <<include_name>>))
				end
			else
				report_error ("filename, surrounded by double quotes, expected after .include.")
			end
			read_token
		end

	preprocessor_use
		local
			use_name: STRING
			use_file: KL_TEXT_INPUT_FILE
			state: XPLAIN_SCANNER_STATE
		do
			read_token
			if last_token = XPLAIN_STRING then
				use_name := make_relative_path (last_string_value)
				create use_file.make (use_name)
				use_file.open_read
				if use_file.is_open_read then
					set_input_buffer (new_file_buffer (use_file))
					create state.make_use (input_buffer, use_name)
					saved_state.put_last (state)
				else
					report_error (format ("Used file $s skipped, because it could not be opened.", <<use_name>>))
				end
			else
				report_error ("string expected after .use")
			end
			read_token
		end


invariant

	has_state: last_token /= 0 implies not saved_state.is_empty

end
