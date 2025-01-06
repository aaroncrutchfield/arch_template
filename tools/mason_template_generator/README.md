# Mason Template Generator

A Dart CLI tool to convert Flutter projects into Mason brick templates. This tool is designed to be run from within your Flutter project's `tools` directory.

## Features

- Converts your Flutter project into a Mason brick template
- Automatically handles project name templating
- Preserves project structure
- Generates proper Mason brick configuration
- Handles binary files appropriately
- Ignores common build artifacts and IDE files
- Runs from a subdirectory without affecting the main project

## Installation

1. The tool is already part of your project in the `tools/mason_template_generator` directory
2. From the tool's directory, run:
   ```bash
   cd tools/mason_template_generator
   dart pub get
   ```

## Usage

You can run the tool in two ways:

1. From the tool's directory:
   ```bash
   dart run bin/mason_template_generator.dart -o path/to/output_directory
   ```

2. From anywhere in your project:
   ```bash
   dart run tools/mason_template_generator/bin/mason_template_generator.dart -o path/to/output_directory
   ```

Optional parameters:
- `-s, --source`: Specify the source directory (defaults to the parent of the tools directory)

The tool will:
1. Create a Mason brick structure in the output directory
2. Copy all project files to the `__brick__` directory
3. Replace project-specific names with Mason variables
4. Generate a `brick.yaml` configuration file

## Generated Template Structure

```
output_directory/
├── __brick__/
│   └── [Your project files with templated variables]
└── brick.yaml
```

## Variables

The generated brick template includes the following variables:
- `project_name`: The name of the new project
- `org_name`: The organization name in reverse domain notation (default: com.example)

## Using the Generated Brick

1. Install Mason if you haven't already:
   ```bash
   dart pub global activate mason_cli
   ```

2. Add the brick to your Mason configuration:
   ```bash
   mason add my_template --path path/to/output_directory
   ```

3. Generate a new project:
   ```bash
   mason make my_template --project_name my_new_project --org_name com.example
   ```

## Development

To modify the template generation process:

1. Update the `_replacements` map in `bin/mason_template_generator.dart` to add more variable substitutions
2. Modify the `_ignorePatterns` list to change which files are ignored
3. Update the brick configuration in `_createBrickYaml()` to add more variables

## Notes

- The tool automatically handles binary files by copying them as-is
- Common Flutter/Dart build artifacts and IDE files are ignored
- All text files are assumed to be UTF-8 encoded
- The tool ignores itself (the `tools/mason_template_generator` directory) when generating the template 