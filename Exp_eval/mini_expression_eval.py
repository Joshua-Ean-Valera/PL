import subprocess
import tempfile
import os
import sys

def lexer_and_semantic_analyzer(input_file=None, output_filename="output.txt"):
    if input_file and os.path.isfile(input_file):
        with open(input_file, "r") as f:
            c_source = f.read()
    else:
        print("Enter your C code (end with Ctrl+Z ---> Enter):")
        c_source_lines = []
        try:
            while True:
                line = input()
                c_source_lines.append(line)
        except EOFError:
            pass
        c_source = "\n".join(c_source_lines)

    with tempfile.TemporaryDirectory() as tmpdir:
        c_file = os.path.join(tmpdir, "prog.c")
        exe_file = os.path.join(tmpdir, "prog.exe" if os.name == 'nt' else "prog.out")

        with open(c_file, "w") as f:
            f.write(c_source)

    with tempfile.TemporaryDirectory() as tmpdir:
        c_file = os.path.join(tmpdir, "prog.c")
        exe_file = os.path.join(tmpdir, "eval.exe" if os.name == 'nt' else "prog.out")

        with open(c_file, "w") as f:
            f.write(c_source)

        # === Run Lexer ===
        lexer_exe = "lexer.out"
        try:
            with open(c_file, "r") as source_file:
                lexer_proc = subprocess.run(
                    [lexer_exe],
                    stdin=source_file,
                    capture_output=True,
                    text=True,
                    timeout=5
                )
            lexer_output = "\n".join(line for line in lexer_proc.stdout.splitlines() if line.strip())

        except FileNotFoundError:
            lexer_output = "Lexer executable not found. Please build your lexer."
        except subprocess.TimeoutExpired:
            lexer_output = "Lexer timed out."

        # === Compile and Run C Program ===
        compile_proc = subprocess.run(
            ["gcc", c_file, "-o", exe_file],
            capture_output=True,
            text=True
        )
        if compile_proc.returncode != 0:
            semantic_output = "Compilation failed:\n" + compile_proc.stderr
        else:
            run_proc = subprocess.run(
                [exe_file],
                capture_output=True,
                text=True
            )
            semantic_output = run_proc.stdout.strip()
            if run_proc.stderr:
                semantic_output += "\nErrors:\n" + run_proc.stderr.strip()

        # === Write all output to a file ===
        with open(output_filename, "w") as out_file:
            out_file.write("=== Input Source Code ===\n")
            out_file.write(c_source + "\n\n")
            out_file.write("=== Lexical Tokenization Output ===\n")
            out_file.write(lexer_output + "\n\n")
            out_file.write("=== Semantic Execution Output ===\n")
            out_file.write(semantic_output + "\n")

    print(f"Output saved to {output_filename}")

# === Entry point from terminal ===
if __name__ == "__main__":
    input_file = sys.argv[1] if len(sys.argv) > 1 else None
    lexer_and_semantic_analyzer(input_file)
