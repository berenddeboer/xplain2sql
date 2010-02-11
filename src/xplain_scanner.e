indexing

  description:

	"Scanner for Xplain ddl parsers%
	%Rewritten from a Delphi 4.0 scanner.%
	%Traces of this go back go versions created in 1994."

  known_bugs:
  "1. Seems /* .. */ style comments not parsed correctly?? Maybe remove %
  %   such style comments."

  author:     "Berend de Boer <berend@pobox.com>"
  copyright:  "Copyright (c) 1999-2001, Berend de Boer, see forum.txt"
  date:       "$Date: 2008/12/15 $"
  revision:   "$Revision: #12 $"

class XPLAIN_SCANNER

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


create

	make_with_stdin,
	make_with_file,
	execute


feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN is
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= cond_literal_sql)
		end

feature {NONE} -- Implementation

	yy_build_tables is
			-- Build scanner tables.
		do
			yy_nxt := yy_nxt_template
			yy_chk := yy_chk_template
			yy_base := yy_base_template
			yy_def := yy_def_template
			yy_ec := yy_ec_template
			yy_meta := yy_meta_template
			yy_accept := yy_accept_template
		end

	yy_execute_action (yy_act: INTEGER) is
			-- Execute semantic action.
		do
if yy_act <= 72 then
if yy_act <= 36 then
if yy_act <= 18 then
if yy_act <= 9 then
if yy_act <= 5 then
if yy_act <= 3 then
if yy_act <= 2 then
if yy_act = 1 then
yy_set_line_column
--|#line 75 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 75")
end
-- Ignore white space
else
yy_set_line_column
--|#line 80 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 80")
end
-- ignore comments
end
else
yy_set_line_column
--|#line 81 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 81")
end
-- ignore comments
end
else
if yy_act = 4 then
	yy_column := yy_column + 1
--|#line 86 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 86")
end
set_start_condition (comment_sql)
else
	yy_column := yy_column + 2
--|#line 87 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 87")
end
set_start_condition (comment_sql)
end
end
else
if yy_act <= 7 then
if yy_act = 6 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 88 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 88")
end

						if pending_init = Void then
							write_pending_statement
						end
						if immediate_output_mode then
							sqlgenerator.write_one_line_comment(text)
						end
						
else
	yy_column := yy_column + 1
--|#line 96 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 96")
end
 -- ignore cr's
						
end
else
if yy_act = 8 then
	yy_line := yy_line + 1
	yy_column := 1
--|#line 98 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 98")
end

						set_start_condition (INITIAL)
						
else
	yy_column := yy_column + 1
--|#line 105 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 105")
end

								 write_pending_statement
								 set_start_condition (cond_literal_sql)
								 my_sql := ""
								 
end
end
end
else
if yy_act <= 14 then
if yy_act <= 12 then
if yy_act <= 11 then
if yy_act = 10 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 110 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 110")
end
 -- Eat anything that's not a '}'
								 my_sql.append_string (text)
								 
else
	yy_line := yy_line + 1
	yy_column := 1
--|#line 113 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 113")
end

								 my_sql.append_character ('%N')
								 
end
else
	yy_column := yy_column + 1
--|#line 116 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 116")
end
 -- ignore cr's
								 
end
else
if yy_act = 13 then
	yy_column := yy_column + 1
--|#line 118 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 118")
end
 set_start_condition (INITIAL); last_token := LITERAL_SQL; last_string_value := my_sql; 
else
	yy_column := yy_column + 2
--|#line 123 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 123")
end
conditional_parse_domain (XPLAIN_A)
end
end
else
if yy_act <= 16 then
if yy_act = 15 then
	yy_column := yy_column + 2
--|#line 124 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 124")
end
conditional_parse_domain (XPLAIN_B)
else
	yy_column := yy_column + 2
--|#line 125 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 125")
end
conditional_parse_domain (XPLAIN_C)
end
else
if yy_act = 17 then
	yy_column := yy_column + 2
--|#line 126 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 126")
end
conditional_parse_domain (XPLAIN_D)
else
	yy_column := yy_column + 2
--|#line 127 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 127")
end
conditional_parse_domain (XPLAIN_I)
end
end
end
end
else
if yy_act <= 27 then
if yy_act <= 23 then
if yy_act <= 21 then
if yy_act <= 20 then
if yy_act = 19 then
	yy_column := yy_column + 2
--|#line 128 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 128")
end
conditional_parse_domain (XPLAIN_M)
else
	yy_column := yy_column + 2
--|#line 129 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 129")
end
conditional_parse_domain (XPLAIN_P)
end
else
	yy_column := yy_column + 2
--|#line 130 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 130")
end
conditional_parse_domain (XPLAIN_R)
end
else
if yy_act = 22 then
	yy_column := yy_column + 2
--|#line 131 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 131")
end
conditional_parse_domain (XPLAIN_T)
else
	yy_column := yy_column + 1
--|#line 136 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 136")
end
last_token := Minus_code
end
end
else
if yy_act <= 25 then
if yy_act = 24 then
	yy_column := yy_column + 1
--|#line 137 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 137")
end
last_token := Plus_code
else
	yy_column := yy_column + 1
--|#line 138 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 138")
end
last_token := Star_code
end
else
if yy_act = 26 then
	yy_column := yy_column + 1
--|#line 139 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 139")
end
last_token := Slash_code
else
	yy_column := yy_column + 1
--|#line 140 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 140")
end
last_token := Equal_code; expect_domain := False
end
end
end
else
if yy_act <= 32 then
if yy_act <= 30 then
if yy_act <= 29 then
if yy_act = 28 then
	yy_column := yy_column + 1
--|#line 141 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 141")
end
last_token := Greater_than_code
else
	yy_column := yy_column + 1
--|#line 142 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 142")
end
last_token := Less_than_code
end
else
	yy_column := yy_column + 2
--|#line 143 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 143")
end
last_token := XPLAIN_NE
end
else
if yy_act = 31 then
	yy_column := yy_column + 1
--|#line 144 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 144")
end
last_token := Dot_code; expect_domain := False
else
	yy_column := yy_column + 2
--|#line 145 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 145")
end
last_token := XPLAIN_DOTDOT
end
end
else
if yy_act <= 34 then
if yy_act = 33 then
	yy_column := yy_column + 2
--|#line 146 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 146")
end
last_token := XPLAIN_GE
else
	yy_column := yy_column + 2
--|#line 147 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 147")
end
last_token := XPLAIN_LE
end
else
if yy_act = 35 then
	yy_column := yy_column + 1
--|#line 148 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 148")
end
last_token := Comma_code
else
	yy_column := yy_column + 1
--|#line 149 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 149")
end
last_token := Colon_code
end
end
end
end
end
else
if yy_act <= 54 then
if yy_act <= 45 then
if yy_act <= 41 then
if yy_act <= 39 then
if yy_act <= 38 then
if yy_act = 37 then
	yy_column := yy_column + 1
--|#line 150 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 150")
end
last_token := Left_parenthesis_code
else
	yy_column := yy_column + 1
--|#line 151 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 151")
end
last_token := Right_parenthesis_code
end
else
	yy_column := yy_column + 3
--|#line 156 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 156")
end
 last_token := XPLAIN_AND 
end
else
if yy_act = 40 then
	yy_end := yy_start + yy_more_len + 3
	yy_column := yy_column + 3
--|#line 157 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 157")
end
 last_token := XPLAIN_AND 
else
	yy_column := yy_column + 3
--|#line 158 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 158")
end
 last_token := XPLAIN_ANY 
end
end
else
if yy_act <= 43 then
if yy_act = 42 then
	yy_column := yy_column + 2
--|#line 159 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 159")
end
 last_token := XPLAIN_AS 
else
	yy_column := yy_column + 6
--|#line 160 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 160")
end
 last_token := XPLAIN_ASSERT 
end
else
if yy_act = 44 then
	yy_column := yy_column + 4
--|#line 161 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 161")
end
 last_token := XPLAIN_BASE; expect_domain := True 
else
	yy_column := yy_column + 7
--|#line 162 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 162")
end
 last_token := XPLAIN_CASCADE 
end
end
end
else
if yy_act <= 50 then
if yy_act <= 48 then
if yy_act <= 47 then
if yy_act = 46 then
	yy_column := yy_column + 4
--|#line 163 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 163")
end
 last_token := XPLAIN_CASE 
else
	yy_column := yy_column + 5
--|#line 164 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 164")
end
 last_token := XPLAIN_CHECK 
end
else
	yy_column := yy_column + 9
--|#line 165 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 165")
end
 last_token := XPLAIN_CLUSTERED 
end
else
if yy_act = 49 then
	yy_column := yy_column + 8
--|#line 166 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 166")
end
 last_token := XPLAIN_CONSTANT; expect_domain := True 
else
	yy_column := yy_column + 5
--|#line 167 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 167")
end
 last_token := XPLAIN_COUNT 
end
end
else
if yy_act <= 52 then
if yy_act = 51 then
	yy_column := yy_column + 8
--|#line 168 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 168")
end
 last_token := XPLAIN_DATABASE 
else
	yy_column := yy_column + 7
--|#line 169 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 169")
end
 last_token := XPLAIN_DEFAULT 
end
else
if yy_act = 53 then
	yy_column := yy_column + 6
--|#line 170 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 170")
end
 last_token := XPLAIN_DELETE 
else
	yy_column := yy_column + 4
--|#line 171 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 171")
end
 last_token := XPLAIN_ECHO 
end
end
end
end
else
if yy_act <= 63 then
if yy_act <= 59 then
if yy_act <= 57 then
if yy_act <= 56 then
if yy_act = 55 then
	yy_column := yy_column + 4
--|#line 172 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 172")
end
 last_token := XPLAIN_ELSE 
else
	yy_end := yy_start + yy_more_len + 4
	yy_column := yy_column + 4
--|#line 173 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 173")
end
 last_token := XPLAIN_ELSE 
end
else
	yy_column := yy_column + 3
--|#line 174 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 174")
end
 last_token := XPLAIN_END 
end
else
if yy_act = 58 then
	yy_column := yy_column + 7
--|#line 175 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 175")
end
 last_token := XPLAIN_ENDPROC 
else
	yy_column := yy_column + 6
--|#line 176 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 176")
end
 last_token := XPLAIN_EXTEND; expect_domain := True 
end
end
else
if yy_act <= 61 then
if yy_act = 60 then
	yy_column := yy_column + 5
--|#line 177 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 177")
end
 last_token := XPLAIN_FALSE 
else
	yy_column := yy_column + 3
--|#line 178 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 178")
end
 last_token := XPLAIN_GET 
end
else
if yy_act = 62 then
	yy_column := yy_column + 2
--|#line 179 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 179")
end
 last_token := XPLAIN_IF 
else
	yy_end := yy_start + yy_more_len + 2
	yy_column := yy_column + 2
--|#line 180 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 180")
end
 last_token := XPLAIN_IF 
end
end
end
else
if yy_act <= 68 then
if yy_act <= 66 then
if yy_act <= 65 then
if yy_act = 64 then
	yy_column := yy_column + 5
--|#line 181 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 181")
end
 last_token := XPLAIN_INDEX 
else
	yy_column := yy_column + 4
--|#line 182 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 182")
end
 last_token := XPLAIN_INIT 
end
else
	yy_column := yy_column + 5
--|#line 183 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 183")
end
 last_token := XPLAIN_INPUT 
end
else
if yy_act = 67 then
	yy_column := yy_column + 6
--|#line 184 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 184")
end
 last_token := XPLAIN_INSERT 
else
	yy_column := yy_column + 8
--|#line 185 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 185")
end
 last_token := XPLAIN_INSERTED 
end
end
else
if yy_act <= 70 then
if yy_act = 69 then
	yy_column := yy_column + 3
--|#line 186 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 186")
end
 last_token := XPLAIN_ITS 
else
	yy_column := yy_column + 9
--|#line 187 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 187")
end
 last_token := XPLAIN_LOGINNAME 
end
else
if yy_act = 71 then
	yy_column := yy_column + 3
--|#line 188 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 188")
end
 last_token := XPLAIN_MAX 
else
	yy_column := yy_column + 3
--|#line 189 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 189")
end
 last_token := XPLAIN_MIN 
end
end
end
end
end
end
else
if yy_act <= 108 then
if yy_act <= 90 then
if yy_act <= 81 then
if yy_act <= 77 then
if yy_act <= 75 then
if yy_act <= 74 then
if yy_act = 73 then
	yy_column := yy_column + 7
--|#line 190 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 190")
end
 last_token := XPLAIN_NEWLINE 
else
	yy_column := yy_column + 3
--|#line 191 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 191")
end
 last_token := XPLAIN_NIL 
end
else
	yy_column := yy_column + 3
--|#line 192 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 192")
end
 last_token := XPLAIN_NOT 
end
else
if yy_act = 76 then
	yy_end := yy_start + yy_more_len + 3
	yy_column := yy_column + 3
--|#line 193 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 193")
end
 last_token := XPLAIN_NOT 
else
	yy_column := yy_column + 4
--|#line 194 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 194")
end
 last_token := XPLAIN_NULL 
end
end
else
if yy_act <= 79 then
if yy_act = 78 then
	yy_column := yy_column + 2
--|#line 195 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 195")
end
 last_token := XPLAIN_OF 
else
	yy_column := yy_column + 8
--|#line 196 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 196")
end
 last_token := XPLAIN_OPTIONAL 
end
else
if yy_act = 80 then
	yy_column := yy_column + 2
--|#line 197 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 197")
end
 last_token := XPLAIN_OR 
else
	yy_end := yy_start + yy_more_len + 2
	yy_column := yy_column + 2
--|#line 198 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 198")
end
 last_token := XPLAIN_OR 
end
end
end
else
if yy_act <= 86 then
if yy_act <= 84 then
if yy_act <= 83 then
if yy_act = 82 then
	yy_column := yy_column + 3
--|#line 199 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 199")
end
 last_token := XPLAIN_PER 
else
	yy_column := yy_column + 9
--|#line 200 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 200")
end
 last_token := XPLAIN_PROCEDURE 
end
else
	yy_column := yy_column + 5
--|#line 201 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 201")
end
 last_token := XPLAIN_PURGE 
end
else
if yy_act = 85 then
yy_set_line_column
--|#line 202 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 202")
end
 last_token := XPLAIN_PATH_PROCEDURE 
else
yy_set_line_column
--|#line 203 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 203")
end
 last_token := XPLAIN_RECOMPILED_PROCEDURE 
end
end
else
if yy_act <= 88 then
if yy_act = 87 then
yy_set_line_column
--|#line 204 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 204")
end
 last_token := XPLAIN_TRIGGER_PROCEDURE 
else
	yy_column := yy_column + 8
--|#line 205 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 205")
end
 last_token := XPLAIN_REQUIRED 
end
else
if yy_act = 89 then
	yy_column := yy_column + 4
--|#line 206 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 206")
end
 last_token := XPLAIN_SOME 
else
	yy_column := yy_column + 10
--|#line 207 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 207")
end
 last_token := XPLAIN_SYSTEMDATE 
end
end
end
end
else
if yy_act <= 99 then
if yy_act <= 95 then
if yy_act <= 93 then
if yy_act <= 92 then
if yy_act = 91 then
	yy_column := yy_column + 4
--|#line 208 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 208")
end
 last_token := XPLAIN_THEN 
else
	yy_end := yy_start + yy_more_len + 4
	yy_column := yy_column + 4
--|#line 209 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 209")
end
 last_token := XPLAIN_THEN 
end
else
	yy_column := yy_column + 5
--|#line 210 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 210")
end
 last_token := XPLAIN_TOTAL 
end
else
if yy_act = 94 then
	yy_column := yy_column + 4
--|#line 211 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 211")
end
 last_token := XPLAIN_TRUE 
else
	yy_column := yy_column + 4
--|#line 212 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 212")
end
 last_token := XPLAIN_TYPE; expect_domain := True 
end
end
else
if yy_act <= 97 then
if yy_act = 96 then
	yy_column := yy_column + 6
--|#line 213 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 213")
end
 last_token := XPLAIN_UNIQUE 
else
	yy_column := yy_column + 6
--|#line 214 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 214")
end
 last_token := XPLAIN_UPDATE 
end
else
if yy_act = 98 then
	yy_column := yy_column + 5
--|#line 215 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 215")
end
 last_token := XPLAIN_VALUE 
else
	yy_column := yy_column + 4
--|#line 216 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 216")
end
 last_token := XPLAIN_WITH 
end
end
end
else
if yy_act <= 104 then
if yy_act <= 102 then
if yy_act <= 101 then
if yy_act = 100 then
	yy_column := yy_column + 5
--|#line 217 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 217")
end
 last_token := XPLAIN_WHERE 
else
yy_set_line_column
--|#line 222 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 222")
end
 last_token := XPLAIN_COMBINE 
end
else
yy_set_line_column
--|#line 223 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 223")
end
 last_token := XPLAIN_HEAD 
end
else
if yy_act = 103 then
yy_set_line_column
--|#line 224 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 224")
end
 last_token := XPLAIN_TAIL 
else
yy_set_line_column
--|#line 229 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 229")
end
 last_token := XPLAIN_DATEF 
end
end
else
if yy_act <= 106 then
if yy_act = 105 then
yy_set_line_column
--|#line 230 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 230")
end
 last_token := XPLAIN_INTEGERF 
else
yy_set_line_column
--|#line 231 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 231")
end
 last_token := XPLAIN_REALF 
end
else
if yy_act = 107 then
yy_set_line_column
--|#line 232 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 232")
end
 last_token := XPLAIN_STRINGF 
else
yy_set_line_column
--|#line 237 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 237")
end
 last_token := XPLAIN_DAYF 
end
end
end
end
end
else
if yy_act <= 126 then
if yy_act <= 117 then
if yy_act <= 113 then
if yy_act <= 111 then
if yy_act <= 110 then
if yy_act = 109 then
yy_set_line_column
--|#line 238 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 238")
end
 last_token := XPLAIN_ISDATE 
else
yy_set_line_column
--|#line 239 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 239")
end
 last_token := XPLAIN_MONTHF 
end
else
yy_set_line_column
--|#line 240 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 240")
end
 last_token := XPLAIN_NEWDATE 
end
else
if yy_act = 112 then
yy_set_line_column
--|#line 241 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 241")
end
 last_token := XPLAIN_TIMEDIF 
else
yy_set_line_column
--|#line 242 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 242")
end
 last_token := XPLAIN_YEARF 
end
end
else
if yy_act <= 115 then
if yy_act = 114 then
yy_set_line_column
--|#line 243 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 243")
end
 last_token := XPLAIN_WDAYF 
else
yy_set_line_column
--|#line 248 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 248")
end
 last_token := XPLAIN_POW 
end
else
if yy_act = 116 then
yy_set_line_column
--|#line 249 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 249")
end
 last_token := XPLAIN_ABS 
else
yy_set_line_column
--|#line 250 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 250")
end
 last_token := XPLAIN_MAXF 
end
end
end
else
if yy_act <= 122 then
if yy_act <= 120 then
if yy_act <= 119 then
if yy_act = 118 then
yy_set_line_column
--|#line 251 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 251")
end
 last_token := XPLAIN_MINF 
else
yy_set_line_column
--|#line 252 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 252")
end
 last_token := XPLAIN_SQRT 
end
else
yy_set_line_column
--|#line 253 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 253")
end
 last_token := XPLAIN_EXP 
end
else
if yy_act = 121 then
yy_set_line_column
--|#line 254 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 254")
end
 last_token := XPLAIN_LN 
else
yy_set_line_column
--|#line 255 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 255")
end
 last_token := XPLAIN_LOG10 
end
end
else
if yy_act <= 124 then
if yy_act = 123 then
yy_set_line_column
--|#line 256 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 256")
end
 last_token := XPLAIN_SIN 
else
yy_set_line_column
--|#line 257 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 257")
end
 last_token := XPLAIN_COS 
end
else
if yy_act = 125 then
yy_set_line_column
--|#line 258 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 258")
end
 last_token := XPLAIN_TAN 
else
yy_set_line_column
--|#line 259 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 259")
end
 last_token := XPLAIN_ASIN 
end
end
end
end
else
if yy_act <= 135 then
if yy_act <= 131 then
if yy_act <= 129 then
if yy_act <= 128 then
if yy_act = 127 then
yy_set_line_column
--|#line 260 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 260")
end
 last_token := XPLAIN_ACOS 
else
yy_set_line_column
--|#line 261 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 261")
end
 last_token := XPLAIN_ATAN 
end
else
yy_set_line_column
--|#line 262 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 262")
end
 last_token := XPLAIN_SINH 
end
else
if yy_act = 130 then
yy_set_line_column
--|#line 263 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 263")
end
 last_token := XPLAIN_COSH 
else
yy_set_line_column
--|#line 264 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 264")
end
 last_token := XPLAIN_TANH 
end
end
else
if yy_act <= 133 then
if yy_act = 132 then
yy_set_line_column
--|#line 265 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 265")
end
 last_token := XPLAIN_ASINH 
else
yy_set_line_column
--|#line 266 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 266")
end
 last_token := XPLAIN_ACOSH 
end
else
if yy_act = 134 then
yy_set_line_column
--|#line 267 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 267")
end
 last_token := XPLAIN_ATANH 
else
yy_set_line_column
--|#line 272 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 272")
end
 last_token := XPLAIN_ID 
end
end
end
else
if yy_act <= 140 then
if yy_act <= 138 then
if yy_act <= 137 then
if yy_act = 136 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 277 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 277")
end

		  last_token := XPLAIN_IDENTIFIER
		  last_string_value := text
		  last_string_value.right_adjust
		
else
yy_set_line_column
--|#line 284 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 284")
end

		 last_token := XPLAIN_IDENTIFIER
		 last_string_value := text.substring(2, text.count-1)
	
end
else
yy_set_line_column
--|#line 292 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 292")
end

	if text.count = 2 then
		last_string_value := ""
	else
		last_string_value := unquote_string (text.substring(2, text.count-1))
	end
	last_token := XPLAIN_STRING
	
end
else
if yy_act = 139 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 301 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 301")
end

	last_token := XPLAIN_INTEGER
	last_integer_value := text.to_integer
	
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
--|#line 305 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 305")
end

	last_token := XPLAIN_DOUBLE
	last_string_value := text
	
end
end
else
if yy_act <= 142 then
if yy_act = 141 then
	yy_column := yy_column + 8
--|#line 313 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 313")
end
 preprocessor_include 
else
	yy_column := yy_column + 4
--|#line 314 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 314")
end
 preprocessor_use 
end
else
if yy_act = 143 then
	yy_column := yy_column + 1
--|#line 323 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 323")
end
last_token := text_item (1).code
else
yy_set_line_column
--|#line 0 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 0")
end
default_action
end
end
end
end
end
end
end
		end

	yy_execute_eof_action (yy_sc: INTEGER) is
			-- Execute EOF semantic action.
		do
			inspect yy_sc
when 0, 1, 2, 3 then
--|#line 0 "xplain_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'xplain_scanner.l' at line 0")
end

	terminate
	std.output.put_string("%N")
	
			else
				terminate
			end
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1701)
			yy_nxt_template_1 (an_array)
			yy_nxt_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_nxt_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,   10,   11,   12,   11,   11,   13,   14,   10,   15,
			   16,   17,   18,   19,   20,   21,   22,   23,   23,   23,
			   24,   25,   26,   27,   28,   29,   30,   31,   32,   33,
			   34,   35,   36,   37,   37,   38,   39,   40,   41,   42,
			   37,   43,   44,   45,   46,   47,   48,   37,   49,   50,
			   51,   10,   54,   55,   54,   55,   57,   58,   57,   58,
			   60,   60,   60,   60,   60,   60,   60,   60,   72,   74,
			   77,   73,   73,   73,   79,   78,   73,   73,   73,   80,
			   81,   83,   83,   83,   83,  551,   75,   60,   60,   60,
			   60,   83,  550,   83,   83,  152,  152,  152,   76,   83,

			   90,   83,  101,  140,   59,  102,   59,   63,   64,   65,
			   66,   85,   86,   95,   83,   67,  103,   96,   83,   68,
			   91,   83,   69,   87,   70,   83,   71,   92,   88,   89,
			   83,   93,   83,   83,   94,   97,  154,   83,   83,   83,
			  549,  548,   83,  104,   98,  105,   99,  547,  126,  111,
			  109,  110,   83,  106,   83,  144,  100,  112,  107,  108,
			  114,  121,  118,  113,  115,  122,  155,   83,   83,   83,
			  116,  138,  119,  139,  120,  123,  117,   83,  124,  127,
			   83,  125,   83,   83,   83,  128,  132,  129,   83,   83,
			  130,  161,  163,  133,  134,  131,  153,  153,  153,  156,

			  135,  160,  141,  136,   83,  162,  142,  143,   83,   79,
			  137,   73,   73,   73,   83,  158,   83,   83,   83,   83,
			  157,   83,  164,   83,   83,  159,   83,  169,   83,   83,
			  546,   83,  170,   83,  173,  165,  166,   83,  171,  175,
			   83,  167,  180,  168,  172,   83,   83,   83,  190,  178,
			   83,   83,  176,  174,  195,   83,  177,   83,   83,  179,
			  181,  181,  181,  182,  208,  191,  196,  183,  185,  192,
			  192,  192,  193,  186,  199,  201,  194,  197,  203,  198,
			  187,  200,   83,  188,  189,  202,   83,   83,  205,   83,
			   83,   83,   83,  206,   83,   83,   83,   83,   83,  207,

			   83,   83,  545,   83,  544,  210,   83,  211,   83,  152,
			  152,  152,   83,   83,   83,   83,   83,  220,  209,  213,
			  214,  212,   83,  218,  223,  229,  215,  216,  219,  217,
			  226,  221,  225,  222,  227,  232,  224,  230,  228,  231,
			  153,  236,  236,  236,  237,  242,   83,  241,  238,   83,
			  239,   83,  153,  153,  153,   83,   83,   83,   83,   83,
			   83,  251,  251,  251,  252,   83,   83,   83,  253,   83,
			   83,   83,  244,   83,  543,  542,  247,  245,  243,  246,
			  249,   83,  258,   83,  259,  256,   83,   83,  248,  257,
			  254,  255,  260,  262,  250,  264,  264,  264,  265,   83,

			  261,   83,  266,  184,  267,  263,  272,   83,  269,   83,
			  268,  181,  181,  181,  181,  271,  271,  271,  183,  181,
			  181,  181,  182,   83,  275,  273,  183,   83,  277,  183,
			  183,  183,  183,   83,  153,  153,  153,  270,  274,   83,
			  192,  192,  192,  192,  541,  286,  276,  194,  192,  192,
			  192,  193,  278,   83,  291,  194,  306,   83,   83,  204,
			   83,   83,   83,  153,  153,  153,  279,  280,  280,  280,
			  281,  292,  292,  292,  282,  283,  283,  283,  284,  287,
			   83,  297,  285,  290,  293,   83,  298,  288,  294,  294,
			  294,  295,  299,   83,   83,  296,  302,  302,  302,  303,

			   83,   83,   83,  304,  311,  311,  311,  312,   83,   83,
			   83,  313,   83,  300,   83,   83,   83,   83,   83,   83,
			  317,  308,   83,   83,  301,  305,   83,   83,   83,  240,
			   83,  307,  310,  314,  318,  316,  322,  319,  309,  320,
			  315,  333,  333,  333,   83,  321,  343,   83,  326,  236,
			  236,  236,  236,  346,  323,  325,  238,  344,   83,  327,
			   83,  324,  236,  236,  236,  237,  338,   83,  353,  238,
			   83,   83,   83,  329,  329,  329,  330,  153,  153,  153,
			  331,  334,  334,  334,  335,  345,   83,  352,  336,  339,
			  339,  339,  340,   83,   83,   83,  341,  357,  347,  375,

			  271,   83,  332,  540,  251,  251,  251,  251,  351,  358,
			  337,  253,  271,  271,  271,   83,  539,  362,  342,  251,
			  251,  251,  252,  402,   83,   83,  253,  361,  366,  360,
			  348,  348,  348,  349,  153,  153,  153,  350,  354,  354,
			  354,  355,   83,   83,   83,  356,  264,  264,  264,  264,
			  369,  368,   83,  266,  264,  264,  264,  265,   83,   83,
			   83,  266,  367,   83,  371,  363,  363,  363,  364,  153,
			  153,  153,  365,   83,  403,  372,  280,  280,  280,  280,
			  370,  380,  381,  282,  280,  280,  280,  281,  538,  373,
			   83,  282,  374,  377,   83,  283,  283,  283,  283,  153,

			  153,  153,  285,  283,  283,  283,  284,   83,   83,  289,
			  285,   83,  292,  378,  378,  378,  379,  386,  153,  153,
			  153,  376,  376,  376,  292,  292,  292,  294,  294,  294,
			  294,   83,  404,  405,  296,  294,  294,  294,  295,  385,
			   83,   83,  296,  393,   83,   83,  382,  382,  382,  383,
			  153,  153,  153,  384,  302,  302,  302,  302,  453,  425,
			  426,  304,  302,  302,  302,  303,   83,  394,  407,  304,
			   83,   83,   83,  387,  387,  387,  388,  153,  153,  153,
			  389,  390,  390,  390,  391,  476,   83,   83,  392,  395,
			  395,  395,  396,   83,  408,  409,  397,  311,  311,  311,

			  311,  333,   83,   83,  313,  311,  311,  311,  312,  406,
			  410,  442,  313,  333,  333,  333,  398,  398,  398,  399,
			  153,  153,  153,  400,  329,  329,  329,  329,  450,  449,
			   83,  331,  329,  329,  329,  330,   83,   83,  537,  331,
			  418,   83,   83,  412,  412,  412,  413,  153,  153,  153,
			  414,  334,  334,  334,  334,   83,  536,   83,  336,  334,
			  334,  334,  335,  422,  448,  423,  336,  430,  424,   83,
			  415,  415,  415,  416,  153,  153,  153,  417,  339,  339,
			  339,  339,  359,   83,   83,  341,  339,  339,  339,  340,
			  433,  465,  431,  341,  432,  432,  432,  419,  419,  419,

			  420,  153,  153,  153,  421,  348,  348,  348,  348,  534,
			   83,  485,  350,  348,  348,  348,  349,   83,   83,   83,
			  350,  435,   83,   83,  427,  427,  427,  428,  153,  153,
			  153,  429,  354,  354,  354,  354,  533,   83,  482,  356,
			  354,  354,  354,  355,  434,   83,  436,  356,  443,  441,
			  444,  363,  363,  363,  363,  153,  153,  153,  365,  363,
			  363,  363,  364,   83,   83,   83,  365,  376,  437,  445,
			  438,  438,  438,  439,  153,  153,  153,  440,   83,  376,
			  376,  376,  378,  378,  378,  378,  447,  382,  382,  382,
			  382,  530,   83,  529,  384,  387,  387,  387,  387,   83, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_nxt_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  468,   83,  389,  390,  390,  390,  390,   83,   83,  451,
			  392,  395,  395,  395,  395,  454,  401,   83,  397,  446,
			  378,  378,  378,  379,  398,  398,  398,  398,  452,  452,
			  452,  400,   83,  467,  526,  153,  153,  153,  484,   83,
			  455,  457,  457,  457,  458,   83,  469,   83,  459,  460,
			  460,  460,  461,   83,   83,  456,  462,  446,  382,  382,
			  382,  383,  464,   83,   83,  384,   83,   83,  466,   83,
			  471,   83,  432,  153,  153,  153,  387,  387,  387,  388,
			   83,   83,   83,  389,  432,  432,  432,  470,  491,  472,
			  480,  153,  153,  153,  390,  390,  390,  391,   83,  492,

			   83,  392,   83,  481,  486,  494,   83,  498,   83,  153,
			  153,  153,  395,  395,  395,  396,   83,   83,  521,  397,
			  490,   83,  452,  499,  500,   83,   83,  153,  153,  153,
			  398,  398,  398,  399,  452,  452,  452,  400,  512,  504,
			  513,  412,  412,  412,  412,  153,  153,  153,  414,  412,
			  412,  412,  413,  510,   83,  508,  414,   83,   83,   83,
			  415,  415,  415,  415,  153,  153,  153,  417,  415,  415,
			  415,  416,   83,   83,   83,  417,  519,   83,  509,  419,
			  419,  419,  419,  153,  153,  153,  421,  419,  419,  419,
			  420,   83,   83,   83,  421,  520,  522,  523,  427,  427,

			  427,  427,  153,  153,  153,  429,  427,  427,  427,  428,
			   83,   83,   83,  429,  527,  524,  528,  473,  473,  473,
			  474,  153,  153,  153,  475,  438,  438,  438,  438,   83,
			  493,   83,  440,  438,  438,  438,  439,   83,  483,   83,
			  440,  511,   83,   83,  477,  477,  477,  478,  153,  153,
			  153,  479,  487,  487,  487,  488,  463,   83,   83,  489,
			  457,  457,  457,  457,   83,   83,   83,  459,  457,  457,
			  457,  458,   83,   83,   83,  459,   83,  411,   83,  460,
			  460,  460,  460,  153,  153,  153,  462,  460,  460,  460,
			  461,   83,   83,  401,  462,   83,   83,   83,  495,  495,

			  495,  496,  153,  153,  153,  497,  501,  501,  501,  502,
			  359,   83,   83,  503,  473,  473,  473,  473,   83,  328,
			   83,  475,  473,  473,  473,  474,  289,   83,   83,  475,
			   83,   83,  240,  477,  477,  477,  477,  153,  153,  153,
			  479,  477,  477,  477,  478,  235,  234,  233,  479,  204,
			   83,  184,  505,  505,  505,  506,  153,  153,  153,  507,
			  487,  487,  487,  487,   83,  151,  150,  489,  487,  487,
			  487,  488,  149,  148,   61,  489,   62,   83,   82,  514,
			  514,  514,  515,  153,  153,  153,  516,  517,  517,  517,
			  518,  495,  495,  495,  495,   62,  552,  552,  497,  495,

			  495,  495,  496,  552,  552,  552,  497,  552,  552,  552,
			  501,  501,  501,  501,  153,  153,  153,  503,  501,  501,
			  501,  502,  552,  552,  552,  503,  552,  552,  552,  505,
			  505,  505,  505,  153,  153,  153,  507,  505,  505,  505,
			  506,  552,  552,  552,  507,  552,  552,  552,  514,  514,
			  514,  514,  153,  153,  153,  516,  514,  514,  514,  515,
			  552,  552,  552,  516,  517,  517,  517,  517,  552,  552,
			  552,  153,  153,  153,  531,  531,  531,  532,  531,  531,
			  531,  531,   84,  552,   84,   84,   84,   84,  147,  552,
			  147,  147,  147,  147,  147,  147,  552,  552,  552,  552,

			  552,  525,  517,  517,  517,  518,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  535,  552,  153,  153,  153,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  525,
			  531,  531,  531,  532,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  153,  153,  153,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  535,   52,   52,
			   52,   52,   52,   52,   52,   52,   52,   53,   53,   53,
			   53,   53,   53,   53,   53,   53,   56,   56,   56,   56,

			   56,   56,   56,   56,   56,   61,   61,   61,   61,   61,
			   61,   61,   61,   61,  145,  145,  145,  552,  145,  145,
			  145,  145,  145,  146,  552,  146,  146,  146,  146,  146,
			  146,  146,   77,   77,   77,   77,   77,   77,   77,   77,
			   77,   78,   78,   78,   78,   78,   78,   78,   78,   78,
			    9,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,

			  552,  552, yy_Dummy>>,
			1, 702, 1000)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1701)
			yy_chk_template_1 (an_array)
			yy_chk_template_2 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_chk_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    5,    5,    6,    6,    7,    7,    8,    8,
			   11,   11,   11,   11,   12,   12,   12,   12,   20,   21,
			   22,   20,   20,   20,   23,   22,   23,   23,   23,   25,
			   25,   29,   34,   33,   47,  550,   21,   60,   60,   60,
			   60,   28,  549,   35,   31,   79,   79,   79,   21,   85,

			   29,   30,   33,   47,    7,   34,    8,   15,   15,   15,
			   15,   28,   28,   31,   32,   15,   35,   31,   38,   15,
			   30,   36,   15,   28,   15,   43,   15,   30,   28,   28,
			   39,   30,   49,   86,   30,   32,   85,   40,   41,   46,
			  547,  546,   42,   36,   32,   36,   32,  545,   43,   39,
			   38,   38,   44,   36,   90,   49,   32,   39,   36,   36,
			   40,   42,   41,   39,   40,   42,   86,   45,   91,   92,
			   40,   46,   41,   46,   41,   42,   40,   87,   42,   44,
			   48,   42,   89,   93,   83,   44,   45,   44,   88,   95,
			   44,   90,   92,   45,   45,   44,   83,   83,   83,   87,

			   45,   89,   48,   45,   94,   91,   48,   48,   97,   73,
			   45,   73,   73,   73,   96,   88,   98,   99,  100,  101,
			   87,  102,   93,  103,  111,   88,  107,   95,  108,  110,
			  544,  124,   95,  114,   97,   94,   94,  116,   96,   99,
			  119,   94,  103,   94,   96,  112,  106,  113,  107,  101,
			  121,  115,  100,   98,  110,  117,  100,  122,  123,  102,
			  104,  104,  104,  104,  124,  108,  111,  104,  106,  109,
			  109,  109,  109,  106,  114,  116,  109,  112,  119,  113,
			  106,  115,  125,  106,  106,  117,  126,  127,  121,  128,
			  129,  130,  131,  122,  133,  135,  132,  136,  137,  123,

			  134,  143,  543,  138,  542,  126,  141,  126,  140,  152,
			  152,  152,  139,  155,  142,  158,  144,  133,  125,  127,
			  128,  126,  159,  132,  136,  141,  129,  130,  132,  131,
			  138,  134,  137,  135,  139,  144,  136,  142,  140,  143,
			  153,  154,  154,  154,  154,  159,  160,  158,  154,  161,
			  155,  164,  153,  153,  153,  163,  162,  166,  170,  168,
			  165,  167,  167,  167,  167,  171,  169,  173,  167,  172,
			  174,  175,  161,  178,  541,  539,  163,  162,  160,  162,
			  165,  177,  170,  185,  171,  169,  180,  186,  164,  169,
			  167,  168,  172,  174,  166,  176,  176,  176,  176,  187,

			  173,  188,  176,  184,  177,  175,  185,  198,  180,  190,
			  178,  181,  181,  181,  181,  184,  184,  184,  181,  182,
			  182,  182,  182,  189,  188,  186,  182,  203,  190,  183,
			  183,  183,  183,  214,  182,  182,  182,  183,  187,  195,
			  192,  192,  192,  192,  538,  198,  189,  192,  193,  193,
			  193,  193,  195,  202,  203,  193,  214,  199,  205,  204,
			  208,  209,  210,  193,  193,  193,  195,  196,  196,  196,
			  196,  204,  204,  204,  196,  197,  197,  197,  197,  199,
			  211,  208,  197,  202,  205,  212,  209,  199,  207,  207,
			  207,  207,  210,  215,  216,  207,  213,  213,  213,  213,

			  217,  222,  218,  213,  219,  219,  219,  219,  220,  223,
			  226,  219,  221,  211,  224,  228,  225,  227,  229,  230,
			  222,  216,  231,  232,  212,  213,  249,  245,  247,  240,
			  242,  215,  218,  219,  223,  221,  227,  224,  217,  225,
			  220,  240,  240,  240,  257,  226,  245,  248,  231,  236,
			  236,  236,  236,  249,  228,  230,  236,  247,  259,  232,
			  250,  229,  237,  237,  237,  237,  242,  256,  257,  237,
			  255,  260,  288,  239,  239,  239,  239,  237,  237,  237,
			  239,  241,  241,  241,  241,  248,  272,  256,  241,  243,
			  243,  243,  243,  263,  268,  267,  243,  259,  250,  288,

			  271,  316,  239,  537,  251,  251,  251,  251,  255,  260,
			  241,  251,  271,  271,  271,  275,  536,  268,  243,  252,
			  252,  252,  252,  316,  274,  276,  252,  267,  272,  263,
			  254,  254,  254,  254,  252,  252,  252,  254,  258,  258,
			  258,  258,  277,  279,  317,  258,  264,  264,  264,  264,
			  276,  275,  278,  264,  265,  265,  265,  265,  297,  298,
			  291,  265,  274,  286,  278,  269,  269,  269,  269,  265,
			  265,  265,  269,  287,  317,  279,  280,  280,  280,  280,
			  277,  297,  298,  280,  281,  281,  281,  281,  535,  286,
			  301,  281,  287,  291,  321,  283,  283,  283,  283,  281,

			  281,  281,  283,  284,  284,  284,  284,  318,  300,  289,
			  284,  308,  292,  293,  293,  293,  293,  301,  284,  284,
			  284,  289,  289,  289,  292,  292,  292,  294,  294,  294,
			  294,  402,  318,  321,  294,  295,  295,  295,  295,  300,
			  347,  352,  295,  308,  309,  323,  299,  299,  299,  299,
			  295,  295,  295,  299,  302,  302,  302,  302,  402,  347,
			  352,  302,  303,  303,  303,  303,  441,  309,  323,  303,
			  324,  322,  325,  305,  305,  305,  305,  303,  303,  303,
			  305,  307,  307,  307,  307,  441,  327,  373,  307,  310,
			  310,  310,  310,  386,  324,  325,  310,  311,  311,  311,

			  311,  333,  338,  393,  311,  312,  312,  312,  312,  322,
			  327,  373,  312,  333,  333,  333,  314,  314,  314,  314,
			  312,  312,  312,  314,  329,  329,  329,  329,  393,  386,
			  385,  329,  330,  330,  330,  330,  346,  357,  534,  330,
			  338,  343,  345,  332,  332,  332,  332,  330,  330,  330,
			  332,  334,  334,  334,  334,  423,  533,  360,  334,  335,
			  335,  335,  335,  343,  385,  345,  335,  357,  346,  358,
			  337,  337,  337,  337,  335,  335,  335,  337,  339,  339,
			  339,  339,  359,  368,  448,  339,  340,  340,  340,  340,
			  360,  423,  358,  340,  359,  359,  359,  342,  342,  342,

			  342,  340,  340,  340,  342,  348,  348,  348,  348,  530,
			  374,  448,  348,  349,  349,  349,  349,  372,  375,  445,
			  349,  368,  361,  369,  353,  353,  353,  353,  349,  349,
			  349,  353,  354,  354,  354,  354,  529,  377,  445,  354,
			  355,  355,  355,  355,  361,  370,  369,  355,  374,  372,
			  375,  363,  363,  363,  363,  355,  355,  355,  363,  364,
			  364,  364,  364,  426,  380,  528,  364,  376,  370,  377,
			  371,  371,  371,  371,  364,  364,  364,  371,  394,  376,
			  376,  376,  378,  378,  378,  378,  380,  382,  382,  382,
			  382,  526,  404,  525,  382,  387,  387,  387,  387,  447, yy_Dummy>>,
			1, 1000, 0)
		end

	yy_chk_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  426,  425,  387,  390,  390,  390,  390,  522,  430,  394,
			  390,  395,  395,  395,  395,  404,  401,  405,  395,  378,
			  379,  379,  379,  379,  398,  398,  398,  398,  401,  401,
			  401,  398,  406,  425,  521,  379,  379,  379,  447,  422,
			  405,  408,  408,  408,  408,  424,  430,  435,  408,  410,
			  410,  410,  410,  436,  520,  406,  410,  379,  383,  383,
			  383,  383,  422,  454,  453,  383,  433,  443,  424,  467,
			  435,  519,  432,  383,  383,  383,  388,  388,  388,  388,
			  444,  449,  465,  388,  432,  432,  432,  433,  453,  436,
			  443,  388,  388,  388,  391,  391,  391,  391,  451,  454,

			  468,  391,  471,  444,  449,  465,  512,  467,  476,  391,
			  391,  391,  396,  396,  396,  396,  486,  484,  509,  396,
			  451,  490,  452,  468,  471,  482,  508,  396,  396,  396,
			  399,  399,  399,  399,  452,  452,  452,  399,  486,  476,
			  490,  412,  412,  412,  412,  399,  399,  399,  412,  413,
			  413,  413,  413,  484,  494,  482,  413,  500,  499,  498,
			  415,  415,  415,  415,  413,  413,  413,  415,  416,  416,
			  416,  416,  504,  510,  511,  416,  494,  513,  483,  419,
			  419,  419,  419,  416,  416,  416,  419,  420,  420,  420,
			  420,  481,  523,  524,  420,  504,  510,  511,  427,  427,

			  427,  427,  420,  420,  420,  427,  428,  428,  428,  428,
			  470,  485,  469,  428,  523,  513,  524,  437,  437,  437,
			  437,  428,  428,  428,  437,  438,  438,  438,  438,  464,
			  463,  456,  438,  439,  439,  439,  439,  455,  446,  434,
			  439,  485,  431,  418,  442,  442,  442,  442,  439,  439,
			  439,  442,  450,  450,  450,  450,  411,  409,  407,  450,
			  457,  457,  457,  457,  403,  381,  367,  457,  458,  458,
			  458,  458,  366,  362,  351,  458,  344,  328,  326,  460,
			  460,  460,  460,  458,  458,  458,  460,  461,  461,  461,
			  461,  320,  319,  315,  461,  306,  290,  273,  466,  466,

			  466,  466,  461,  461,  461,  466,  472,  472,  472,  472,
			  262,  261,  246,  472,  473,  473,  473,  473,  244,  234,
			  206,  473,  474,  474,  474,  474,  201,  200,  191,  474,
			  179,  157,  156,  477,  477,  477,  477,  474,  474,  474,
			  477,  478,  478,  478,  478,  149,  148,  145,  478,  120,
			  118,  105,  480,  480,  480,  480,  478,  478,  478,  480,
			  487,  487,  487,  487,   84,   78,   77,  487,  488,  488,
			  488,  488,   76,   75,   62,  488,   61,   37,   27,  491,
			  491,  491,  491,  488,  488,  488,  491,  492,  492,  492,
			  492,  495,  495,  495,  495,   13,    9,    0,  495,  496,

			  496,  496,  496,    0,    0,    0,  496,    0,    0,    0,
			  501,  501,  501,  501,  496,  496,  496,  501,  502,  502,
			  502,  502,    0,    0,    0,  502,    0,    0,    0,  505,
			  505,  505,  505,  502,  502,  502,  505,  506,  506,  506,
			  506,    0,    0,    0,  506,    0,    0,    0,  514,  514,
			  514,  514,  506,  506,  506,  514,  515,  515,  515,  515,
			    0,    0,    0,  515,  517,  517,  517,  517,    0,    0,
			    0,  515,  515,  515,  527,  527,  527,  527,  531,  531,
			  531,  531,  557,    0,  557,  557,  557,  557,  560,    0,
			  560,  560,  560,  560,  560,  560,    0,    0,    0,    0,

			    0,  517,  518,  518,  518,  518,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,  531,    0,  518,  518,  518,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,  518,
			  532,  532,  532,  532,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,  532,  532,  532,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,  532,  553,  553,
			  553,  553,  553,  553,  553,  553,  553,  554,  554,  554,
			  554,  554,  554,  554,  554,  554,  555,  555,  555,  555,

			  555,  555,  555,  555,  555,  556,  556,  556,  556,  556,
			  556,  556,  556,  556,  558,  558,  558,    0,  558,  558,
			  558,  558,  558,  559,    0,  559,  559,  559,  559,  559,
			  559,  559,  561,  561,  561,  561,  561,  561,  561,  561,
			  561,  562,  562,  562,  562,  562,  562,  562,  562,  562,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,

			  552,  552, yy_Dummy>>,
			1, 702, 1000)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    0,    0,   49,   51,   53,   55, 1396,
			 1650,   58,   62, 1389, 1650,   83, 1650, 1650, 1650, 1650,
			   54,   54,   59,   59, 1650,   57, 1650, 1356,   86,   76,
			   96,   89,  109,   78,   77,   88,  116, 1372,  113,  125,
			  132,  133,  137,  120,  147,  162,  134,   79,  175,  127,
			    0, 1650, 1650,    0, 1650, 1650,    0, 1650, 1650, 1650,
			   85, 1370, 1368, 1650, 1650, 1650, 1650, 1650, 1650, 1650,
			 1650, 1650, 1650,  194, 1650, 1336, 1330, 1363, 1362,   78,
			 1650, 1650, 1650,  179, 1359,   94,  128,  172,  183,  177,
			  149,  163,  164,  178,  199,  184,  209,  203,  211,  212,

			  213,  214,  216,  218,  258, 1346,  241,  221,  223,  267,
			  224,  219,  240,  242,  228,  246,  232,  250, 1345,  235,
			 1344,  245,  252,  253,  226,  277,  281,  282,  284,  285,
			  286,  287,  291,  289,  295,  290,  292,  293,  298,  307,
			  303,  301,  309,  296,  311, 1339,    0,    0, 1320, 1317,
			 1650, 1650,  292,  335,  339,  308, 1327, 1326,  310,  317,
			  341,  344,  351,  350,  346,  355,  352,  359,  354,  361,
			  353,  360,  364,  362,  365,  366,  393,  376,  368, 1325,
			  381,  409,  417,  427,  398,  378,  382,  394,  396,  418,
			  404, 1323,  438,  446, 1650,  434,  465,  473,  402,  452,

			 1322, 1321,  448,  422,  454,  453, 1315,  486,  455,  456,
			  457,  475,  480,  494,  428,  488,  489,  495,  497,  502,
			  503,  507,  496,  504,  509,  511,  505,  512,  510,  513,
			  514,  517,  518, 1650, 1284, 1650,  547,  560, 1650,  571,
			  524,  579,  525,  587, 1313,  522, 1307,  523,  542,  521,
			  555,  602,  617, 1650,  628,  565,  562,  539,  636,  553,
			  566, 1306, 1305,  588,  644,  652, 1650,  590,  589,  663,
			 1650,  595,  581, 1292,  619,  610,  620,  637,  647,  638,
			  674,  682, 1650,  693,  701, 1650,  658,  668,  567,  704,
			 1291,  655,  707,  711,  725,  733, 1650,  653,  654,  744,

			  703,  685,  752,  760, 1650,  771, 1290,  779,  706,  739,
			  787,  795,  803, 1650,  814, 1288,  596,  639,  702, 1287,
			 1286,  689,  766,  740,  765,  767, 1273,  781, 1233,  822,
			  830, 1650,  841,  796,  849,  857, 1650,  868,  797,  876,
			  884, 1650,  895,  836, 1271,  837,  831,  735,  903,  911,
			 1650, 1269,  736,  922,  930,  938, 1650,  832,  864,  877,
			  852,  917, 1268,  949,  957, 1650, 1267, 1261,  878,  918,
			  940,  968,  912,  782,  905,  913,  962,  932,  980, 1018,
			  959, 1260,  985, 1056, 1650,  825,  788,  993, 1074, 1650,
			 1001, 1092, 1650,  798,  973, 1009, 1110, 1650, 1022, 1128,

			 1650, 1011,  726, 1259,  987, 1012, 1027, 1253, 1039, 1252,
			 1047, 1229, 1139, 1147, 1650, 1158, 1166, 1650, 1238, 1177,
			 1185, 1650, 1034,  850, 1040,  996,  958, 1196, 1204, 1650,
			 1003, 1237, 1067, 1061, 1234, 1042, 1048, 1215, 1223, 1231,
			 1650,  761, 1242, 1062, 1075,  914, 1197,  994,  879, 1076,
			 1250, 1093, 1117, 1059, 1058, 1232, 1226, 1258, 1266, 1650,
			 1277, 1285, 1650, 1202, 1224, 1077, 1296, 1064, 1095, 1207,
			 1205, 1097, 1304, 1312, 1320, 1650, 1103, 1331, 1339, 1650,
			 1350, 1186, 1120, 1140, 1112, 1206, 1111, 1358, 1366, 1650,
			 1116, 1377, 1385, 1650, 1149, 1389, 1397, 1650, 1154, 1153,

			 1152, 1408, 1416, 1650, 1167, 1427, 1435, 1650, 1121, 1092,
			 1168, 1169, 1101, 1172, 1446, 1454, 1650, 1462, 1500, 1066,
			 1049, 1006, 1002, 1187, 1188,  952,  964, 1472,  960,  898,
			  865, 1476, 1538,  830,  797,  647,  588,  575,  406,  348,
			 1650,  348,  260,  274,  189,  120,  113,   96, 1650,   51,
			   57, 1650, 1650, 1577, 1586, 1595, 1604, 1479, 1613, 1622,
			 1487, 1631, 1640, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  552,    1,  553,  553,  554,  554,  555,  555,  552,
			  552,  552,  552,  556,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  557,  557,
			  557,  557,  557,  557,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,  557,  557,  557,  557,
			  558,  552,  552,  559,  552,  552,  560,  552,  552,  552,
			  552,  556,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  561,  562,  552,
			  552,  552,  552,  552,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,  557,  557,  557,  557,

			  557,  557,  557,  557,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  558,  559,  560,  552,  552,
			  552,  552,  552,  552,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,  557,  557,  557,  557,
			  557,  552,  552,  552,  552,  557,  557,  557,  557,  557,
			  557,  557,  552,  552,  552,  557,  557,  557,  557,  557,

			  557,  557,  557,  557,  552,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  552,  552,  552,  552,  552,  552,  557,
			  552,  557,  557,  557,  557,  557,  557,  557,  557,  557,
			  557,  552,  552,  552,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  552,  552,  552,  557,  557,  557,
			  552,  552,  557,  557,  557,  557,  557,  557,  557,  557,
			  552,  552,  552,  552,  552,  552,  557,  557,  557,  552,
			  557,  557,  552,  557,  552,  552,  552,  557,  557,  557,

			  557,  557,  552,  552,  552,  557,  557,  557,  557,  557,
			  557,  552,  552,  552,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,  557,  557,  552,  552,
			  552,  552,  557,  552,  552,  552,  552,  557,  557,  552,
			  552,  552,  557,  557,  557,  557,  557,  557,  552,  552,
			  552,  557,  557,  557,  552,  552,  552,  557,  557,  552,
			  557,  557,  557,  552,  552,  552,  557,  557,  557,  557,
			  557,  557,  557,  557,  557,  557,  552,  557,  552,  552,
			  557,  557,  552,  552,  552,  557,  557,  552,  552,  552,
			  552,  552,  552,  557,  557,  552,  552,  552,  552,  552,

			  552,  552,  557,  557,  557,  557,  557,  557,  557,  557,
			  557,  552,  552,  552,  552,  552,  552,  552,  557,  552,
			  552,  552,  557,  557,  557,  557,  557,  552,  552,  552,
			  557,  557,  552,  557,  557,  557,  557,  557,  552,  552,
			  552,  557,  557,  557,  557,  557,  552,  557,  557,  557,
			  557,  557,  552,  557,  557,  557,  557,  552,  552,  552,
			  552,  552,  552,  552,  557,  557,  557,  557,  557,  557,
			  557,  557,  557,  552,  552,  552,  557,  552,  552,  552,
			  557,  557,  557,  552,  557,  557,  557,  552,  552,  552,
			  557,  557,  557,  552,  557,  552,  552,  552,  557,  557,

			  557,  552,  552,  552,  557,  552,  552,  552,  557,  552,
			  557,  557,  557,  557,  552,  552,  552,  552,  552,  557,
			  557,  552,  557,  557,  557,  552,  552,  557,  557,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,    0,  552,  552,  552,  552,  552,  552,  552,
			  552,  552,  552, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    1,    4,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    5,    1,    6,    7,    1,    1,    1,    8,
			    9,   10,   11,   12,   13,   14,   15,   16,   17,   18,
			   19,   19,   19,   19,   19,   19,   19,   19,   20,    1,
			   21,   22,   23,    1,    1,   24,   25,   26,   27,   28,
			   29,   30,   31,   32,   33,   34,   35,   36,   37,   38,
			   39,   40,   41,   42,   43,   44,   45,   46,   47,   48,
			   33,    1,    1,    1,    1,    1,   49,   24,   25,   26,

			   27,   28,   29,   30,   31,   32,   33,   34,   35,   36,
			   37,   38,   39,   40,   41,   42,   43,   44,   45,   46,
			   47,   48,   33,   50,    1,   51,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,

			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1, yy_Dummy>>)
		end

	yy_meta_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    2,    2,    3,    1,    1,    4,    1,
			    1,    1,    1,    1,    1,    1,    1,    3,    5,    6,
			    1,    1,    1,    1,    3,    3,    3,    3,    3,    3,
			    3,    3,    3,    3,    3,    3,    3,    3,    3,    3,
			    3,    3,    3,    3,    3,    3,    3,    7,    8,    1,
			    1,    9, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    0,    0,    6,    6,   10,   10,  145,
			  143,    1,    1,  143,    4,   37,   38,   25,   24,   35,
			   23,   31,   26,  139,   36,   29,   27,   28,  136,  136,
			  136,  136,  136,  136,  136,  136,  136,  136,  136,  136,
			  136,  136,  136,  136,  136,  136,  136,  136,  136,  136,
			  143,    9,  144,    6,    8,    7,   10,   11,   12,   13,
			    1,    0,  138,   14,   15,   16,   17,   18,   19,   20,
			   21,   22,    5,  139,   32,    0,    0,    3,    2,    0,
			   34,   30,   33,    0,  136,  136,  136,  136,   42,  136,
			  136,  136,  136,  136,  136,  136,  136,  136,  136,  136,

			  136,  136,  136,  136,  136,   62,  136,  136,  136,  136,
			  136,  136,  136,  136,  136,  136,  136,  136,   78,  136,
			   80,  136,  136,  136,  136,  136,  136,  136,  136,  136,
			  136,  136,  136,  136,  136,  136,  136,  136,  136,  136,
			  136,  136,  136,  136,  136,    0,    6,   10,    0,    0,
			    3,    2,  140,  136,  136,  136,   39,   41,  136,  136,
			  136,  136,  136,  136,  136,  136,  136,  136,  136,  136,
			  136,  136,  136,  136,  136,   57,  136,  136,  136,   61,
			  136,    0,    0,    0,    0,  136,  136,  136,  136,  136,
			  136,   69,    0,    0,  121,  136,   71,   72,  136,  136,

			   74,   75,  136,  136,    0,  136,   82,  136,  136,  136,
			  136,  136,  136,  136,  136,  136,  136,  136,  136,  136,
			  136,  136,  136,  136,  136,  136,  136,  136,  136,  136,
			  136,  136,  136,  137,    0,  142,    0,    0,  116,  136,
			    0,  136,  136,  136,   44,  136,   46,  136,  136,  136,
			  136,    0,    0,  124,  136,  136,  136,  136,  136,  136,
			  136,   54,   55,  136,    0,    0,  120,  136,  136,  136,
			  135,   63,  136,   65,  136,  136,  136,  136,  136,  136,
			    0,    0,  117,    0,    0,  118,  136,  136,  136,    0,
			   77,  136,   81,  136,    0,    0,  115,  136,  136,  136,

			  136,  136,    0,    0,  123,  136,   89,  136,  136,  136,
			  136,    0,    0,  125,  136,   91,  136,  136,  136,   94,
			   95,  136,  136,  136,  136,  136,   99,  136,    0,    0,
			    0,  127,  136,   40,    0,    0,  126,  136,  136,    0,
			    0,  128,  136,  136,   47,  136,  136,  136,    0,    0,
			  130,   50,  136,  136,    0,    0,  108,  136,  136,    0,
			  136,  136,   60,    0,    0,  102,   64,   66,  136,  136,
			  136,  136,  136,  136,  136,  136,   76,  136,    0,    0,
			  136,   84,    0,    0,  106,  136,  136,    0,    0,  129,
			    0,    0,  119,  136,  136,    0,    0,  103,    0,    0,

			  131,    0,  136,   93,  136,  136,  136,   98,  136,  100,
			  136,    0,    0,    0,  133,    0,    0,  132,   43,    0,
			    0,  134,  136,  136,  136,  136,  136,    0,    0,  104,
			  136,   53,   56,  136,   59,   67,  136,  136,    0,    0,
			  122,  136,  136,  136,  136,  136,    0,  136,  136,  136,
			  136,  136,   92,  136,  136,   96,   97,    0,    0,  114,
			    0,    0,  113,    0,   45,  136,  136,  136,  136,   52,
			   58,  136,  136,    0,    0,  109,  136,    0,    0,  110,
			  136,   73,  136,    0,  136,  136,  136,    0,    0,  107,
			  136,  136,  136,  141,  136,    0,    0,  101,   49,   51,

			   68,    0,    0,  105,  136,    0,    0,  111,   79,    0,
			  136,  136,   88,  136,    0,    0,  112,    0,    0,   48,
			   70,    0,   83,  136,  136,    0,    0,  136,   90,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			   85,    0,    0,    0,    0,    0,    0,    0,   87,    0,
			    0,   86,    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 1650
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 552
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 553
			-- Mark between normal states and templates

	yyNull_equiv_class: INTEGER is 1
			-- Equivalence code for NULL character

	yyReject_used: BOOLEAN is false
			-- Is `reject' called?

	yyVariable_trail_context: BOOLEAN is false
			-- Is there a regular expression with
			-- both leading and trailing parts having
			-- variable length?

	yyReject_or_variable_trail_context: BOOLEAN is false
			-- Is `reject' called or is there a
			-- regular expression with both leading
			-- and trailing parts having variable length?

	yyNb_rules: INTEGER is 144
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 145
			-- End of buffer rule code

	yyLine_used: BOOLEAN is true
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is false
			-- Is `position' used?

	INITIAL: INTEGER is 0
	comment: INTEGER is 1
	comment_sql: INTEGER is 2
	cond_literal_sql: INTEGER is 3
			-- Start condition codes

feature -- User-defined features



feature {NONE} -- Initialization

	make_with_file (a_file: KI_CHARACTER_INPUT_STREAM) is
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

	make_with_stdin is
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

	do_make is
			-- Create a new Xplain scanner.
		do
			make_compressed_scanner_skeleton
			create saved_state.make
		end

	execute is
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

	conditional_parse_domain (token: INTEGER) is
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

	report_error (a_message: STRING) is
			-- Print error message.
		local
		  state: XPLAIN_SCANNER_STATE
		do
			if saved_state.is_empty then
				std.error.put_string (a_message)
			else
				state := saved_state.last
				if state.filename /= Void then
					std.error.put_string (state.filename)
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

	report_warning (a_message: STRING) is
			-- Print error message.
		local
		  state: XPLAIN_SCANNER_STATE
		do
			std.error.put_string ("Warning: ")
			if saved_state.is_empty then
				std.error.put_string (a_message)
			else
				state := saved_state.last
				if state.filename /= Void then
					std.error.put_string (state.filename)
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

	pending_init: XPLAIN_TYPE
			-- set if for a type inits need to be processed

	write_pending_statement is
		do
			-- ignore
		end


feature -- Outside

	sqlgenerator: SQL_GENERATOR

	set_sqlgenerator (sqlg: SQL_GENERATOR) is
		do
			sqlgenerator := sqlg
		end


feature {NONE} -- .include/.use support

	saved_state: DS_LINKED_LIST [XPLAIN_SCANNER_STATE]

	make_relative_path (name: STRING): STRING is
			-- `name' if an absolute path, else `name' relative from
			-- currently parsed filename
		require
			name_not_empty: name /= Void and then not name.is_empty
		local
			current_dir: STRING
		do
			current_dir := saved_state.last.directory
			if current_dir = Void then
				Result := name
			else
				if name.item (1) = '/' then
					Result := name
				else
					Result := current_dir + name
				end
			end
		end

	use_mode: BOOLEAN is
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

	wrap: BOOLEAN is
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

	immediate_output_mode: BOOLEAN is
			-- True if output should be generated immediately. Until full
			-- AST building is in place, we need this trick.
		do
			Result := not use_mode and then not procedure_mode
		end


feature {NONE} -- Implementation

	my_sql: STRING

	unquote_string (s: STRING): STRING is
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
				variant
					Result.count - (i - 1)
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
				end
			end
		ensure
			unquote_string_not_void: Result /= Void
			unquote_string_not_empty: not s.is_empty implies not Result.is_empty
		end


feature {NONE} -- Preprocessor commands

	preprocessor_include is
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

	preprocessor_use is
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
