from common import test_names, compile_file, has_reference_check, reference_file
import os
import filecmp

def output_directory():
    return os.path.join("tests", "output")

def output_file(name):
    return os.path.join("tests", "output", name + ".png")

def run_test(name):
    success = compile_file(name, output_file(name), True, "Running")
    if success:
        if has_reference_check(name):
            success &= filecmp.cmp(output_file(name), reference_file(name))

        if success:
            print(" ✓")
        else:
            print(" ✗")
    
    return success

def main():
    if not os.path.exists(output_directory()):
        os.makedirs(output_directory())

    success = True
    for testname in test_names():
        success &= run_test(testname)

    if success:
        print("All tests ran successfully ✓")
    else:
        print("Some tests failed ✗")

    for file in os.listdir(output_directory()):
        name = file.removesuffix(".png")
        os.remove(output_file(name))
    os.rmdir(output_directory())

if __name__ == "__main__":
    main()
