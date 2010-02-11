indexing

	description:

		"Produces PostgreSQL 8.1 output."

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2010/02/11 $"
	revision: "$Revision: #3 $"


class

	SQL_GENERATOR_PGSQL_81


inherit

	SQL_GENERATOR_PGSQL_73
		redefine
			target_name,
			MaxIdentifierLength,
			SupportsJoinInUpdate,
			output_update_from_clause,
			output_update_extend_from_clause,
			as_string,
			plpgsql_block_demarcation,
			sp_end,
			safe_sql
		end


create

	make


feature -- About this generator

	target_name: STRING is
			-- Name and version of dialect
		once
			Result := "PostgreSQL 8.1"
		end


feature -- Identifiers

	MaxIdentifierLength: INTEGER is
			-- Default length for PostgreSQL 8.1
		once
			Result := 63
		end


feature -- update options

	SupportsJoinInUpdate: BOOLEAN is
			-- Does this dialect support a from clause in an update statement?
		do
			Result := True
		end


feature -- Literal

	as_string (s: STRING): STRING is
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


feature {NONE} -- Update SQL

	output_update_from_clause (a_subject: XPLAIN_SUBJECT; a_join_list: JOIN_LIST) is
			-- PostgreSQL way of having joins in an update statement.
		do
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string (once "from ")
			std.output.put_string (sql_update_joins (False, a_join_list))
		end

	output_update_extend_from_clause (a_subject: XPLAIN_SUBJECT; a_join_list: JOIN_LIST) is
			-- PostgreSQL way of having joins in an update statement.
		do
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string (once "from ")
			std.output.put_string (a_subject.type.quoted_name (Current))
			std.output.put_string (sql_update_joins (True, a_join_list))
		end

	sql_update_joins (a_skip_first: BOOLEAN; join_list: JOIN_LIST): STRING is
			-- `join_list' as join statements suitable for PostgreSQL
			-- update from clause.
		require
			join_list_not_void: join_list /= Void
		local
			jnode: JOIN_NODE
			tablename: STRING
			code: STRING
		do
			create code.make (512)

			-- write from clause
			-- if `a_skip_first', skip first table, because that's the
			-- table mentioned in the from clause.
			from
				if a_skip_first then
					jnode := join_list.first.next
				else
					jnode := join_list.first
				end
			until
				jnode = Void
			loop
				if not code.is_empty or else a_skip_first then
					code := code + ", "
				end
				code := code + jnode.item.attribute.quoted_name (Current)
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
				code := code + quote_identifier(jnode.item.attribute.sqlpkname (Current))
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


feature -- Stored procedure support

	plpgsql_block_demarcation: STRING is "$$"

	sp_end is
			-- Write statements, if any, to end a stored procedure.
		do
			is_stored_procedure := False
			std.output.put_string ("end")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_string (plpgsql_block_demarcation)
			std.output.put_string (" language 'plpgsql'")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end


feature {NONE} -- SQL parts

	safe_sql (s: STRING): STRING is
			-- ' characters in `s' are quoted if necessary
		do
			Result := s
		end

end
