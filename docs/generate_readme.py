import os
import subprocess
import json

GENERATED_IMAGE_COUNT = 0
IMAGE_FOLDER = os.path.join("docs", "images")
TMP_FILE_FOLDER = os.path.join("docs", "tmp")
README_FILE_PATH = os.path.join("docs", "readme.typ")

def file_name():
    return os.path.join(TMP_FILE_FOLDER, "file_" + str(GENERATED_IMAGE_COUNT) + ".typ")

def image_name():
    return os.path.join(IMAGE_FOLDER, "image_" + str(GENERATED_IMAGE_COUNT) + ".png")

def create_file_folder():
    if not os.path.exists(TMP_FILE_FOLDER):
        os.makedirs(TMP_FILE_FOLDER)

def delete_file_folder():
    for file in os.listdir(TMP_FILE_FOLDER):
        os.remove(os.path.join(TMP_FILE_FOLDER, file))
    os.rmdir(TMP_FILE_FOLDER)

def compile_code(code):
    global GENERATED_IMAGE_COUNT

    current_filename = file_name()
    current_imagename = image_name()
    GENERATED_IMAGE_COUNT += 1

    with open(current_filename, mode="w") as file:
        file.write(code)

    print("Compiling " + current_filename, end="", flush=True)
    completed_process = subprocess.run(["typst", "compile", current_filename, "--root", ".", current_imagename], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if completed_process.returncode != 0:
        print(" ✗")
        print(completed_process.stderr)
        print(completed_process.stdout)
        exit(1)
    else:
        print(" ✓")

    return current_imagename

def query_exports():
    print("Querying " + README_FILE_PATH, end="", flush=True)
    completed_process = subprocess.run(["typst", "query", README_FILE_PATH, "--root", ".", "<export>"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if completed_process.returncode != 0:
        print(" ✗")
        print(completed_process.stderr)
        print(completed_process.stdout)
        exit(1)
    print(" ✓")
    return completed_process.stdout

def exported_markdown():
    exports = json.loads(query_exports())
    return "\n".join([e["value"] for e in exports]).lstrip()

def generate_images(markdown):
    open_tag_index = markdown.find("<GENERATE-IMAGE>")
    if open_tag_index >= 0:
        close_tag_index = markdown.find("</GENERATE-IMAGE>")
        assert close_tag_index >= 0

        before = markdown[:open_tag_index].rstrip() + "\n\n"
        image_code = markdown[open_tag_index:close_tag_index].removeprefix("<GENERATE-IMAGE>")
        after = markdown[close_tag_index:].removeprefix("</GENERATE-IMAGE>")

        image_path = compile_code(image_code)
        return before + f"![image]({image_path})" + generate_images(after)
    else:
        return markdown

def main():
    markdown = exported_markdown()
    create_file_folder()
    markdown = generate_images(markdown)
    delete_file_folder()
    with open("README.md", mode="w") as file:
        file.write(markdown)

if __name__ == "__main__":
    main()
