import os
import sys
import json
import filecmp
import subprocess

class ToolStatus:
    def __init__(self, msg_success, msg_fail):
        self._msg_success = msg_success
        self._msg_fail = msg_fail

        self._tool_success = True
        self._action_success = True

    def _end_tool(self):
        if self._tool_success:
            print(self._msg_success + " ✓")
            sys.exit(0)
        else:
            print(self._msg_fail + " ✗")
            sys.exit(1)

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, exc_trace):
        if exc_type is not None:
            return False
        self._end_tool()

    def start_action(self, msg):
        self._action_success = True
        print(msg, end="", flush=True)

    def update_action(self, value):
        self._action_success &= value
        self._tool_success &= value
        if not value:
            print(" ✗")

    def check_runner(self, runner):
        runner_success = runner.last_returncode == 0
        self.update_action(runner_success)
        if not runner_success:
            print(runner.last_stdout)
            print(runner.last_stderr)
        return runner_success

    def end_action(self, value):
        self.update_action(value)
        if self._action_success:
            print(" ✓")
        return self._action_success

    def end_action_assert(self, value):
        if not self.end_action(value):
            self._end_tool()

    def only_success(self):
        return self._tool_success

class TypstRunner:
    def __init__(self):
        self._tmp_folder = os.path.join("tools", "tmp")
        self.last_stderr = None
        self.last_stdout = None
        self.last_returncode = None

    def _delete_tmp_folder(self):
        for file in os.listdir(self._tmp_folder):
            os.remove(os.path.join(self._tmp_folder, file))
        os.rmdir(self._tmp_folder)

    def __enter__(self):
        if not os.path.exists(self._tmp_folder):
            os.makedirs(self._tmp_folder)
        else:
            self._delete_tmp_folder()
            os.makedirs(self._tmp_folder)
        return self

    def __exit__(self, exc_type, exc_value, exc_trace):
        if exc_type is not None:
            return False

        self._delete_tmp_folder()

    def tmp_file_path(self, filename):
        return os.path.join(self._tmp_folder, filename)

    def compile_file(self, input_path, output_path):
        completed_process = subprocess.run(["typst", "compile", input_path, "--root", ".", output_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        self.last_returncode = completed_process.returncode
        self.last_stderr = completed_process.stderr
        self.last_stdout = completed_process.stdout
        return self.last_returncode == 0

    def compile_code(self, code, input_filename, output_path):
        input_path = self.tmp_file_path(input_filename)
        with open(input_path, mode="w") as file:
            file.write(code)
        return self.compile_file(input_path, output_path)

    def query_file(self, path, query):
        completed_process = subprocess.run(["typst", "query", path, "--root", ".", query], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        self.last_returncode = completed_process.returncode
        self.last_stderr = completed_process.stderr
        self.last_stdout = completed_process.stdout

        return json.loads(completed_process.stdout), self.last_returncode == 0

def compare_files(file_a, file_b):
    return os.path.exists(file_a) and os.path.exists(file_b) and filecmp.cmp(file_a, file_b)
