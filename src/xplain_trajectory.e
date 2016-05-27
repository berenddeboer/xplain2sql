note

	description:

	"Xplain domain restriction abstraction"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #5 $"


class

	XPLAIN_TRAJECTORY


inherit

	XPLAIN_DOMAIN_RESTRICTION
		rename
			make as make_xplain_domain_restriction
		redefine
			check_attachment
		end

	KL_SHARED_STANDARD_FILES
		export
			{NONE} all
		end


create

	make


feature {NONE} -- Initialisation

	make (a_min, a_max: STRING)
		require
			min_not_empty: a_min /= Void and then not a_min.is_empty
			max_not_empty: a_max /= Void and then not a_max.is_empty
		do
			make_xplain_domain_restriction (True)
			min := a_min
			max := a_max
		end

feature

	min: STRING
	max: STRING
			-- The raw user supplied values; can't convert them to
			-- numbers to avoid overflow.

feature -- SQL code

	sqldomainconstraint (sqlgenerator: SQL_GENERATOR; column_name: STRING): STRING
		do
			result := sqlgenerator.sqlcheck_between(Current, column_name)
		end

feature -- Check restriction against representation

	check_attachment (sqlgenerator: SQL_GENERATOR; representation: XPLAIN_REPRESENTATION)
			-- Print warning if a value in enumeration does not fit in
			-- max base type length.
		local
			Irepresentation: XPLAIN_I_REPRESENTATION
			Rrepresentation: XPLAIN_R_REPRESENTATION
			min_length,
			max_length: INTEGER
		do
			min_length := min.count
			if min.item (1) = '-' then
				min_length := min.count -1
			end
			max_length := max.count
			if max.item (1) = '-' then
				max_length := max.count -1
			end
			Irepresentation ?= representation
			if Irepresentation /= Void then
				if min_length > Irepresentation.length then
					std.error.put_string ("Minimum value ")
					std.error.put_string (min)
					std.error.put_string (" in trajectory exceeds maximum length ")
					std.error.put_integer (Irepresentation.length)
					std.error.put_string (" of integer representation.%N")
				end
				if max_length > Irepresentation.length then
					std.error.put_string ("Maximum value ")
					std.error.put_string (max)
					std.error.put_string (" in trajectory exceeds maximum length ")
					std.error.put_integer (Irepresentation.length)
					std.error.put_string (" of integer representation.%N")
				end
			else
				Rrepresentation ?= representation
				if Rrepresentation /= Void then
					if min_length > Rrepresentation.before then
						std.error.put_string ("Minimum value ")
						std.error.put_string (min)
						std.error.put_string (" in trajectory exceeds maximum length ")
						std.error.put_integer (Rrepresentation.before)
						std.error.put_string (" of real representation.%N")
					end
					if max_length > Rrepresentation.before then
						std.error.put_string ("Maximum value ")
						std.error.put_string (max)
						std.error.put_string (" in trajectory exceeds maximum length ")
						std.error.put_integer (Rrepresentation.before)
						std.error.put_string (" of real representation.%N")
					end
				end
			end
		end


invariant

	min_not_empty: min /= Void and then not min.is_empty
	max_not_empty: max /= Void and then not max.is_empty

end
