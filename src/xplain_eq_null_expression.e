note

	description: "Xplain if property equal to NULL expression."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2003, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #3 $"


class

	XPLAIN_EQ_NULL_EXPRESSION


inherit

	XPLAIN_NULL_EXPRESSION


create

	make


feature {NONE} -- Implementation

	compare_with_null: STRING = " is null"


end
