note

	description:
		"Produces mySQL 3.22 output. Maybe lower versions are supported also"

	known_bugs:
		"1. quoted_identifiers not supported, were only introduced with 3.32.6."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"


class

	SQL_GENERATOR_MYSQL322


inherit

	SQL_GENERATOR_MYSQL
		redefine
			AutoPrimaryKeyConstraint
		end


create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "mySQL 3.22"
		end


feature -- table options

	AutoPrimaryKeyConstraint: STRING
		once
			Result := "auto_increment " + PrimaryKeyConstraint
		end


end
