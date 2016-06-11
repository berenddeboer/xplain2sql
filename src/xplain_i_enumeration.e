note

	description:

		"Xplain integer enumerations"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

class

	XPLAIN_I_ENUMERATION

inherit

	XPLAIN_I_DOMAIN_RESTRICTION
		rename
			make as make_xplain_domain_restriction
		redefine
			check_attachment
		end

	XPLAIN_ENUMERATION [XPLAIN_I_NODE]

	KL_IMPORTED_INTEGER_ROUTINES
		export
			{NONE} all
		end

	KL_SHARED_STANDARD_FILES
		export
			{NONE} all
		end

	ST_FORMATTING_ROUTINES
		export
			{NONE} all
		end

create

	make

feature {NONE} -- Initialization

	make (a_first: XPLAIN_I_NODE)
		do
			make_xplain_domain_restriction (True)
			first := a_first
		end

feature

	sqldomainconstraint (sqlgenerator: SQL_GENERATOR; a_column_name: STRING): STRING
			-- Return SQL search condition something like
			-- "check value in (1, 2)"
		do
			Result := sqlgenerator.sqlcheck_in (first, a_column_name)
		end

feature -- Check restriction against representation

	check_attachment (sqlgenerator: SQL_GENERATOR; a_representation: XPLAIN_REPRESENTATION)
			-- Print warning if restriction is not ok for representation.
		local
			n: detachable XPLAIN_I_NODE
			i_min_number,
			i_max_number: INTEGER
			r_min_number,
			r_max_number: DOUBLE
		do
			if attached {XPLAIN_I_REPRESENTATION} a_representation as i then
				-- We can only check this if we're dealing with stuff that
				-- fits in a 32 bit integer right now...
				if i.length <= 9 then
					i_max_number := INTEGER_.power (10, i.length) - 1
					i_min_number := - i_max_number
					from
						n := first
					until
						n = Void
					loop
						if n.item > i_max_number then
							std.error.put_string (format("Value $i in integer enumeration exceeds maximum possible number $i of domain (I$i).%N", <<integer_cell (n.item), integer_cell (i_max_number), integer_cell (i.length)>>))
						elseif n.item.item < i_min_number then
							std.error.put_string (format("Value $i in integer enumeration is lower than minimum possible number $i of domain (I$i).%N", <<integer_cell (n.item), integer_cell (i_min_number), integer_cell (i.length)>>))
						end
						n := n.next
					end
				end
			elseif attached {XPLAIN_R_REPRESENTATION} a_representation as r then
				r_max_number := (10.0) ^ (r.before) - 1
				r_min_number := - r_max_number
				from
					n := first
				until
					n = Void
				loop
					if n.item.item > r_max_number then
						std.error.put_string (format("Value $i in real enumeration exceeds maximum possible number $0.0f of domain (R$i,$i).%N", <<integer_cell (n.item), double_cell (r_max_number), integer_cell (r.before), integer_cell (r.after)>>))
					elseif n.item.item < r_min_number then
						std.error.put_string (format("Value $i in real enumeration is lower than minimum possible number $0.0f of domain (R$i,$i).%N", <<integer_cell (n.item), double_cell (r_min_number), integer_cell (r.before), integer_cell (r.after)>>))
					end
					n := n.next
				end
			end
		end

end
