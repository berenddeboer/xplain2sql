note

	description: "Produces Microsoft Access 2000 SQL output"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: "

class

	SQL_GENERATOR_MSACCESS2000

inherit

	SQL_GENERATOR_MSACCESS
		redefine
			AutoPrimaryKeyConstraint
		end

create

	make

feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "Microsoft Access 2000"
		end

feature -- table options

	AutoPrimaryKeyConstraint: STRING
		once
			Result := "counter not null primary key"
		end

end
