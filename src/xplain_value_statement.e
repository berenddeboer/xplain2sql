note

	description: "Describes the Xplain value assignment statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"


class

	XPLAIN_VALUE_STATEMENT


inherit

	XPLAIN_STATEMENT
		redefine
			cleanup,
			write_value_declare_inside_sp
		end

	XPLAIN_UNIVERSE_ACCESSOR


create

	make


feature {NONE} -- Initialization

	make (a_value: XPLAIN_VALUE)
		require
			have_value: a_value /= Void
		do
			value := a_value
		end


feature -- Generate output

	write (a_generator: ABSTRACT_GENERATOR)
			-- Write output according to this generator.
		do
			a_generator.write_value (value)
		end

	write_value_declare_inside_sp (a_generator: SQL_GENERATOR_WITH_SP)
			-- Write output according to this generator.
		do
			if not a_generator.is_value_declared (value) then
				a_generator.create_value_declare (value)
			end
		ensure then
			declared: a_generator.is_value_declared (value)
		end


feature -- Cleanup

	cleanup
			-- When value is used in procedure, the value is removed from
			-- the universe the after stored procedure has been generated.
			-- This of course assumes that the code for a stored
			-- procedure is emitted immediately after it appears in the
			-- input, but that is currently the case.
		do
			-- Test if it still exists, a value is only added once to the
			-- universe, but there can be multiple value statements.
			if universe.has (value.name) then
				universe.delete (value)
			end
		ensure then
			does_not_exist_in_universe: not universe.has (value.name)
		end


feature -- Access

	value: XPLAIN_VALUE


feature -- Status

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Is parameter `a_parameter' used by this statement?
		do
			Result := value.expression.uses_parameter (a_parameter)
		end


invariant

	have_value: value /= Void

end
