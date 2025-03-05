# Makefile for Substack article conversion
# Usage: 
# - Convert single file: make convert FILE=content/article/your-file.md
# - Convert all files: make convert-all

# Configuration
CONTENT_DIR := content/article
OUTPUT_DIR := output
PANDOC := pandoc
PANDOC_OPTS := -f markdown+smart -t html --metadata=lang:en --variable=document-css:false --variable=mainfont="Helvetica" --html-q-tags -s --no-highlight
TMP_DIR := $(shell mktemp -d)

# Convert a single markdown file to HTML and copy to clipboard
convert:
	@if [ -z "$(FILE)" ]; then \
		echo "Error: Please specify a file with FILE=path/to/file.md"; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE)" ]; then \
		echo "Error: File '$(FILE)' not found"; \
		exit 1; \
	fi
	@mkdir -p $(OUTPUT_DIR)
	@echo "Converting $(FILE) to HTML..."
	@$(PANDOC) $(PANDOC_OPTS) "$(FILE)" | \
		sed -e '/<html>/d' -e '/<\/html>/d' -e '/<head>/,/<\/head>/d' -e '/<body>/d' -e '/<\/body>/d' > "$(OUTPUT_DIR)/$(notdir $(FILE:.md=.html))"
	@echo "Creating properly encoded HTML document..."
	@echo '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Substack Article</title></head><body>' > "$(TMP_DIR)/full.html"
	@cat "$(OUTPUT_DIR)/$(notdir $(FILE:.md=.html))" >> "$(TMP_DIR)/full.html"
	@echo '</body></html>' >> "$(TMP_DIR)/full.html"
	@echo "Converting to RTF for clipboard..."
	@textutil -convert rtf -encoding UTF-8 -output "$(TMP_DIR)/temp.rtf" "$(TMP_DIR)/full.html"
	@cat "$(TMP_DIR)/temp.rtf" | pbcopy -Prefer rtf
	@rm -rf "$(TMP_DIR)"
	@echo "✅ Converted '$(FILE)' to HTML and saved to $(OUTPUT_DIR)/$(notdir $(FILE:.md=.html))"
	@echo "📋 HTML content copied to clipboard with formatting preserved. Ready to paste into Substack editor."

# Convert all markdown files in content directory
convert-all:
	@mkdir -p $(OUTPUT_DIR)
	@echo "Converting all markdown files in $(CONTENT_DIR)..."
	@for file in $(CONTENT_DIR)/*.md; do \
		if [ -f "$$file" ]; then \
			html_file="$(OUTPUT_DIR)/$$(basename "$$file" .md).html"; \
			echo "Processing $$file -> $$html_file"; \
			$(PANDOC) $(PANDOC_OPTS) "$$file" | \
				sed -e '/<html>/d' -e '/<\/html>/d' -e '/<head>/,/<\/head>/d' -e '/<body>/d' -e '/<\/body>/d' > "$$html_file"; \
			echo "✅ Converted"; \
		fi; \
	done
	@echo "All conversions complete. HTML files are in $(OUTPUT_DIR)/"

# Preview the HTML in the default browser
preview:
	@if [ -z "$(FILE)" ]; then \
		echo "Error: Please specify a file with FILE=path/to/file.md"; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE)" ]; then \
		echo "Error: File '$(FILE)' not found"; \
		exit 1; \
	fi
	@mkdir -p $(OUTPUT_DIR)
	@echo "Generating preview for $(FILE)..."
	@$(PANDOC) $(PANDOC_OPTS) --embed-resources --standalone --metadata title="Preview" "$(FILE)" > "$(OUTPUT_DIR)/$(notdir $(FILE:.md=.preview.html))"
	@open "$(OUTPUT_DIR)/$(notdir $(FILE:.md=.preview.html))"
	@echo "Preview opened in your default browser."

.PHONY: convert convert-all preview 