from generate_readme import split_images, combine_markdown, IMAGE_FOLDER, query_to_markdown, README_TEMPLATE_PATH, README_PATH
from common import TypstRunner, ToolStatus, compare_files
import os

def check_images(split_markdown, runner, status):
    if type(split_markdown) == dict:
        name, code, after = split_markdown["name"], split_markdown["code"], split_markdown["after"]
        image_path = os.path.join(IMAGE_FOLDER, name + ".png")

        status.start_action("Checking " + image_path)
        output_path = runner.tmp_file_path(name + ".png")
        runner.compile_code(code, name + ".typ", output_path)
        if status.check_runner(runner):
            status.end_action(compare_files(image_path, output_path))
        else:
            status.end_action(False)

        check_images(split_markdown["after"], runner, status)

def main():
    with TypstRunner() as runner, ToolStatus("Readme is up to date", "Readme is not up to date") as status:
        status.start_action("Compiling " + README_TEMPLATE_PATH)
        output_path = runner.tmp_file_path("readme.pdf")
        runner.compile_file(README_TEMPLATE_PATH, output_path)
        status.end_action_assert(status.check_runner(runner))

        status.start_action("Querying " + README_TEMPLATE_PATH)
        query_result, query_success = runner.query_file(README_TEMPLATE_PATH, "<export>")
        status.end_action_assert(query_success)

        markdown_with_tags = query_to_markdown(query_result)
        split_markdown = split_images(markdown_with_tags)

        check_images(split_markdown, runner, status)

        status.start_action("Checking " + README_PATH)
        markdown = combine_markdown(split_markdown)
        with open(README_PATH) as file:
            status.end_action(file.read() == markdown)

if __name__ == "__main__":
    main()
