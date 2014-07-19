#!/usr/bin/env bash

# # Bash script for running the test suite every time a file is changed.

julia ../tests/test_1_parsing.jl  && \
julia ../tests/test_2_evaluating_simple_expressions.jl && \
julia ../tests/test_3_evaluating_complex_expressions.jl && \
julia ../tests/test_4_working_with_variables_and_environments.jl && \
julia ../tests/test_5_adding_functions_to_the_mix.jl && \
julia ../tests/test_6_working_with_lists.jl && \
julia ../tests/test_7_using_the_language.jl


