# Mason Template Generator

A Python script to convert a Flutter project into a Mason brick template.

## Prerequisites

- Python 3.6+
- PyYAML package (`pip install pyyaml`)

## Installation

1. Copy both `mason_template_generator.py` and this README to your Flutter project root directory
2. Make the script executable:
   ```bash
   chmod +x mason_template_generator.py
   ```

## Usage

1. Navigate to your Flutter project root directory
2. Run the script with the desired output directory:
   ```bash
   ./mason_template_generator.py path/to/output_directory
   ```

The script will:
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

## Customization

You can modify the script to:
- Add more template variables
- Customize file processing logic
- Add additional file patterns to ignore
- Modify the brick configuration

## Notes

- The script ignores common Flutter/Dart build artifacts and IDE files
- Binary files are copied as-is
- The script assumes UTF-8 encoding for text files 