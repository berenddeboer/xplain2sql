note

	description: "Xplain2SQL root class."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999-2018 Berend de Boer, see LICENSE"

class

	XPLAIN2SQL


inherit

	KL_SHARED_STANDARD_FILES

	KL_SHARED_ARGUMENTS

	KL_IMPORTED_STRING_ROUTINES

	ST_FORMATTING_ROUTINES
		export
			{NONE} all
		end

	EXCEPTIONS
		export
			{NONE} all
		end


create

	make


feature -- identification

	Version: STRING = "5.1"


feature -- creation

	make
			-- Parse xplain files `arguments (1..argument_count)'.
		local
			j, n: INTEGER
			in_filename: detachable STRING
			out_filename: STRING
			in_file: detachable KL_TEXT_INPUT_FILE
			arg: STRING
			AutoPrimaryKeyEnabled,
			AssertEnabled,
			AttributeRequiredEnabled,
			ExtendIndex,
			ExtendView,
			NoStoredProcedurePrefix,
			OldConstraintNames,
			SetDatabaseEnabled,
			StoredProcedureEnabled,
			IdentifierWithSpacesEnabled,
			TimestampEnabled,
			TimeZoneEnabled,
			ViewsEnabled: BOOLEAN          -- sql generation options
			XMLEnabled: BOOLEAN            -- middleware generation options
			sqlgenerator: detachable SQL_GENERATOR
			mwgenerator: detachable MIDDLEWARE_GENERATOR
			primary_key_format: detachable STRING
			sequence_name_format: detachable STRING
		do
			-- parse command line and set options
			n := Arguments.argument_count

			if n = 0 then
				show_usage
				die (1)
			end

			from
				j := 1
				AssertEnabled := True
				AttributeRequiredEnabled := True
				AutoPrimaryKeyEnabled := True
				ExtendIndex := True
				ExtendView := True
				SetDatabaseEnabled := True
				StoredProcedureEnabled := True
				IdentifierWithSpacesEnabled := True
				TimestampEnabled := False
				TimeZoneEnabled := True
				ViewsEnabled := False
			until
				j > n
			loop
				arg := Arguments.argument (j)
				if arg.count > 0 and equal(arg.substring(1,2), "--") then
					arg.keep_tail (arg.count - 1)
				end
				if equal(arg, "-o") then
					out_filename := Arguments.argument (j+1)
				elseif
					equal(arg, "-h") or else equal(arg, "-help")  then
					show_usage
					die (0)
				elseif arg ~  "-version" or else arg ~  "--version" then
					std.output.put_string (Version)
					die (0)

					-- sql options
				elseif equal(arg, "-noauto") then
					AutoPrimaryKeyEnabled := False
				elseif equal(arg, "-noassert") then
					AssertEnabled := False
				elseif equal(arg, "-attributenull") then
					AttributeRequiredEnabled := False
				elseif equal(arg, "-oldconstraintnames") then
					OldConstraintNames := True
				elseif equal(arg, "-nodatabase") then
					SetDatabaseEnabled := False
				elseif equal(arg, "-noextendindex") then
					ExtendIndex := False
				elseif equal(arg, "-noextendview") then
					ExtendView := False
				elseif equal(arg, "-nosp") then
					StoredProcedureEnabled := False
				elseif equal(arg, "-nospace") then
					IdentifierWithSpacesEnabled := False
				elseif equal(arg, "-nospprefix") then
					NoStoredProcedurePrefix := True
				elseif equal(arg, "-pkformat") then
					if j + 1 <= n then
						if valid_format_and_parameters (Arguments.argument (j+1), <<"test">>) then
							primary_key_format := Arguments.argument (j+1)
						else
							std.error.put_string("Option -pkformat has an invalid format specification: ")
							std.error.put_string(Arguments.argument (j+1))
							std.error.put_character ('%N')
							die (1)
						end
						j := j + 1
					else
						std.error.put_string("Option -pkformat should have one argument, but no arguments are given.%N")
						die (1)
					end
				elseif equal(arg, "-sequenceformat") then
					if j + 1 <= n then
						if
							valid_format_and_parameters (Arguments.argument (j+1), <<"test", "id_test">>) or else
								valid_format_and_parameters (Arguments.argument (j+1), <<"id_test">>)
						then
							sequence_name_format := Arguments.argument (j+1)
						else
							std.error.put_string("Option -sequenceformat has an invalid format specification: ")
							std.error.put_string(Arguments.argument (j+1))
							std.error.put_character ('%N')
							die (1)
						end
						j := j + 1
					else
						std.error.put_string("Option -sequenceformat should have one argument, but no arguments are given.%N")
						die (1)
					end
				elseif equal(arg, "-timestamp") or else equal(arg, "-timestamps") then
					TimestampEnabled := True
				elseif equal(arg, "-notimezone") then
					TimeZoneEnabled := False
				elseif equal(arg, "-view") or else equal(arg, "-views") then
					ViewsEnabled := True

					-- dialect options
				elseif equal (arg, "-ansi")  then
					create {SQL_GENERATOR_ANSI} sqlgenerator.make
				elseif equal (arg, "-basic")  then
					create {SQL_GENERATOR_BASIC} sqlgenerator.make
				elseif equal (arg, "-db26")  then
					create {SQL_GENERATOR_DB2_6} sqlgenerator.make
				elseif equal (arg, "-db2") or else equal (arg, "-db271")  then
					create {SQL_GENERATOR_DB2_71} sqlgenerator.make
				elseif equal (arg, "-foxpro") then
					create {SQL_GENERATOR_FOXPRO} sqlgenerator.make
				elseif equal (arg, "-interbase") or else equal (arg, "-interbase6") or else equal (arg, "-ib6") then
					create {SQL_GENERATOR_INTERBASE6} sqlgenerator.make
				elseif equal (arg, "-firebird") or else equal (arg, "-firebird21") then
					create {SQL_GENERATOR_FIREBIRD_21} sqlgenerator.make
				elseif equal (arg, "-msaccess97")  then
					create {SQL_GENERATOR_MSACCESS97} sqlgenerator.make
				elseif equal (arg, "-msaccess") or else equal (arg, "-msaccess2000")  then
					create {SQL_GENERATOR_MSACCESS2000} sqlgenerator.make
				elseif equal (arg, "-msql")  then
					create {SQL_GENERATOR_MSQL} sqlgenerator.make
				elseif equal (arg, "-mysql") or else equal (arg, "-mysql5") then
					create {SQL_GENERATOR_MYSQL5} sqlgenerator.make
				elseif equal (arg, "-mysql4") then
					create {SQL_GENERATOR_MYSQL4} sqlgenerator.make
				elseif equal (arg, "-mysql322")  then
					create {SQL_GENERATOR_MYSQL322} sqlgenerator.make
				elseif equal (arg, "-oracle") or else equal (arg, "-oracle901") then
					create {SQL_GENERATOR_ORACLE} sqlgenerator.make
				elseif equal (arg, "-pgsql") or else equal (arg, "-pgsql9") or else equal (arg, "-pgsql95") then
					create {SQL_GENERATOR_PGSQL_95} sqlgenerator.make
				elseif equal (arg, "-pgsql8") or else equal (arg, "-pgsql82") then
					create {SQL_GENERATOR_PGSQL_82} sqlgenerator.make
				elseif equal (arg, "-pgsql81") then
					create {SQL_GENERATOR_PGSQL_81} sqlgenerator.make
				elseif equal (arg, "-pgsql7") or else equal (arg, "-pgsql73") then
					create {SQL_GENERATOR_PGSQL_73} sqlgenerator.make
				elseif equal (arg, "-pgsql72") then
					create {SQL_GENERATOR_PGSQL_72} sqlgenerator.make
				elseif equal (arg, "-sqlite") or else equal (arg, "-sqlite3") then
					create {SQL_GENERATOR_SQLITE_3} sqlgenerator.make
				elseif equal (arg, "-tsql") or else equal (arg, "-tsql2016") then
					create {SQL_GENERATOR_TSQL2016} sqlgenerator.make
				elseif equal (arg, "-tsql2000") then
					create {SQL_GENERATOR_TSQL2000} sqlgenerator.make
				elseif equal (arg, "-tsql70") or else equal (arg, "-tsql7") then
					create {SQL_GENERATOR_TSQL70} sqlgenerator.make
				elseif equal (arg, "-tsql65") then
					create {SQL_GENERATOR_TSQL65} sqlgenerator.make

					-- middleware options
				elseif equal (arg, "-ADO") or else equal (arg, "-ado") then
					--ADOEnabled := True
					std.error.put_string ("The -ado option is no longer supported.%N")
				elseif equal (arg, "-delphi")  then
					--DelphiEnabled := True
					std.error.put_string ("The -delphi option is no longer supported.%N")
				elseif equal (arg, "-xml")  then
					XMLEnabled := True

					-- bad option
				elseif arg.count > 0 and arg.item(1) = '-' then
					std.error.put_string("Unrecognized option '")
					std.error.put_string(arg)
					std.error.put_string("'.%N")
					die (1)
				else
					in_filename := arg
				end
				j := j + 1
			end

			-- if filename specified, open it
			if not attached in_filename then
				std.error.put_string ("(reading from stdin)%N")
			else
				create in_file.make (in_filename)
				in_file.open_read
				if not in_file.is_open_read then
					std.error.put_string ("xplain2sql: cannot read file %'")
					std.error.put_string (in_filename)
					std.error.put_string ("%'%N")
					die (1)
				end
			end

			if not attached sqlgenerator then
				create {SQL_GENERATOR_ANSI} sqlgenerator.make
			end
			sqlgenerator.set_options(
				AssertEnabled,
				AttributeRequiredEnabled,
				AutoPrimaryKeyEnabled,
				ExtendIndex,
				ExtendView,
				NoStoredProcedurePrefix,
				OldConstraintNames,
				SetDatabaseEnabled,
				StoredProcedureEnabled,
				IdentifierWithSpacesEnabled,
				TimestampEnabled,
				TimeZoneEnabled,
				ViewsEnabled)
			if attached primary_key_format as pkf then
				sqlgenerator.set_primary_key_format (pkf)
			end
			if attached sequence_name_format as snf then
				sqlgenerator.set_sequence_name_format (snf)
			end

			if not attached in_file then
				create parser.make_with_stdin (sqlgenerator)
			else
				create parser.make_with_file (in_file, sqlgenerator)
			end

			if XMLEnabled then
				create {XML_GENERATOR} mwgenerator.make (sqlgenerator)
				parser.set_mwgenerator (mwgenerator)
			end

			-- parse
			sqlgenerator.write_one_line_comment ("Script generated by xplain2sql, version " + Version + ".")
			sqlgenerator.write_one_line_comment ("Target SQL dialect is " + sqlgenerator.target_name + ".")
			parser.parse
			if attached in_file then
				in_file.close
			end
			if parser.syntax_error then
				die (1)
			else
				if attached mwgenerator as mwg then
					if XMLEnabled then
						mwg.dump_statements (parser.statements, sqlgenerator)
					end
				end
			end
		end


feature -- help

	show_usage
		do
			std.error.put_string ("This is xplain2sql, version ")
			std.error.put_string (Version)
			std.error.put_string ("%N")
			std.error.put_string ("Support page: http://www.berenddeboer.net/xplain2sql/%N%N")
			std.error.put_string ("usage: xplain2sql [sql dialect] [options] [Xplain-script | stdin ]%N%N")

			std.error.put_string ("The following sql dialects are supported:%N")
			std.error.put_string ("-ansi            output ANSI-92 sql%N")
			std.error.put_string ("-basic           output basic sql%N")
			std.error.put_string ("-db26            output DB2 version 6 sql%N")
			std.error.put_string ("-db2%N")
			std.error.put_string ("-db271           output DB2 version 7.1 sql%N")
			std.error.put_string ("-firebird%N")
			std.error.put_string ("-firebird21      output FireBird 2.1 sql%N")
			std.error.put_string ("-foxpro          output FoxPro sql%N")
			std.error.put_string ("-interbase%N")
			std.error.put_string ("-interbase6      output InterBase 6 sql%N")
			std.error.put_string ("-msaccess97      output Microsoft Access '97 sql%N")
			std.error.put_string ("-msaccess%N")
			std.error.put_string ("-msaccess2000    output Microsoft Access 2000 sql%N")
			std.error.put_string ("-msql            output mini SQL%N")
			std.error.put_string ("-mysql322        output MySQL 3.22%N")
			std.error.put_string ("-mysql4          output MySQL 4.0 ANSI mode%N")
			std.error.put_string ("-mysql%N")
			std.error.put_string ("-mysql5          output MySQL 5.0 ANSI mode%N")
			std.error.put_string ("-oracle%N")
			std.error.put_string ("-oracle901       output Oracle 9.0.1%N")
			std.error.put_string ("-pgsql7%N")
			std.error.put_string ("-pgsql73         output PostgreSQL 7.3%N")
			std.error.put_string ("-pgsql81         output PostgreSQL 8.1%N")
			std.error.put_string ("-pgsql8%N")
			std.error.put_string ("-pgsql82         output PostgreSQL 8.2%N")
			std.error.put_string ("-pgsql%N")
			std.error.put_string ("-pgsql9%N")
			std.error.put_string ("-pgsql95         output PostgreSQL 9.5%N")
			std.error.put_string ("-sqlite%N")
			std.error.put_string ("-sqlite3         output SQLite 3 SQL%N")
			std.error.put_string ("-tsql%N")
			std.error.put_string ("-tsql2016        output Microsoft SQL Server 2016 Transact SQL%N")
			std.error.put_string ("-tsql2000        output Microsoft SQL Server 2000 Transact SQL%N")
			std.error.put_string ("-tsql70          output Microsoft SQL Server Transact SQL 7.0%N")
			std.error.put_string ("-tsql65          output Microsoft SQL Server Transact SQL 6.5%N")

			std.error.put_string ("%NSQL generation options can be:%N")
			std.error.put_string ("-attributenull   Attributes (columns) are null by default%N")
			std.error.put_string ("-noauto          do not create auto-generated primary keys%N")
			std.error.put_string ("-noassert        do not generate code to support asserts%N")
			std.error.put_string ("-nodatabase      do not generate code for the database command%N")
			std.error.put_string ("-noextendindex   do not create index on the primary key for extend temporary tables%N")
			std.error.put_string ("-noextendview    always generate a temporary table for an extend%N")
			std.error.put_string ("-nosp            do not create insert/update and delete stored procedures%N")
			std.error.put_string ("-nospprefix      do not prefix stored procedure names with sp_%N")
			std.error.put_string ("-notimezone      do not emit date data type with time zone enabled%N")
			std.error.put_string ("-oldconstraintnames  use old-style constraint names.%N")
			std.error.put_string ("-pkformat        set generating format for name of primary key column.%N")
			std.error.put_string ("-sequenceformat  set generating format for sequence name used in primary key.%N")
			std.error.put_string ("-timestamp       generate timestamps%N")
			std.error.put_string ("-view            create views on table%N")

			std.error.put_string ("%NMiddleware code options can be:%N")
			std.error.put_string ("-xml             Create XML description of generated code%N")
		end


feature -- state

		parser: XPLAIN_PARSER


end
