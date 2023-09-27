import argparse
from common import compile_file, reference_file, test_names

def main():
    parser = argparse.ArgumentParser(description="Update the reference images of tests.")
    parser.add_argument("--all", "-a", action="store_true", help="Update all reference images")
    parser.add_argument("tests", nargs="*", help="List of tests to update")
    
    args = parser.parse_args()

    if args.all or args.tests:
        tests = test_names() if args.all else args.tests

        success = True
        for test in tests:
            if compile_file(test, reference_file(test), False, "Updating") == True:
                print(" ✓")
            else:
                success = False
    
        if success:
            print("All references updated successfully ✓")
        else:
            print("Some reference updates failed ✗")
    else:
        print("No tests provided. Use either '--all' or provide a list of test names.")
    

if __name__ == "__main__":
    main()
