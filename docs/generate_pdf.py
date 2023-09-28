import os
import subprocess

README_FILE_PATH = os.path.join("docs", "readme.typ")

def main():
    print("Compiling " + README_FILE_PATH, end="", flush=True)
    completed_process = subprocess.run(["typst", "compile", README_FILE_PATH, "--root", "."], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if completed_process.returncode != 0:
        print(" ✗")
        print(completed_process.stderr)
        print(completed_process.stdout)
        exit(1)
    else:
        print(" ✓")

if __name__ == "__main__":
    main()
