# Markdown to Substack HTML Converter

This toolset provides an automated workflow for converting Markdown articles to HTML for pasting into Substack.

## Prerequisites

- macOS with [Homebrew](https://brew.sh/)
- [Pandoc](https://pandoc.org/) - Universal document converter (`brew install pandoc`)

## Features

- Converts Markdown to clean HTML suitable for Substack
- Preserves formatting when pasting into Substack (uses RTF format)
- Automatically copies the result to clipboard with formatting intact
- Provides a preview option
- Supports batch conversion of multiple files

## How It Works

This tool uses a two-step conversion process to ensure formatting is preserved when pasting into Substack:

1. Markdown is converted to HTML using Pandoc
2. HTML is converted to RTF (Rich Text Format) using macOS's built-in `textutil`
3. RTF content is copied to clipboard with formatting preserved

This approach ensures Substack recognizes the formatting rather than seeing plain text.

## Usage

### Using the Shell Script

For quick one-off conversions:

```bash
./md2substack.sh content/article/your-file.md
```

The HTML will be copied to your clipboard with formatting preserved, ready to paste into Substack.

### Using the Makefile

#### Convert a Single File

```bash
make convert FILE=content/article/your-file.md
```

This will:
1. Convert the file to HTML
2. Save it to `output/your-file.html`
3. Copy the HTML to your clipboard with formatting preserved

#### Preview in Browser

```bash
make preview FILE=content/article/your-file.md
```

This will generate a preview HTML file and open it in your default browser.

#### Convert All Files

```bash
make convert-all
```

This will convert all Markdown files in the `content/article` directory and save the HTML files to the `output` directory.

## Workflow

1. Write your article in Markdown format in the `content/article` directory
2. Run `make convert FILE=content/article/your-file.md` to convert it to HTML
3. Open Substack editor
4. Paste the formatted content (Cmd+V) into the Substack editor
5. Review and publish

## Advanced Configuration

You can modify the Pandoc options in the Makefile to customize the conversion. The current configuration uses:

```
PANDOC_OPTS := -f markdown+smart -t html -s --no-highlight
```

- `markdown+smart`: Enable smart quotes and other typographic enhancements
- `-s`: Produce standalone HTML
- `--no-highlight`: Disable syntax highlighting for code blocks

## Troubleshooting

- If the HTML formatting doesn't look right in Substack, try using `make preview` to see the rendered HTML first
- If pasting doesn't preserve formatting, make sure you're using Cmd+V to paste (not Edit > Paste and Match Style)
- For complex documents, you might need to paste sections separately
- Check for unsupported Markdown features
- Make sure your Markdown is well-formed 