from common import TypstRunner, ToolStatus
import os

README_PATH = "README.md"
README_TEMPLATE_PATH = os.path.join("docs", "readme.typ")
README_PDF_PATH = os.path.join("docs", "readme.pdf")
IMAGE_FOLDER = os.path.join("docs", "images")

def query_to_markdown(query_result):
    return "\n".join([e["value"] for e in query_result]).lstrip()

def split_open_tag(markdown):
    open_tag_start_index = markdown.find("<GENERATE-IMAGE:")
    open_tag_end_index = markdown[open_tag_start_index:].find(">") + open_tag_start_index

    before = markdown[:open_tag_start_index]
    name = markdown[open_tag_start_index:open_tag_end_index].removeprefix("<GENERATE-IMAGE:")
    after = markdown[open_tag_end_index:].removeprefix(">")

    return before, after, name

def split_close_tag(markdown):
    close_tag_start_index = markdown.find("</GENERATE-IMAGE>")
    
    before = markdown[:close_tag_start_index]
    after = markdown[close_tag_start_index:].removeprefix("</GENERATE-IMAGE>")

    return before, after

def split_images(markdown):
    if "<GENERATE-IMAGE:" in markdown:
        before, after, name = split_open_tag(markdown)
        code, after = split_close_tag(after)

        before = before.rstrip() + "\n\n"
        return {"before": before, "code": code, "name": name, "after": split_images(after)}
    else:
        return markdown

def generate_images(split_markdown, runner, status):
    if type(split_markdown) == dict:
        name, code, after = split_markdown["name"], split_markdown["code"], split_markdown["after"]
        image_path = os.path.join(IMAGE_FOLDER, name + ".png")

        status.start_action("Compiling " + image_path)
        status.end_action(runner.compile_code(code, name + ".typ", image_path))

        generate_images(after, runner, status)

def combine_markdown(split_markdown):
    if type(split_markdown) == dict:
        before, after, name = split_markdown["before"], split_markdown["after"], split_markdown["name"]
        image_path = os.path.join(IMAGE_FOLDER, name + ".png")
        return before + f"![image]({image_path})" + combine_markdown(after)
    else:
        return split_markdown

def main():
    with TypstRunner() as runner, ToolStatus("Generated readme", "Failed to generate readme") as status:
        status.start_action("Compiling " + README_TEMPLATE_PATH)
        runner.compile_file(README_TEMPLATE_PATH, README_PDF_PATH)
        status.end_action_assert(status.check_runner(runner))

        status.start_action("Querying " + README_TEMPLATE_PATH)
        query_result, query_success = runner.query_file(README_TEMPLATE_PATH, "<export>")
        status.end_action_assert(query_success)

        markdown_with_tags = query_to_markdown(query_result)
        split_markdown = split_images(markdown_with_tags)
        generate_images(split_markdown, runner, status)
        if not status.only_success():
            return

        markdown = combine_markdown(split_markdown)
        with open(README_PATH, mode="w") as file:
            file.write(markdown)

if __name__ == "__main__":
    main()
