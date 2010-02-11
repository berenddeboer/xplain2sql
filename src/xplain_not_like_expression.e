indexing

	description: "Use for <> expressions with string literal that contains wild card characters."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2003, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #3 $"


class

	XPLAIN_NOT_LIKE_EXPRESSION


inherit

	XPLAIN_LIKE_EXPRESSION
		redefine
			sqloperator,
			xplain_operator
		end


create

	make


feature -- SQL code

	sqloperator: STRING is
			-- The SQL translation for `operator'
		once
			Result := "not like"
		end


feature {NONE} -- Once strings

	xplain_operator: STRING is
			-- The Xplain operator itself.
		once
			Result := "<>"
		end


end
