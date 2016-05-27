note

	description: "Produces Microsoft Access '97 SQL output"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	SQL_GENERATOR_MSACCESS97

inherit

	SQL_GENERATOR_MSACCESS
		redefine
			AutoPrimaryKeyConstraint,
			UniqueConstraintSupported,
			InlineUniqueConstraintSupported
		end

create

	make

feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "Microsoft Access '97"
		end

feature -- Table options

	AutoPrimaryKeyConstraint: STRING
		once
			Result := "counter not null"
		end

	UniqueConstraintSupported: BOOLEAN
		once
			Result := False
		end

	InlineUniqueConstraintSupported: BOOLEAN
		once
			Result := False
		end

end
