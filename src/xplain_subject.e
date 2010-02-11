indexing

	description: "typename [ identification ]"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #7 $"

class

	XPLAIN_SUBJECT


create

	make


feature {NONE} -- Initialization

	make (
			a_type: XPLAIN_TYPE;
			an_identification: XPLAIN_EXPRESSION) is
			-- Initialize subject.
		require
			type_not_void: a_type /= Void
		do
			type := a_type
			identification := an_identification
		end


feature -- Access

	identification: XPLAIN_EXPRESSION
			-- Either a string/integer or a parameter expression;
			-- if void, no identification given.

	type: XPLAIN_TYPE
			-- Type to operate on

invariant

	type_not_void: type /= Void

end
