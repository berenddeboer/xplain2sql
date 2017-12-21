note

	description: "Singleton accessor class that returns the Xplain universe."
	thanks: "Thanks to Design Patterns and Contracts."

	author: "Berend de Boer"


class

	XPLAIN_UNIVERSE_ACCESSOR


feature {NONE} -- Implementation

	universe: XPLAIN_UNIVERSE
			-- Access to the unique instance.
		once
			create Result.make
		ensure
			result_not_void: Result /= Void
		end

	is_universe_real_singleton: BOOLEAN
			-- Do multiple calls to `universe' return the same result?
		do
			Result := universe = universe
		end


invariant

	accessing_real_singleton: is_universe_real_singleton

end
