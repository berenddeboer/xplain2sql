note

	description: "Describes the Xplain extend statement."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2002, Berend de Boer"

class

	XPLAIN_EXTEND_STATEMENT


inherit

	XPLAIN_STATEMENT
		redefine
			cleanup,
			optimize_for_procedure
		end


create

	make


feature -- Initialization

	make (a_extension: XPLAIN_EXTENSION)
		require
			have_extension: a_extension /= Void
		do
			extension := a_extension
		end


feature -- Commands

	cleanup
			-- After stored procedure has been written, the extend is
			-- removed from the type.
		do
			extension.type.remove_extension (extension)
		end

	optimize_for_procedure (a_procedure : XPLAIN_PROCEDURE)
		local
			cursor: DS_BILINKED_LIST_CURSOR [XPLAIN_STATEMENT]
			updated: BOOLEAN
			an: XPLAIN_ATTRIBUTE_NAME
			optimization_possible: BOOLEAN
		do
			optimization_possible := extension.expression.is_update_optimization_supported
			if optimization_possible then
				create an.make (Void, extension.name)
				cursor := a_procedure.statements.new_cursor
				from
					cursor.start
				until
					updated or else
					cursor.after
				loop
					if cursor.item /= Current then
						updated := cursor.item.updates_attribute (extension.type, an)
					end
					cursor.forth
				end
				if not updated then
					extension.set_no_update_optimization (True)
				end
			end
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Is parameter `a_parameter' used by this statement?
		do
			Result := extension.expression.uses_parameter (a_parameter)
		end

	write (a_generator: ABSTRACT_GENERATOR)
			-- Write output according to this generator.
		do
			a_generator.write_extend (extension)
		end


feature -- Access

	extension: XPLAIN_EXTENSION


invariant

	have_extension: extension /= Void

end
