indexing

	description: "Gobo cursor that finds it ok to traverse over a filtered subset of the data."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2003, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #3 $"


deferred class

	DS_FILTER_CURSOR [G]


inherit

	DS_LINKED_LIST_CURSOR [G]
		redefine
			forth,
			is_first,
			start
		end


feature -- Status report

	is_first: BOOLEAN


feature -- Cursor movement

	forth is
			-- Move cursor to next position included in the filter.
		do
			is_first := False
			from
				precursor
			until
				after or else
				is_included
			loop
				precursor
			end
		end

	start is
			-- Move cursor to first position included in the filter.
		do
			is_first := not container.is_empty
			precursor
			if not after then
				if not is_included then
					forth
				end
			end
			is_first := not after
		end


feature -- Filter check

	is_included: BOOLEAN is
			-- Is current item included in the filter?
		require
			not_after: not after
		deferred
		end

end
