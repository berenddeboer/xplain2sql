indexing

	description:

		"SQL dialect which does not support triggers"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #2 $"


deferred class

	SQL_GENERATOR_WITHOUT_TRIGGERS


inherit

	SQL_GENERATOR


feature -- init [default]

	init_forced_default (an_attribute: XPLAIN_ATTRIBUTE): BOOLEAN is
			-- Does this attribute have an init that has to be converted
			-- to a after-insert style trigger?
		do
			-- Not applicable
			Result := False
		end

	init_forced_null (an_attribute: XPLAIN_ATTRIBUTE): BOOLEAN is
			-- Does this attribute have a init default that has to be
			-- converted to a after-insert style trigger?
		do
			-- Not applicable
			Result := False
		end


feature -- write

	write_init (type: XPLAIN_TYPE) is
		do
			if init_necessary (type) then
				std.error.put_string ("This SQL dialect does not support all defined initializations for " + type.name + ".%N")
			end
		end

end
