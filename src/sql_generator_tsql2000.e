indexing

	description:

		"SQL for Microsoft SQL Server 2000"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #3 $"


class

	SQL_GENERATOR_TSQL2000


inherit

	SQL_GENERATOR_TSQL70
		redefine
			datatype_int,
			max_numeric_precision,
			target_name
		end


create

	make


feature -- About this generator

	target_name: STRING is
			-- Name and version of dialect
		once
			Result := "MS SQL Server 2000"
		end


feature -- Numeric precision

	max_numeric_precision: INTEGER is
			-- Maximum precision of the numeric data type
		once
			Result := 38
		end


feature -- type specification for xplain types

	datatype_int (representation: XPLAIN_I_REPRESENTATION): STRING is
		do
			inspect representation.length
			when 1 .. 4 then
				Result := "smallint"
			when 5 .. 9 then
				Result := "integer"
			when 10 .. 19 then
				Result := "bigint"
			else
				if representation.length > max_numeric_precision then
					std.error.put_string ("Too large integer representation detected: ")
					std.error.put_integer (representation.length)
					std.error.put_string ("%NRepresentation truncated to ")
					std.error.put_integer (max_numeric_precision)
					std.error.put_character ('%N')
					Result := "numeric(" + max_numeric_precision.out + ", 0)"
				else
					Result := "numeric(" + representation.length.out + ", 0)"
				end
			end
		end

end
