import os
import zipfile

def sanitize_filename(filename):
    return filename.replace("_", "").replace("-", "")

def zip_directory(src_dir, zip_file):
    for root, dirs, files in os.walk(src_dir):
        for file in files:
            sanitized_file = sanitize_filename(file)
            file_path = os.path.join(root, file)
            sanitized_file_path = os.path.join(root, sanitized_file)
            zip_file.write(file_path, os.path.relpath(sanitized_file_path, os.path.join(src_dir, '..')))

def create_op_file():
    top_dir_name = os.path.basename(os.getcwd())
    op_file_name = f"{sanitize_filename(top_dir_name)}.op"

    with zipfile.ZipFile(op_file_name, 'w', zipfile.ZIP_DEFLATED) as zipf:
        zip_directory('./src', zipf)

        additional_files = ['info.toml', 'LICENSE', 'README.md']
        for file in additional_files:
            if os.path.exists(file):
                sanitized_file = sanitize_filename(file)
                zipf.write(file, sanitized_file)

    print(f"Created {op_file_name} successfully.")
    print(f"IMPORTANT: Enable showDefaultLogs, in src/Condictions/Logging.as so the logs are uniform")

if __name__ == "__main__":
    create_op_file()
