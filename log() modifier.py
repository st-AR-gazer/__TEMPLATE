import os
import re

def modify_log_statements(directory):
    log_pattern = re.compile(r'log\((.*), LogLevel::(\w+)(?:, \d+)?\);')
    modifications = []

    for root, dirs, files in os.walk(directory):
        if '.git' in root.split(os.sep):
            continue

        for file in files:
            if file in ['.gitignore', '.gitattributes']:
                continue

            file_path = os.path.join(root, file)
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()

                file_modified = False
                modified_lines = []
                for i, line in enumerate(lines):
                    match = log_pattern.search(line)
                    if match:
                        file_modified = True
                        log_content, log_level = match.groups()
                        new_line = f'log({log_content}, LogLevel::{log_level}, {i + 1});\n'
                        lines[i] = new_line
                        modified_lines.append(i + 1)

                if file_modified:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.writelines(lines)
                    modifications.append((file_path, modified_lines))
            except UnicodeDecodeError:
                continue

    return modifications

def main():
    print("Log Statement Modifier")
    directory = "./src"
    modifications = modify_log_statements(directory)

    print("Processing complete.")
    if modifications:
        print("Files modified:")
        for file_path, lines in modifications:
            print(f"  - {file_path}: Lines {', '.join(map(str, lines))}")
    else:
        print("No files were modified.")
    input("Press Enter to exit...")

if __name__ == "__main__":
    main()
