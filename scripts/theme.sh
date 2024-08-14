#!/bin/bash
# v1.0.0
# Define colors
# \033 is the Octal of the ASCII value for the Escape character. ESC (in hexadecimal it's \x1b).
# [ is the beginning of the escape sequence.
# 1 is a parameter that specifies the output to be bold or increased intensity.
# ; is a separator. It separates parameters.
# 31, 32, 33, 34 are color codes.
export RED='\033[1;31m'
export BLUE='\033[1;34m'
export YELLOW='\033[1;33m'
export GREEN='\033[1;32m'
export NC='\033[0m' # No Color