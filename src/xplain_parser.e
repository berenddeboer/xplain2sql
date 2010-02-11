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
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #16 $"


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



feature {NONE} -- Implementation

	yy_build_parser_tables is
			-- Build parser tables.
		do
			yytranslate := yytranslate_template
			yyr1 := yyr1_template
			yytypes1 := yytypes1_template
			yytypes2 := yytypes2_template
			yydefact := yydefact_template
			yydefgoto := yydefgoto_template
			yypact := yypact_template
			yypgoto := yypgoto_template
			yytable := yytable_template
			yycheck := yycheck_template
		end

	yy_create_value_stacks is
			-- Create value stacks.
		do
		end

	yy_init_value_stacks is
			-- Initialize value stacks.
		do
			yyvsp1 := -1
			yyvsp2 := -1
			yyvsp3 := -1
			yyvsp4 := -1
			yyvsp5 := -1
			yyvsp6 := -1
			yyvsp7 := -1
			yyvsp8 := -1
			yyvsp9 := -1
			yyvsp10 := -1
			yyvsp11 := -1
			yyvsp12 := -1
			yyvsp13 := -1
			yyvsp14 := -1
			yyvsp15 := -1
			yyvsp16 := -1
			yyvsp17 := -1
			yyvsp18 := -1
			yyvsp19 := -1
			yyvsp20 := -1
			yyvsp21 := -1
			yyvsp22 := -1
			yyvsp23 := -1
			yyvsp24 := -1
			yyvsp25 := -1
			yyvsp26 := -1
			yyvsp27 := -1
			yyvsp28 := -1
			yyvsp29 := -1
			yyvsp30 := -1
			yyvsp31 := -1
			yyvsp32 := -1
			yyvsp33 := -1
			yyvsp34 := -1
			yyvsp35 := -1
			yyvsp36 := -1
			yyvsp37 := -1
			yyvsp38 := -1
			yyvsp39 := -1
			yyvsp40 := -1
			yyvsp41 := -1
			yyvsp42 := -1
			yyvsp43 := -1
			yyvsp44 := -1
			yyvsp45 := -1
			yyvsp46 := -1
		end

	yy_clear_value_stacks is
			-- Clear objects in semantic value stacks so that
			-- they can be collected by the garbage collector.
		do
			if yyvs1 /= Void then
				yyvs1.clear_all
			end
			if yyvs2 /= Void then
				yyvs2.clear_all
			end
			if yyvs3 /= Void then
				yyvs3.clear_all
			end
			if yyvs4 /= Void then
				yyvs4.clear_all
			end
			if yyvs5 /= Void then
				yyvs5.clear_all
			end
			if yyvs6 /= Void then
				yyvs6.clear_all
			end
			if yyvs7 /= Void then
				yyvs7.clear_all
			end
			if yyvs8 /= Void then
				yyvs8.clear_all
			end
			if yyvs9 /= Void then
				yyvs9.clear_all
			end
			if yyvs10 /= Void then
				yyvs10.clear_all
			end
			if yyvs11 /= Void then
				yyvs11.clear_all
			end
			if yyvs12 /= Void then
				yyvs12.clear_all
			end
			if yyvs13 /= Void then
				yyvs13.clear_all
			end
			if yyvs14 /= Void then
				yyvs14.clear_all
			end
			if yyvs15 /= Void then
				yyvs15.clear_all
			end
			if yyvs16 /= Void then
				yyvs16.clear_all
			end
			if yyvs17 /= Void then
				yyvs17.clear_all
			end
			if yyvs18 /= Void then
				yyvs18.clear_all
			end
			if yyvs19 /= Void then
				yyvs19.clear_all
			end
			if yyvs20 /= Void then
				yyvs20.clear_all
			end
			if yyvs21 /= Void then
				yyvs21.clear_all
			end
			if yyvs22 /= Void then
				yyvs22.clear_all
			end
			if yyvs23 /= Void then
				yyvs23.clear_all
			end
			if yyvs24 /= Void then
				yyvs24.clear_all
			end
			if yyvs25 /= Void then
				yyvs25.clear_all
			end
			if yyvs26 /= Void then
				yyvs26.clear_all
			end
			if yyvs27 /= Void then
				yyvs27.clear_all
			end
			if yyvs28 /= Void then
				yyvs28.clear_all
			end
			if yyvs29 /= Void then
				yyvs29.clear_all
			end
			if yyvs30 /= Void then
				yyvs30.clear_all
			end
			if yyvs31 /= Void then
				yyvs31.clear_all
			end
			if yyvs32 /= Void then
				yyvs32.clear_all
			end
			if yyvs33 /= Void then
				yyvs33.clear_all
			end
			if yyvs34 /= Void then
				yyvs34.clear_all
			end
			if yyvs35 /= Void then
				yyvs35.clear_all
			end
			if yyvs36 /= Void then
				yyvs36.clear_all
			end
			if yyvs37 /= Void then
				yyvs37.clear_all
			end
			if yyvs38 /= Void then
				yyvs38.clear_all
			end
			if yyvs39 /= Void then
				yyvs39.clear_all
			end
			if yyvs40 /= Void then
				yyvs40.clear_all
			end
			if yyvs41 /= Void then
				yyvs41.clear_all
			end
			if yyvs42 /= Void then
				yyvs42.clear_all
			end
			if yyvs43 /= Void then
				yyvs43.clear_all
			end
			if yyvs44 /= Void then
				yyvs44.clear_all
			end
			if yyvs45 /= Void then
				yyvs45.clear_all
			end
			if yyvs46 /= Void then
				yyvs46.clear_all
			end
		end

	yy_push_last_value (yychar1: INTEGER) is
			-- Push semantic value associated with token `last_token'
			-- (with internal id `yychar1') on top of corresponding
			-- value stack.
		do
			inspect yytypes2.item (yychar1)
			when 1 then
				yyvsp1 := yyvsp1 + 1
				if yyvsp1 >= yyvsc1 then
					if yyvs1 = Void then
						debug ("GEYACC")
							std.error.put_line ("Create yyvs1")
						end
						create yyspecial_routines1
						yyvsc1 := yyInitial_yyvs_size
						yyvs1 := yyspecial_routines1.make (yyvsc1)
					else
						debug ("GEYACC")
							std.error.put_line ("Resize yyvs1")
						end
						yyvsc1 := yyvsc1 + yyInitial_yyvs_size
						yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
					end
				end
				yyvs1.put (last_any_value, yyvsp1)
			when 2 then
				yyvsp2 := yyvsp2 + 1
				if yyvsp2 >= yyvsc2 then
					if yyvs2 = Void then
						debug ("GEYACC")
							std.error.put_line ("Create yyvs2")
						end
						create yyspecial_routines2
						yyvsc2 := yyInitial_yyvs_size
						yyvs2 := yyspecial_routines2.make (yyvsc2)
					else
						debug ("GEYACC")
							std.error.put_line ("Resize yyvs2")
						end
						yyvsc2 := yyvsc2 + yyInitial_yyvs_size
						yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
					end
				end
				yyvs2.put (last_string_value, yyvsp2)
			when 3 then
				yyvsp3 := yyvsp3 + 1
				if yyvsp3 >= yyvsc3 then
					if yyvs3 = Void then
						debug ("GEYACC")
							std.error.put_line ("Create yyvs3")
						end
						create yyspecial_routines3
						yyvsc3 := yyInitial_yyvs_size
						yyvs3 := yyspecial_routines3.make (yyvsc3)
					else
						debug ("GEYACC")
							std.error.put_line ("Resize yyvs3")
						end
						yyvsc3 := yyvsc3 + yyInitial_yyvs_size
						yyvs3 := yyspecial_routines3.resize (yyvs3, yyvsc3)
					end
				end
				yyvs3.put (last_integer_value, yyvsp3)
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: not a token type: ")
					std.error.put_integer (yytypes2.item (yychar1))
					std.error.put_new_line
				end
				abort
			end
		end

	yy_push_error_value is
			-- Push semantic value associated with token 'error'
			-- on top of corresponding value stack.
		local
			yyval1: ANY
		do
			yyvsp1 := yyvsp1 + 1
			if yyvsp1 >= yyvsc1 then
				if yyvs1 = Void then
					debug ("GEYACC")
						std.error.put_line ("Create yyvs1")
					end
					create yyspecial_routines1
					yyvsc1 := yyInitial_yyvs_size
					yyvs1 := yyspecial_routines1.make (yyvsc1)
				else
					debug ("GEYACC")
						std.error.put_line ("Resize yyvs1")
					end
					yyvsc1 := yyvsc1 + yyInitial_yyvs_size
					yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
				end
			end
			yyvs1.put (yyval1, yyvsp1)
		end

	yy_pop_last_value (yystate: INTEGER) is
			-- Pop semantic value from stack when in state `yystate'.
		local
			yy_type_id: INTEGER
		do
			yy_type_id := yytypes1.item (yystate)
			inspect yy_type_id
			when 1 then
				yyvsp1 := yyvsp1 - 1
			when 2 then
				yyvsp2 := yyvsp2 - 1
			when 3 then
				yyvsp3 := yyvsp3 - 1
			when 4 then
				yyvsp4 := yyvsp4 - 1
			when 5 then
				yyvsp5 := yyvsp5 - 1
			when 6 then
				yyvsp6 := yyvsp6 - 1
			when 7 then
				yyvsp7 := yyvsp7 - 1
			when 8 then
				yyvsp8 := yyvsp8 - 1
			when 9 then
				yyvsp9 := yyvsp9 - 1
			when 10 then
				yyvsp10 := yyvsp10 - 1
			when 11 then
				yyvsp11 := yyvsp11 - 1
			when 12 then
				yyvsp12 := yyvsp12 - 1
			when 13 then
				yyvsp13 := yyvsp13 - 1
			when 14 then
				yyvsp14 := yyvsp14 - 1
			when 15 then
				yyvsp15 := yyvsp15 - 1
			when 16 then
				yyvsp16 := yyvsp16 - 1
			when 17 then
				yyvsp17 := yyvsp17 - 1
			when 18 then
				yyvsp18 := yyvsp18 - 1
			when 19 then
				yyvsp19 := yyvsp19 - 1
			when 20 then
				yyvsp20 := yyvsp20 - 1
			when 21 then
				yyvsp21 := yyvsp21 - 1
			when 22 then
				yyvsp22 := yyvsp22 - 1
			when 23 then
				yyvsp23 := yyvsp23 - 1
			when 24 then
				yyvsp24 := yyvsp24 - 1
			when 25 then
				yyvsp25 := yyvsp25 - 1
			when 26 then
				yyvsp26 := yyvsp26 - 1
			when 27 then
				yyvsp27 := yyvsp27 - 1
			when 28 then
				yyvsp28 := yyvsp28 - 1
			when 29 then
				yyvsp29 := yyvsp29 - 1
			when 30 then
				yyvsp30 := yyvsp30 - 1
			when 31 then
				yyvsp31 := yyvsp31 - 1
			when 32 then
				yyvsp32 := yyvsp32 - 1
			when 33 then
				yyvsp33 := yyvsp33 - 1
			when 34 then
				yyvsp34 := yyvsp34 - 1
			when 35 then
				yyvsp35 := yyvsp35 - 1
			when 36 then
				yyvsp36 := yyvsp36 - 1
			when 37 then
				yyvsp37 := yyvsp37 - 1
			when 38 then
				yyvsp38 := yyvsp38 - 1
			when 39 then
				yyvsp39 := yyvsp39 - 1
			when 40 then
				yyvsp40 := yyvsp40 - 1
			when 41 then
				yyvsp41 := yyvsp41 - 1
			when 42 then
				yyvsp42 := yyvsp42 - 1
			when 43 then
				yyvsp43 := yyvsp43 - 1
			when 44 then
				yyvsp44 := yyvsp44 - 1
			when 45 then
				yyvsp45 := yyvsp45 - 1
			when 46 then
				yyvsp46 := yyvsp46 - 1
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: unknown type id: ")
					std.error.put_integer (yy_type_id)
					std.error.put_new_line
				end
				abort
			end
		end

feature {NONE} -- Semantic actions

	yy_do_action (yy_act: INTEGER) is
			-- Execute semantic action.
		local
			yyval1: ANY
			yyval2: STRING
			yyval33: XPLAIN_STATEMENT
			yyval35: XPLAIN_CONSTANT_ASSIGNMENT_STATEMENT
			yyval4: XPLAIN_BASE
			yyval43: XPLAIN_TYPE_STATEMENT
			yyval34: XPLAIN_CONSTANT_STATEMENT
			yyval5: XPLAIN_DOMAIN_RESTRICTION
			yyval6: XPLAIN_A_NODE
			yyval7: XPLAIN_I_NODE
			yyval8: XPLAIN_LOGICAL_EXPRESSION
			yyval9: XPLAIN_EXPRESSION
			yyval10: XPLAIN_LOGICAL_VALUE_EXPRESSION
			yyval11: XPLAIN_SYSTEM_EXPRESSION
			yyval12: XPLAIN_ATTRIBUTE_NAME_NODE
			yyval13: XPLAIN_ATTRIBUTE_NAME
			yyval14: XPLAIN_TYPE
			yyval15: XPLAIN_REPRESENTATION
			yyval16: XPLAIN_PK_REPRESENTATION
			yyval17: XPLAIN_ATTRIBUTE_NODE
			yyval18: XPLAIN_ATTRIBUTE
			yyval3: INTEGER
			yyval19: XPLAIN_ASSERTION
			yyval20: XPLAIN_ASSIGNMENT_NODE
			yyval21: XPLAIN_ASSIGNMENT
			yyval36: XPLAIN_CASCADE_STATEMENT
			yyval37: XPLAIN_CASCADE_FUNCTION_EXPRESSION
			yyval38: XPLAIN_DELETE_STATEMENT
			yyval22: XPLAIN_SUBJECT
			yyval44: XPLAIN_UPDATE_STATEMENT
			yyval45: XPLAIN_VALUE_STATEMENT
			yyval46: XPLAIN_VALUE_SELECTION_STATEMENT
			yyval23: XPLAIN_SELECTION_FUNCTION
			yyval40: XPLAIN_GET_STATEMENT
			yyval39: XPLAIN_EXTEND_STATEMENT
			yyval24: XPLAIN_EXTENSION
			yyval25: XPLAIN_EXTEND_ATTRIBUTE
			yyval26: XPLAIN_EXTENSION_EXPRESSION
			yyval27: XPLAIN_SELECTION
			yyval28: XPLAIN_SELECTION_LIST
			yyval29: XPLAIN_SORT_NODE
			yyval30: XPLAIN_FUNCTION
			yyval31: XPLAIN_EXPRESSION_NODE
			yyval41: XPLAIN_PROCEDURE_STATEMENT
			yyval32: XPLAIN_STATEMENT_NODE
			yyval42: XPLAIN_SQL_STATEMENT
		do
			inspect yy_act
when 1 then
--|#line 278 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 278")
end

			write_pending_statement
			sqlgenerator.write_end (yyvs2.item (yyvsp2))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 2 then
--|#line 283 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 283")
end

			report_error ("Additional end detected after parsing the end belonging to the database command.")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp1 := yyvsp1 -4
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 3 then
--|#line 288 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 288")
end

			report_error ("Additional input after end of database.: " + text)
			abort
			
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 4 then
--|#line 293 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 293")
end

			report_error ("Script should start with the 'database' command instead of: " + text)
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 5 then
--|#line 301 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 301")
end

			sqlgenerator.write_use_database (yyvs2.item (yyvsp2))
			yyval2 := yyvs2.item (yyvsp2)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs2.put (yyval2, yyvsp2)
end
when 6 then
--|#line 309 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 309")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 7 then
--|#line 314 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 314")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 8 then
--|#line 315 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 315")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 9 then
--|#line 319 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 319")
end

			if not use_mode then
				if yyvs33.item (yyvsp33) /= Void then -- because statement support is partial at the moment
					statements.add (yyvs33.item (yyvsp33))
				end
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp33 := yyvsp33 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 10 then
--|#line 327 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 327")
end

statements.add (yyvs42.item (yyvsp42)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp42 := yyvsp42 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 11 then
--|#line 329 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 329")
end

statements.add (yyvs42.item (yyvsp42)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp42 := yyvsp42 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 12 then
--|#line 331 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 331")
end

			if not use_mode then
				if yyvs33.item (yyvsp33) /= Void then -- because statement support is partial at the moment
					statements.add (yyvs33.item (yyvsp33))
				end
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp33 := yyvsp33 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 13 then
--|#line 339 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 339")
end

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
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 14 then
--|#line 355 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 355")
end

yyval33 := yyvs33.item (yyvsp33) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs33.put (yyval33, yyvsp33)
end
when 15 then
--|#line 357 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 357")
end

yyval33 := yyvs33.item (yyvsp33) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs33.put (yyval33, yyvsp33)
end
when 16 then
--|#line 359 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 359")
end

yyval33 := yyvs41.item (yyvsp41) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp41 := yyvsp41 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 17 then
--|#line 369 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 369")
end

yyval33 := yyvs33.item (yyvsp33) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs33.put (yyval33, yyvsp33)
end
when 18 then
--|#line 371 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 371")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 19 then
--|#line 372 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 372")
end

yyval33 := yyvs35.item (yyvsp35) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp35 := yyvsp35 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 20 then
--|#line 377 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 377")
end

yyval33 := yyvs43.item (yyvsp43) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp43 := yyvsp43 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 21 then
--|#line 379 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 379")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp4 := yyvsp4 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 22 then
--|#line 380 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 380")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 23 then
--|#line 381 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 381")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 24 then
--|#line 382 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 382")
end

yyval33 := yyvs34.item (yyvsp34) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp34 := yyvsp34 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 25 then
--|#line 385 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 385")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp19 := yyvsp19 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 26 then
--|#line 386 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 386")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 27 then
--|#line 388 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 388")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 28 then
--|#line 392 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 392")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 29 then
--|#line 393 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 393")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 30 then
--|#line 397 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 397")
end

write_pending_statement
			myvariable := universe.find_variable(yyvs2.item (yyvsp2))
			if myvariable = Void then
				report_error ("Not a valid variable: " + yyvs2.item (yyvsp2))
				abort
			else
				if not use_mode then
					sqlgenerator.write_constant_assignment (myvariable, yyvs9.item (yyvsp9))
				end
				myvariable.set_value (yyvs9.item (yyvsp9))
			end
			create yyval35.make (myvariable, yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp35 := yyvsp35 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -3
	yyvsp9 := yyvsp9 -1
	if yyvsp35 >= yyvsc35 then
		if yyvs35 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs35")
			end
			create yyspecial_routines35
			yyvsc35 := yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.make (yyvsc35)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs35")
			end
			yyvsc35 := yyvsc35 + yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.resize (yyvs35, yyvsc35)
		end
	end
	yyvs35.put (yyval35, yyvsp35)
end
when 31 then
--|#line 411 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 411")
end

			report_error ("A constant assignment expression should be surrounded by parentheses")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp35 := yyvsp35 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	if yyvsp35 >= yyvsc35 then
		if yyvs35 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs35")
			end
			create yyspecial_routines35
			yyvsc35 := yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.make (yyvsc35)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs35")
			end
			yyvsc35 := yyvsc35 + yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.resize (yyvs35, yyvsc35)
		end
	end
	yyvs35.put (yyval35, yyvsp35)
end
when 32 then
--|#line 421 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 421")
end

		write_pending_statement
		if yyvs15.item (yyvsp15).domain.is_equal ("(B)") then
			create {XPLAIN_B_RESTRICTION} dummyrestriction.make (False)
		else
			create {XPLAIN_REQUIRED} dummyrestriction.make (False)
		end
		yyvs15.item (yyvsp15).set_domain_restriction (sqlgenerator, dummyrestriction)
		create {XPLAIN_BASE} yyval4.make (yyvs2.item (yyvsp2), yyvs15.item (yyvsp15))
		if not use_mode then
			sqlgenerator.write_base(yyval4)
		end
		universe.add(yyval4)
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp4 := yyvsp4 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	yyvsp15 := yyvsp15 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 33 then
--|#line 436 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 436")
end

		write_pending_statement
		if yyvs15.item (yyvsp15).domain.is_equal ("(B)") then
			create {XPLAIN_B_RESTRICTION} dummyrestriction.make (True)
		else
			create {XPLAIN_REQUIRED} dummyrestriction.make (True)
		end
		yyvs15.item (yyvsp15).set_domain_restriction (sqlgenerator, dummyrestriction)
		create {XPLAIN_BASE} yyval4.make (yyvs2.item (yyvsp2), yyvs15.item (yyvsp15))
		if not use_mode then
			sqlgenerator.write_base(yyval4)
		end
		universe.add(yyval4)
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp4 := yyvsp4 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp2 := yyvsp2 -1
	yyvsp15 := yyvsp15 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 34 then
--|#line 451 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 451")
end

write_pending_statement
		yyvs15.item (yyvsp15).set_domain_restriction (sqlgenerator, yyvs5.item (yyvsp5))
		create {XPLAIN_BASE} yyval4.make (yyvs2.item (yyvsp2), yyvs15.item (yyvsp15))
		if not use_mode then
			sqlgenerator.write_base(yyval4)
		end
		universe.add (yyval4)
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp4 := yyvsp4 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	yyvsp15 := yyvsp15 -1
	yyvsp5 := yyvsp5 -1
	if yyvsp4 >= yyvsc4 then
		if yyvs4 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs4")
			end
			create yyspecial_routines4
			yyvsc4 := yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.make (yyvsc4)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs4")
			end
			yyvsc4 := yyvsc4 + yyInitial_yyvs_size
			yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
		end
	end
	yyvs4.put (yyval4, yyvsp4)
end
when 35 then
--|#line 463 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 463")
end

			write_pending_statement
			create mytype.make (yyvs2.item (yyvsp2), yyvs16.item (yyvsp16), yyvs17.item (yyvsp17))
			universe.add (mytype)
			pending_type := mytype
			create yyval43.make (mytype)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp43 := yyvsp43 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp2 := yyvsp2 -1
	yyvsp16 := yyvsp16 -1
	yyvsp17 := yyvsp17 -1
	if yyvsp43 >= yyvsc43 then
		if yyvs43 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs43")
			end
			create yyspecial_routines43
			yyvsc43 := yyInitial_yyvs_size
			yyvs43 := yyspecial_routines43.make (yyvsc43)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs43")
			end
			yyvsc43 := yyvsc43 + yyInitial_yyvs_size
			yyvs43 := yyspecial_routines43.resize (yyvs43, yyvsc43)
		end
	end
	yyvs43.put (yyval43, yyvsp43)
end
when 36 then
--|#line 474 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 474")
end

			if pending_init /= yyvs14.item (yyvsp14) then
				write_pending_init
			end
			if yyvs14.item (yyvsp14) /= Void then
				pending_init := yyvs14.item (yyvsp14)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp14 := yyvsp14 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 37 then
--|#line 474 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 474")
end

is_init_default := False 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 38 then
--|#line 488 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 488")
end

			if pending_init /= yyvs14.item (yyvsp14) then
				write_pending_init
			end
			if yyvs14.item (yyvsp14) /= Void then
				pending_init := yyvs14.item (yyvsp14)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -2
	yyvsp14 := yyvsp14 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 39 then
--|#line 488 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 488")
end

is_init_default := True 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 40 then
--|#line 502 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 502")
end

			write_pending_statement
			create {XPLAIN_REQUIRED} dummyrestriction.make (False)
			yyvs15.item (yyvsp15).set_domain_restriction (sqlgenerator, dummyrestriction)
			create myvariable.make (yyvs2.item (yyvsp2), yyvs15.item (yyvsp15))
			if not use_mode then
				sqlgenerator.write_constant (myvariable)
			end
			universe.add(myvariable)
			create yyval34.make (myvariable)
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp34 := yyvsp34 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	yyvsp15 := yyvsp15 -1
	if yyvsp34 >= yyvsc34 then
		if yyvs34 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs34")
			end
			create yyspecial_routines34
			yyvsc34 := yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.make (yyvsc34)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs34")
			end
			yyvsc34 := yyvsc34 + yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.resize (yyvs34, yyvsc34)
		end
	end
	yyvs34.put (yyval34, yyvsp34)
end
when 41 then
--|#line 516 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 516")
end

write_pending_statement
		myobject := get_known_object (yyvs2.item (yyvsp2))
		if myobject /= Void then
			if immediate_output_mode then
				sqlgenerator.write_drop (myobject)
			end
			universe.delete (myobject)
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 42 then
--|#line 529 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 529")
end

			write_pending_statement
			myattribute := subject_type.find_attribute (yyvs13.item (yyvsp13))
			if myattribute = Void then
				error_unknown_attribute (yyvs2.item (yyvsp2), yyvs13.item (yyvsp13))
			else
				if immediate_output_mode then
					subject_type.write_drop_attribute	(sqlgenerator, myattribute)
				end
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp1 := yyvsp1 -2
	yyvsp2 := yyvsp2 -1
	yyvsp13 := yyvsp13 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 43 then
--|#line 529 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 529")
end

subject_type := get_known_type (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 44 then
--|#line 542 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 542")
end

report_warning ("Purging of inits is not yet supported.") 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	yyvsp13 := yyvsp13 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 45 then
--|#line 542 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 542")
end

subject_type := get_known_type (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 46 then
--|#line 549 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 549")
end

yyval5 := yyvs5.item (yyvsp5) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs5.put (yyval5, yyvsp5)
end
when 47 then
--|#line 551 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 551")
end

create {XPLAIN_A_PATTERN} yyval5.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp5 := yyvsp5 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp5 >= yyvsc5 then
		if yyvs5 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs5")
			end
			create yyspecial_routines5
			yyvsc5 := yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.make (yyvsc5)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs5")
			end
			yyvsc5 := yyvsc5 + yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.resize (yyvs5, yyvsc5)
		end
	end
	yyvs5.put (yyval5, yyvsp5)
end
when 48 then
--|#line 553 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 553")
end

yyval5 := yyvs5.item (yyvsp5) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs5.put (yyval5, yyvsp5)
end
when 49 then
--|#line 555 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 555")
end

			report_error ("Domain restriction not supported for this data type or error in domain restriction definition.")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp5 := yyvsp5 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp5 >= yyvsc5 then
		if yyvs5 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs5")
			end
			create yyspecial_routines5
			yyvsc5 := yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.make (yyvsc5)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs5")
			end
			yyvsc5 := yyvsc5 + yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.resize (yyvs5, yyvsc5)
		end
	end
	yyvs5.put (yyval5, yyvsp5)
end
when 50 then
--|#line 563 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 563")
end

create {XPLAIN_A_ENUMERATION} yyval5.make (yyvs6.item (yyvsp6)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp5 := yyvsp5 + 1
	yyvsp6 := yyvsp6 -1
	if yyvsp5 >= yyvsc5 then
		if yyvs5 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs5")
			end
			create yyspecial_routines5
			yyvsc5 := yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.make (yyvsc5)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs5")
			end
			yyvsc5 := yyvsc5 + yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.resize (yyvs5, yyvsc5)
		end
	end
	yyvs5.put (yyval5, yyvsp5)
end
when 51 then
--|#line 565 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 565")
end

create {XPLAIN_I_ENUMERATION} yyval5.make (yyvs7.item (yyvsp7)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp5 := yyvsp5 + 1
	yyvsp7 := yyvsp7 -1
	if yyvsp5 >= yyvsc5 then
		if yyvs5 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs5")
			end
			create yyspecial_routines5
			yyvsc5 := yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.make (yyvsc5)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs5")
			end
			yyvsc5 := yyvsc5 + yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.resize (yyvs5, yyvsc5)
		end
	end
	yyvs5.put (yyval5, yyvsp5)
end
when 52 then
--|#line 570 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 570")
end

create {XPLAIN_A_NODE} yyval6.make (yyvs2.item (yyvsp2), void) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp6 := yyvsp6 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp6 >= yyvsc6 then
		if yyvs6 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs6")
			end
			create yyspecial_routines6
			yyvsc6 := yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.make (yyvsc6)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs6")
			end
			yyvsc6 := yyvsc6 + yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.resize (yyvs6, yyvsc6)
		end
	end
	yyvs6.put (yyval6, yyvsp6)
end
when 53 then
--|#line 572 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 572")
end

create {XPLAIN_A_NODE} yyval6.make (yyvs2.item (yyvsp2), yyvs6.item (yyvsp6)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -1
	yyvs6.put (yyval6, yyvsp6)
end
when 54 then
--|#line 577 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 577")
end

create {XPLAIN_I_NODE} yyval7.make (yyvs3.item (yyvsp3), Void) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp7 := yyvsp7 + 1
	yyvsp3 := yyvsp3 -1
	if yyvsp7 >= yyvsc7 then
		if yyvs7 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs7")
			end
			create yyspecial_routines7
			yyvsc7 := yyInitial_yyvs_size
			yyvs7 := yyspecial_routines7.make (yyvsc7)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs7")
			end
			yyvsc7 := yyvsc7 + yyInitial_yyvs_size
			yyvs7 := yyspecial_routines7.resize (yyvs7, yyvsc7)
		end
	end
	yyvs7.put (yyval7, yyvsp7)
end
when 55 then
--|#line 579 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 579")
end

create {XPLAIN_I_NODE} yyval7.make (yyvs3.item (yyvsp3), yyvs7.item (yyvsp7)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp3 := yyvsp3 -1
	yyvsp1 := yyvsp1 -1
	yyvs7.put (yyval7, yyvsp7)
end
when 56 then
--|#line 581 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 581")
end

			report_error ("An integer enumeration cannot contain a %"..%". If you want to specify a trajectory, the format should be (I2) (1..*) for example.")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp7 := yyvsp7 + 1
	yyvsp3 := yyvsp3 -1
	yyvsp1 := yyvsp1 -2
	if yyvsp7 >= yyvsc7 then
		if yyvs7 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs7")
			end
			create yyspecial_routines7
			yyvsc7 := yyInitial_yyvs_size
			yyvs7 := yyspecial_routines7.make (yyvsc7)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs7")
			end
			yyvsc7 := yyvsc7 + yyInitial_yyvs_size
			yyvs7 := yyspecial_routines7.resize (yyvs7, yyvsc7)
		end
	end
	yyvs7.put (yyval7, yyvsp7)
end
when 57 then
--|#line 589 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 589")
end

			if yyvs2.item (yyvsp2 - 1).is_integer and then yyvs2.item (yyvsp2).is_integer then
				if yyvs2.item (yyvsp2 - 1).to_integer > yyvs2.item (yyvsp2).to_integer then
					report_error ("Trajectory's lower value " + yyvs2.item (yyvsp2 - 1) + " is more than the upper value " + yyvs2.item (yyvsp2) + ".")
					abort
				end
			end
			create {XPLAIN_TRAJECTORY} yyval5.make (yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp5 := yyvsp5 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -2
	if yyvsp5 >= yyvsc5 then
		if yyvs5 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs5")
			end
			create yyspecial_routines5
			yyvsc5 := yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.make (yyvsc5)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs5")
			end
			yyvsc5 := yyvsc5 + yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.resize (yyvs5, yyvsc5)
		end
	end
	yyvs5.put (yyval5, yyvsp5)
end
when 58 then
--|#line 602 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 602")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 59 then
--|#line 604 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 604")
end

			create yyval2.make_filled ('9', last_width)
			yyval2.insert_character ('-', 1)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 60 then
--|#line 612 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 612")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 61 then
--|#line 614 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 614")
end

create yyval2.make_filled ('9', last_width) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 62 then
--|#line 619 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 619")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 63 then
--|#line 623 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 623")
end

yyval2 := "+" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 64 then
--|#line 625 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 625")
end

yyval2 := "-" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 65 then
--|#line 629 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 629")
end

yyval2 := "*" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 66 then
--|#line 631 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 631")
end

yyval2 := "/" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 67 then
--|#line 633 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 633")
end

yyval2 := "%%" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 68 then
--|#line 638 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 638")
end

		  create {XPLAIN_LOGICAL_INFIX_EXPRESSION} dummye.make (yyvs9.item (yyvsp9), once "or", yyvs8.item (yyvsp8))
		  create yyval8.make (dummye)
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -1
	yyvs8.put (yyval8, yyvsp8)
end
when 69 then
--|#line 643 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 643")
end

			create yyval8.make (yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp8 := yyvsp8 + 1
	yyvsp9 := yyvsp9 -1
	if yyvsp8 >= yyvsc8 then
		if yyvs8 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs8")
			end
			create yyspecial_routines8
			yyvsc8 := yyInitial_yyvs_size
			yyvs8 := yyspecial_routines8.make (yyvsc8)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs8")
			end
			yyvsc8 := yyvsc8 + yyInitial_yyvs_size
			yyvs8 := yyspecial_routines8.resize (yyvs8, yyvsc8)
		end
	end
	yyvs8.put (yyval8, yyvsp8)
end
when 70 then
--|#line 650 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 650")
end

create {XPLAIN_LOGICAL_INFIX_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9 - 1), once "and", yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 71 then
--|#line 652 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 652")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs9.put (yyval9, yyvsp9)
end
when 72 then
--|#line 662 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 662")
end

			if subject_type /= Void then
				myobject := get_object_if_valid_tree (yyvs12.item (yyvsp12))
				if myobject /= Void then
					-- the last object in the tree knows what expression to build here
					dummye := last_object_in_tree.create_expression (yyvs12.item (yyvsp12))
					if dummye.is_logical_expression then
						create {XPLAIN_NOTNOT_EXPRESSION} yyval9.make (dummye)
					else
						yyval9 := dummye
					end
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
			end
			
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 73 then
--|#line 680 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 680")
end

			if subject_type /= Void then
				myobject := get_object_if_valid_tree (yyvs12.item (yyvsp12))
				if myobject /= Void then
					-- the last object in the tree knows what expression to build here
					dummye := last_object_in_tree.create_expression (yyvs12.item (yyvsp12))
					create {XPLAIN_NOT_EXPRESSION} yyval9.make (dummye)
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
			end

		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 74 then
--|#line 695 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 695")
end

			if is_parameter_declared (yyvs13.item (yyvsp13)) then
				create {XPLAIN_PARAMETER_EXPRESSION} yyval9.make (yyvs13.item (yyvsp13))
			end
			
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp13 := yyvsp13 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 75 then
--|#line 701 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 701")
end

			if is_parameter_declared (yyvs13.item (yyvsp13)) then
				create {XPLAIN_PARAMETER_EXPRESSION} yyval9.make (yyvs13.item (yyvsp13))
				create {XPLAIN_NOT_EXPRESSION} yyval9.make (yyval9)
			end
			
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp13 := yyvsp13 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 76 then
--|#line 708 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 708")
end

create {XPLAIN_EQ_NULL_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 77 then
--|#line 710 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 710")
end

create {XPLAIN_NE_NULL_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 78 then
--|#line 712 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 712")
end

			yyval9 := new_logical_infix_expression (yyvs9.item (yyvsp9 - 1), yyvs2.item (yyvsp2), yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp2 := yyvsp2 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 79 then
--|#line 716 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 716")
end

			dummye := new_logical_infix_expression (yyvs9.item (yyvsp9 - 1), yyvs2.item (yyvsp2), yyvs9.item (yyvsp9))
			create {XPLAIN_NOT_EXPRESSION} yyval9.make (dummye)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 80 then
--|#line 721 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 721")
end

create {XPLAIN_PARENTHESIS_EXPRESSION} yyval9.make (yyvs8.item (yyvsp8)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp8 := yyvsp8 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 81 then
--|#line 723 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 723")
end

create {XPLAIN_PARENTHESIS_EXPRESSION} yyval9.make (yyvs8.item (yyvsp8))
		  create {XPLAIN_NOT_EXPRESSION} yyval9.make (yyval9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 82 then
--|#line 726 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 726")
end

yyval9 := yyvs10.item (yyvsp10) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp10 := yyvsp10 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 83 then
--|#line 728 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 728")
end

create {XPLAIN_NOT_EXPRESSION} yyval9.make (yyvs10.item (yyvsp10)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp10 := yyvsp10 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 84 then
--|#line 732 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 732")
end

yyval2 := "<" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 85 then
--|#line 734 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 734")
end

yyval2 := "<=" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 86 then
--|#line 736 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 736")
end

yyval2 := ">" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 87 then
--|#line 738 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 738")
end

yyval2 := ">=" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 88 then
--|#line 740 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 740")
end

yyval2 := "=" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 89 then
--|#line 742 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 742")
end

yyval2 := "<>" 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 90 then
--|#line 747 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 747")
end

create {XPLAIN_LOGICAL_VALUE_EXPRESSION} yyval10.make (True) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp10 := yyvsp10 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp10 >= yyvsc10 then
		if yyvs10 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs10")
			end
			create yyspecial_routines10
			yyvsc10 := yyInitial_yyvs_size
			yyvs10 := yyspecial_routines10.make (yyvsc10)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs10")
			end
			yyvsc10 := yyvsc10 + yyInitial_yyvs_size
			yyvs10 := yyspecial_routines10.resize (yyvs10, yyvsc10)
		end
	end
	yyvs10.put (yyval10, yyvsp10)
end
when 91 then
--|#line 749 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 749")
end

create {XPLAIN_LOGICAL_VALUE_EXPRESSION} yyval10.make (False) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp10 := yyvsp10 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp10 >= yyvsc10 then
		if yyvs10 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs10")
			end
			create yyspecial_routines10
			yyvsc10 := yyInitial_yyvs_size
			yyvs10 := yyspecial_routines10.make (yyvsc10)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs10")
			end
			yyvsc10 := yyvsc10 + yyInitial_yyvs_size
			yyvs10 := yyspecial_routines10.resize (yyvs10, yyvsc10)
		end
	end
	yyvs10.put (yyval10, yyvsp10)
end
when 92 then
--|#line 754 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 754")
end

create {XPLAIN_SYSTEMDATE_EXPRESSION} yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp11 := yyvsp11 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp11 >= yyvsc11 then
		if yyvs11 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs11")
			end
			create yyspecial_routines11
			yyvsc11 := yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.make (yyvsc11)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs11")
			end
			yyvsc11 := yyvsc11 + yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.resize (yyvs11, yyvsc11)
		end
	end
	yyvs11.put (yyval11, yyvsp11)
end
when 93 then
--|#line 756 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 756")
end

create {XPLAIN_LOGINNAME_EXPRESSION}yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp11 := yyvsp11 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp11 >= yyvsc11 then
		if yyvs11 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs11")
			end
			create yyspecial_routines11
			yyvsc11 := yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.make (yyvsc11)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs11")
			end
			yyvsc11 := yyvsc11 + yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.resize (yyvs11, yyvsc11)
		end
	end
	yyvs11.put (yyval11, yyvsp11)
end
when 94 then
--|#line 761 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 761")
end

create {XPLAIN_INFIX_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9 - 1), yyvs2.item (yyvsp2), yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp2 := yyvsp2 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 95 then
--|#line 763 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 763")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs9.put (yyval9, yyvsp9)
end
when 96 then
--|#line 765 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 765")
end

create {XPLAIN_IF_EXPRESSION} yyval9.make (yyvs8.item (yyvsp8), yyvs9.item (yyvsp9 - 1), yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 97 then
--|#line 770 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 770")
end

create {XPLAIN_INFIX_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9 - 1), yyvs2.item (yyvsp2), yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp2 := yyvsp2 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 98 then
--|#line 772 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 772")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs9.put (yyval9, yyvsp9)
end
when 99 then
--|#line 777 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 777")
end

			-- we have something here that can be an
			-- attribute/extension/value/variable.
			-- let's get the correct object associated with this tree
			if subject_type /= Void then
				myobject := get_object_if_valid_tree (yyvs12.item (yyvsp12))
				if myobject /= Void then
					-- the last object in the tree knows what expression to build here
					yyval9 := last_object_in_tree.create_expression (yyvs12.item (yyvsp12))
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 100 then
--|#line 793 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 793")
end

			if subject_type /= Void then
				myobject := get_object_if_valid_tree (yyvs12.item (yyvsp12))
				if myobject /= Void then
					-- the last object in the tree knows what expression to build here
					dummye := last_object_in_tree.create_expression (yyvs12.item (yyvsp12))
					create {XPLAIN_PREFIX_EXPRESSION} yyval9.make ("-", dummye)
				end
			else
				report_error ("type or attribute name not valid here.")
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 101 then
--|#line 807 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 807")
end

yyval9 := yyvs11.item (yyvsp11) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp11 := yyvsp11 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 102 then
--|#line 811 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 811")
end

			create {XPLAIN_COMBINE_FUNCTION} yyval9.make (yyvs31.item (yyvsp31))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp31 := yyvsp31 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 103 then
--|#line 819 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 819")
end

			create {XPLAIN_DATEF_FUNCTION} yyval9.make (yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 104 then
--|#line 823 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 823")
end

			create {XPLAIN_INTEGER_FUNCTION} yyval9.make (yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 105 then
--|#line 827 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 827")
end

			create {XPLAIN_REAL_FUNCTION} yyval9.make (yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 106 then
--|#line 831 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 831")
end

			create {XPLAIN_STRING_FUNCTION} yyval9.make (yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 107 then
--|#line 839 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 839")
end

create {XPLAIN_ID_FUNCTION} yyval9.make (subject_type) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 108 then
--|#line 842 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 842")
end

create {XPLAIN_PARENTHESIS_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 109 then
--|#line 844 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 844")
end

create {XPLAIN_PARENTHESIS_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9))
		  create {XPLAIN_PREFIX_EXPRESSION} yyval9.make ("-", yyval9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -3
	yyvs9.put (yyval9, yyvsp9)
end
when 110 then
--|#line 847 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 847")
end

create {XPLAIN_STRING_EXPRESSION} yyval9.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 111 then
--|#line 849 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 849")
end

create {XPLAIN_NUMBER_EXPRESSION} yyval9.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 112 then
--|#line 851 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 851")
end

yyval9 := yyvs10.item (yyvsp10) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp10 := yyvsp10 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 113 then
--|#line 853 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 853")
end

create {XPLAIN_UNMANAGED_PARAMETER_EXPRESSION} yyval9.make (yyvs13.item (yyvsp13).full_name) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp13 := yyvsp13 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 114 then
--|#line 855 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 855")
end

			if is_parameter_declared (yyvs13.item (yyvsp13)) then
				create {XPLAIN_PARAMETER_EXPRESSION} yyval9.make (yyvs13.item (yyvsp13))
			end
			
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp13 := yyvsp13 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 115 then
--|#line 863 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 863")
end

			create {XPLAIN_USER_FUNCTION} yyval9.make (yyvs2.item (yyvsp2), Void)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 116 then
--|#line 867 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 867")
end

			create {XPLAIN_USER_FUNCTION} yyval9.make (yyvs2.item (yyvsp2), yyvs31.item (yyvsp31))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	yyvsp31 := yyvsp31 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 117 then
--|#line 873 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 873")
end

create {XPLAIN_SQL_EXPRESSION} yyval9.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 118 then
--|#line 877 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 877")
end

yyval2 := yyvs3.item (yyvsp3).out 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp3 := yyvsp3 -1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 119 then
--|#line 879 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 879")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 120 then
--|#line 884 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 884")
end

create yyval12.make (yyvs13.item (yyvsp13), Void) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp12 := yyvsp12 + 1
	yyvsp13 := yyvsp13 -1
	if yyvsp12 >= yyvsc12 then
		if yyvs12 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs12")
			end
			create yyspecial_routines12
			yyvsc12 := yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.make (yyvsc12)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs12")
			end
			yyvsc12 := yyvsc12 + yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.resize (yyvs12, yyvsc12)
		end
	end
	yyvs12.put (yyval12, yyvsp12)
end
when 121 then
--|#line 886 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 886")
end

create yyval12.make (yyvs13.item (yyvsp13), yyvs12.item (yyvsp12)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp13 := yyvsp13 -1
	yyvsp1 := yyvsp1 -1
	yyvs12.put (yyval12, yyvsp12)
end
when 122 then
--|#line 892 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 892")
end

create yyval13.make (Void, yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp13 := yyvsp13 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp13 >= yyvsc13 then
		if yyvs13 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs13")
			end
			create yyspecial_routines13
			yyvsc13 := yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.make (yyvsc13)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs13")
			end
			yyvsc13 := yyvsc13 + yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.resize (yyvs13, yyvsc13)
		end
	end
	yyvs13.put (yyval13, yyvsp13)
end
when 123 then
--|#line 894 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 894")
end

create yyval13.make (yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp13 := yyvsp13 + 1
	yyvsp2 := yyvsp2 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp13 >= yyvsc13 then
		if yyvs13 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs13")
			end
			create yyspecial_routines13
			yyvsc13 := yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.make (yyvsc13)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs13")
			end
			yyvsc13 := yyvsc13 + yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.resize (yyvs13, yyvsc13)
		end
	end
	yyvs13.put (yyval13, yyvsp13)
end
when 124 then
--|#line 899 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 899")
end

yyval13 := yyvs13.item (yyvsp13) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs13.put (yyval13, yyvsp13)
end
when 125 then
--|#line 903 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 903")
end

			myattribute := subject_type.find_attribute (yyvs13.item (yyvsp13))
			if myattribute = Void then
				error_unknown_attribute (yyvs2.item (yyvsp2), yyvs13.item (yyvsp13))
			else
				if myattribute.init /= Void then
					report_warning (format ("Attribute `$s' already has an initialization expression.", <<myattribute.full_name>>))
				end
				if is_init_default then
					myattribute.set_init_default (yyvs9.item (yyvsp9))
				else
					myattribute.set_init (yyvs9.item (yyvsp9))
				end
				yyval14 := subject_type
			end
			subject_type := Void
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	yyvsp13 := yyvsp13 -1
	yyvsp9 := yyvsp9 -1
	yyvs14.put (yyval14, yyvsp14)
end
when 126 then
--|#line 903 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 903")
end

subject_type := get_known_type (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp14 := yyvsp14 + 1
	if yyvsp14 >= yyvsc14 then
		if yyvs14 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs14")
			end
			create yyspecial_routines14
			yyvsc14 := yyInitial_yyvs_size
			yyvs14 := yyspecial_routines14.make (yyvsc14)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs14")
			end
			yyvsc14 := yyvsc14 + yyInitial_yyvs_size
			yyvs14 := yyspecial_routines14.resize (yyvs14, yyvsc14)
		end
	end
	yyvs14.put (yyval14, yyvsp14)
end
when 127 then
--|#line 926 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 926")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs9.put (yyval9, yyvsp9)
end
when 128 then
--|#line 928 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 928")
end

yyval9 := yyvs8.item (yyvsp8) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp8 := yyvsp8 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 129 then
--|#line 930 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 930")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -3
	yyvs9.put (yyval9, yyvsp9)
end
when 130 then
--|#line 934 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 934")
end

yyval8 := yyvs8.item (yyvsp8) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs8.put (yyval8, yyvsp8)
end
when 131 then
--|#line 939 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 939")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs9.put (yyval9, yyvsp9)
end
when 132 then
--|#line 944 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 944")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 133 then
--|#line 947 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 947")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 134 then
--|#line 948 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 948")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 135 then
--|#line 951 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 951")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp9 := yyvsp9 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 136 then
--|#line 954 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 954")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp3 := yyvsp3 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 137 then
--|#line 955 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 955")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 138 then
--|#line 958 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 958")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp9 := yyvsp9 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 139 then
--|#line 962 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 962")
end

			last_width := yyvs3.item (yyvsp3)
			create {XPLAIN_A_REPRESENTATION} yyval15.make (last_width)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp3 := yyvsp3 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 140 then
--|#line 967 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 967")
end

create {XPLAIN_B_REPRESENTATION} yyval15 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 141 then
--|#line 969 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 969")
end

			last_width := yyvs3.item (yyvsp3)
			create {XPLAIN_C_REPRESENTATION} yyval15.make (last_width)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp3 := yyvsp3 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 142 then
--|#line 974 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 974")
end

create {XPLAIN_D_REPRESENTATION} yyval15 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 143 then
--|#line 976 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 976")
end

			last_width := yyvs3.item (yyvsp3)
			create {XPLAIN_I_REPRESENTATION} yyval15.make (yyvs3.item (yyvsp3))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp3 := yyvsp3 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 144 then
--|#line 981 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 981")
end

create {XPLAIN_M_REPRESENTATION} yyval15 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 145 then
--|#line 983 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 983")
end

create {XPLAIN_P_REPRESENTATION} yyval15 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 146 then
--|#line 985 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 985")
end

			last_width := yyvs3.item (yyvsp3 - 1)
			create {XPLAIN_R_REPRESENTATION} yyval15.make (yyvs3.item (yyvsp3 - 1), yyvs3.item (yyvsp3))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -2
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 147 then
--|#line 990 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 990")
end

create {XPLAIN_T_REPRESENTATION} yyval15 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 148 then
--|#line 992 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 992")
end

			report_error ("Comma expected in R representation instead of: " + text)
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp3 := yyvsp3 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 149 then
--|#line 997 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 997")
end

			report_error ("Representation expected instead of: " + text)
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 150 then
--|#line 1005 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1005")
end

			create {XPLAIN_PK_A_REPRESENTATION} yyval16.make (yyvs3.item (yyvsp3))
			create {XPLAIN_A_REFERENCES} dummya.make
			yyval16.set_domain_restriction(sqlgenerator, dummya)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp16 := yyvsp16 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp3 := yyvsp3 -1
	if yyvsp16 >= yyvsc16 then
		if yyvs16 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs16")
			end
			create yyspecial_routines16
			yyvsc16 := yyInitial_yyvs_size
			yyvs16 := yyspecial_routines16.make (yyvsc16)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs16")
			end
			yyvsc16 := yyvsc16 + yyInitial_yyvs_size
			yyvs16 := yyspecial_routines16.resize (yyvs16, yyvsc16)
		end
	end
	yyvs16.put (yyval16, yyvsp16)
end
when 151 then
--|#line 1011 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1011")
end

			create {XPLAIN_PK_I_REPRESENTATION}yyval16.make (yyvs3.item (yyvsp3))
			create {XPLAIN_I_REFERENCES} dummyi.make
			yyval16.set_domain_restriction(sqlgenerator, dummyi)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp16 := yyvsp16 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp3 := yyvsp3 -1
	if yyvsp16 >= yyvsc16 then
		if yyvs16 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs16")
			end
			create yyspecial_routines16
			yyvsc16 := yyInitial_yyvs_size
			yyvs16 := yyspecial_routines16.make (yyvsc16)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs16")
			end
			yyvsc16 := yyvsc16 + yyInitial_yyvs_size
			yyvs16 := yyspecial_routines16.resize (yyvs16, yyvsc16)
		end
	end
	yyvs16.put (yyval16, yyvsp16)
end
when 152 then
--|#line 1017 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1017")
end

			report_error ("type identification expected instead of: " + text)
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp16 := yyvsp16 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp16 >= yyvsc16 then
		if yyvs16 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs16")
			end
			create yyspecial_routines16
			yyvsc16 := yyInitial_yyvs_size
			yyvs16 := yyspecial_routines16.make (yyvsc16)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs16")
			end
			yyvsc16 := yyvsc16 + yyInitial_yyvs_size
			yyvs16 := yyspecial_routines16.resize (yyvs16, yyvsc16)
		end
	end
	yyvs16.put (yyval16, yyvsp16)
end
when 153 then
--|#line 1025 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1025")
end

yyval2 := yyvs2.item (yyvsp2); current_type_name := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 154 then
--|#line 1029 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1029")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 155 then
--|#line 1033 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1033")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 156 then
--|#line 1037 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1037")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 157 then
--|#line 1041 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1041")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 158 then
--|#line 1046 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1046")
end

create {XPLAIN_ATTRIBUTE_NODE} yyval17.make (yyvs18.item (yyvsp18), Void) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp17 := yyvsp17 + 1
	yyvsp18 := yyvsp18 -1
	if yyvsp17 >= yyvsc17 then
		if yyvs17 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs17")
			end
			create yyspecial_routines17
			yyvsc17 := yyInitial_yyvs_size
			yyvs17 := yyspecial_routines17.make (yyvsc17)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs17")
			end
			yyvsc17 := yyvsc17 + yyInitial_yyvs_size
			yyvs17 := yyspecial_routines17.resize (yyvs17, yyvsc17)
		end
	end
	yyvs17.put (yyval17, yyvsp17)
end
when 159 then
--|#line 1048 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1048")
end

create {XPLAIN_ATTRIBUTE_NODE} yyval17.make (yyvs18.item (yyvsp18), yyvs17.item (yyvsp17)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp18 := yyvsp18 -1
	yyvsp1 := yyvsp1 -1
	yyvs17.put (yyval17, yyvsp17)
end
when 160 then
--|#line 1050 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1050")
end

			report_error ("comma or dot expected instead of: " + text)
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp17 := yyvsp17 + 1
	yyvsp18 := yyvsp18 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp17 >= yyvsc17 then
		if yyvs17 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs17")
			end
			create yyspecial_routines17
			yyvsc17 := yyInitial_yyvs_size
			yyvs17 := yyspecial_routines17.make (yyvsc17)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs17")
			end
			yyvsc17 := yyvsc17 + yyInitial_yyvs_size
			yyvs17 := yyspecial_routines17.resize (yyvs17, yyvsc17)
		end
	end
	yyvs17.put (yyval17, yyvsp17)
end
when 161 then
--|#line 1057 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1057")
end

create {XPLAIN_ATTRIBUTE} yyval18.make (
			yyvs13.item (yyvsp13).role, yyvs13.item (yyvsp13).abstracttype_if_known,
			True, sqlgenerator.check_if_required (yyvs13.item (yyvsp13).abstracttype_if_known),
			True, False) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp18 := yyvsp18 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp13 := yyvsp13 -1
	if yyvsp18 >= yyvsc18 then
		if yyvs18 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs18")
			end
			create yyspecial_routines18
			yyvsc18 := yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.make (yyvsc18)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs18")
			end
			yyvsc18 := yyvsc18 + yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.resize (yyvs18, yyvsc18)
		end
	end
	yyvs18.put (yyval18, yyvsp18)
end
when 162 then
--|#line 1062 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1062")
end

create {XPLAIN_ATTRIBUTE} yyval18.make (
			yyvs13.item (yyvsp13).role, yyvs13.item (yyvsp13).abstracttype_if_known,
			True, sqlgenerator.check_if_required (yyvs13.item (yyvsp13).abstracttype_if_known),
			False, False) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
	yyvsp13 := yyvsp13 -1
	if yyvsp18 >= yyvsc18 then
		if yyvs18 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs18")
			end
			create yyspecial_routines18
			yyvsc18 := yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.make (yyvsc18)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs18")
			end
			yyvsc18 := yyvsc18 + yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.resize (yyvs18, yyvsc18)
		end
	end
	yyvs18.put (yyval18, yyvsp18)
end
when 163 then
--|#line 1067 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1067")
end

create {XPLAIN_ATTRIBUTE} yyval18.make (
			yyvs13.item (yyvsp13).role, yyvs13.item (yyvsp13).abstracttype_if_known,
		True, False, False, False) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp18 := yyvsp18 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp13 := yyvsp13 -1
	if yyvsp18 >= yyvsc18 then
		if yyvs18 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs18")
			end
			create yyspecial_routines18
			yyvsc18 := yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.make (yyvsc18)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs18")
			end
			yyvsc18 := yyvsc18 + yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.resize (yyvs18, yyvsc18)
		end
	end
	yyvs18.put (yyval18, yyvsp18)
end
when 164 then
--|#line 1071 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1071")
end

create {XPLAIN_ATTRIBUTE} yyval18.make (
			yyvs13.item (yyvsp13).role, yyvs13.item (yyvsp13).abstracttype_if_known,
			True, True, False, False) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp18 := yyvsp18 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp13 := yyvsp13 -1
	if yyvsp18 >= yyvsc18 then
		if yyvs18 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs18")
			end
			create yyspecial_routines18
			yyvsc18 := yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.make (yyvsc18)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs18")
			end
			yyvsc18 := yyvsc18 + yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.resize (yyvs18, yyvsc18)
		end
	end
	yyvs18.put (yyval18, yyvsp18)
end
when 165 then
--|#line 1075 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1075")
end

create {XPLAIN_ATTRIBUTE} yyval18.make (
		yyvs13.item (yyvsp13).role, yyvs13.item (yyvsp13).abstracttype_if_known,
		True, True, False, True) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp18 := yyvsp18 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp13 := yyvsp13 -1
	if yyvsp18 >= yyvsc18 then
		if yyvs18 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs18")
			end
			create yyspecial_routines18
			yyvsc18 := yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.make (yyvsc18)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs18")
			end
			yyvsc18 := yyvsc18 + yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.resize (yyvs18, yyvsc18)
		end
	end
	yyvs18.put (yyval18, yyvsp18)
end
when 166 then
--|#line 1083 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1083")
end

		myabstracttype := get_known_base_or_type (yyvs2.item (yyvsp2))
		create yyval13.make (Void, yyvs2.item (yyvsp2))
		if myabstracttype /= Void then
			-- when self reference, it is valid to be Void
			yyval13.set_object (myabstracttype)
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp13 := yyvsp13 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp13 >= yyvsc13 then
		if yyvs13 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs13")
			end
			create yyspecial_routines13
			yyvsc13 := yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.make (yyvsc13)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs13")
			end
			yyvsc13 := yyvsc13 + yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.resize (yyvs13, yyvsc13)
		end
	end
	yyvs13.put (yyval13, yyvsp13)
end
when 167 then
--|#line 1092 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1092")
end

		myabstracttype := get_known_base_or_type (yyvs2.item (yyvsp2))
		create yyval13.make (yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2))
		if myabstracttype /= Void then
			-- when self reference, it is valid to be Void
			yyval13.set_object (myabstracttype)
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp13 := yyvsp13 + 1
	yyvsp2 := yyvsp2 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp13 >= yyvsc13 then
		if yyvs13 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs13")
			end
			create yyspecial_routines13
			yyvsc13 := yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.make (yyvsc13)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs13")
			end
			yyvsc13 := yyvsc13 + yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.resize (yyvs13, yyvsc13)
		end
	end
	yyvs13.put (yyval13, yyvsp13)
end
when 168 then
--|#line 1104 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1104")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 169 then
--|#line 1106 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1106")
end

yyval2  := yyvs2.item (yyvsp2 - 1) + " " + yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 170 then
--|#line 1110 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1110")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 171 then
--|#line 1114 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1114")
end

yyval3 := yyvs3.item (yyvsp3) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs3.put (yyval3, yyvsp3)
end
when 172 then
--|#line 1121 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1121")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 173 then
--|#line 1129 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1129")
end

yyval9 := yyvs8.item (yyvsp8) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp8 := yyvsp8 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 174 then
--|#line 1134 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1134")
end

			dummyl ?= yyvs9.item (yyvsp9)
			if dummyl = Void then
				create yyval8.make (yyvs9.item (yyvsp9))
			else
				yyval8 := dummyl
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp8 := yyvsp8 + 1
	yyvsp9 := yyvsp9 -1
	if yyvsp8 >= yyvsc8 then
		if yyvs8 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs8")
			end
			create yyspecial_routines8
			yyvsc8 := yyInitial_yyvs_size
			yyvs8 := yyspecial_routines8.make (yyvsc8)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs8")
			end
			yyvsc8 := yyvsc8 + yyInitial_yyvs_size
			yyvs8 := yyspecial_routines8.resize (yyvs8, yyvsc8)
		end
	end
	yyvs8.put (yyval8, yyvsp8)
end
when 175 then
--|#line 1143 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1143")
end

			create {XPLAIN_LOGICAL_INFIX_EXPRESSION} dummye.make (yyvs9.item (yyvsp9), "or", yyvs8.item (yyvsp8))
			create yyval8.make (dummye)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -1
	yyvs8.put (yyval8, yyvsp8)
end
when 176 then
--|#line 1151 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1151")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs9.put (yyval9, yyvsp9)
end
when 177 then
--|#line 1153 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1153")
end

create {XPLAIN_LOGICAL_INFIX_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9 - 1), "and", yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 178 then
--|#line 1158 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1158")
end

create {XPLAIN_PARENTHESIS_EXPRESSION} yyval9.make (yyvs8.item (yyvsp8)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp8 := yyvsp8 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 179 then
--|#line 1160 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1160")
end

create {XPLAIN_PARENTHESIS_EXPRESSION} yyval9.make (yyvs8.item (yyvsp8))
		  create {XPLAIN_NOT_EXPRESSION} yyval9.make (yyval9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 180 then
--|#line 1163 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1163")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs9.put (yyval9, yyvsp9)
end
when 181 then
--|#line 1165 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1165")
end

		-- @@BdB: This seems tricky: I shouldn't be able to assign a
		-- variable to a constant. And it looks like that isn't
		-- forbidden in the following code:
		myvariable := universe.find_variable (yyvs2.item (yyvsp2))
		if myvariable = Void then
			-- not a variable, maybe a value?
			-- depends on context, not checked now
			myvalue := universe.find_value (yyvs2.item (yyvsp2))
			if myvalue = Void then
				report_error ("Not a known variable: " + yyvs2.item (yyvsp2))
				abort
			else
				create {XPLAIN_VALUE_EXPRESSION} dummye.make (myvalue)
				create {XPLAIN_NOT_EXPRESSION} yyval9.make (dummye)
			end
		else
			create {XPLAIN_VARIABLE_EXPRESSION} dummye.make (myvariable)
			create {XPLAIN_NOT_EXPRESSION} yyval9.make (dummye)
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 182 then
--|#line 1187 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1187")
end

create {XPLAIN_STRING_EXPRESSION} yyval9.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 183 then
--|#line 1189 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1189")
end

yyval9 := yyvs10.item (yyvsp10) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp10 := yyvsp10 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 184 then
--|#line 1191 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1191")
end

create {XPLAIN_NOT_EXPRESSION} yyval9.make (yyvs10.item (yyvsp10)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp10 := yyvsp10 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 185 then
--|#line 1193 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1193")
end

			create {XPLAIN_LOGICAL_INFIX_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9 - 1), yyvs2.item (yyvsp2), yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp2 := yyvsp2 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 186 then
--|#line 1202 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1202")
end

create {XPLAIN_INFIX_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9 - 1), "+", yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 187 then
--|#line 1204 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1204")
end

create {XPLAIN_INFIX_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9 - 1), "-", yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 188 then
--|#line 1206 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1206")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs9.put (yyval9, yyvsp9)
end
when 189 then
--|#line 1211 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1211")
end

create {XPLAIN_INFIX_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9 - 1), "*", yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 190 then
--|#line 1213 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1213")
end

create {XPLAIN_INFIX_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9 - 1), "/", yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 191 then
--|#line 1215 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1215")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs9.put (yyval9, yyvsp9)
end
when 192 then
--|#line 1220 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1220")
end

create {XPLAIN_PARENTHESIS_EXPRESSION} yyval9.make (yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 193 then
--|#line 1222 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1222")
end

create {XPLAIN_NUMBER_EXPRESSION} yyval9.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 194 then
--|#line 1224 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1224")
end

create {XPLAIN_PREFIX_EXPRESSION} yyval9.make ("-", yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 195 then
--|#line 1226 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1226")
end

myvariable := universe.find_variable (yyvs2.item (yyvsp2))
		if myvariable = Void then
			-- not a variable, maybe a value?
			-- depends on context, not checked now
			myvalue := universe.find_value (yyvs2.item (yyvsp2))
			if myvalue = Void then
				report_error ("Not a known variable: " + yyvs2.item (yyvsp2))
				abort
			else
				create {XPLAIN_VALUE_EXPRESSION} yyval9.make (myvalue)
			end
		else
			create {XPLAIN_VARIABLE_EXPRESSION} yyval9.make (myvariable)
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 196 then
--|#line 1250 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1250")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp5 := yyvsp5 + 1
	if yyvsp5 >= yyvsc5 then
		if yyvs5 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs5")
			end
			create yyspecial_routines5
			yyvsc5 := yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.make (yyvsc5)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs5")
			end
			yyvsc5 := yyvsc5 + yyInitial_yyvs_size
			yyvs5 := yyspecial_routines5.resize (yyvs5, yyvsc5)
		end
	end
	yyvs5.put (yyval5, yyvsp5)
end
when 197 then
--|#line 1251 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1251")
end

yyval5 := yyvs5.item (yyvsp5) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs5.put (yyval5, yyvsp5)
end
when 198 then
--|#line 1254 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1254")
end

			create {XPLAIN_ASSERTION} yyval19.make (sqlgenerator, extend_type, yyvs2.item (yyvsp2), yyvs5.item (yyvsp5), yyvs26.item (yyvsp26))
			if immediate_output_mode and then
				(yyval19.is_function or else yyval19.is_complex or else not sqlgenerator.CalculatedColumnsSupported) then
				write_pending_statement
				sqlgenerator.write_assertion (yyval19)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 8
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -2
	yyvsp5 := yyvsp5 -1
	yyvsp26 := yyvsp26 -1
	yyvs19.put (yyval19, yyvsp19)
end
when 199 then
--|#line 1254 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1254")
end

			extend_type := get_known_type (yyvs2.item (yyvsp2))
			subject_type := extend_type            -- in case of expression extension
			last_width := 1 -- hack, incorrect restriction for assert, must base * on max width of expression
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp19 := yyvsp19 + 1
	if yyvsp19 >= yyvsc19 then
		if yyvs19 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs19")
			end
			create yyspecial_routines19
			yyvsc19 := yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.make (yyvsc19)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs19")
			end
			yyvsc19 := yyvsc19 + yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.resize (yyvs19, yyvsc19)
		end
	end
	yyvs19.put (yyval19, yyvsp19)
end
when 200 then
--|#line 1269 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1269")
end

			report_error ("Please use its instead of with.")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp19 := yyvsp19 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	if yyvsp19 >= yyvsc19 then
		if yyvs19 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs19")
			end
			create yyspecial_routines19
			yyvsc19 := yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.make (yyvsc19)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs19")
			end
			yyvsc19 := yyvsc19 + yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.resize (yyvs19, yyvsc19)
		end
	end
	yyvs19.put (yyval19, yyvsp19)
end
when 201 then
--|#line 1274 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1274")
end

			report_warning ("Virtual value assertion not yet supported. No code will be generated.")
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp19 := yyvsp19 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp5 := yyvsp5 -1
	yyvsp9 := yyvsp9 -1
	if yyvsp19 >= yyvsc19 then
		if yyvs19 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs19")
			end
			create yyspecial_routines19
			yyvsc19 := yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.make (yyvsc19)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs19")
			end
			yyvsc19 := yyvsc19 + yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.resize (yyvs19, yyvsc19)
		end
	end
	yyvs19.put (yyval19, yyvsp19)
end
when 202 then
--|#line 1280 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1280")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 203 then
--|#line 1284 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1284")
end

yyval1 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 204 then
--|#line 1288 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1288")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 205 then
--|#line 1292 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1292")
end

		create myindex.make (subject_type, yyvs2.item (yyvsp2), False, False, yyvs12.item (yyvsp12))
		if not use_mode then
			sqlgenerator.write_index (myindex)
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -2
	yyvsp12 := yyvsp12 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 206 then
--|#line 1292 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1292")
end

write_pending_statement
		subject_type := get_known_type (yyvs2.item (yyvsp2))
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 207 then
--|#line 1304 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1304")
end

		create myindex.make (subject_type, yyvs2.item (yyvsp2), True, False, yyvs12.item (yyvsp12))
		if not use_mode then
			sqlgenerator.write_index (myindex)
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 8
	yyvsp1 := yyvsp1 -4
	yyvsp2 := yyvsp2 -2
	yyvsp12 := yyvsp12 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 208 then
--|#line 1304 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1304")
end

write_pending_statement
		subject_type := get_known_type (yyvs2.item (yyvsp2))
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 209 then
--|#line 1315 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1315")
end

		create myindex.make (subject_type, yyvs2.item (yyvsp2), False, True, yyvs12.item (yyvsp12))
		if not use_mode then
			sqlgenerator.write_index (myindex)
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 8
	yyvsp1 := yyvsp1 -4
	yyvsp2 := yyvsp2 -2
	yyvsp12 := yyvsp12 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 210 then
--|#line 1315 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1315")
end

write_pending_statement
		subject_type := get_known_type (yyvs2.item (yyvsp2))
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 211 then
--|#line 1326 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1326")
end

		create myindex.make (subject_type, yyvs2.item (yyvsp2), True, True, yyvs12.item (yyvsp12))
		if not use_mode then
			sqlgenerator.write_index (myindex)
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 9
	yyvsp1 := yyvsp1 -5
	yyvsp2 := yyvsp2 -2
	yyvsp12 := yyvsp12 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 212 then
--|#line 1326 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1326")
end

write_pending_statement
		subject_type := get_known_type (yyvs2.item (yyvsp2))
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 213 then
--|#line 1340 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1340")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp12 := yyvsp12 + 1
	if yyvsp12 >= yyvsc12 then
		if yyvs12 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs12")
			end
			create yyspecial_routines12
			yyvsc12 := yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.make (yyvsc12)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs12")
			end
			yyvsc12 := yyvsc12 + yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.resize (yyvs12, yyvsc12)
		end
	end
	yyvs12.put (yyval12, yyvsp12)
end
when 214 then
--|#line 1341 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1341")
end

yyval12 := yyvs12.item (yyvsp12) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs12.put (yyval12, yyvsp12)
end
when 215 then
--|#line 1345 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1345")
end

			myattribute := subject_type.find_attribute (yyvs13.item (yyvsp13))
			if myattribute = Void then
				error_unknown_attribute (subject_type.name, yyvs13.item (yyvsp13))
			else
			  create yyval12.make (yyvs13.item (yyvsp13), Void)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp12 := yyvsp12 + 1
	yyvsp13 := yyvsp13 -1
	if yyvsp12 >= yyvsc12 then
		if yyvs12 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs12")
			end
			create yyspecial_routines12
			yyvsc12 := yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.make (yyvsc12)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs12")
			end
			yyvsc12 := yyvsc12 + yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.resize (yyvs12, yyvsc12)
		end
	end
	yyvs12.put (yyval12, yyvsp12)
end
when 216 then
--|#line 1354 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1354")
end

			myattribute := subject_type.find_attribute (yyvs13.item (yyvsp13))
			if myattribute = Void then
				error_unknown_attribute (subject_type.name, yyvs13.item (yyvsp13))
			else
				create yyval12.make (yyvs13.item (yyvsp13), yyvs12.item (yyvsp12))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp13 := yyvsp13 -1
	yyvsp1 := yyvsp1 -1
	yyvs12.put (yyval12, yyvsp12)
end
when 217 then
--|#line 1363 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1363")
end

			report_error ("comma or dot expected instead of: " + text)
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp12 := yyvsp12 + 1
	yyvsp13 := yyvsp13 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp12 >= yyvsc12 then
		if yyvs12 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs12")
			end
			create yyspecial_routines12
			yyvsc12 := yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.make (yyvsc12)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs12")
			end
			yyvsc12 := yyvsc12 + yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.resize (yyvs12, yyvsc12)
		end
	end
	yyvs12.put (yyval12, yyvsp12)
end
when 218 then
--|#line 1378 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1378")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 219 then
--|#line 1379 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1379")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 220 then
--|#line 1383 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1383")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp44 := yyvsp44 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 221 then
--|#line 1384 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1384")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp38 := yyvsp38 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 222 then
--|#line 1385 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1385")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp33 := yyvsp33 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 223 then
--|#line 1386 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1386")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp36 := yyvsp36 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 224 then
--|#line 1390 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1390")
end

			write_pending_statement
			mytype := yyvs22.item (yyvsp22).type
			warn_attributes_with_inits (yyvs20.item (yyvsp20))
			if
				yyvs22.item (yyvsp22).identification = Void
			then
				report_error ("Identification expected.")
				abort
			elseif
				mytype.representation.is_integer and then
				yyvs22.item (yyvsp22).identification.is_constant and then
				not yyvs22.item (yyvsp22).identification.sqlvalue (sqlgenerator).is_integer
			then
				report_error (format ("Primary key %"$s%" is not an integer.", <<yyvs22.item (yyvsp22).identification.sqlvalue (sqlgenerator)>>))
				abort
			else
				create {XPLAIN_INSERT_STATEMENT} yyval33.make (mytype, yyvs22.item (yyvsp22).identification, yyvs20.item (yyvsp20))
				if immediate_output_mode then
					sqlgenerator.write_insert (mytype, yyvs22.item (yyvsp22).identification, yyvs20.item (yyvsp20))
				end
			end
			subject_type := Void
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp22 := yyvsp22 -1
	yyvsp20 := yyvsp20 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 225 then
--|#line 1415 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1415")
end

			write_pending_statement
			mytype := yyvs22.item (yyvsp22).type
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
			create {XPLAIN_INSERT_STATEMENT} yyval33.make (mytype, Void, yyvs20.item (yyvsp20))
			if immediate_output_mode then
				sqlgenerator.write_insert (mytype, Void, yyvs20.item (yyvsp20))
			end
			subject_type := Void
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp22 := yyvsp22 -1
	yyvsp20 := yyvsp20 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 226 then
--|#line 1436 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1436")
end

			report_error ("its expected instead of: '" + text + "'")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp22 := yyvsp22 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 227 then
--|#line 1441 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1441")
end

			write_pending_statement
			mytype := yyvs22.item (yyvsp22).type
			create {XPLAIN_GET_INSERT_STATEMENT} yyval33.make (yyvs28.item (yyvsp28), mytype, False, yyvs12.item (yyvsp12))
			if immediate_output_mode then
				yyval33.write (sqlgenerator)
			end
			subject_type := Void
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp28 := yyvsp28 -1
	yyvsp22 := yyvsp22 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 228 then
--|#line 1451 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1451")
end

			write_pending_statement
			mytype := yyvs22.item (yyvsp22).type
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
			create {XPLAIN_GET_INSERT_STATEMENT} yyval33.make (yyvs28.item (yyvsp28), mytype, True, yyvs12.item (yyvsp12))
			if immediate_output_mode then
				yyval33.write (sqlgenerator)
			end
			subject_type := Void
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp28 := yyvsp28 -1
	yyvsp22 := yyvsp22 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 229 then
--|#line 1475 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1475")
end

create {XPLAIN_ASSIGNMENT_NODE} yyval20.make (yyvs21.item (yyvsp21), Void) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp20 := yyvsp20 + 1
	yyvsp21 := yyvsp21 -1
	if yyvsp20 >= yyvsc20 then
		if yyvs20 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs20")
			end
			create yyspecial_routines20
			yyvsc20 := yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.make (yyvsc20)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs20")
			end
			yyvsc20 := yyvsc20 + yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.resize (yyvs20, yyvsc20)
		end
	end
	yyvs20.put (yyval20, yyvsp20)
end
when 230 then
--|#line 1477 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1477")
end

create {XPLAIN_ASSIGNMENT_NODE} yyval20.make (yyvs21.item (yyvsp21), yyvs20.item (yyvsp20)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp21 := yyvsp21 -1
	yyvsp1 := yyvsp1 -1
	yyvs20.put (yyval20, yyvsp20)
end
when 231 then
--|#line 1479 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1479")
end

			report_error ("comma or dot expected instead of: " + text)
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp20 := yyvsp20 + 1
	yyvsp21 := yyvsp21 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp20 >= yyvsc20 then
		if yyvs20 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs20")
			end
			create yyspecial_routines20
			yyvsc20 := yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.make (yyvsc20)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs20")
			end
			yyvsc20 := yyvsc20 + yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.resize (yyvs20, yyvsc20)
		end
	end
	yyvs20.put (yyval20, yyvsp20)
end
when 232 then
--|#line 1487 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1487")
end

create {XPLAIN_ASSIGNMENT} yyval21.make (yyvs13.item (yyvsp13), yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp21 := yyvsp21 + 1
	yyvsp13 := yyvsp13 -1
	yyvsp1 := yyvsp1 -1
	yyvsp9 := yyvsp9 -1
	if yyvsp21 >= yyvsc21 then
		if yyvs21 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs21")
			end
			create yyspecial_routines21
			yyvsc21 := yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.make (yyvsc21)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs21")
			end
			yyvsc21 := yyvsc21 + yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.resize (yyvs21, yyvsc21)
		end
	end
	yyvs21.put (yyval21, yyvsp21)
end
when 233 then
--|#line 1492 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1492")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs9.put (yyval9, yyvsp9)
end
when 234 then
--|#line 1494 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1494")
end

yyval9 := yyvs8.item (yyvsp8) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp8 := yyvsp8 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 235 then
--|#line 1499 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1499")
end

			if yyvs37.item (yyvsp37) /= Void then
				subject_type := get_known_type (yyvs2.item (yyvsp2)) -- subject_type changed by cascade_definition I think
				create yyval36.make (sqlgenerator, subject_type, yyvs13.item (yyvsp13), yyvs37.item (yyvsp37))
				if immediate_output_mode then
					yyval36.write (sqlgenerator)
				end
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	yyvsp13 := yyvsp13 -1
	yyvsp37 := yyvsp37 -1
	yyvs36.put (yyval36, yyvsp36)
end
when 236 then
--|#line 1499 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1499")
end

			subject_type := get_known_type (yyvs2.item (yyvsp2))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp36 := yyvsp36 + 1
	if yyvsp36 >= yyvsc36 then
		if yyvs36 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs36")
			end
			create yyspecial_routines36
			yyvsc36 := yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.make (yyvsc36)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs36")
			end
			yyvsc36 := yyvsc36 + yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.resize (yyvs36, yyvsc36)
		end
	end
	yyvs36.put (yyval36, yyvsp36)
end
when 237 then
--|#line 1521 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1521")
end

			myobject := get_object_if_valid_tree (yyvs12.item (yyvsp12))
			if myobject /= Void then
				create {XPLAIN_CASCADE_FUNCTION_EXPRESSION} yyval37.make (yyvs23.item (yyvsp23), yyvs12.item (yyvsp12))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp37 := yyvsp37 + 1
	yyvsp23 := yyvsp23 -1
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp37 >= yyvsc37 then
		if yyvs37 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs37")
			end
			create yyspecial_routines37
			yyvsc37 := yyInitial_yyvs_size
			yyvs37 := yyspecial_routines37.make (yyvsc37)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs37")
			end
			yyvsc37 := yyvsc37 + yyInitial_yyvs_size
			yyvs37 := yyspecial_routines37.resize (yyvs37, yyvsc37)
		end
	end
	yyvs37.put (yyval37, yyvsp37)
end
when 238 then
--|#line 1528 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1528")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp37 := yyvsp37 + 1
	yyvsp9 := yyvsp9 -1
	if yyvsp37 >= yyvsc37 then
		if yyvs37 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs37")
			end
			create yyspecial_routines37
			yyvsc37 := yyInitial_yyvs_size
			yyvs37 := yyspecial_routines37.make (yyvsc37)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs37")
			end
			yyvsc37 := yyvsc37 + yyInitial_yyvs_size
			yyvs37 := yyspecial_routines37.resize (yyvs37, yyvsc37)
		end
	end
	yyvs37.put (yyval37, yyvsp37)
end
when 239 then
--|#line 1529 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1529")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp37 := yyvsp37 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp8 := yyvsp8 -1
	if yyvsp37 >= yyvsc37 then
		if yyvs37 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs37")
			end
			create yyspecial_routines37
			yyvsc37 := yyInitial_yyvs_size
			yyvs37 := yyspecial_routines37.make (yyvsc37)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs37")
			end
			yyvsc37 := yyvsc37 + yyInitial_yyvs_size
			yyvs37 := yyspecial_routines37.resize (yyvs37, yyvsc37)
		end
	end
	yyvs37.put (yyval37, yyvsp37)
end
when 240 then
--|#line 1535 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1535")
end

yyval12 := yyvs12.item (yyvsp12) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs12.put (yyval12, yyvsp12)
end
when 241 then
--|#line 1539 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1539")
end

		write_pending_statement
		if immediate_output_mode then
			sqlgenerator.write_delete (yyvs22.item (yyvsp22), yyvs9.item (yyvsp9))
		end
		subject_type := Void
		create yyval38.make (yyvs22.item (yyvsp22), yyvs9.item (yyvsp9))
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp38 := yyvsp38 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp22 := yyvsp22 -1
	yyvsp9 := yyvsp9 -1
	if yyvsp38 >= yyvsc38 then
		if yyvs38 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs38")
			end
			create yyspecial_routines38
			yyvsc38 := yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.make (yyvsc38)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs38")
			end
			yyvsc38 := yyvsc38 + yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.resize (yyvs38, yyvsc38)
		end
	end
	yyvs38.put (yyval38, yyvsp38)
end
when 242 then
--|#line 1551 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1551")
end

			subject_type := get_known_type (yyvs2.item (yyvsp2))
			if subject_type = Void then
				report_error ("Type `" + yyvs2.item (yyvsp2) + "' not known.")
				abort
			else
				my_str ?= yyvs9.item (yyvsp9)
				if my_str /= Void and then subject_type.representation.length < my_str.value.count then
					report_error ("Instance identification %"" + my_str.value + "%" does not fit in domain " + subject_type.representation.domain + " of type " + subject_type.name + ".")
					abort
				else
					create {XPLAIN_SUBJECT} yyval22.make (subject_type, yyvs9.item (yyvsp9))
				end
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp22 := yyvsp22 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp9 := yyvsp9 -1
	if yyvsp22 >= yyvsc22 then
		if yyvs22 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs22")
			end
			create yyspecial_routines22
			yyvsc22 := yyInitial_yyvs_size
			yyvs22 := yyspecial_routines22.make (yyvsc22)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs22")
			end
			yyvsc22 := yyvsc22 + yyInitial_yyvs_size
			yyvs22 := yyspecial_routines22.resize (yyvs22, yyvsc22)
		end
	end
	yyvs22.put (yyval22, yyvsp22)
end
when 243 then
--|#line 1570 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1570")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp9 := yyvsp9 + 1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 244 then
--|#line 1571 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1571")
end

			-- number or string
			if yyvs2.item (yyvsp2).is_integer then
				create {XPLAIN_NUMBER_EXPRESSION} yyval9.make (yyvs2.item (yyvsp2))
			else
				create {XPLAIN_STRING_EXPRESSION} yyval9.make (yyvs2.item (yyvsp2))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 245 then
--|#line 1580 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1580")
end

			if is_parameter_declared (yyvs13.item (yyvsp13)) then
				create {XPLAIN_PARAMETER_EXPRESSION} yyval9.make (yyvs13.item (yyvsp13))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp13 := yyvsp13 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 246 then
--|#line 1586 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1586")
end

			myvalue := get_known_value (yyvs2.item (yyvsp2))
			if myvalue /= Void then
				create {XPLAIN_VALUE_EXPRESSION} yyval9.make (myvalue)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 247 then
--|#line 1593 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1593")
end

			report_error ("name of a value expected instead of: " + text)
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 248 then
--|#line 1601 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1601")
end

		write_pending_statement
		if immediate_output_mode then
			sqlgenerator.write_update (yyvs22.item (yyvsp22), yyvs20.item (yyvsp20), yyvs9.item (yyvsp9))
		end
		subject_type := Void
		create yyval44.make (yyvs22.item (yyvsp22), yyvs20.item (yyvsp20), yyvs9.item (yyvsp9))
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp44 := yyvsp44 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp22 := yyvsp22 -1
	yyvsp20 := yyvsp20 -1
	yyvsp9 := yyvsp9 -1
	if yyvsp44 >= yyvsc44 then
		if yyvs44 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs44")
			end
			create yyspecial_routines44
			yyvsc44 := yyInitial_yyvs_size
			yyvs44 := yyspecial_routines44.make (yyvsc44)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs44")
			end
			yyvsc44 := yyvsc44 + yyInitial_yyvs_size
			yyvs44 := yyspecial_routines44.resize (yyvs44, yyvsc44)
		end
	end
	yyvs44.put (yyval44, yyvsp44)
end
when 249 then
--|#line 1610 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1610")
end

report_error ("its expected instead of: '" + text + "'")
		  abort 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp44 := yyvsp44 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp22 := yyvsp22 -1
	if yyvsp44 >= yyvsc44 then
		if yyvs44 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs44")
			end
			create yyspecial_routines44
			yyvsc44 := yyInitial_yyvs_size
			yyvs44 := yyspecial_routines44.make (yyvsc44)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs44")
			end
			yyvsc44 := yyvsc44 + yyInitial_yyvs_size
			yyvs44 := yyspecial_routines44.resize (yyvs44, yyvsc44)
		end
	end
	yyvs44.put (yyval44, yyvsp44)
end
when 250 then
--|#line 1615 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1615")
end

		create {XPLAIN_ATTRIBUTE_NAME} yyval13.make (Void, yyvs2.item (yyvsp2))
		myattribute := subject_type.find_attribute (yyval13)
		if myattribute = Void then
			error_unknown_attribute (subject_type.name, yyval13)
		else
			yyval13.set_attribute (myattribute)
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp13 := yyvsp13 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp13 >= yyvsc13 then
		if yyvs13 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs13")
			end
			create yyspecial_routines13
			yyvsc13 := yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.make (yyvsc13)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs13")
			end
			yyvsc13 := yyvsc13 + yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.resize (yyvs13, yyvsc13)
		end
	end
	yyvs13.put (yyval13, yyvsp13)
end
when 251 then
--|#line 1625 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1625")
end

		create {XPLAIN_ATTRIBUTE_NAME} yyval13.make (yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2))
		myattribute := subject_type.find_attribute (yyval13)
		if myattribute = Void then
			error_unknown_attribute (subject_type.name, yyval13)
		else
			yyval13.set_attribute (myattribute)
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp13 := yyvsp13 + 1
	yyvsp2 := yyvsp2 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp13 >= yyvsc13 then
		if yyvs13 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs13")
			end
			create yyspecial_routines13
			yyvsc13 := yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.make (yyvsc13)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs13")
			end
			yyvsc13 := yyvsc13 + yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.resize (yyvs13, yyvsc13)
		end
	end
	yyvs13.put (yyval13, yyvsp13)
end
when 252 then
--|#line 1637 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1637")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp40 := yyvsp40 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 253 then
--|#line 1638 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1638")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp39 := yyvsp39 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 254 then
--|#line 1639 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1639")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp45 := yyvsp45 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 255 then
--|#line 1640 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1640")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 256 then
--|#line 1642 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1642")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp46 := yyvsp46 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 257 then
--|#line 1646 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1646")
end

			write_pending_statement
			create myvalue.make (sqlgenerator, yyvs2.item (yyvsp2), yyvs9.item (yyvsp9))
			if immediate_output_mode then
				sqlgenerator.write_value (myvalue)
			end
			universe.add (myvalue)
			create yyval45.make (myvalue)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp45 := yyvsp45 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp2 := yyvsp2 -1
	yyvsp9 := yyvsp9 -1
	if yyvsp45 >= yyvsc45 then
		if yyvs45 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs45")
			end
			create yyspecial_routines45
			yyvsc45 := yyInitial_yyvs_size
			yyvs45 := yyspecial_routines45.make (yyvsc45)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs45")
			end
			yyvsc45 := yyvsc45 + yyInitial_yyvs_size
			yyvs45 := yyspecial_routines45.resize (yyvs45, yyvsc45)
		end
	end
	yyvs45.put (yyval45, yyvsp45)
end
when 258 then
--|#line 1659 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1659")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs9.put (yyval9, yyvsp9)
end
when 259 then
--|#line 1661 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1661")
end

create {XPLAIN_SELECTION_EXPRESSION} yyval9.make (yyvs23.item (yyvsp23)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp23 := yyvsp23 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 260 then
--|#line 1663 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1663")
end

			mytype := get_known_type (yyvs2.item (yyvsp2))
			if not sqlgenerator.CreateAutoPrimaryKey then
				report_error ("Auto primary key support disabled or not supported. Cannot retrieve auto-generated primary key.")
			end
			if mytype /= Void then
				create {XPLAIN_LAST_AUTO_PK_EXPRESSION} yyval9.make (mytype)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 261 then
--|#line 1673 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1673")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 262 then
--|#line 1674 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1674")
end

create {XPLAIN_UNMANAGED_PARAMETER_EXPRESSION} yyval9.make (yyvs13.item (yyvsp13).full_name) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp13 := yyvsp13 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 263 then
--|#line 1676 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1676")
end

yyval9 := yyvs11.item (yyvsp11) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp11 := yyvsp11 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 264 then
--|#line 1678 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1678")
end

			if is_parameter_declared (yyvs13.item (yyvsp13)) then
				create {XPLAIN_PARAMETER_EXPRESSION} yyval9.make (yyvs13.item (yyvsp13))
			end
			
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp13 := yyvsp13 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 265 then
--|#line 1686 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1686")
end

			create {XPLAIN_DATEF_FUNCTION} yyval9.make (yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 266 then
--|#line 1690 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1690")
end

			create {XPLAIN_INTEGER_FUNCTION} yyval9.make (yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 267 then
--|#line 1694 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1694")
end

			create {XPLAIN_REAL_FUNCTION} yyval9.make (yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 268 then
--|#line 1698 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1698")
end

			create {XPLAIN_STRING_FUNCTION} yyval9.make (yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs9.put (yyval9, yyvsp9)
end
when 269 then
--|#line 1704 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1704")
end

			create {XPLAIN_USER_FUNCTION} yyval9.make (yyvs2.item (yyvsp2), Void)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 270 then
--|#line 1708 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1708")
end

			create {XPLAIN_USER_FUNCTION} yyval9.make (yyvs2.item (yyvsp2), yyvs31.item (yyvsp31))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	yyvsp31 := yyvsp31 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 271 then
--|#line 1712 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1712")
end

create {XPLAIN_SQL_EXPRESSION} yyval9.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 272 then
--|#line 1717 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1717")
end

			write_pending_statement
			myvalue := get_known_value (yyvs2.item (yyvsp2))
			if myvalue /= Void then
				if immediate_output_mode then
					sqlgenerator.write_select_value (myvalue)
				end
				create yyval46.make (myvalue)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp46 := yyvsp46 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp46 >= yyvsc46 then
		if yyvs46 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs46")
			end
			create yyspecial_routines46
			yyvsc46 := yyInitial_yyvs_size
			yyvs46 := yyspecial_routines46.make (yyvsc46)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs46")
			end
			yyvsc46 := yyvsc46 + yyInitial_yyvs_size
			yyvs46 := yyspecial_routines46.resize (yyvs46, yyvsc46)
		end
	end
	yyvs46.put (yyval46, yyvsp46)
end
when 273 then
--|#line 1731 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1731")
end

			report_error ("Input not yet supported.")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp15 := yyvsp15 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 274 then
--|#line 1736 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1736")
end

			report_error ("Input not yet supported.")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 -1
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 275 then
--|#line 1744 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1744")
end

			if yyvs30.item (yyvsp30).property_required = 0 and yyvs9.item (yyvsp9 - 1) /= Void then
				report_error ("Function " + yyvs30.item (yyvsp30).name + " does not allow a property to be present.")
				abort
			elseif yyvs30.item (yyvsp30).property_required = 1 and yyvs9.item (yyvsp9 - 1) = Void then
				report_error ("Function " + yyvs30.item (yyvsp30).name + " requires the presence of a property.")
				abort
			else
				create yyval23.make (yyvs30.item (yyvsp30), yyvs22.item (yyvsp22), yyvs9.item (yyvsp9 - 1), yyvs9.item (yyvsp9))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp23 := yyvsp23 + 1
	yyvsp30 := yyvsp30 -1
	yyvsp22 := yyvsp22 -1
	yyvsp9 := yyvsp9 -2
	if yyvsp23 >= yyvsc23 then
		if yyvs23 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs23")
			end
			create yyspecial_routines23
			yyvsc23 := yyInitial_yyvs_size
			yyvs23 := yyspecial_routines23.make (yyvsc23)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs23")
			end
			yyvsc23 := yyvsc23 + yyInitial_yyvs_size
			yyvs23 := yyspecial_routines23.resize (yyvs23, yyvsc23)
		end
	end
	yyvs23.put (yyval23, yyvsp23)
end
when 276 then
--|#line 1760 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1760")
end

		create {XPLAIN_GET_STATEMENT} yyval40.make (yyvs27.item (yyvsp27))
		write_pending_statement
		if immediate_output_mode then
			sqlgenerator.write_select (yyvs27.item (yyvsp27))
		end
		subject_type := Void
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp40 := yyvsp40 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp27 := yyvsp27 -1
	if yyvsp40 >= yyvsc40 then
		if yyvs40 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs40")
			end
			create yyspecial_routines40
			yyvsc40 := yyInitial_yyvs_size
			yyvs40 := yyspecial_routines40.make (yyvsc40)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs40")
			end
			yyvsc40 := yyvsc40 + yyInitial_yyvs_size
			yyvs40 := yyspecial_routines40.resize (yyvs40, yyvsc40)
		end
	end
	yyvs40.put (yyval40, yyvsp40)
end
when 277 then
--|#line 1772 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1772")
end

			if immediate_output_mode then
				sqlgenerator.write_extend (yyvs24.item (yyvsp24))
			end
			subject_type := Void
			create yyval39.make (yyvs24.item (yyvsp24))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp39 := yyvsp39 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp24 := yyvsp24 -1
	if yyvsp39 >= yyvsc39 then
		if yyvs39 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs39")
			end
			create yyspecial_routines39
			yyvsc39 := yyInitial_yyvs_size
			yyvs39 := yyspecial_routines39.make (yyvsc39)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs39")
			end
			yyvsc39 := yyvsc39 + yyInitial_yyvs_size
			yyvs39 := yyspecial_routines39.resize (yyvs39, yyvsc39)
		end
	end
	yyvs39.put (yyval39, yyvsp39)
end
when 278 then
--|#line 1783 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1783")
end

			if extend_type.has_attribute (Void, yyvs25.item (yyvsp25).name) then
				report_error (format ("Cannot extend type `$s' with attribute `$s', because it already has an attribute with that name.", <<yyvs2.item (yyvsp2), yyvs25.item (yyvsp25).name>>))
				abort
			else
				if universe.has (yyvs25.item (yyvsp25).name) then
					report_error (format ("There is already an object (constant, value, base, type or procedure) with name `$s'. The name of an extend must be unique to avoid ambiguous expressions.", <<yyvs25.item (yyvsp25).name>>))
					abort
				else
					create yyval24.make (sqlgenerator, extend_type, yyvs25.item (yyvsp25), yyvs26.item (yyvsp26))
					--extend_type.add_extension ($$)
				end
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	yyvsp25 := yyvsp25 -1
	yyvsp26 := yyvsp26 -1
	yyvs24.put (yyval24, yyvsp24)
end
when 279 then
--|#line 1783 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1783")
end

			write_pending_statement
			extend_type := get_known_type (yyvs2.item (yyvsp2))
			subject_type := extend_type -- in case of expression extension
			
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp24 := yyvsp24 + 1
	if yyvsp24 >= yyvsc24 then
		if yyvs24 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs24")
			end
			create yyspecial_routines24
			yyvsc24 := yyInitial_yyvs_size
			yyvs24 := yyspecial_routines24.make (yyvsc24)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs24")
			end
			yyvsc24 := yyvsc24 + yyInitial_yyvs_size
			yyvs24 := yyspecial_routines24.resize (yyvs24, yyvsc24)
		end
	end
	yyvs24.put (yyval24, yyvsp24)
end
when 280 then
--|#line 1804 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1804")
end

			report_error ("Use with instead of its in the extend expression.")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp24 := yyvsp24 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp24 >= yyvsc24 then
		if yyvs24 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs24")
			end
			create yyspecial_routines24
			yyvsc24 := yyInitial_yyvs_size
			yyvs24 := yyspecial_routines24.make (yyvsc24)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs24")
			end
			yyvsc24 := yyvsc24 + yyInitial_yyvs_size
			yyvs24 := yyspecial_routines24.resize (yyvs24, yyvsc24)
		end
	end
	yyvs24.put (yyval24, yyvsp24)
end
when 281 then
--|#line 1812 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1812")
end

create yyval25.make (yyvs2.item (yyvsp2), Void) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp25 := yyvsp25 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp25 >= yyvsc25 then
		if yyvs25 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs25")
			end
			create yyspecial_routines25
			yyvsc25 := yyInitial_yyvs_size
			yyvs25 := yyspecial_routines25.make (yyvsc25)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs25")
			end
			yyvsc25 := yyvsc25 + yyInitial_yyvs_size
			yyvs25 := yyspecial_routines25.resize (yyvs25, yyvsc25)
		end
	end
	yyvs25.put (yyval25, yyvsp25)
end
when 282 then
--|#line 1814 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1814")
end

create yyval25.make (yyvs2.item (yyvsp2), yyvs15.item (yyvsp15)); yyvs15.item (yyvsp15).set_domain_restriction (sqlgenerator, dummyrestriction) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp25 := yyvsp25 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp15 := yyvsp15 -1
	if yyvsp25 >= yyvsc25 then
		if yyvs25 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs25")
			end
			create yyspecial_routines25
			yyvsc25 := yyInitial_yyvs_size
			yyvs25 := yyspecial_routines25.make (yyvsc25)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs25")
			end
			yyvsc25 := yyvsc25 + yyInitial_yyvs_size
			yyvs25 := yyspecial_routines25.resize (yyvs25, yyvsc25)
		end
	end
	yyvs25.put (yyval25, yyvsp25)
end
when 283 then
--|#line 1819 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1819")
end

create {XPLAIN_EXTENSION_EXPRESSION_EXPRESSION} yyval26.make (yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp26 := yyvsp26 + 1
	yyvsp9 := yyvsp9 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 284 then
--|#line 1821 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1821")
end

create {XPLAIN_EXTENSION_EXPRESSION_EXPRESSION} yyval26.make (yyvs8.item (yyvsp8)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp26 := yyvsp26 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp8 := yyvsp8 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 285 then
--|#line 1823 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1823")
end

-- check per attribute tree for validness
		myobject := get_object_if_valid_tree (yyvs12.item (yyvsp12))
		if myobject /= Void then
			if yyvs12.item (yyvsp12).last.item.object = extend_type then
				create {XPLAIN_EXTENSION_FUNCTION_EXPRESSION} yyval26.make (yyvs23.item (yyvsp23), yyvs12.item (yyvsp12))
			else
				report_error ("Error in per clause. The given type is `" + yyvs12.item (yyvsp12).last.item.object.name + "', while the expected type is `" + extend_type.name + "'. Make sure the per property ends in the same type that is being extended.")
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
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp26 := yyvsp26 + 1
	yyvsp23 := yyvsp23 -1
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 286 then
--|#line 1843 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1843")
end

report_error("per keyword expected instead of: " + text)
		abort 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp26 := yyvsp26 + 1
	yyvsp23 := yyvsp23 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 287 then
--|#line 1849 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1849")
end

yyval27 := yyvs28.item (yyvsp28) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp27 := yyvsp27 + 1
	yyvsp28 := yyvsp28 -1
	if yyvsp27 >= yyvsc27 then
		if yyvs27 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs27")
			end
			create yyspecial_routines27
			yyvsc27 := yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.make (yyvsc27)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs27")
			end
			yyvsc27 := yyvsc27 + yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.resize (yyvs27, yyvsc27)
		end
	end
	yyvs27.put (yyval27, yyvsp27)
end
when 288 then
--|#line 1851 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1851")
end

yyval27 := yyvs23.item (yyvsp23) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp27 := yyvsp27 + 1
	yyvsp23 := yyvsp23 -1
	if yyvsp27 >= yyvsc27 then
		if yyvs27 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs27")
			end
			create yyspecial_routines27
			yyvsc27 := yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.make (yyvsc27)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs27")
			end
			yyvsc27 := yyvsc27 + yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.resize (yyvs27, yyvsc27)
		end
	end
	yyvs27.put (yyval27, yyvsp27)
end
when 289 then
--|#line 1856 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1856")
end

create {XPLAIN_SELECTION_LIST} yyval28.make (yyvs22.item (yyvsp22), yyvs31.item (yyvsp31), yyvs9.item (yyvsp9), yyvs29.item (yyvsp29))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp28 := yyvsp28 + 1
	yyvsp22 := yyvsp22 -1
	yyvsp31 := yyvsp31 -1
	yyvsp9 := yyvsp9 -1
	yyvsp29 := yyvsp29 -1
	if yyvsp28 >= yyvsc28 then
		if yyvs28 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs28")
			end
			create yyspecial_routines28
			yyvsc28 := yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.make (yyvsc28)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs28")
			end
			yyvsc28 := yyvsc28 + yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.resize (yyvs28, yyvsc28)
		end
	end
	yyvs28.put (yyval28, yyvsp28)
end
when 290 then
--|#line 1859 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1859")
end

		  create {XPLAIN_SELECTION_LIST} yyval28.make (yyvs22.item (yyvsp22), yyvs31.item (yyvsp31), yyvs9.item (yyvsp9), yyvs29.item (yyvsp29))
			yyval28.set_identification_text (yyvs2.item (yyvsp2))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp28 := yyvsp28 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp22 := yyvsp22 -1
	yyvsp31 := yyvsp31 -1
	yyvsp9 := yyvsp9 -1
	yyvsp29 := yyvsp29 -1
	if yyvsp28 >= yyvsc28 then
		if yyvs28 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs28")
			end
			create yyspecial_routines28
			yyvsc28 := yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.make (yyvsc28)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs28")
			end
			yyvsc28 := yyvsc28 + yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.resize (yyvs28, yyvsc28)
		end
	end
	yyvs28.put (yyval28, yyvsp28)
end
when 291 then
--|#line 1866 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1866")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp29 := yyvsp29 + 1
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 292 then
--|#line 1867 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1867")
end

yyval29 := yyvs29.item (yyvsp29) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs29.put (yyval29, yyvsp29)
end
when 293 then
--|#line 1872 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1872")
end

		myobject := get_object_if_valid_tree (yyvs12.item (yyvsp12))
		if myobject /= Void then
			create {XPLAIN_SORT_NODE} yyval29.make (yyvs12.item (yyvsp12), True, Void)
		end 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp29 := yyvsp29 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 294 then
--|#line 1877 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1877")
end

		myobject := get_object_if_valid_tree (yyvs12.item (yyvsp12))
		if myobject /= Void then
			create {XPLAIN_SORT_NODE} yyval29.make (yyvs12.item (yyvsp12), False, Void)
		end 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp29 := yyvsp29 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 295 then
--|#line 1882 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1882")
end

		myobject := get_object_if_valid_tree (yyvs12.item (yyvsp12))
		if myobject /= Void then
			create {XPLAIN_SORT_NODE} yyval29.make (yyvs12.item (yyvsp12), True, yyvs29.item (yyvsp29))
		end 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -1
	yyvs29.put (yyval29, yyvsp29)
end
when 296 then
--|#line 1887 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1887")
end

		myobject := get_object_if_valid_tree (yyvs12.item (yyvsp12))
		if myobject /= Void then
			create {XPLAIN_SORT_NODE} yyval29.make (yyvs12.item (yyvsp12), False, yyvs29.item (yyvsp29))
		end 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -2
	yyvsp12 := yyvsp12 -1
	yyvs29.put (yyval29, yyvsp29)
end
when 297 then
--|#line 1895 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1895")
end

			if yyvs30.item (yyvsp30).property_required = 0 and yyvs9.item (yyvsp9 - 1) /= Void then
				report_error ("Function " + yyvs30.item (yyvsp30).name + " does not allow a property to be present.")
				abort
			elseif yyvs30.item (yyvsp30).property_required = 1 and yyvs9.item (yyvsp9 - 1) = Void then
				report_error ("Function " + yyvs30.item (yyvsp30).name + " requires the presence of a property.")
				abort
			else
				create yyval23.make (yyvs30.item (yyvsp30), yyvs22.item (yyvsp22), yyvs9.item (yyvsp9 - 1), yyvs9.item (yyvsp9))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp23 := yyvsp23 + 1
	yyvsp30 := yyvsp30 -1
	yyvsp22 := yyvsp22 -1
	yyvsp9 := yyvsp9 -2
	if yyvsp23 >= yyvsc23 then
		if yyvs23 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs23")
			end
			create yyspecial_routines23
			yyvsc23 := yyInitial_yyvs_size
			yyvs23 := yyspecial_routines23.make (yyvsc23)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs23")
			end
			yyvsc23 := yyvsc23 + yyInitial_yyvs_size
			yyvs23 := yyspecial_routines23.resize (yyvs23, yyvsc23)
		end
	end
	yyvs23.put (yyval23, yyvsp23)
end
when 298 then
--|#line 1909 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1909")
end

create {XPLAIN_MAX_FUNCTION} yyval30 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 299 then
--|#line 1911 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1911")
end

create {XPLAIN_MIN_FUNCTION} yyval30 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 300 then
--|#line 1913 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1913")
end

create {XPLAIN_TOTAL_FUNCTION} yyval30 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 301 then
--|#line 1915 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1915")
end

create {XPLAIN_COUNT_FUNCTION} yyval30 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 302 then
--|#line 1917 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1917")
end

create {XPLAIN_ANY_FUNCTION} yyval30 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 303 then
--|#line 1919 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1919")
end

create {XPLAIN_NIL_FUNCTION} yyval30 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 304 then
--|#line 1921 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1921")
end

create {XPLAIN_SOME_FUNCTION} yyval30 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 305 then
--|#line 1932 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1932")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp31 := yyvsp31 + 1
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 306 then
--|#line 1933 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1933")
end

			yyval31 := yyvs31.item (yyvsp31)
			yyval31.give_column_names (2) -- first column is always the instance id
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs31.put (yyval31, yyvsp31)
end
when 307 then
--|#line 1941 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1941")
end

create yyval31.make (yyvs9.item (yyvsp9), yyvs2.item (yyvsp2), Void) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp31 := yyvsp31 + 1
	yyvsp9 := yyvsp9 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 308 then
--|#line 1943 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1943")
end

create yyval31.make (yyvs9.item (yyvsp9), yyvs2.item (yyvsp2), yyvs31.item (yyvsp31)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp9 := yyvsp9 -1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -1
	yyvs31.put (yyval31, yyvsp31)
end
when 309 then
--|#line 1945 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1945")
end

			report_error ("its keyword should not appear after comma. Remove it.")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp31 := yyvsp31 + 1
	yyvsp9 := yyvsp9 -1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 310 then
--|#line 1950 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1950")
end

			report_error ("Superfluous comma detected. Remove it.")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp31 := yyvsp31 + 1
	yyvsp9 := yyvsp9 -1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 311 then
--|#line 1958 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1958")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp9 := yyvsp9 + 1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 312 then
--|#line 1959 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1959")
end

yyval9 := yyvs9.item (yyvsp9) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs9.put (yyval9, yyvsp9)
end
when 313 then
--|#line 1964 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1964")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp2 := yyvsp2 + 1
	if yyvsp2 >= yyvsc2 then
		if yyvs2 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs2")
			end
			create yyspecial_routines2
			yyvsc2 := yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.make (yyvsc2)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs2")
			end
			yyvsc2 := yyvsc2 + yyInitial_yyvs_size
			yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
		end
	end
	yyvs2.put (yyval2, yyvsp2)
end
when 314 then
--|#line 1965 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1965")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 315 then
--|#line 1967 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1967")
end

			report_error ("The as keyword should be followed by a name (my name) or a quoted name (`my new name'), not by a string.")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 316 then
--|#line 1975 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1975")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp9 := yyvsp9 + 1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 317 then
--|#line 1976 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1976")
end

yyval9 := yyvs8.item (yyvsp8) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp8 := yyvsp8 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 318 then
--|#line 1981 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1981")
end

		if not use_mode then
			sqlgenerator.echo(yyvs2.item (yyvsp2))
			sqlgenerator.write_echo(yyvs2.item (yyvsp2))
		end
	
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 319 then
--|#line 1996 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1996")
end

			procedure_mode := False
			create myprocedure.make (yyvs2.item (yyvsp2), yyvs12.item (yyvsp12), yyvs3.item (yyvsp3), yyvs32.item (yyvsp32))
			universe.add (myprocedure)
			if immediate_output_mode then
				sqlgenerator.write_procedure (myprocedure)
			end
			create yyval41.make (myprocedure)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 8
	yyvsp41 := yyvsp41 -1
	yyvsp3 := yyvsp3 -1
	yyvsp2 := yyvsp2 -1
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -2
	yyvsp32 := yyvsp32 -1
	yyvs41.put (yyval41, yyvsp41)
end
when 320 then
--|#line 1996 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1996")
end

			write_pending_statement
			procedure_mode := True
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp41 := yyvsp41 + 1
	if yyvsp41 >= yyvsc41 then
		if yyvs41 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs41")
			end
			create yyspecial_routines41
			yyvsc41 := yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.make (yyvsc41)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs41")
			end
			yyvsc41 := yyvsc41 + yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.resize (yyvs41, yyvsc41)
		end
	end
	yyvs41.put (yyval41, yyvsp41)
end
when 321 then
--|#line 1996 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 1996")
end

			my_parameters := yyvs12.item (yyvsp12)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp41 := yyvsp41 + 1
	if yyvsp41 >= yyvsc41 then
		if yyvs41 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs41")
			end
			create yyspecial_routines41
			yyvsc41 := yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.make (yyvsc41)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs41")
			end
			yyvsc41 := yyvsc41 + yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.resize (yyvs41, yyvsc41)
		end
	end
	yyvs41.put (yyval41, yyvsp41)
end
when 322 then
--|#line 2018 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2018")
end

yyval3 := 0 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp3 := yyvsp3 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp3 >= yyvsc3 then
		if yyvs3 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs3")
			end
			create yyspecial_routines3
			yyvsc3 := yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.make (yyvsc3)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs3")
			end
			yyvsc3 := yyvsc3 + yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.resize (yyvs3, yyvsc3)
		end
	end
	yyvs3.put (yyval3, yyvsp3)
end
when 323 then
--|#line 2019 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2019")
end

yyval3 := 1 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp3 := yyvsp3 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp3 >= yyvsc3 then
		if yyvs3 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs3")
			end
			create yyspecial_routines3
			yyvsc3 := yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.make (yyvsc3)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs3")
			end
			yyvsc3 := yyvsc3 + yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.resize (yyvs3, yyvsc3)
		end
	end
	yyvs3.put (yyval3, yyvsp3)
end
when 324 then
--|#line 2020 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2020")
end

yyval3 := 2 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp3 := yyvsp3 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp3 >= yyvsc3 then
		if yyvs3 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs3")
			end
			create yyspecial_routines3
			yyvsc3 := yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.make (yyvsc3)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs3")
			end
			yyvsc3 := yyvsc3 + yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.resize (yyvs3, yyvsc3)
		end
	end
	yyvs3.put (yyval3, yyvsp3)
end
when 325 then
--|#line 2021 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2021")
end

yyval3 := 3 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp3 := yyvsp3 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp3 >= yyvsc3 then
		if yyvs3 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs3")
			end
			create yyspecial_routines3
			yyvsc3 := yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.make (yyvsc3)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs3")
			end
			yyvsc3 := yyvsc3 + yyInitial_yyvs_size
			yyvs3 := yyspecial_routines3.resize (yyvs3, yyvsc3)
		end
	end
	yyvs3.put (yyval3, yyvsp3)
end
when 326 then
--|#line 2025 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2025")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp12 := yyvsp12 + 1
	if yyvsp12 >= yyvsc12 then
		if yyvs12 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs12")
			end
			create yyspecial_routines12
			yyvsc12 := yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.make (yyvsc12)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs12")
			end
			yyvsc12 := yyvsc12 + yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.resize (yyvs12, yyvsc12)
		end
	end
	yyvs12.put (yyval12, yyvsp12)
end
when 327 then
--|#line 2026 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2026")
end

yyval12 := yyvs12.item (yyvsp12) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs12.put (yyval12, yyvsp12)
end
when 328 then
--|#line 2031 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2031")
end

create yyval12.make (yyvs13.item (yyvsp13), Void) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp12 := yyvsp12 + 1
	yyvsp13 := yyvsp13 -1
	if yyvsp12 >= yyvsc12 then
		if yyvs12 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs12")
			end
			create yyspecial_routines12
			yyvsc12 := yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.make (yyvsc12)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs12")
			end
			yyvsc12 := yyvsc12 + yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.resize (yyvs12, yyvsc12)
		end
	end
	yyvs12.put (yyval12, yyvsp12)
end
when 329 then
--|#line 2033 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2033")
end

create yyval12.make (yyvs13.item (yyvsp13), yyvs12.item (yyvsp12)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp13 := yyvsp13 -1
	yyvsp1 := yyvsp1 -1
	yyvs12.put (yyval12, yyvsp12)
end
when 330 then
--|#line 2038 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2038")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp32 := yyvsp32 + 1
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 331 then
--|#line 2039 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2039")
end

yyval32 := yyvs32.item (yyvsp32) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs32.put (yyval32, yyvsp32)
end
when 332 then
--|#line 2044 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2044")
end

			create yyval32.make (yyvs33.item (yyvsp33), Void)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp32 := yyvsp32 + 1
	yyvsp33 := yyvsp33 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 333 then
--|#line 2048 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2048")
end

			create yyval32.make (yyvs33.item (yyvsp33), yyvs32.item (yyvsp32))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp33 := yyvsp33 -1
	yyvsp1 := yyvsp1 -1
	yyvs32.put (yyval32, yyvsp32)
end
when 334 then
--|#line 2052 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2052")
end

			create yyval32.make (yyvs42.item (yyvsp42), Void)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp32 := yyvsp32 + 1
	yyvsp42 := yyvsp42 -1
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 335 then
--|#line 2056 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2056")
end

			create yyval32.make (yyvs42.item (yyvsp42), yyvs32.item (yyvsp32))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp42 := yyvsp42 -1
	yyvs32.put (yyval32, yyvsp32)
end
when 336 then
--|#line 2060 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2060")
end

			if equal (text, "end") then
				report_error ("Unexpected 'end' in stored procedure. '.' missing in last statement?")
				abort
			else
				report_error ("Stumbled upon: " + text)
				abort
		end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 337 then
--|#line 2070 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2070")
end

report_error ("A base statement cannot appear in a procedure."); abort 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 338 then
--|#line 2072 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2072")
end

report_error ("A type statement cannot appear in a procedure."); abort 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 339 then
--|#line 2074 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2074")
end

report_error ("An assert statement cannot appear in a procedure."); abort 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 340 then
--|#line 2076 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2076")
end

report_error ("An init statement cannot appear in a procedure."); abort 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 341 then
--|#line 2078 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2078")
end

report_error ("A procedure statement cannot appear in a procedure."); abort 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -2
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 342 then
--|#line 2083 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2083")
end

yyval33 := yyvs39.item (yyvsp39) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp39 := yyvsp39 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 343 then
--|#line 2085 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2085")
end

yyval33 := yyvs38.item (yyvsp38) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp38 := yyvsp38 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 344 then
--|#line 2087 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2087")
end

yyval33 := yyvs33.item (yyvsp33) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs33.put (yyval33, yyvsp33)
end
when 345 then
--|#line 2089 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2089")
end

yyval33 := yyvs40.item (yyvsp40) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp40 := yyvsp40 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 346 then
--|#line 2091 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2091")
end

yyval33 := yyvs44.item (yyvsp44) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp44 := yyvsp44 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 347 then
--|#line 2093 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2093")
end

yyval33 := yyvs45.item (yyvsp45) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp45 := yyvsp45 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 348 then
--|#line 2095 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2095")
end

yyval33 := yyvs46.item (yyvsp46) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp46 := yyvsp46 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 349 then
--|#line 2105 "xplain_parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'xplain_parser.y' at line 2105")
end

			create yyval42.make (yyvs2.item (yyvsp2))
			if immediate_output_mode then
				sqlgenerator.write_sql (yyvs2.item (yyvsp2))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp42 := yyvsp42 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp42 >= yyvsc42 then
		if yyvs42 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs42")
			end
			create yyspecial_routines42
			yyvsc42 := yyInitial_yyvs_size
			yyvs42 := yyspecial_routines42.make (yyvsc42)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs42")
			end
			yyvsc42 := yyvsc42 + yyInitial_yyvs_size
			yyvs42 := yyspecial_routines42.resize (yyvs42, yyvsc42)
		end
	end
	yyvs42.put (yyval42, yyvsp42)
end
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: unknown rule id: ")
					std.error.put_integer (yy_act)
					std.error.put_new_line
				end
				abort
			end
		end

	yy_do_error_action (yy_act: INTEGER) is
			-- Execute error action.
		do
			inspect yy_act
			when 614 then
					-- End-of-file expected action.
				report_eof_expected_error
			else
					-- Default action.
				report_error ("parse error")
			end
		end

feature {NONE} -- Table templates

	yytranslate_template: SPECIAL [INTEGER] is
			-- Template for `yytranslate'
		once
			Result := yyfixed_array (<<
			    0,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,  126,  118,    2,    2,
			  121,  122,  116,  114,  123,  115,  120,  117,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,  125,  128,
			  110,  108,  111,  124,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,  129,    2,  130,    2,  127,    2,    2,    2,    2,

			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,

			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    1,    2,    3,    4,
			    5,    6,    7,    8,    9,   10,   11,   12,   13,   14,
			   15,   16,   17,   18,   19,   20,   21,   22,   23,   24,
			   25,   26,   27,   28,   29,   30,   31,   32,   33,   34,
			   35,   36,   37,   38,   39,   40,   41,   42,   43,   44,

			   45,   46,   47,   48,   49,   50,   51,   52,   53,   54,
			   55,   56,   57,   58,   59,   60,   61,   62,   63,   64,
			   65,   66,   67,   68,   69,   70,   71,   72,   73,   74,
			   75,   76,   77,   78,   79,   80,   81,   82,   83,   84,
			   85,   86,   87,   88,   89,   90,   91,   92,   93,   94,
			   95,   96,   97,   98,   99,  100,  101,  102,  103,  104,
			  105,  106,  107,  109,  112,  113,  119, yyDummy>>)
		end

	yyr1_template: SPECIAL [INTEGER] is
			-- Template for `yyr1'
		once
			Result := yyfixed_array (<<
			    0,  234,  234,  234,  234,  131,  132,  235,  235,  236,
			  236,  236,  236,  236,  214,  214,  214,  215,  215,  215,
			  217,  217,  217,  217,  217,  217,  217,  217,  237,  237,
			  219,  219,  133,  133,  133,  230,  238,  244,  239,  245,
			  218,  242,  243,  246,  243,  247,  135,  135,  135,  135,
			  136,  136,  137,  137,  138,  138,  138,  139,  140,  140,
			  141,  141,  142,  143,  143,  144,  144,  144,  145,  145,
			  147,  147,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  148,  148,  148,  148,  148,  148,
			  149,  149,  150,  150,  151,  151,  151,  152,  152,  153,

			  153,  153,  153,  153,  153,  153,  153,  153,  153,  153,
			  153,  153,  153,  153,  153,  153,  153,  153,  154,  154,
			  155,  155,  156,  156,  157,  158,  248,  159,  159,  159,
			  160,  161,  249,  250,  250,  252,  253,  253,  251,  162,
			  162,  162,  162,  162,  162,  162,  162,  162,  162,  162,
			  163,  163,  163,  164,  165,  166,  167,  168,  169,  169,
			  169,  170,  170,  170,  170,  170,  171,  171,  172,  172,
			  173,  174,  175,  176,  180,  180,  181,  181,  182,  182,
			  182,  182,  182,  182,  182,  182,  177,  177,  177,  178,
			  178,  178,  179,  179,  179,  179,  134,  134,  183,  254,

			  183,  183,  184,  255,  240,  241,  256,  241,  257,  241,
			  258,  241,  259,  185,  185,  186,  186,  186,  216,  216,
			  261,  261,  261,  261,  226,  226,  226,  226,  226,  187,
			  187,  187,  188,  189,  189,  220,  262,  221,  221,  221,
			  222,  223,  190,  191,  191,  191,  191,  191,  231,  231,
			  192,  192,  260,  260,  260,  260,  260,  232,  193,  193,
			  193,  193,  193,  193,  193,  193,  193,  193,  193,  193,
			  193,  193,  233,  264,  264,  194,  225,  224,  195,  265,
			  195,  196,  196,  197,  197,  197,  197,  198,  198,  199,
			  199,  200,  200,  201,  201,  201,  201,  202,  203,  203,

			  203,  203,  203,  203,  203,  204,  204,  205,  205,  205,
			  205,  206,  206,  207,  207,  207,  208,  208,  263,  227,
			  266,  267,  228,  228,  228,  228,  209,  209,  210,  210,
			  211,  211,  212,  212,  212,  212,  212,  212,  212,  212,
			  212,  212,  213,  213,  213,  213,  213,  213,  213,  229, yyDummy>>)
		end

	yytypes1_template: SPECIAL [INTEGER] is
			-- Template for `yytypes1'
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    2,    2,    2,    2,    2,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    4,    2,    2,   19,   33,   33,   33,   33,   34,
			   35,   36,   38,   39,   40,   33,   41,    3,   42,   43,
			   44,   45,   46,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    2,    1,    1,    1,    2,
			    2,    1,    2,    2,   22,    2,    1,    2,    2,    2,
			   22,    1,    1,    2,    1,    1,    1,    1,    1,    1,
			    1,    2,   22,   27,   28,   23,   30,    2,   24,    2,

			   22,    2,    1,    2,    2,    2,    2,    2,    1,    1,
			    1,   41,    1,    1,    2,    1,    1,    2,    1,    1,
			    1,    2,    9,    1,    1,    1,    1,    1,   16,    2,
			    1,    1,    1,    1,    1,   14,    2,   22,    1,   31,
			    1,   22,    1,    1,    1,    9,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,   15,    1,   15,    1,
			    1,    1,    1,    1,    5,    5,    2,    2,    1,    1,
			    1,    2,    1,    1,    2,    1,    1,    1,    1,    1,
			    1,    1,    3,    2,    2,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,   10,   11,    2,    2,

			    2,    3,    2,    9,    9,    9,    9,    8,    9,    9,
			    9,   23,   30,    1,   13,    2,   13,    2,    1,    2,
			    2,    2,   20,   21,   13,    3,    3,    1,    1,    1,
			    1,   20,   14,   14,   31,    1,    1,    1,    1,    1,
			    2,    1,    1,    1,    1,    1,    1,    1,   10,   11,
			    9,    9,    9,    2,   12,   13,    2,    2,    2,   31,
			    9,   22,    1,    9,   24,    1,    1,    1,    8,    9,
			    9,   10,    9,   12,    1,    3,    1,    1,    3,    1,
			    3,    1,    3,   36,    1,    5,    1,   19,    1,    2,
			    2,    5,    6,    7,    2,    3,    1,    9,    1,   12,

			    1,    1,    1,    1,    2,    1,    2,   13,   13,    9,
			    8,    1,    9,    2,    9,    9,    9,    9,    1,   10,
			    2,   15,    1,    1,    1,    1,    1,    1,    1,    1,
			    2,    1,    1,    1,    1,   22,   15,    1,    1,    1,
			    9,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			   17,   18,   13,    1,   13,   20,    1,    9,    2,   13,
			   13,    9,    1,   12,    9,    9,    9,    9,   31,    8,
			    8,    1,    2,    1,    1,    2,    1,    1,    1,    2,
			    1,    1,    1,   29,    1,    1,   12,    9,    9,    2,
			   25,   13,    8,    9,    1,    1,   10,    9,   12,    1,

			    1,    1,    1,    2,    1,    1,    1,    1,    1,   13,
			    2,    2,    1,    1,    1,    1,    9,    1,   13,   12,
			    1,    1,    2,    1,    1,    2,    1,    1,    1,    9,
			    1,    1,    1,    1,    8,    9,    9,    9,    9,    9,
			    8,    9,    9,    2,    2,    2,   20,    1,    9,    9,
			   13,   13,   13,   13,    1,    1,   13,   13,   29,    1,
			    1,    9,    1,    1,    1,    1,    1,    1,    2,    2,
			    1,    9,    9,   12,    2,    1,   12,   29,   12,   13,
			   12,   15,    1,    1,   13,    8,    2,    9,    8,    1,
			    1,    9,    3,    1,    5,    5,    1,    2,    2,    6,

			    7,    1,    1,   41,    1,    2,   12,    1,    1,   31,
			    1,    9,    8,    1,   17,    1,    1,   31,    1,    9,
			    1,    1,   31,   12,    1,    1,    1,    1,    9,   26,
			   23,    1,    9,    1,    1,    9,   23,   37,    1,    1,
			   12,    1,    1,    1,    1,    1,    1,   32,   32,   33,
			   38,   39,   40,   33,   42,   44,   45,   46,   12,    1,
			   12,    1,    1,    1,    1,    9,    9,    1,    1,    1,
			   29,   12,    8,    1,    1,    8,    1,   26,    1,    1,
			    1,    1,    1,    1,    1,   32,   12,    8,    9,    9,
			    9,   29,    1,   12,    1,   12,   12,   32,    1,    1,

			    2,    3,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    9,    9,    1,    1,    1, yyDummy>>)
		end

	yytypes2_template: SPECIAL [INTEGER] is
			-- Template for `yytypes2'
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    2,    2,    2,    2,    3,    1,

			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1, yyDummy>>)
		end

	yydefact_template: SPECIAL [INTEGER] is
			-- Template for `yydefact'
		once
			Result := yyfixed_array (<<
			    0,    0,    4,    0,  168,    0,    6,  349,    0,  324,
			  323,  325,  322,    0,    0,    0,    0,    0,    0,    0,
			   37,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			   13,   21,    0,  155,   25,    0,   14,   15,   17,   24,
			   19,  223,  221,  253,  252,  222,   16,  320,    0,   20,
			  220,  254,  256,    0,    8,   18,   22,   23,   26,   27,
			   28,   29,  218,  219,  255,  169,    5,    0,    0,  206,
			  153,    0,  272,  243,    0,    0,    0,   43,   41,  156,
			    0,   39,    0,  170,  300,  304,  303,  299,  298,  301,
			  302,    0,  305,  276,  287,  288,    0,    0,  277,  318,

			  316,    0,  204,    0,    0,  154,    0,  203,    0,    0,
			    0,    0,   11,    0,  208,    0,    0,  210,    0,    0,
			    0,  244,  242,    0,  249,    0,    0,  152,    0,   45,
			    0,    0,    0,  226,    0,   36,  126,  305,    0,  316,
			    0,  311,  279,  280,    0,  241,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,  149,   40,  236,    0,    0,
			  199,    0,    0,   49,    0,   48,   47,   62,    0,   31,
			   12,  326,    0,    0,  212,    0,    0,    0,    0,    0,
			    0,    0,  171,  172,  271,    0,    0,    0,    0,    0,
			   90,   92,    0,   93,    0,   91,  183,  263,  193,  195,

			  182,  118,  119,  258,  180,  188,  191,  173,  174,  176,
			  257,  259,    0,    0,  245,    0,  124,  166,  247,    0,
			    0,  250,  316,    0,    0,    0,    0,    0,    0,    0,
			    0,  224,   38,    0,  316,    0,    0,    0,    0,    0,
			  117,  107,    0,    0,    0,    0,    0,    0,  112,  101,
			  313,   95,   98,  111,   99,  120,    0,  157,  110,  306,
			  291,  213,    0,  316,    0,    0,    0,    0,  317,   71,
			   69,  112,    0,   99,  147,    0,  145,  144,    0,  142,
			    0,  140,    0,    0,   33,   34,  200,    0,   59,    0,
			   58,   46,   50,   51,   52,   54,    0,    0,    0,    0,

			    0,    3,    0,    0,    0,    0,    0,  262,  264,  180,
			    0,    0,  194,  260,    0,    0,    0,    0,    0,  184,
			  181,  273,    0,    0,   87,   85,   86,   84,   89,   88,
			    0,    0,    0,    0,    0,  311,    0,    0,  246,    0,
			  248,    0,  231,    0,  151,  150,    0,    0,    0,    0,
			   35,    0,  162,    0,   42,  225,    0,  291,    0,  113,
			  114,    0,    0,  100,    0,    0,    0,    0,    0,  130,
			    0,    0,  307,   64,   63,    0,   67,   66,   65,    0,
			    0,    0,    0,  289,  213,    0,  227,  312,  297,    0,
			    0,  114,    0,    0,    0,    0,  112,    0,   99,    0,

			    0,   89,   88,    0,    0,  148,  143,  141,  139,    0,
			  202,  196,    0,    0,    0,    0,  201,   30,  328,  327,
			  321,    2,    0,    0,    0,    0,    0,  192,  178,    0,
			  268,  267,  266,  265,    0,  187,  186,  185,  190,  189,
			  175,  177,  316,  274,  167,  251,  230,    0,  233,  232,
			    0,  165,  164,  163,    0,  160,   44,    0,  290,    0,
			  108,    0,  106,  105,  104,  103,  102,    0,  315,  314,
			    0,   94,   97,  121,  123,    0,  293,  292,  228,    0,
			  214,  282,    0,   80,  114,    0,    0,   70,   68,   77,
			   76,   78,    0,    0,    0,  197,   61,    0,   60,   53,

			   55,   56,    0,    0,    0,    0,  205,    0,  269,    0,
			  179,  275,    0,  161,  159,    0,  115,    0,  109,    0,
			  310,  309,  308,  294,    0,    0,  217,    0,  283,  278,
			    0,   81,   79,  146,    0,  238,    0,  235,    0,   57,
			  329,    0,    0,    0,    0,    0,  336,    0,  331,    0,
			  343,  342,  345,  344,    0,  346,  347,  348,  207,    0,
			  209,  270,  234,    0,    0,  127,  125,  116,    0,    0,
			  295,  216,    0,    0,  286,    0,    0,  198,  341,  338,
			  340,  337,  339,  319,    0,  335,  211,    0,  131,    0,
			   96,  296,  284,  285,  239,  240,  237,  333,  128,    0,

			  137,  136,  129,    0,    0,    0,    0,  132,  134,  133,
			    0,    0,  135,  138,    0,    0,    0, yyDummy>>)
		end

	yydefgoto_template: SPECIAL [INTEGER] is
			-- Template for `yydefgoto'
		once
			Result := yyfixed_array (<<
			    3,    5,   31,  494,  164,  291,  292,  293,  165,  289,
			  497,  166,  375,  379,  268,  269,  270,  330,  248,  249,
			  393,  251,  252,  253,  254,  255,  214,  135,  566,  370,
			  589,  156,  128,  136,  104,  199,   78,  256,  350,  351,
			  216,  257,  258,  201,  202,  203,  204,  205,  206,  207,
			  208,  209,   34,  411,  386,  480,  222,  223,  449,   74,
			  122,  224,  210,  211,   98,  390,  529,   93,   94,  383,
			  477,  530,  212,  139,  259,  263,  372,  145,  299,  419,
			  547,  548,  549,   35,   36,   37,   38,   39,   40,   41,
			  537,  596,   42,   43,   44,   45,   46,   47,   48,   49,

			   50,   51,   52,  614,   53,   54,   55,   56,   57,   58,
			   59,   60,   61,   82,  134,  130,  228,  233,  602,  603,
			  607,  604,  605,  287,  108,  116,  173,  176,  303,   62,
			   63,  283,   64,  213,  264,  111,  503, yyDummy>>)
		end

	yypact_template: SPECIAL [INTEGER] is
			-- Template for `yypact'
		once
			Result := yyfixed_array (<<
			   46,   29, -32768, 1629,   29,  478, -32768, -32768,  152, -32768,
			 -32768, -32768, -32768,   29,  513,   29,   29,   29,   31,   29,
			  567, 1014,   29,  490,   29,   29,  584,   29,   29,   29,
			 -32768, -32768,  471, -32768, -32768,  468, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, 1575, -32768,
			 -32768, -32768, -32768,  559, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768,   29,  488, -32768,
			 -32768,   29,  465,  -43,   66,  120,   29, -32768, -32768,  543,
			   67, -32768,   29, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768,   29,  526, -32768,  545, -32768,   29,  200, -32768, -32768,

			  305,  544, -32768,  542,  544, -32768,  169,  168,   21,   41,
			 1515,   29, -32768,  446, -32768,   29,  541, -32768,  925,   29,
			   25, -32768, -32768,   29, -32768,  466,  460, -32768,  453, -32768,
			  530,  527,   29, -32768,   29, -32768, -32768,  526, 1258,  305,
			   29,  404, -32768, -32768, 1127, -32768,  429,  450,  425,  416,
			  438,  409,  432,  407,  430, -32768, -32768, -32768,  117,  522,
			 -32768,  132,   42, -32768,  414, -32768, -32768, -32768,  274, -32768,
			 -32768,  463,  318,  495, -32768,   29,  485,   29,   29,   29,
			  274,  242, -32768, -32768, -32768,   29,  925,  925,  925,  925,
			 -32768, -32768,  114, -32768,  544, -32768, -32768, -32768, -32768, -32768,

			 -32768, -32768, -32768, -32768,  860,  231, -32768, -32768,  473,  497,
			 -32768, -32768,   29,  519, -32768,  383, -32768,  375, -32768,  382,
			  380,  375,  305,   54,  384,  372,  362,  346,  464,   29,
			   29, -32768, -32768,  461,  305,   29,   29,   29, 1258,  -37,
			 -32768, -32768, 1258, 1258, 1258, 1258, 1258, 1127, -32768, -32768,
			  483,  252,  154, -32768, -32768,  459,  356,  739, -32768, -32768,
			  392,    9, 1258,  305,   29,   29, 1127, 1381, -32768,  479,
			  445,  676,  580,  670, -32768,   48, -32768, -32768,  357, -32768,
			  355, -32768,  343,   29, -32768, -32768, -32768,   29, -32768,  345,
			 -32768, -32768, -32768, -32768,  340,  121,  925,  339,   29,  352,

			  458, -32768,   29,  431,  348,   29,  322, -32768, -32768,  760,
			  329,  242, -32768, -32768,  328,  327,  325,  317,  274, -32768,
			 -32768, -32768,  242,  242, -32768, -32768, -32768, -32768, -32768, -32768,
			  242,  242,  242,  274,  274,  404,  295,   29, -32768,   29,
			 -32768,   29, -32768, 1339, -32768, -32768,   29,   29,   29,   29,
			 -32768,   56, -32768,   29, -32768, -32768,   29,  392,  321, -32768,
			 -32768,  309, 1258, -32768,  307,  303,  302,  301,  299, -32768,
			  377,  259,  297, -32768, -32768, 1258, -32768, -32768, -32768, 1453,
			   29,   29,  -30, -32768,  388,   29, -32768, -32768, -32768,  888,
			  308,  540,  290,  359,   29, 1127,  514,  482,  373, 1127,

			 1127,  378,  370, 1258,  306, -32768, -32768, -32768, -32768,  294,
			 -32768,  275,   87,  295,  292,  381, -32768, -32768,  265, -32768,
			 -32768, -32768,  270,   29,   29,  256, 1250, -32768, -32768,  145,
			 -32768, -32768, -32768, -32768,  234,  231,  231,  210, -32768, -32768,
			 -32768, -32768,  305, -32768, -32768, -32768, -32768, 1127, -32768, -32768,
			  220, -32768, -32768, -32768,  346, -32768, -32768,  203, -32768, 1169,
			 -32768,  219, -32768, -32768, -32768, -32768, -32768, 1258, -32768, -32768,
			 1047, -32768, -32768, -32768, -32768,   29,  184, -32768, -32768,   55,
			 -32768, -32768,  783, -32768,  253,  216, 1258, -32768, -32768, -32768,
			 -32768, -32768,  205,  883,  192, -32768, -32768,  198, -32768, -32768,

			 -32768, -32768,   29, 1682,   29,  182, -32768,   29, -32768,  183,
			 -32768, -32768,  165, -32768, -32768, 1005, -32768,  162, -32768,  263,
			 -32768, -32768, -32768,  151,  -30,   29, -32768, 1127, -32768, -32768,
			   44, -32768, -32768, -32768, 1127, -32768,  207, -32768,  783, -32768,
			 -32768,  257,  221,  211,  195,  185, -32768,  189, -32768,   61,
			 -32768, -32768, -32768, -32768, 1403, -32768, -32768, -32768, -32768,   29,
			 -32768, -32768, -32768, 1127, 1258, -32768, -32768, -32768, 1258,  -30,
			 -32768, -32768,   28,   29, -32768,   -6,   29, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, 1069, -32768, -32768,  -15, -32768,   65,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,   42,

			 -32768, -32768, -32768,  135,  -46,  -39,  -49, -32768, -32768, -32768,
			 1005, 1005, -32768, -32768,   69,   64, -32768, yyDummy>>)
		end

	yypgoto_template: SPECIAL [INTEGER] is
			-- Template for `yypgoto'
		once
			Result := yyfixed_array (<<
			 -32768, -32768, -32768, -32768,  484, -32768,  240,  241,  229, -32768,
			 -32768, -32768, -32768, -32768, -242, -32768,  239, -224,  266, -114,
			   19,  254, -32768,  428,  160,  395, -167,  494, -210, -32768,
			 -32768,  -98, -32768,   33, -32768,   18, -32768,  150,  173, -32768,
			  178,   12,  -21, -159, -32768,  469, -166,   63, -171, -163,
			  279, -32768, -32768, -32768,  228, -353, -125, -32768, -32768,   -1,
			 -32768, -220,  -76, -32768, -32768, -32768,   72, -32768, -32768,  248,
			 -492,  -19,  -20,  474, -238,  271, -32768, -120, -32768,  101,
			 -32768, -493, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -251, -252, -253, -258, -32768, -32768, -275, -32768,

			 -286, -301, -465, -32768, -32768,   -4, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768,   -2, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, yyDummy>>)
		end

	yytable_template: SPECIAL [INTEGER] is
			-- Template for `yytable'
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1776)
			yytable_template_1 (an_array)
			yytable_template_2 (an_array)
			Result := yyfixed_array (an_array)
		end

	yytable_template_1 (an_array: ARRAY [INTEGER]) is
			-- Fill chunk #1 of template for `yytable'.
		do
			yyarray_subcopy (an_array, <<
			   91,   96,   95,  295,  197,  369,  158,  231,  368,  354,
			  312,  307,  308,    6,  309,   33,   65,  310,   80,  260,
			   92,   32,  163,  100,  392,   70,  218,   72,   73,   70,
			   79,   73,  570,   73,   97,  385,   73,   33,  557,  103,
			  105,  107,  169,  101,  112,  574,   69,    2,  403,  405,
			   75,   77,  121,   83,   76,  342,  526,  455,    4,    1,
			   33,  585,  106,  409,  616,    4,   32,  124,  133,  615,
			  360,  506,  197,  197,  197,  197,  611,  591,  120,   70,
			  573,  119,  609,   70,  362,  475,  610,  167,   70,  557,
			  137,  597,  123,  132,   70,  141,  321,  200,  391,  599,

			  114, -229,  340,   73,  117,  355,  170,  598,   73,  129,
			  314,  315,  316,  317,  357,  336,  594,   83,  163,  557,
			    4,  127,   33,  171,    4,  384,    4,   70,   32,  162,
			   33,  217,  219,  456,  195,  221,  457,  167,   83,  261,
			  182,  294,  161,  388,  221,  429,   70,  200,  174,  606,
			  592,  558,   73,  485,  560,  434,  190,  250,  488,  200,
			  438,  439,  168,  272,  437,  200,  200,  200,  200,  403,
			  440,  404,  571,  486, -229, -215, -158,  341,  525,  454,
			   33,  584,  197,  131,  183,  182,  582,  304,  509,  306,
			  217,  217,   33,   33, -153,  160,  581,   70,   33,   33,

			   33,   33,  556,  496,   33,  512,  586,  583,  284,    4,
			  320,  335,  580,   83, -153,  159,  446,  555,  313,  126,
			  416,  517,  579,  125,   73,  162,  143,  484,  554,  183,
			  182,   83,  522,  182,   68,  318,   67,  -32,  161,  217,
			  415,  221,  221,  576,  414,  553,  142,  358,  288,  217,
			  552,  551,  550,  556,  -75,  295,  -75,  361,  578,  323,
			  322,  364,  365,  366,  367,  250,  272,  427,  555,  215,
			  378,  377,  376,  220,  569,  200,  389,  217,  -75,  554,
			  568,  387,  220,  556,  567,  572,  397,  562,  -75,  -75,
			  559,  481,  575,  -75,  195,  221,  553,  200,  555,  410,

			  538,  552,  551,  550,  273,  561,  192,  524,   33,  554,
			  217,  515,  200,  200,  422,  443,  190,  425,   -1,  301,
			  539,  587,  511,   33,  323,  322,  553,  533,  215,  215,
			   33,  552,  551,  550,   33,   33,  300,    4,  531,  183,
			  182,  518,   33,   33,   33,   33,   33,  332,  331,  444,
			  513,  445,  144,  221,    4,  468,  510,  181,  217,  217,
			  217,  217,  448,  311,  507,  221,  374,  373,  221,    4,
			   83,  183,  182,  -75,  -73,  -75,  -73,  215,  504,  220,
			  220,  461,  501,  469,  196,  435,  436,  215,  502,  181,
			  182,   83,  294,  474,  471,  180,  161,  217,  -73,  363,

			  612,  613,  493,  490,  492,  352,  217,  273,  -73,  -73,
			  271,  489,  483,  -73,  385,  215,  482,  467,  272,  272,
			  470,  466,  491,  465,  464,  463,  273,  398,  382,  462,
			  262,  460,  349,  220,  196,  505,  217,  348,  347,  433,
			  601,    4,  459,  426,  601,  250,  196,  432,  215,  431,
			  430,  428,  196,  196,  196,  196,  424,  423,  319,  421,
			  420,  417,   96,  413,  412,  408,  217,  402,  401,  327,
			  326,  325,  324,   96,  536,  346,  418,  407,  250,  406,
			  400,  460,  399,  381,  345,  380,  519,  356,  371,  250,
			  353,  220,  343,  -73,  344,  -73,  215,  215,  215,  215,

			  334,  528, -157,  220,  338,  532,  220,  339,  333,  298,
			  337,  305,  535,  271,  217,  -83,  217,  -83,   96,  217,
			  155,  302,  296,  286,  450,  451,  452,  453,  282,  281,
			  280,  279,  271,  396,  565,  215,  278,  217,  277,  -83,
			  473,  -74,  476,  -74,  215,  155,  198,  276,  275,  -83,
			  -83,  274,  138,  230,  -83,  273,  229,  528,  226,  273,
			  273,  227,  196,  479,  225,  -74,  172,  175,  157, -153,
			  140,  217,  115,  118,  215,  -74,  -74,  113,  600,  109,
			  -74,   81,  600,  588,  196,  102,   99,  590,  110,  290,
			  329,  328,  327,  326,  325,  324,  198,   71,   66,  196,

			  196,  608,  479,  540,  215,  458,  442,  273,  198,  198,
			  577,  234,  478,  441,  198,  198,  198,  198,  154,  153,
			  152,  151,  150,  149,  148,  147,  146,  514,  232,  565,
			  565,  359,  352,  472,  -83,  523,  -83,  297,  487, -261,
			  495, -261,  285,  154,  153,  152,  151,  150,  149,  148,
			  147,  146,  215,  499,  215,  500,    0,  215,    0,    0,
			  -74,  271,  -74,    0,    0,  271,  271,    0,    0,    0,
			    0,  -72,    0,  -72,    0,  215,    0,  -82,    0,  -82,
			  418,    0,  479,    0,  476,  479,    0,  273,  402,  401,
			  327,  326,  325,  324,  273,  -72,    0,    0,    0,    0,

			    0,  -82,    0,  479,    0,  -72,  -72,    0,    0,  215,
			  -72,  -82,  -82,  271,    0,    0,  -82,    0,    0,    0,
			    0,    0,    0,  273,  198,    0,    0,    0,    0,  476,
			    0,    0,    0,  593,    0,    0,  595,  479,    0,  198,
			 -122,    0, -122,    0, -122,    0,  198,    0,    0,    0,
			  198,  198,    0, -122,    0,    0, -122,    0,  198,  198,
			  198,  198,  198,    0, -122, -122,    0,    0,    0,    0,
			    0,    0,    0, -122, -122, -122,    0,    0,    0, -122,
			    0,    0,    0,    0,    0,    0, -122,   90,    0,    0,
			  -72,    0,  -72,  271,    0,   89,  -82,    0,  -82,    0,

			  271,    0,    0,  195,    0,  247,    0,    0,    0,    0,
			  193,   88,   87,    0,   86,    0,    0,    0,    0,    0,
			    0,   85,  191,    0,   84,  190,    0,    0,    0,  271,
			    0,  246,    0,    0,    0, -122,    0, -122,    0,    0,
			  498,  245,  244,  243,  242,    0,    0, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122,    0, -122,
			    0, -122, -122,    0,    0,    0,    0, -122,  329,  328,
			  327,  326,  325,  324,  323,  322,  241,  240,    4,   83,
			  183,  182,  427,    0,    0,    0,    0,   90,    0,  155,
			    0,    0,    0,    0,    0,   89,    0,    0,  239,    0,

			    0,    0,    0,  195,  527,  247,    0,  237,  236,  235,
			  193,   88,   87,    0,   86,    0,    0,    0,    0,    0,
			    0,   85,  191,    0,   84,  190,    0,    0,    0,   90,
			    0,  246,    0,    0,    0,    0,    0,   89,    0,    0,
			    0,  245,  244,  243,  242,  195,    0,    0,    0,  194,
			    0,    0,  193,   88,   87,    0,   86,  192,    0,    0,
			    0,    0,    0,   85,  191,    0,   84,  190,  329,  328,
			  327,  326,  325,  324,  323,  322,  241,  240,    4,   83,
			  183,  182,    0,  189,  188,  187,  186,  154,  153,  152,
			  151,  150,  149,  148,  147,  146, -281,    0,  239,    0, yyDummy>>,
			1, 1000, 0)
		end

	yytable_template_2 (an_array: ARRAY [INTEGER]) is
			-- Fill chunk #2 of template for `yytable'.
		do
			yyarray_subcopy (an_array, <<
			    0,    0,    0,    0,  534,    0,    0,  237,  236,  235,
			  185,    0,    0,    0,  564,    0,    0,    0,   90,  184,
			    4,   83,  183,  182,    0,  195,   89,  247,    0,    0,
			    0,    0,  193,    0,    0,    0,    0,    0,    0,    0,
			  181,    0,   88,   87,  191,   86,  180,  190,    0,  179,
			  178,  177,   85,  246,    0,   84,    0,    0,    0,    0,
			    0,    0,    0,  245,  244,  243,  242,  195,    0,  247,
			  546,    0,    0,  521,  193,  545,  544,    0,    0,    0,
			    0,    0,    0,    0,   24,    0,  191, -332,   22,  190,
			   21,    0,  543,    0,   19,  246,    0,    0,  241,  240,

			    4,   83,  183,  182,    0,  245,  244,  243,  242,    4,
			   83,    0,  542,   16,   15,    0,    0,    0,    0,    0,
			  239,    0,    0,    0,    0,    0,  563,    0,    0,  237,
			  236,  235,    0,    0,    0,    0,    0,    0,    0,    0,
			  241,  240,    4,   83,  183,  182,    0,  195,    0,  247,
			    0,    0,    0,    0,  193,    0,  541,    0,    0,  267,
			    0,    0,  239,    7,    0,    0,  191,    0,  238,  190,
			  520,  237,  236,  235,    0,  246,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,  245,  244,  243,  242,  195,
			    0,  247,    0,    0,    0,    0,  193,    0,    0,    0,

			    0,    0,    0,    0,    0,    0,    0,    0,  191,    0,
			    0,  190,    0,    0,    0,    0,    0,  246,    0,    0,
			  241,  240,    4,   83,  183,  182,    0,  245,  244,  243,
			  242,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,  239,    0,    0,    0,    0,    0,  266,    0,
			    0,  265,  236,  235,    0,    0,    0,    0,    0,    0,
			    0,    0,  241,  240,    4,   83,  183,  182,    0,    0,
			  195,    0,  247,    0,    0,    0,    0,  193,  195,    0,
			  247,    0,    0,    0,  239,  193,    0,    0,    0,  191,
			  238,  516,  190,  237,  236,  235,    0,  191,  246,    0,

			  190,    0,    0,    0,    0,    0,  246,    0,  245,  244,
			  243,  242,    0,    0,    0,    0,  245,  244,  243,  242,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,  241,  240,    4,   83,  183,  182,    0,
			    0,  241,  240,    4,   83,  183,  182,    0,    0,  195,
			    0,  247,    0,    0,    0,  239,  193,    0,    0,    0,
			    0,  238,  508,  239,  237,  236,  235,    0,  191,  238,
			    0,  190,  237,  236,  235,    0,    0,  246,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,  245,  244,  243,

			  242,  195,    0,  247,  546,    0,    0,    0,  193,  545,
			  544,    0,    0,    0,    0,    0,    0,    0,   24,    0,
			  191, -334,   22,  190,   21,    0,  543,    0,   19,  246,
			    0,    0,  241,  240,    4,   83,  183,  182,    0,  245,
			  244,  243,  242,    0,    0,    0,  542,   16,   15,    0,
			    0,    0,    0,    0,  239,    0,    0,    0,    0,    0,
			  447,    0,    0,  237,  236,  235,    0,    0,    0,    0,
			    0,    0,    0,  195,  241,  240,    4,   83,  183,  182,
			  193,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			  541,    0,  191,    0,    0,  190,  239,    7,    0,    0,

			    0,  246,  395,    0,    0,  394,  236,  235,    0,    0,
			    0,  245,  244,  243,  242,    0,   30,    0,    0,    0,
			    0,   29,   28,   27,    0,   26,   25,    0,    0,    0,
			   24,   23,    0,   -9,   22,    0,   21,    0,   20,    0,
			   19,    0,    0,    0,    0,    0,  241,  240,    4,   83,
			  183,  182,   18,    0,    0,    0,    0,    0,   17,   16,
			   15,    0,    0,    0,    0,    0,    0,    0,  239,    0,
			    0,    0,    0,    0,  238,    0,   30,  237,  236,  235,
			    0,   29,   28,   27,    0,   26,   25,    0,    0,    0,
			   24,   23,    0,  -10,   22,    0,   21,   14,   20,   13,

			   19,    0,   12,   11,   10,    9,    0,    8,    0,    7,
			    4,    0,   18,    0,    0,    0,    0,    0,   17,   16,
			   15,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			   30,    0,    0,    0,    0,   29,   28,   27,    0,   26,
			   25,    0,    0,    0,   24,   23,    0,   -7,   22,    0,
			   21,    0,   20,    0,   19,    0,    0,   14,    0,   13,
			    0,    0,   12,   11,   10,    9,   18,    8,    0,    7,
			    4,    0,   17,   16,   15,    0,    0,    0,    0,    0,
			    0,    0,    0,  546,    0,    0,    0,    0,  545,  544,
			    0,    0,    0,    0,    0,    0,    0,   24,    0,    0,

			 -330,   22,    0,   21,    0,  543,    0,   19,    0,    0,
			    0,   14,    0,   13,    0,    0,   12,   11,   10,    9,
			    0,    8,    0,    7,    4,  542,   16,   15,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,  541,
			    0,    0,    0,    0,    0,    0,    7, yyDummy>>,
			1, 777, 1000)
		end

	yycheck_template: SPECIAL [INTEGER] is
			-- Template for `yycheck'
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 1776)
			yycheck_template_1 (an_array)
			yycheck_template_2 (an_array)
			Result := yyfixed_array (an_array)
		end

	yycheck_template_1 (an_array: ARRAY [INTEGER]) is
			-- Fill chunk #1 of template for `yycheck'.
		do
			yyarray_subcopy (an_array, <<
			   21,   21,   21,  162,  118,  247,  104,  132,  246,  229,
			  181,  178,  179,    1,  180,    3,    4,  180,   19,  139,
			   21,    3,    1,   24,  266,   13,    1,   15,   16,   17,
			   18,   19,  524,   21,   22,   26,   24,   25,  503,   27,
			   28,   29,    1,   25,   48,    1,   13,    1,  272,    1,
			   17,   18,   73,   96,   23,    1,    1,    1,   95,   13,
			   48,  554,   29,  283,    0,   95,   48,    1,    1,    0,
			  237,  424,  186,  187,  188,  189,  125,  569,  121,   67,
			   36,  124,  128,   71,  121,  115,  125,  108,   76,  554,
			   91,  584,   26,   26,   82,   96,  194,  118,  265,   34,

			   67,   47,  222,   91,   71,  230,  110,  122,   96,   76,
			  186,  187,  188,  189,  234,  213,  122,   96,    1,  584,
			   95,    1,  110,  111,   95,  116,   95,  115,  110,  108,
			  118,  119,  120,  353,   20,  123,  356,  158,   96,  140,
			   98,  162,  121,  263,  132,  311,  134,  168,  115,   14,
			  122,  504,  140,  395,  507,  318,   42,  138,  400,  180,
			  331,  332,  121,  144,  330,  186,  187,  188,  189,  393,
			  333,  123,  525,  397,  120,  120,  120,  123,  123,  123,
			  168,  120,  296,  116,   97,   98,    1,  175,  426,  177,
			  178,  179,  180,  181,   26,   26,    1,  185,  186,  187,

			  188,  189,  503,  116,  192,  447,  559,   18,   91,   95,
			  192,  212,    1,   96,   46,   46,  341,  503,  185,   99,
			  296,  459,    1,  103,  212,  108,   26,  394,  503,   97,
			   98,   96,  470,   98,   82,  121,   84,  120,  121,  227,
			  119,  229,  230,   36,  123,  503,   46,  235,  116,  237,
			  503,  503,  503,  554,    1,  414,    3,  238,    1,  114,
			  115,  242,  243,  244,  245,  246,  247,  122,  554,  119,
			  116,  117,  118,  123,  123,  296,  264,  265,   25,  554,
			   17,  262,  132,  584,  122,  527,  267,  122,   35,   36,
			  108,  389,  534,   40,   20,  283,  554,  318,  584,  287,

			  108,  554,  554,  554,  144,  122,   32,  123,  296,  584,
			  298,  108,  333,  334,  302,  336,   42,  305,    0,    1,
			  122,  563,  442,  311,  114,  115,  584,  122,  178,  179,
			  318,  584,  584,  584,  322,  323,   18,   95,  122,   97,
			   98,  122,  330,  331,  332,  333,  334,  116,  117,  337,
			  130,  339,   47,  341,   95,   96,  122,  115,  346,  347,
			  348,  349,  343,  121,  108,  353,  114,  115,  356,   95,
			   96,   97,   98,  120,    1,  122,    3,  227,  108,  229,
			  230,  362,    1,  371,  118,  322,  323,  237,  123,  115,
			   98,   96,  413,  381,  375,  121,  121,  385,   25,  239,

			  610,  611,  108,   33,   98,  227,  394,  247,   35,   36,
			  144,   33,  122,   40,   26,  265,  108,   40,  399,  400,
			  123,  122,  403,  122,  122,  122,  266,  267,   36,  122,
			   26,  122,   86,  283,  168,  423,  424,   91,   92,  122,
			  599,   95,  121,  121,  603,  426,  180,  122,  298,  122,
			  122,  122,  186,  187,  188,  189,  108,   26,  192,    1,
			  108,  122,  482,  123,  119,  122,  454,  108,  109,  110,
			  111,  112,  113,  493,  493,  129,  298,  122,  459,  122,
			   35,  122,    3,  127,  122,   26,  467,   26,    5,  470,
			   26,  341,  108,  120,  122,  122,  346,  347,  348,  349,

			    3,  482,  127,  353,  122,  486,  356,  127,   35,   46,
			  127,   26,  493,  247,  502,    1,  504,    3,  538,  507,
			    1,   26,  108,    1,  346,  347,  348,  349,   98,  122,
			   98,  122,  266,  267,  515,  385,   98,  525,  122,   25,
			  380,    1,  382,    3,  394,    1,  118,  122,   98,   35,
			   36,  122,   26,   26,   40,  395,   26,  538,   98,  399,
			  400,  108,  296,  385,   98,   25,  120,   26,   26,   26,
			   25,  559,   84,  108,  424,   35,   36,   18,  599,  108,
			   40,   14,  603,  564,  318,    1,   96,  568,  120,  161,
			  108,  109,  110,  111,  112,  113,  168,   84,  120,  333,

			  334,  603,  424,  502,  454,  357,  335,  447,  180,  181,
			  538,  137,  384,  334,  186,  187,  188,  189,   99,  100,
			  101,  102,  103,  104,  105,  106,  107,  454,  134,  610,
			  611,  236,  454,  379,  120,  475,  122,  168,  399,  120,
			  411,  122,  158,   99,  100,  101,  102,  103,  104,  105,
			  106,  107,  502,  413,  504,  414,   -1,  507,   -1,   -1,
			  120,  395,  122,   -1,   -1,  399,  400,   -1,   -1,   -1,
			   -1,    1,   -1,    3,   -1,  525,   -1,    1,   -1,    3,
			  502,   -1,  504,   -1,  524,  507,   -1,  527,  108,  109,
			  110,  111,  112,  113,  534,   25,   -1,   -1,   -1,   -1,

			   -1,   25,   -1,  525,   -1,   35,   36,   -1,   -1,  559,
			   40,   35,   36,  447,   -1,   -1,   40,   -1,   -1,   -1,
			   -1,   -1,   -1,  563,  296,   -1,   -1,   -1,   -1,  569,
			   -1,   -1,   -1,  573,   -1,   -1,  576,  559,   -1,  311,
			    1,   -1,    3,   -1,    5,   -1,  318,   -1,   -1,   -1,
			  322,  323,   -1,   14,   -1,   -1,   17,   -1,  330,  331,
			  332,  333,  334,   -1,   25,   26,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   34,   35,   36,   -1,   -1,   -1,   40,
			   -1,   -1,   -1,   -1,   -1,   -1,   47,    4,   -1,   -1,
			  120,   -1,  122,  527,   -1,   12,  120,   -1,  122,   -1,

			  534,   -1,   -1,   20,   -1,   22,   -1,   -1,   -1,   -1,
			   27,   28,   29,   -1,   31,   -1,   -1,   -1,   -1,   -1,
			   -1,   38,   39,   -1,   41,   42,   -1,   -1,   -1,  563,
			   -1,   48,   -1,   -1,   -1,   96,   -1,   98,   -1,   -1,
			  412,   58,   59,   60,   61,   -1,   -1,  108,  109,  110,
			  111,  112,  113,  114,  115,  116,  117,  118,   -1,  120,
			   -1,  122,  123,   -1,   -1,   -1,   -1,  128,  108,  109,
			  110,  111,  112,  113,  114,  115,   93,   94,   95,   96,
			   97,   98,  122,   -1,   -1,   -1,   -1,    4,   -1,    1,
			   -1,   -1,   -1,   -1,   -1,   12,   -1,   -1,  115,   -1,

			   -1,   -1,   -1,   20,  121,   22,   -1,  124,  125,  126,
			   27,   28,   29,   -1,   31,   -1,   -1,   -1,   -1,   -1,
			   -1,   38,   39,   -1,   41,   42,   -1,   -1,   -1,    4,
			   -1,   48,   -1,   -1,   -1,   -1,   -1,   12,   -1,   -1,
			   -1,   58,   59,   60,   61,   20,   -1,   -1,   -1,   24,
			   -1,   -1,   27,   28,   29,   -1,   31,   32,   -1,   -1,
			   -1,   -1,   -1,   38,   39,   -1,   41,   42,  108,  109,
			  110,  111,  112,  113,  114,  115,   93,   94,   95,   96,
			   97,   98,   -1,   58,   59,   60,   61,   99,  100,  101,
			  102,  103,  104,  105,  106,  107,  108,   -1,  115,   -1, yyDummy>>,
			1, 1000, 0)
		end

	yycheck_template_2 (an_array: ARRAY [INTEGER]) is
			-- Fill chunk #2 of template for `yycheck'.
		do
			yyarray_subcopy (an_array, <<
			   -1,   -1,   -1,   -1,  121,   -1,   -1,  124,  125,  126,
			   85,   -1,   -1,   -1,    9,   -1,   -1,   -1,    4,   94,
			   95,   96,   97,   98,   -1,   20,   12,   22,   -1,   -1,
			   -1,   -1,   27,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			  115,   -1,   28,   29,   39,   31,  121,   42,   -1,  124,
			  125,  126,   38,   48,   -1,   41,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   58,   59,   60,   61,   20,   -1,   22,
			    1,   -1,   -1,   26,   27,    6,    7,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   15,   -1,   39,   18,   19,   42,
			   21,   -1,   23,   -1,   25,   48,   -1,   -1,   93,   94,

			   95,   96,   97,   98,   -1,   58,   59,   60,   61,   95,
			   96,   -1,   43,   44,   45,   -1,   -1,   -1,   -1,   -1,
			  115,   -1,   -1,   -1,   -1,   -1,  121,   -1,   -1,  124,
			  125,  126,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   93,   94,   95,   96,   97,   98,   -1,   20,   -1,   22,
			   -1,   -1,   -1,   -1,   27,   -1,   87,   -1,   -1,   32,
			   -1,   -1,  115,   94,   -1,   -1,   39,   -1,  121,   42,
			  123,  124,  125,  126,   -1,   48,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   58,   59,   60,   61,   20,
			   -1,   22,   -1,   -1,   -1,   -1,   27,   -1,   -1,   -1,

			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   39,   -1,
			   -1,   42,   -1,   -1,   -1,   -1,   -1,   48,   -1,   -1,
			   93,   94,   95,   96,   97,   98,   -1,   58,   59,   60,
			   61,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,  115,   -1,   -1,   -1,   -1,   -1,  121,   -1,
			   -1,  124,  125,  126,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   93,   94,   95,   96,   97,   98,   -1,   -1,
			   20,   -1,   22,   -1,   -1,   -1,   -1,   27,   20,   -1,
			   22,   -1,   -1,   -1,  115,   27,   -1,   -1,   -1,   39,
			  121,  122,   42,  124,  125,  126,   -1,   39,   48,   -1,

			   42,   -1,   -1,   -1,   -1,   -1,   48,   -1,   58,   59,
			   60,   61,   -1,   -1,   -1,   -1,   58,   59,   60,   61,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   93,   94,   95,   96,   97,   98,   -1,
			   -1,   93,   94,   95,   96,   97,   98,   -1,   -1,   20,
			   -1,   22,   -1,   -1,   -1,  115,   27,   -1,   -1,   -1,
			   -1,  121,  122,  115,  124,  125,  126,   -1,   39,  121,
			   -1,   42,  124,  125,  126,   -1,   -1,   48,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   58,   59,   60,

			   61,   20,   -1,   22,    1,   -1,   -1,   -1,   27,    6,
			    7,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   15,   -1,
			   39,   18,   19,   42,   21,   -1,   23,   -1,   25,   48,
			   -1,   -1,   93,   94,   95,   96,   97,   98,   -1,   58,
			   59,   60,   61,   -1,   -1,   -1,   43,   44,   45,   -1,
			   -1,   -1,   -1,   -1,  115,   -1,   -1,   -1,   -1,   -1,
			  121,   -1,   -1,  124,  125,  126,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   20,   93,   94,   95,   96,   97,   98,
			   27,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   87,   -1,   39,   -1,   -1,   42,  115,   94,   -1,   -1,

			   -1,   48,  121,   -1,   -1,  124,  125,  126,   -1,   -1,
			   -1,   58,   59,   60,   61,   -1,    1,   -1,   -1,   -1,
			   -1,    6,    7,    8,   -1,   10,   11,   -1,   -1,   -1,
			   15,   16,   -1,   18,   19,   -1,   21,   -1,   23,   -1,
			   25,   -1,   -1,   -1,   -1,   -1,   93,   94,   95,   96,
			   97,   98,   37,   -1,   -1,   -1,   -1,   -1,   43,   44,
			   45,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  115,   -1,
			   -1,   -1,   -1,   -1,  121,   -1,    1,  124,  125,  126,
			   -1,    6,    7,    8,   -1,   10,   11,   -1,   -1,   -1,
			   15,   16,   -1,   18,   19,   -1,   21,   82,   23,   84,

			   25,   -1,   87,   88,   89,   90,   -1,   92,   -1,   94,
			   95,   -1,   37,   -1,   -1,   -1,   -1,   -1,   43,   44,
			   45,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			    1,   -1,   -1,   -1,   -1,    6,    7,    8,   -1,   10,
			   11,   -1,   -1,   -1,   15,   16,   -1,   18,   19,   -1,
			   21,   -1,   23,   -1,   25,   -1,   -1,   82,   -1,   84,
			   -1,   -1,   87,   88,   89,   90,   37,   92,   -1,   94,
			   95,   -1,   43,   44,   45,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,    1,   -1,   -1,   -1,   -1,    6,    7,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   15,   -1,   -1,

			   18,   19,   -1,   21,   -1,   23,   -1,   25,   -1,   -1,
			   -1,   82,   -1,   84,   -1,   -1,   87,   88,   89,   90,
			   -1,   92,   -1,   94,   95,   43,   44,   45,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   87,
			   -1,   -1,   -1,   -1,   -1,   -1,   94, yyDummy>>,
			1, 777, 1000)
		end

feature {NONE} -- Semantic value stacks

	yyvs1: SPECIAL [ANY]
			-- Stack for semantic values of type ANY

	yyvsc1: INTEGER
			-- Capacity of semantic value stack `yyvs1'

	yyvsp1: INTEGER
			-- Top of semantic value stack `yyvs1'

	yyspecial_routines1: KL_SPECIAL_ROUTINES [ANY]
			-- Routines that ought to be in SPECIAL [ANY]

	yyvs2: SPECIAL [STRING]
			-- Stack for semantic values of type STRING

	yyvsc2: INTEGER
			-- Capacity of semantic value stack `yyvs2'

	yyvsp2: INTEGER
			-- Top of semantic value stack `yyvs2'

	yyspecial_routines2: KL_SPECIAL_ROUTINES [STRING]
			-- Routines that ought to be in SPECIAL [STRING]

	yyvs3: SPECIAL [INTEGER]
			-- Stack for semantic values of type INTEGER

	yyvsc3: INTEGER
			-- Capacity of semantic value stack `yyvs3'

	yyvsp3: INTEGER
			-- Top of semantic value stack `yyvs3'

	yyspecial_routines3: KL_SPECIAL_ROUTINES [INTEGER]
			-- Routines that ought to be in SPECIAL [INTEGER]

	yyvs4: SPECIAL [XPLAIN_BASE]
			-- Stack for semantic values of type XPLAIN_BASE

	yyvsc4: INTEGER
			-- Capacity of semantic value stack `yyvs4'

	yyvsp4: INTEGER
			-- Top of semantic value stack `yyvs4'

	yyspecial_routines4: KL_SPECIAL_ROUTINES [XPLAIN_BASE]
			-- Routines that ought to be in SPECIAL [XPLAIN_BASE]

	yyvs5: SPECIAL [XPLAIN_DOMAIN_RESTRICTION]
			-- Stack for semantic values of type XPLAIN_DOMAIN_RESTRICTION

	yyvsc5: INTEGER
			-- Capacity of semantic value stack `yyvs5'

	yyvsp5: INTEGER
			-- Top of semantic value stack `yyvs5'

	yyspecial_routines5: KL_SPECIAL_ROUTINES [XPLAIN_DOMAIN_RESTRICTION]
			-- Routines that ought to be in SPECIAL [XPLAIN_DOMAIN_RESTRICTION]

	yyvs6: SPECIAL [XPLAIN_A_NODE]
			-- Stack for semantic values of type XPLAIN_A_NODE

	yyvsc6: INTEGER
			-- Capacity of semantic value stack `yyvs6'

	yyvsp6: INTEGER
			-- Top of semantic value stack `yyvs6'

	yyspecial_routines6: KL_SPECIAL_ROUTINES [XPLAIN_A_NODE]
			-- Routines that ought to be in SPECIAL [XPLAIN_A_NODE]

	yyvs7: SPECIAL [XPLAIN_I_NODE]
			-- Stack for semantic values of type XPLAIN_I_NODE

	yyvsc7: INTEGER
			-- Capacity of semantic value stack `yyvs7'

	yyvsp7: INTEGER
			-- Top of semantic value stack `yyvs7'

	yyspecial_routines7: KL_SPECIAL_ROUTINES [XPLAIN_I_NODE]
			-- Routines that ought to be in SPECIAL [XPLAIN_I_NODE]

	yyvs8: SPECIAL [XPLAIN_LOGICAL_EXPRESSION]
			-- Stack for semantic values of type XPLAIN_LOGICAL_EXPRESSION

	yyvsc8: INTEGER
			-- Capacity of semantic value stack `yyvs8'

	yyvsp8: INTEGER
			-- Top of semantic value stack `yyvs8'

	yyspecial_routines8: KL_SPECIAL_ROUTINES [XPLAIN_LOGICAL_EXPRESSION]
			-- Routines that ought to be in SPECIAL [XPLAIN_LOGICAL_EXPRESSION]

	yyvs9: SPECIAL [XPLAIN_EXPRESSION]
			-- Stack for semantic values of type XPLAIN_EXPRESSION

	yyvsc9: INTEGER
			-- Capacity of semantic value stack `yyvs9'

	yyvsp9: INTEGER
			-- Top of semantic value stack `yyvs9'

	yyspecial_routines9: KL_SPECIAL_ROUTINES [XPLAIN_EXPRESSION]
			-- Routines that ought to be in SPECIAL [XPLAIN_EXPRESSION]

	yyvs10: SPECIAL [XPLAIN_LOGICAL_VALUE_EXPRESSION]
			-- Stack for semantic values of type XPLAIN_LOGICAL_VALUE_EXPRESSION

	yyvsc10: INTEGER
			-- Capacity of semantic value stack `yyvs10'

	yyvsp10: INTEGER
			-- Top of semantic value stack `yyvs10'

	yyspecial_routines10: KL_SPECIAL_ROUTINES [XPLAIN_LOGICAL_VALUE_EXPRESSION]
			-- Routines that ought to be in SPECIAL [XPLAIN_LOGICAL_VALUE_EXPRESSION]

	yyvs11: SPECIAL [XPLAIN_SYSTEM_EXPRESSION]
			-- Stack for semantic values of type XPLAIN_SYSTEM_EXPRESSION

	yyvsc11: INTEGER
			-- Capacity of semantic value stack `yyvs11'

	yyvsp11: INTEGER
			-- Top of semantic value stack `yyvs11'

	yyspecial_routines11: KL_SPECIAL_ROUTINES [XPLAIN_SYSTEM_EXPRESSION]
			-- Routines that ought to be in SPECIAL [XPLAIN_SYSTEM_EXPRESSION]

	yyvs12: SPECIAL [XPLAIN_ATTRIBUTE_NAME_NODE]
			-- Stack for semantic values of type XPLAIN_ATTRIBUTE_NAME_NODE

	yyvsc12: INTEGER
			-- Capacity of semantic value stack `yyvs12'

	yyvsp12: INTEGER
			-- Top of semantic value stack `yyvs12'

	yyspecial_routines12: KL_SPECIAL_ROUTINES [XPLAIN_ATTRIBUTE_NAME_NODE]
			-- Routines that ought to be in SPECIAL [XPLAIN_ATTRIBUTE_NAME_NODE]

	yyvs13: SPECIAL [XPLAIN_ATTRIBUTE_NAME]
			-- Stack for semantic values of type XPLAIN_ATTRIBUTE_NAME

	yyvsc13: INTEGER
			-- Capacity of semantic value stack `yyvs13'

	yyvsp13: INTEGER
			-- Top of semantic value stack `yyvs13'

	yyspecial_routines13: KL_SPECIAL_ROUTINES [XPLAIN_ATTRIBUTE_NAME]
			-- Routines that ought to be in SPECIAL [XPLAIN_ATTRIBUTE_NAME]

	yyvs14: SPECIAL [XPLAIN_TYPE]
			-- Stack for semantic values of type XPLAIN_TYPE

	yyvsc14: INTEGER
			-- Capacity of semantic value stack `yyvs14'

	yyvsp14: INTEGER
			-- Top of semantic value stack `yyvs14'

	yyspecial_routines14: KL_SPECIAL_ROUTINES [XPLAIN_TYPE]
			-- Routines that ought to be in SPECIAL [XPLAIN_TYPE]

	yyvs15: SPECIAL [XPLAIN_REPRESENTATION]
			-- Stack for semantic values of type XPLAIN_REPRESENTATION

	yyvsc15: INTEGER
			-- Capacity of semantic value stack `yyvs15'

	yyvsp15: INTEGER
			-- Top of semantic value stack `yyvs15'

	yyspecial_routines15: KL_SPECIAL_ROUTINES [XPLAIN_REPRESENTATION]
			-- Routines that ought to be in SPECIAL [XPLAIN_REPRESENTATION]

	yyvs16: SPECIAL [XPLAIN_PK_REPRESENTATION]
			-- Stack for semantic values of type XPLAIN_PK_REPRESENTATION

	yyvsc16: INTEGER
			-- Capacity of semantic value stack `yyvs16'

	yyvsp16: INTEGER
			-- Top of semantic value stack `yyvs16'

	yyspecial_routines16: KL_SPECIAL_ROUTINES [XPLAIN_PK_REPRESENTATION]
			-- Routines that ought to be in SPECIAL [XPLAIN_PK_REPRESENTATION]

	yyvs17: SPECIAL [XPLAIN_ATTRIBUTE_NODE]
			-- Stack for semantic values of type XPLAIN_ATTRIBUTE_NODE

	yyvsc17: INTEGER
			-- Capacity of semantic value stack `yyvs17'

	yyvsp17: INTEGER
			-- Top of semantic value stack `yyvs17'

	yyspecial_routines17: KL_SPECIAL_ROUTINES [XPLAIN_ATTRIBUTE_NODE]
			-- Routines that ought to be in SPECIAL [XPLAIN_ATTRIBUTE_NODE]

	yyvs18: SPECIAL [XPLAIN_ATTRIBUTE]
			-- Stack for semantic values of type XPLAIN_ATTRIBUTE

	yyvsc18: INTEGER
			-- Capacity of semantic value stack `yyvs18'

	yyvsp18: INTEGER
			-- Top of semantic value stack `yyvs18'

	yyspecial_routines18: KL_SPECIAL_ROUTINES [XPLAIN_ATTRIBUTE]
			-- Routines that ought to be in SPECIAL [XPLAIN_ATTRIBUTE]

	yyvs19: SPECIAL [XPLAIN_ASSERTION]
			-- Stack for semantic values of type XPLAIN_ASSERTION

	yyvsc19: INTEGER
			-- Capacity of semantic value stack `yyvs19'

	yyvsp19: INTEGER
			-- Top of semantic value stack `yyvs19'

	yyspecial_routines19: KL_SPECIAL_ROUTINES [XPLAIN_ASSERTION]
			-- Routines that ought to be in SPECIAL [XPLAIN_ASSERTION]

	yyvs20: SPECIAL [XPLAIN_ASSIGNMENT_NODE]
			-- Stack for semantic values of type XPLAIN_ASSIGNMENT_NODE

	yyvsc20: INTEGER
			-- Capacity of semantic value stack `yyvs20'

	yyvsp20: INTEGER
			-- Top of semantic value stack `yyvs20'

	yyspecial_routines20: KL_SPECIAL_ROUTINES [XPLAIN_ASSIGNMENT_NODE]
			-- Routines that ought to be in SPECIAL [XPLAIN_ASSIGNMENT_NODE]

	yyvs21: SPECIAL [XPLAIN_ASSIGNMENT]
			-- Stack for semantic values of type XPLAIN_ASSIGNMENT

	yyvsc21: INTEGER
			-- Capacity of semantic value stack `yyvs21'

	yyvsp21: INTEGER
			-- Top of semantic value stack `yyvs21'

	yyspecial_routines21: KL_SPECIAL_ROUTINES [XPLAIN_ASSIGNMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_ASSIGNMENT]

	yyvs22: SPECIAL [XPLAIN_SUBJECT]
			-- Stack for semantic values of type XPLAIN_SUBJECT

	yyvsc22: INTEGER
			-- Capacity of semantic value stack `yyvs22'

	yyvsp22: INTEGER
			-- Top of semantic value stack `yyvs22'

	yyspecial_routines22: KL_SPECIAL_ROUTINES [XPLAIN_SUBJECT]
			-- Routines that ought to be in SPECIAL [XPLAIN_SUBJECT]

	yyvs23: SPECIAL [XPLAIN_SELECTION_FUNCTION]
			-- Stack for semantic values of type XPLAIN_SELECTION_FUNCTION

	yyvsc23: INTEGER
			-- Capacity of semantic value stack `yyvs23'

	yyvsp23: INTEGER
			-- Top of semantic value stack `yyvs23'

	yyspecial_routines23: KL_SPECIAL_ROUTINES [XPLAIN_SELECTION_FUNCTION]
			-- Routines that ought to be in SPECIAL [XPLAIN_SELECTION_FUNCTION]

	yyvs24: SPECIAL [XPLAIN_EXTENSION]
			-- Stack for semantic values of type XPLAIN_EXTENSION

	yyvsc24: INTEGER
			-- Capacity of semantic value stack `yyvs24'

	yyvsp24: INTEGER
			-- Top of semantic value stack `yyvs24'

	yyspecial_routines24: KL_SPECIAL_ROUTINES [XPLAIN_EXTENSION]
			-- Routines that ought to be in SPECIAL [XPLAIN_EXTENSION]

	yyvs25: SPECIAL [XPLAIN_EXTEND_ATTRIBUTE]
			-- Stack for semantic values of type XPLAIN_EXTEND_ATTRIBUTE

	yyvsc25: INTEGER
			-- Capacity of semantic value stack `yyvs25'

	yyvsp25: INTEGER
			-- Top of semantic value stack `yyvs25'

	yyspecial_routines25: KL_SPECIAL_ROUTINES [XPLAIN_EXTEND_ATTRIBUTE]
			-- Routines that ought to be in SPECIAL [XPLAIN_EXTEND_ATTRIBUTE]

	yyvs26: SPECIAL [XPLAIN_EXTENSION_EXPRESSION]
			-- Stack for semantic values of type XPLAIN_EXTENSION_EXPRESSION

	yyvsc26: INTEGER
			-- Capacity of semantic value stack `yyvs26'

	yyvsp26: INTEGER
			-- Top of semantic value stack `yyvs26'

	yyspecial_routines26: KL_SPECIAL_ROUTINES [XPLAIN_EXTENSION_EXPRESSION]
			-- Routines that ought to be in SPECIAL [XPLAIN_EXTENSION_EXPRESSION]

	yyvs27: SPECIAL [XPLAIN_SELECTION]
			-- Stack for semantic values of type XPLAIN_SELECTION

	yyvsc27: INTEGER
			-- Capacity of semantic value stack `yyvs27'

	yyvsp27: INTEGER
			-- Top of semantic value stack `yyvs27'

	yyspecial_routines27: KL_SPECIAL_ROUTINES [XPLAIN_SELECTION]
			-- Routines that ought to be in SPECIAL [XPLAIN_SELECTION]

	yyvs28: SPECIAL [XPLAIN_SELECTION_LIST]
			-- Stack for semantic values of type XPLAIN_SELECTION_LIST

	yyvsc28: INTEGER
			-- Capacity of semantic value stack `yyvs28'

	yyvsp28: INTEGER
			-- Top of semantic value stack `yyvs28'

	yyspecial_routines28: KL_SPECIAL_ROUTINES [XPLAIN_SELECTION_LIST]
			-- Routines that ought to be in SPECIAL [XPLAIN_SELECTION_LIST]

	yyvs29: SPECIAL [XPLAIN_SORT_NODE]
			-- Stack for semantic values of type XPLAIN_SORT_NODE

	yyvsc29: INTEGER
			-- Capacity of semantic value stack `yyvs29'

	yyvsp29: INTEGER
			-- Top of semantic value stack `yyvs29'

	yyspecial_routines29: KL_SPECIAL_ROUTINES [XPLAIN_SORT_NODE]
			-- Routines that ought to be in SPECIAL [XPLAIN_SORT_NODE]

	yyvs30: SPECIAL [XPLAIN_FUNCTION]
			-- Stack for semantic values of type XPLAIN_FUNCTION

	yyvsc30: INTEGER
			-- Capacity of semantic value stack `yyvs30'

	yyvsp30: INTEGER
			-- Top of semantic value stack `yyvs30'

	yyspecial_routines30: KL_SPECIAL_ROUTINES [XPLAIN_FUNCTION]
			-- Routines that ought to be in SPECIAL [XPLAIN_FUNCTION]

	yyvs31: SPECIAL [XPLAIN_EXPRESSION_NODE]
			-- Stack for semantic values of type XPLAIN_EXPRESSION_NODE

	yyvsc31: INTEGER
			-- Capacity of semantic value stack `yyvs31'

	yyvsp31: INTEGER
			-- Top of semantic value stack `yyvs31'

	yyspecial_routines31: KL_SPECIAL_ROUTINES [XPLAIN_EXPRESSION_NODE]
			-- Routines that ought to be in SPECIAL [XPLAIN_EXPRESSION_NODE]

	yyvs32: SPECIAL [XPLAIN_STATEMENT_NODE]
			-- Stack for semantic values of type XPLAIN_STATEMENT_NODE

	yyvsc32: INTEGER
			-- Capacity of semantic value stack `yyvs32'

	yyvsp32: INTEGER
			-- Top of semantic value stack `yyvs32'

	yyspecial_routines32: KL_SPECIAL_ROUTINES [XPLAIN_STATEMENT_NODE]
			-- Routines that ought to be in SPECIAL [XPLAIN_STATEMENT_NODE]

	yyvs33: SPECIAL [XPLAIN_STATEMENT]
			-- Stack for semantic values of type XPLAIN_STATEMENT

	yyvsc33: INTEGER
			-- Capacity of semantic value stack `yyvs33'

	yyvsp33: INTEGER
			-- Top of semantic value stack `yyvs33'

	yyspecial_routines33: KL_SPECIAL_ROUTINES [XPLAIN_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_STATEMENT]

	yyvs34: SPECIAL [XPLAIN_CONSTANT_STATEMENT]
			-- Stack for semantic values of type XPLAIN_CONSTANT_STATEMENT

	yyvsc34: INTEGER
			-- Capacity of semantic value stack `yyvs34'

	yyvsp34: INTEGER
			-- Top of semantic value stack `yyvs34'

	yyspecial_routines34: KL_SPECIAL_ROUTINES [XPLAIN_CONSTANT_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_CONSTANT_STATEMENT]

	yyvs35: SPECIAL [XPLAIN_CONSTANT_ASSIGNMENT_STATEMENT]
			-- Stack for semantic values of type XPLAIN_CONSTANT_ASSIGNMENT_STATEMENT

	yyvsc35: INTEGER
			-- Capacity of semantic value stack `yyvs35'

	yyvsp35: INTEGER
			-- Top of semantic value stack `yyvs35'

	yyspecial_routines35: KL_SPECIAL_ROUTINES [XPLAIN_CONSTANT_ASSIGNMENT_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_CONSTANT_ASSIGNMENT_STATEMENT]

	yyvs36: SPECIAL [XPLAIN_CASCADE_STATEMENT]
			-- Stack for semantic values of type XPLAIN_CASCADE_STATEMENT

	yyvsc36: INTEGER
			-- Capacity of semantic value stack `yyvs36'

	yyvsp36: INTEGER
			-- Top of semantic value stack `yyvs36'

	yyspecial_routines36: KL_SPECIAL_ROUTINES [XPLAIN_CASCADE_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_CASCADE_STATEMENT]

	yyvs37: SPECIAL [XPLAIN_CASCADE_FUNCTION_EXPRESSION]
			-- Stack for semantic values of type XPLAIN_CASCADE_FUNCTION_EXPRESSION

	yyvsc37: INTEGER
			-- Capacity of semantic value stack `yyvs37'

	yyvsp37: INTEGER
			-- Top of semantic value stack `yyvs37'

	yyspecial_routines37: KL_SPECIAL_ROUTINES [XPLAIN_CASCADE_FUNCTION_EXPRESSION]
			-- Routines that ought to be in SPECIAL [XPLAIN_CASCADE_FUNCTION_EXPRESSION]

	yyvs38: SPECIAL [XPLAIN_DELETE_STATEMENT]
			-- Stack for semantic values of type XPLAIN_DELETE_STATEMENT

	yyvsc38: INTEGER
			-- Capacity of semantic value stack `yyvs38'

	yyvsp38: INTEGER
			-- Top of semantic value stack `yyvs38'

	yyspecial_routines38: KL_SPECIAL_ROUTINES [XPLAIN_DELETE_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_DELETE_STATEMENT]

	yyvs39: SPECIAL [XPLAIN_EXTEND_STATEMENT]
			-- Stack for semantic values of type XPLAIN_EXTEND_STATEMENT

	yyvsc39: INTEGER
			-- Capacity of semantic value stack `yyvs39'

	yyvsp39: INTEGER
			-- Top of semantic value stack `yyvs39'

	yyspecial_routines39: KL_SPECIAL_ROUTINES [XPLAIN_EXTEND_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_EXTEND_STATEMENT]

	yyvs40: SPECIAL [XPLAIN_GET_STATEMENT]
			-- Stack for semantic values of type XPLAIN_GET_STATEMENT

	yyvsc40: INTEGER
			-- Capacity of semantic value stack `yyvs40'

	yyvsp40: INTEGER
			-- Top of semantic value stack `yyvs40'

	yyspecial_routines40: KL_SPECIAL_ROUTINES [XPLAIN_GET_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_GET_STATEMENT]

	yyvs41: SPECIAL [XPLAIN_PROCEDURE_STATEMENT]
			-- Stack for semantic values of type XPLAIN_PROCEDURE_STATEMENT

	yyvsc41: INTEGER
			-- Capacity of semantic value stack `yyvs41'

	yyvsp41: INTEGER
			-- Top of semantic value stack `yyvs41'

	yyspecial_routines41: KL_SPECIAL_ROUTINES [XPLAIN_PROCEDURE_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_PROCEDURE_STATEMENT]

	yyvs42: SPECIAL [XPLAIN_SQL_STATEMENT]
			-- Stack for semantic values of type XPLAIN_SQL_STATEMENT

	yyvsc42: INTEGER
			-- Capacity of semantic value stack `yyvs42'

	yyvsp42: INTEGER
			-- Top of semantic value stack `yyvs42'

	yyspecial_routines42: KL_SPECIAL_ROUTINES [XPLAIN_SQL_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_SQL_STATEMENT]

	yyvs43: SPECIAL [XPLAIN_TYPE_STATEMENT]
			-- Stack for semantic values of type XPLAIN_TYPE_STATEMENT

	yyvsc43: INTEGER
			-- Capacity of semantic value stack `yyvs43'

	yyvsp43: INTEGER
			-- Top of semantic value stack `yyvs43'

	yyspecial_routines43: KL_SPECIAL_ROUTINES [XPLAIN_TYPE_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_TYPE_STATEMENT]

	yyvs44: SPECIAL [XPLAIN_UPDATE_STATEMENT]
			-- Stack for semantic values of type XPLAIN_UPDATE_STATEMENT

	yyvsc44: INTEGER
			-- Capacity of semantic value stack `yyvs44'

	yyvsp44: INTEGER
			-- Top of semantic value stack `yyvs44'

	yyspecial_routines44: KL_SPECIAL_ROUTINES [XPLAIN_UPDATE_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_UPDATE_STATEMENT]

	yyvs45: SPECIAL [XPLAIN_VALUE_STATEMENT]
			-- Stack for semantic values of type XPLAIN_VALUE_STATEMENT

	yyvsc45: INTEGER
			-- Capacity of semantic value stack `yyvs45'

	yyvsp45: INTEGER
			-- Top of semantic value stack `yyvs45'

	yyspecial_routines45: KL_SPECIAL_ROUTINES [XPLAIN_VALUE_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_VALUE_STATEMENT]

	yyvs46: SPECIAL [XPLAIN_VALUE_SELECTION_STATEMENT]
			-- Stack for semantic values of type XPLAIN_VALUE_SELECTION_STATEMENT

	yyvsc46: INTEGER
			-- Capacity of semantic value stack `yyvs46'

	yyvsp46: INTEGER
			-- Top of semantic value stack `yyvs46'

	yyspecial_routines46: KL_SPECIAL_ROUTINES [XPLAIN_VALUE_SELECTION_STATEMENT]
			-- Routines that ought to be in SPECIAL [XPLAIN_VALUE_SELECTION_STATEMENT]

feature {NONE} -- Constants

	yyFinal: INTEGER is 616
			-- Termination state id

	yyFlag: INTEGER is -32768
			-- Most negative INTEGER

	yyNtbase: INTEGER is 131
			-- Number of tokens

	yyLast: INTEGER is 1776
			-- Upper bound of `yytable' and `yycheck'

	yyMax_token: INTEGER is 366
			-- Maximum token id
			-- (upper bound of `yytranslate'.)

	yyNsyms: INTEGER is 268
			-- Number of symbols
			-- (terminal and nonterminal)

feature -- User-defined features



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
						report_error ( format("Object `$s' is not an attribute of type `$s', nor a value or constant.", <<first.item.name, subject_type.name>>))
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
					node.item.attribute_name.attribute.init /= Void and then
					not node.item.attribute_name.attribute.is_init_default
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
