note

  description: "Xplain node used for enumerations"
  author:     "Berend de Boer <berend@pobox.com>"
  copyright:  "Copyright (c) 1999, Berend de Boer"

deferred class XPLAIN_ENUMERATION_NODE [G]

inherit

	XPLAIN_NODE [G]

feature

	to_sqlcode (sqlgenerator: SQL_GENERATOR): STRING
			-- return something suitable for sql in enumeration
		deferred
		ensure
			valid_result: Result /= Void
		end

end
