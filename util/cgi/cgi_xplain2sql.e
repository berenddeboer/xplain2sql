note

	description: "Access to xplain2sql through cgi protocol."

	author: "Berend de Boer"

class CGI_XPLAIN2SQL

inherit

	EPX_CGI
		rename
			stdin as stdc_stdin,
			stdout as stdc_stdout,
			stderr as stdc_stderr
		redefine
			make
		end

	-- POSIX_FILE_SYSTEM
	-- 	export
	-- 		{NONE} all
	-- 	end

	POSIX_CURRENT_PROCESS
		select
			stdin,
			stdout,
			stderr
		end

	STDC_SECURITY_ACCESSOR
		export
			{NONE} all
		end

	ARGUMENTS
		export
			{NONE} all
		end


create

	make,
	make_no_rescue


feature -- Initialization

	make
		local
			i_16MB,
			i_64MB: INTEGER
		do
			i_16MB := 16 * 1024 * 1024
			i_64MB := 64 * 1024 * 1024
			security.memory.set_max_single_allocation (i_16MB)
			security.memory.set_max_allocated_memory (i_64MB)
			security.files.set_max_open_files (32)
			precursor
		end


feature -- our work

	targetSQL: STRING

	execute
		local
			xplain2sql: POSIX_EXEC_PROCESS
			error_lines: ARRAY [STRING]
			i: INTEGER
			Xplain_statement: STRING
			options: ARRAY [STRING]
		do
			content_text_html

			targetSQL := value ("targetSQL")
			if targetSQL.is_empty then
				targetSQL := "ANSI SQL"
			end

			doctype
			b_html

			b_head
			title ("Convert Xplain to SQL")
			stop_tag

			b_body

			b_form ("post", "cgi_xplain2sql.cgi")
-- 			b_form ("post", command_name)

			p ("Enter one or more Xplain statements:")

			b_textarea ("Xplain")
			set_attribute ("cols", "72")
			set_attribute ("rows", "10")
			Xplain_statement := raw_value ("Xplain")
			if Xplain_statement.is_empty then
				puts ("database example.%N%N")
				puts ("# your Xplain statements here%N%N")
				puts ("end.%N")
			else
				puts (Xplain_statement)
			end
			e_textarea

			b_table
			set_attribute ("cols", "4")
			set_attribute ("width", "700")

			-- header
			b_tr
			b_th
			puts ("Target SQL")
			e_th
			b_th
			puts ("Options:")
			e_th
			e_tr

			-- second row
			b_tr

			-- target SQL column
			b_td
			set_attribute ("align", "center")
			set_attribute ("valign", "top")
			b_select ("targetSQL")
			from
				sql_dialects.start
			until
				sql_dialects.after
			loop
				put_option (sql_dialects.key_for_iteration)
				sql_dialects.forth
			end
			e_select
			e_td

			-- options column
			b_td

			b_p
			b_checkbox ("auto", "on")
			if value ("auto").is_equal ("on") or else
				not has_input then
				set_attribute ("checked", Void)
			end
			puts ("Auto-generated primary keys")
			e_checkbox
			e_p

			b_p
			b_checkbox ("sp", "on")
			if value ("sp").is_equal ("on") then
				set_attribute ("checked", Void)
			end
			puts ("Generate insert/update/delete stored procedures")
			e_checkbox
			e_p

			b_p
			b_checkbox ("database", "on")
			if value ("database").is_equal ("on") or else
				not has_input then
				set_attribute ("checked", Void)
			end
			puts ("Generate  code for database command")
			e_checkbox
			e_p

			b_p
			b_checkbox ("spprefix", "on")
			if value ("spprefix").is_equal ("on") or else
				not has_input then
				set_attribute ("checked", Void)
			end
			puts ("Prefix stored procedures with 'sp_'")
			e_checkbox
			e_p

			b_p
			b_checkbox ("timestamp", "on")
			if value ("timestamp").is_equal ("on") then
				set_attribute ("checked", Void)
			end
			puts ("Generate  timestamps")
			e_checkbox
			e_p

			b_p
			b_checkbox ("view", "on")
			if value ("view").is_equal ("on") then
				set_attribute ("checked", Void)
			end
			puts ("Generate  views")
			e_checkbox
			e_p

			e_td
			e_tr

			e_table

			b_p
			b_button_submit ("action", "Translate to SQL")
			e_button_submit

			nbsp

			b_button_reset
			e_button_reset
			e_p

			e_form

			hr

			create error_lines.make (0, -1)

			if targetSQL.is_empty then
				p ("Equivalent SQL code:")
			else
				b_p
				puts ("Equivalent ")
				puts (targetSQL)
				puts (" code:")
				e_p
			end

			b_textarea ("SQL")
			set_attribute ("cols", "72")
			set_attribute ("rows", "15")

			-- easy to fool with < or > tags
			-- should make sanitize_input or dehtml routine
			if not raw_value ("Xplain").is_empty then

				-- determine target sql
				sql_dialects.search (targetSQL)
				if sql_dialects.found then
					targetSQL := sql_dialects.found_item
				else
					targetSQL := "-basic"
				end

				create options.make (0, 0)
				options.put (targetSQL, 0)
				if value ("auto").is_empty then
					options.resize (0, options.count)
					options.put ("-noauto", options.upper)
				end
				if value ("sp").is_empty then
					options.resize (0, options.count)
					options.put ("-nosp", options.upper)
				end
				if value ("database").is_empty then
					options.resize (0, options.count)
					options.put ("-nodatabase", options.upper)
				end
				if value ("spprefix").is_empty then
					options.resize (0, options.count)
					options.put ("-nospprefix", options.upper)
				end
				if value ("timestamp").is_equal ("on") then
					options.resize (0, options.count)
					options.put ("-timestamp", options.upper)
				end
				if value ("view").is_equal ("on") then
					options.resize (0, options.count)
					options.put ("-view", options.upper)
				end

				create xplain2sql.make_capture_all ("./xplain2sql", options)
				xplain2sql.execute
				xplain2sql.stdin.write_string (raw_value ("Xplain"))
				xplain2sql.stdin.write_string ("%N")
				xplain2sql.stdin.flush
				xplain2sql.fd_stdin.close
				from
					xplain2sql.stdout.read_string (4096)
				until
					xplain2sql.stdout.end_of_input
				loop
					puts (xplain2sql.stdout.last_string)
					xplain2sql.stdout.read_string (4096)
				end

				from
					xplain2sql.stderr.read_line
				until
					xplain2sql.stderr.end_of_input
				loop
					error_lines.force (xplain2sql.stderr.last_string.twin, error_lines.upper)
					xplain2sql.stderr.read_line
				end
				if
					error_lines.count >= 1 and then
					error_lines.item (error_lines.lower).is_equal ("(reading from stdin)")
				then
					error_lines.remove_head (1)
				end

				xplain2sql.wait_for (True)
				nbsp
			else
				nbsp
			end
			e_textarea

			hr

			p ("Error messages:")

			b_textarea ("SQLError")
			set_attribute ("cols", "72")
			set_attribute ("rows", "6")

			if error_lines.count > 0 then
				from
					i := error_lines.lower
				until
					i > error_lines.upper
				loop
					puts (error_lines.item (i))
					i := i + 1
				end
				nbsp
			else
				nbsp
			end
			e_textarea

			e_body
			e_html
		end

	put_option (contents: STRING)
		do
			if targetSQL.is_equal (contents) then
				selected_option (contents)
			else
				option (contents)
			end
		end


feature {NONE} -- Implementation

	sql_dialects: DS_HASH_TABLE [STRING, STRING]
			-- Recognized options.
		once
			create Result.make (11)
			Result.put_last ("-ansi", "ANSI SQL")
			Result.put_last ("-db2", "DB/2 7.1")
			Result.put_last ("-interbase", "InterBase 6/FireBird 1.0.3")
			Result.put_last ("-msaccess", "Microsoft Access 2000")
			Result.put_last ("-mysql322", "MySQL 3.22")
			Result.put_last ("-mysql", "MySQL 5.0 (ANSI mode)")
			Result.put_last ("-oracle", "Oracle 9.0.1")
			Result.put_last ("-pgsql", "PostgreSQL 7.3.3")
			Result.put_last ("-sqlite", "SQLite 3")
			Result.put_last ("-tsql7", "Microsoft SQL Server 7")
			Result.put_last ("-tsql", "Microsoft SQL Server 2000 or higher")
		ensure
			sql_dialects_not_void: Result /= Void
			at_least_one_option: not Result.is_empty
		end


end
