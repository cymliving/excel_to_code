require_relative "simplify/replace_shared_strings"
require_relative "simplify/replace_named_references"
require_relative "simplify/replace_table_references"
require_relative "simplify/replace_ranges_with_array_literals"
require_relative "simplify/inline_formulae"
require_relative "simplify/replace_formulae_with_calculated_values"
require_relative "simplify/replace_indirects_with_references"
require_relative "simplify/simplify_arithmetic"
require_relative "simplify/identify_dependencies"
require_relative "simplify/remove_cells"
require_relative "simplify/count_formula_references"
require_relative "simplify/identify_repeated_formula_elements"
require_relative "simplify/replace_common_elements_in_formulae"
require_relative "simplify/replace_arrays_with_single_cells"
require_relative "simplify/replace_values_with_constants"
