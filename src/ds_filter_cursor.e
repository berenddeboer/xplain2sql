note

	description: "Gobo cursor that finds it ok to traverse over a filtered subset of the data."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2003, Berend de Boer"


deferred class

	DS_FILTER_CURSOR [G]


inherit

	DS_LINKED_LIST_CURSOR [G]
		redefine
			forth,
			is_first,
			start,
			new_iterator
		end


feature -- Access

	new_iterator: DS_LINKED_LIST_CURSOR [G]
			-- New external cursor to be used in the 'across' construct
			-- to traverse `container'
		do
			Result := container.new_iterator
		end


feature -- Status report

	is_first: BOOLEAN


feature -- Cursor movement

	forth
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

	start
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

	is_included: BOOLEAN
			-- Is current item included in the filter?
		require
			not_after: not after
		deferred
		end

end
