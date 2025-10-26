#!/bin/bash

# Fix headers for files that already have incorrect headers

set -euo pipefail

AUTHOR="Garnish Contributors"
COPYRIGHT_HOLDER="Garnish Contributors"
YEAR=2025

fix_header() {
    local file="$1"
    local filename=$(basename "$file")
    
    # Detect module from path
    if [[ "$file" =~ /GarnishTheme/ ]]; then
        MODULE="GarnishTheme"
    elif [[ "$file" =~ /GarnishExpansion/ ]]; then
        MODULE="GarnishExpansion"
    else
        MODULE="Garnish"
    fi
    
    # Create new header
    cat > "$file.header" << HEADER
//
//  $filename
//  $MODULE
//
//  Created by $AUTHOR, $YEAR.
//
//  Copyright © $YEAR $COPYRIGHT_HOLDER. All rights reserved.
//  Licensed under the MIT License.
//

HEADER
    
    # Remove old header (everything up to first non-comment/blank line)
    awk '
        BEGIN { in_header = 1; blank_count = 0 }
        /^\/\// { if (in_header) next }
        /^[[:space:]]*$/ { 
            if (in_header) {
                blank_count++
                if (blank_count > 1) in_header = 0
                next
            }
        }
        { in_header = 0; print }
    ' "$file" > "$file.tmp"
    
    # Combine new header with content
    cat "$file.header" "$file.tmp" > "$file.new"
    mv "$file.new" "$file"
    rm "$file.header" "$file.tmp"
    
    echo "✓ Fixed $file"
}

# List of files with header issues
FILES=(
    "Sources/GarnishTheme/GarnishThemeDemo.swift"
    "Sources/Garnish/GarnishDemo.swift"
    "Sources/Garnish/Extensions/FontExtensions.swift"
    "Sources/Garnish/Extensions/UIColorExtensions.swift"
    "Sources/Garnish/Extensions/ColorConvenienceExtensions.swift"
    "Sources/Garnish/Extensions/ColorExtensions.swift"
    "Sources/Garnish/Deprecated/recomendedFontWeight.swift"
    "Sources/Garnish/Deprecated/colorBase(dep).swift"
    "Sources/Garnish/Deprecated/contrastingForeground.swift"
    "Sources/GarnishExpansion/GarnishColorExpansion.swift"
    "Sources/Garnish/Deprecated/Examples.swift"
    "Sources/Garnish/Deprecated/adjustForBackground.swift"
    "Sources/Garnish/Deprecated/FontExtensionsDeprecated.swift"
    "Sources/Garnish/Garnish.swift"
    "Sources/Garnish/Deprecated/garnishModifier.swift"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        fix_header "$file"
    fi
done

echo "✅ Fixed ${#FILES[@]} file headers"
