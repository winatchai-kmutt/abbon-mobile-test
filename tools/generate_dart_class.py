import json
import argparse

def snake_to_camel_case(snake_str):
    """Convert snake_case to camelCase."""
    components = snake_str.split('_')
    return components[0] + ''.join(x.title() for x in components[1:])

def generate_dart_class(json_file, output_file):
    # Read the JSON file
    with open(json_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Generate the Dart class content
    dart_class = "// DO NOT EDIT.  This is code generated. \n\n"  # Add the comment at the top
    dart_class += "abstract class LocaleKeys {\n"
    for key in data.keys():
        camel_case_key = snake_to_camel_case(key)  # Convert snake_case to camelCase
        dart_class += f"  static const {camel_case_key} = '{key}';\n"
    dart_class += "}"
    
    # Write the Dart class to the output file
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(dart_class)

    print(f"Generated {output_file} from {json_file}")

def main():
    # Set up command-line argument parsing
    parser = argparse.ArgumentParser(description="Generate Dart constants from a JSON file.")
    parser.add_argument('json_file', type=str, help='Path to the input JSON file')
    parser.add_argument('output_file', type=str, help='Path to the output Dart file')
    
    # Parse arguments
    args = parser.parse_args()
    
    # Generate the Dart class
    generate_dart_class(args.json_file, args.output_file)

if __name__ == "__main__":
    main()