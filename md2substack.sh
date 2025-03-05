#!/bin/bash

# md2substack.sh - Convert Markdown to HTML for Substack
# Usage: ./md2substack.sh <input.md>

if [ $# -eq 0 ]; then
  echo "Usage: ./md2substack.sh <input.md>"
  exit 1
fi

input_file="$1"

if [ ! -f "$input_file" ]; then
  echo "Error: File '$input_file' not found"
  exit 1
fi

# Create a temporary directory
tmp_dir=$(mktemp -d)
html_file="$tmp_dir/temp.html"
rtf_file="$tmp_dir/temp.rtf"

# Convert markdown to HTML with pandoc with explicit UTF-8 encoding
echo "Converting to HTML..."
pandoc -f markdown+smart -t html --metadata=lang:en --variable=document-css:false --variable=mainfont="Helvetica" --html-q-tags -s --no-highlight "$input_file" | 
  sed -e '/<html>/d' -e '/<\/html>/d' -e '/<head>/,/<\/head>/d' -e '/<body>/d' -e '/<\/body>/d' > "$html_file"

# Better approach: Use open command with pbcopy
echo "Preparing for clipboard..."

# Create a full HTML document for textutil to process properly
cat > "$tmp_dir/full.html" << EOF
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Substack Article</title>
</head>
<body>
$(cat "$html_file")
</body>
</html>
EOF

# Convert to RTF with explicit encoding
textutil -convert rtf -encoding UTF-8 -output "$rtf_file" "$tmp_dir/full.html"

# Copy to clipboard
cat "$rtf_file" | pbcopy -Prefer rtf

# Clean up temporary files
rm -rf "$tmp_dir"

echo "✅ Converted '$input_file' to HTML and copied to clipboard with formatting preserved."
echo "📋 Ready to paste into Substack editor." 