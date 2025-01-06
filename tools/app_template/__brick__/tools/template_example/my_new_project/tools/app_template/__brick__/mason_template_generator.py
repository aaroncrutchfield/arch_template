#!/usr/bin/env python3
import os
import shutil
import re
import yaml
from pathlib import Path

class MasonTemplateGenerator:
    def __init__(self, source_dir: str, output_dir: str):
        self.source_dir = Path(source_dir)
        self.output_dir = Path(output_dir)
        self.project_name = self.source_dir.name
        self.brick_name = f"{self.project_name}_template"
        
        # Common replacements for templating
        self.replacements = {
            self.project_name: "my_new_project",
            self.project_name.title(): "",
            self.project_name.lower(): "",
        }

    def create_brick_structure(self):
        """Creates the basic Mason brick directory structure"""
        brick_dir = self.output_dir / "__brick__"
        brick_dir.mkdir(parents=True, exist_ok=True)
        return brick_dir

    def process_file_content(self, content: str) -> str:
        """Replace project-specific names with Mason variables"""
        for old, new in self.replacements.items():
            content = content.replace(old, new)
        return content

    def should_ignore_file(self, file_path: str) -> bool:
        """Check if file should be ignored in template"""
        ignore_patterns = [
            r'\.git/',
            r'\.dart_tool/',
            r'\.mason/',
            r'build/',
            r'\.packages$',
            r'\.lock$',
            r'\.iml$',
            r'\.log$',
        ]
        return any(re.search(pattern, file_path) for pattern in ignore_patterns)

    def copy_and_process_files(self, brick_dir: Path):
        """Copy and process all project files to the brick directory"""
        for root, dirs, files in os.walk(self.source_dir):
            rel_path = Path(root).relative_to(self.source_dir)
            
            # Skip ignored directories
            if self.should_ignore_file(str(rel_path)):
                continue

            # Create corresponding directory in brick
            target_dir = brick_dir / rel_path
            target_dir.mkdir(parents=True, exist_ok=True)

            # Process each file
            for file in files:
                if self.should_ignore_file(file):
                    continue

                source_file = Path(root) / file
                target_file = target_dir / file

                # Read and process content
                with open(source_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                processed_content = self.process_file_content(content)

                # Write processed content
                with open(target_file, 'w', encoding='utf-8') as f:
                    f.write(processed_content)

    def create_brick_yaml(self):
        """Create the brick.yaml configuration file"""
        brick_config = {
            'name': self.brick_name,
            'description': f'A brick to create a new Flutter application based on {self.project_name}',
            'version': '0.1.0+1',
            'environment': {
                'mason': '>=0.1.0-dev <0.1.0'
            },
            'vars': {
                'project_name': {
                    'type': 'string',
                    'description': 'The project name',
                    'prompt': 'What is the project name?'
                },
                'org_name': {
                    'type': 'string',
                    'description': 'The organization name (reverse domain notation)',
                    'prompt': 'What is the organization name (com.example)?',
                    'default': 'com.example'
                }
            }
        }

        with open(self.output_dir / 'brick.yaml', 'w') as f:
            yaml.dump(brick_config, f, sort_keys=False)

    def generate(self):
        """Main method to generate the Mason brick"""
        print(f"Generating Mason brick from {self.project_name}...")
        
        # Create brick structure
        brick_dir = self.create_brick_structure()
        
        # Copy and process files
        self.copy_and_process_files(brick_dir)
        
        # Create brick.yaml
        self.create_brick_yaml()
        
        print(f"Mason brick generated successfully at {self.output_dir}")


if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python mason_template_generator.py <output_directory>")
        sys.exit(1)

    source_dir = os.getcwd()
    output_dir = sys.argv[1]

    generator = MasonTemplateGenerator(source_dir, output_dir)
    generator.generate() 