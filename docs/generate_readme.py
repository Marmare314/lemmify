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

def get_content():
    print("Querying " + README_FILE_PATH, end="", flush=True)
    completed_process = subprocess.run(["typst", "query", README_FILE_PATH, "--root", ".", "<export>"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if completed_process.returncode != 0:
        print(" ✗")
        print(completed_process.stderr)
        print(completed_process.stdout)
        exit(1)
    print(" ✓")
    return completed_process.stdout

def compile_file():
    print("Compiling " + file_name(), end="", flush=True)
    completed_process = subprocess.run(["typst", "compile", file_name(), "--root", ".", image_name()], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if completed_process.returncode != 0:
        print(" ✗")
        print(completed_process.stderr)
        print(completed_process.stdout)
        exit(1)
    else:
        print(" ✓")

def create_file_folder():
    if not os.path.exists(TMP_FILE_FOLDER):
        os.makedirs(TMP_FILE_FOLDER)

def delete_file_folder():
    for file in os.listdir(TMP_FILE_FOLDER):
        os.remove(os.path.join(TMP_FILE_FOLDER, file))
    os.rmdir(TMP_FILE_FOLDER)

def convert_to_markdown(content):
    global GENERATED_IMAGE_COUNT

    result = ""
    for element in content:
        if element["func"] == "heading":
            if result != "":
                result += "\n"
            # assume unnumbered and text-only headings
            result += "#" * element["level"] + " " + element["body"]["text"] + "\n\n"
        elif element["func"] == "text":
            result += element["text"] + "\n"
        elif element["func"] == "raw":
            result += "```" + element["lang"] + "\n" + element["text"] + "\n" + "```\n\n"
        elif element["func"] == "metadata":
            with open(file_name(), mode="w") as file:
                file.write(element["value"]["code"])
            compile_file()
            result += f"\n![image]({image_name()})\n"
            GENERATED_IMAGE_COUNT += 1
        elif element["func"] == "enum":
            element = element["children"][0]
            result += str(element["number"]) + ". " + element["body"]["text"] + "\n"

    return result

def main():
    content = json.loads(get_content())
    create_file_folder()
    markdown = convert_to_markdown(content)
    delete_file_folder()
    with open("README.md", mode="w") as file:
        file.write(markdown)

if __name__ == "__main__":
    main()
