from common import ToolStatus, TypstRunner, compare_files
from generate_references import list_tests, input_file_path, reference_file_path, has_reference_check

def main():
    with TypstRunner() as runner, ToolStatus("All tests passed", "Some tests failed") as status:
        for test in list_tests():
            status.start_action("Checking " + input_file_path(test))
            output_path = runner.tmp_file_path(test + ".png")
            runner.compile_file(input_file_path(test), output_path)
            if status.check_runner(runner):
                if has_reference_check(test):
                    status.end_action(compare_files(output_path, reference_file_path(test)))
                else:
                    status.end_action(True)
            else:
                status.end_action(False)

if __name__ == "__main__":
    main()
