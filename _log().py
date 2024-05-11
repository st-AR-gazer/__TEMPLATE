import os
import re

# Regex log() pattern
log_pattern = re.compile(r'log\(([^;]*?)\);')

# Regex function definitions pattern
function_pattern = re.compile(
    r'(void|int|uint|int8|uint8|int16|uint16|int64|uint64|float|double|bool|string|wstring|'
    r'vec2|vec3|vec4|int2|int3|nat2|nat3|iso3|mat3|iso4|mat4|quat|RGBAColor|MemoryBuffer|'
    r'DataRef|CMwStack|MwId|MwSArray|MwStridedArray|MwFastArray|MwFastBuffer|MwFastBufferCat|'
    r'MwRefBuffer|MwNodPool|MwVirtualArray|array<[^>]*>|enum\w*|dictionaryValue|dictionary|ref)'
    r'\s+(\w+)\s*\(([^)]*)\)\s*\{')

# Default params
default_params = {
    'msg': '""',
    'level': "LogLevel::Info",
    'line': "-1",
    'functionName': '""'
}

def get_function_name(lines, index):
    for i in range(index, -1, -1):
        match = function_pattern.search(lines[i])
        if match:
            return match.group(2)
    return "UnknownFunction"

def clean_and_update_params(params, index, lines):
    cleaned_params = [param for param in params if param.strip()]

    filled_params = []
    for i, key in enumerate(default_params):
        try:
            filled_params.append(cleaned_params[i] if cleaned_params[i] else default_params[key])
        except IndexError:
            filled_params.append(default_params[key])

    # Update line and function name dynamically or use default if unavailable
    filled_params[2] = str(index + 1) if len(filled_params) > 2 else default_params['line']  # Update line number
    filled_params[3] = f'"{get_function_name(lines, index)}"' if len(filled_params) > 3 else default_params['functionName']  # Update function name
    return filled_params

def modify_log_statements(file_path):
    modified = False
    with open(file_path, 'r') as file:
        lines = file.readlines()

    with open(file_path, 'w') as file:
        for index, line in enumerate(lines):
            result = log_pattern.search(line)
            if result:
                log_content = result.group(1)
                params = [param.strip() for param in log_content.split(',')]
                updated_params = clean_and_update_params(params, index, lines)

                new_log = f'log({", ".join(updated_params)});'
                line = line.replace(result.group(0), new_log)
                modified = True
                print(f"Updated log call in {file_path}: {new_log}")
            file.write(line)

    return modified

def process_directory(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            if modify_log_statements(file_path):
                print(f"Found and updated instances in: {file_path}")

process_directory('./src')
