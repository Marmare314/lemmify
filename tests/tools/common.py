import os
import subprocess

def input_file(name):
    return os.path.join("tests", name + ".typ")

def reference_file(name):
    return os.path.join("tests", "references", name + ".png")

def has_reference_check(name):
    with open(input_file(name)) as file:
        test_input = file.read()
        return not test_input.startswith("// Ref: false")

def compile_file(name, output_file, check_compilation, action):
    if not has_reference_check(name) and not check_compilation:
        return None

    print(action + " " + name + ".typ", end="", flush=True)
    completed_process = subprocess.run(["typst", "compile", input_file(name), "--root", ".", output_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if completed_process.returncode != 0:
        print(" ✗")
        print(completed_process.stderr)
        print(completed_process.stdout)
        return False
    return True

def test_names():
    tests = []
    for file in os.listdir("tests"):
        if file.endswith(".typ"):
            testname = file.removesuffix(".typ")
            tests.append(testname)
    return tests
