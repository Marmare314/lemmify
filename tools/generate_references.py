from common import ToolStatus, TypstRunner
import argparse
import sys
import os

def list_tests():
    tests = []
    for file in os.listdir("tests"):
        if file.endswith(".typ"):
            testname = file.removesuffix(".typ")
            tests.append(testname)
    return tests

def input_file_path(test_name):
    return os.path.join("tests", test_name + ".typ")

def reference_file_path(test_name):
    return os.path.join("tests", "references", test_name + ".png")

def has_reference_check(test_name):
    with open(input_file_path(test_name)) as file:
        test_input = file.read()
        return not test_input.startswith("// Ref: false")

def main():
    parser = argparse.ArgumentParser(description="Update the reference images of tests.")
    parser.add_argument("--all", "-a", action="store_true", help="Update all reference images")
    parser.add_argument("tests", nargs="*", help="List of tests to update")
    
    args = parser.parse_args()

    if args.all or args.tests:
        tests = list_tests() if args.all else args.tests

        with TypstRunner() as runner, ToolStatus("Updated references", "Failed to update references") as status:
            for test in tests:
                if has_reference_check(test):
                    status.start_action("Compiling " + input_file_path(test))
                    runner.compile_file(input_file_path(test), reference_file_path(test))
                    status.end_action(status.check_runner(runner))
    else:
        print("No tests provided. Use either '--all' or provide a list of test names.")
        sys.exit(1)
    

if __name__ == "__main__":
    main()
