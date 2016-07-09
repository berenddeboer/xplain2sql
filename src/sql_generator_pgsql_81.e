note

	description:

		"Produces PostgreSQL 8.1 output."

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2007, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"


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

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "PostgreSQL 8.1"
		end


feature -- Identifiers

	MaxIdentifierLength: INTEGER
			-- Default length for PostgreSQL 8.1
		once
			Result := 63
		end


feature -- update options

	SupportsJoinInUpdate: BOOLEAN
			-- Does this dialect support a from clause in an update statement?
		do
			Result := True
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


feature {NONE} -- Update SQL

	output_update_from_clause (a_subject: XPLAIN_SUBJECT; a_join_list: JOIN_LIST)
			-- PostgreSQL way of having joins in an update statement.
		do
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string (once "from ")
			std.output.put_string (sql_update_joins (False, a_join_list))
		end

	output_update_extend_from_clause (a_subject: XPLAIN_SUBJECT; a_join_list: JOIN_LIST)
			-- PostgreSQL way of having joins in an update statement.
		do
			std.output.put_character ('%N')
			std.output.put_string (Tab)
			std.output.put_string (once "from ")
			std.output.put_string (a_subject.type.quoted_name (Current))
			std.output.put_string (sql_update_joins (True, a_join_list))
		end

	sql_update_joins (a_skip_first: BOOLEAN; join_list: JOIN_LIST): STRING
			-- `join_list' as join statements suitable for PostgreSQL
			-- update from clause.
		require
			join_list_not_void: join_list /= Void
		local
			jnode: detachable JOIN_NODE
			code: STRING
		do
			create code.make (512)

			-- write from clause
			-- if `a_skip_first', skip first table, because that's the
			-- table mentioned in the from clause.
			from
				if a_skip_first then
					check attached join_list.first as first then
						jnode := first.next
					end
				else
					jnode := join_list.first
				end
			until
				not attached jnode
			loop
				if not code.is_empty or else a_skip_first then
					code := code + ", "
				end
				code := code + jnode.item.aggregate_attribute.quoted_name (Current)
				if attached jnode.item.attribute_alias_name as n then
					-- only write alias when not equal to table/view name
					code := code + " "
					code := code + quote_identifier(n)
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
				not attached jnode
			loop
				code := code + quote_identifier(jnode.item.attribute_alias_name)
				code := code + "."
				code := code + quote_identifier(jnode.item.aggregate_attribute.sqlpkname (Current))
				code := code + " = "
				code := code + quote_identifier(jnode.item.aggregate_alias_name)
				code := code + "."
				code := code + quote_identifier(jnode.item.aggregate_fk)
				jnode := jnode.next
				if attached jnode then
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

	plpgsql_block_demarcation: STRING = "$$"

	sp_end
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

	safe_sql (s: STRING): STRING
			-- ' characters in `s' are quoted if necessary
		do
			Result := s
		end

end
