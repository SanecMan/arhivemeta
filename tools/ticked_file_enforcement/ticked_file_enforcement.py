import codecs
import fnmatch
import functools
import glob
import json
import os
import sys

# simple way to check if we're running on github actions, or on a local machine
on_github = os.getenv("GITHUB_ACTIONS") == "true"

def green(text):
    return "\033[32m" + str(text) + "\033[0m"

def red(text):
    return "\033[31m" + str(text) + "\033[0m"

def blue(text):
    return "\033[34m" + str(text) + "\033[0m"

schema = json.load(sys.stdin)
file_reference = schema["file"]
file_reference_basename = os.path.basename(file_reference)
scannable_directory = schema["scannable_directory"]
subdirectories = schema["subdirectories"]
FORBIDDEN_INCLUDES = schema["forbidden_includes"]
excluded_files = schema["excluded_files"]

def post_error(string):
    print(red(f"Ticked File Enforcement [{file_reference}]: " + string))
    if on_github:
        print(f"::error file={file_reference},line=1,title=Ticked File Enforcement::{string}")

for excluded_file in excluded_files:
    full_file_path = scannable_directory + excluded_file
    if not os.path.isfile(full_file_path):
        post_error(f"Excluded file {full_file_path} does not exist, please remove it!")
        sys.exit(1)

file_extensions = ("dm", "dmf")

reading = False
lines = []
total = 0

with open(file_reference, 'r') as file:
    for line in file:
        total += 1
        line = line.strip()

        if line == "// BEGIN_INCLUDE":
            reading = True
            continue
        elif line == "// END_INCLUDE":
            break
        elif not reading:
            continue

        # MASSMETA EDIT ADDITION START (check modular code folder)
        # need to make full path
        if scannable_directory == "massmeta/":
            line =  line[:10] + "massmeta\\" + line[10:]
        # MASSMETA EDIT ADDITION END
        lines.append(line)

# MASSMETA EDIT ADDITION START (check modular code folder)
if scannable_directory == "massmeta/":
    extra_lines = []
    fail_no_include_modular = False
    print(blue(f"Scanning Modular Code... Checking files in [{scannable_directory}]"))
    for module_file in lines:
        module_file_path = module_file.replace('\\', '/')
        module_file_path_clean = module_file_path[10:-1]
        print(f"    [{module_file_path_clean}] with in it:")
        if module_file_path_clean[-11:] != "includes.dm":
            red(f"      File [{module_file_path_clean}] must be named \"includes.dm\", skipping the file.")
            fail_no_include_modular = True
            continue

        with open(module_file_path_clean, 'r') as extra_file:
            for extra_line in extra_file:
                extra_line = extra_line.strip()
                if (extra_line[10:14] != "code"):
                    red(f"       File [{extra_line}] must be in \"code/\" folder")
                    fail_no_include_modular = True

                # make full path
                extra_line = module_file[:-12] + extra_line[10:]
                extra_lines.append(extra_line)
                extra_line.replace('\\', '/')
                print(f"        {extra_line[10:-1]}")

    if fail_no_include_modular:
        post_error(f"Modular Ticked File Enforcement has failed!")
        sys.exit(1)

    lines.extend(extra_lines)
# MASSMETA EDIT ADDITION END

offset = total - len(lines)
print(blue(f"Ticked File Enforcement: {offset} lines were ignored in output for [{file_reference}]."))
fail_no_include = False

scannable_files = []
for file_extension in file_extensions:
    compiled_directory = f"{scannable_directory}/**/*.{file_extension}"
    scannable_files += glob.glob(compiled_directory, recursive=True)

if len(scannable_files) == 0:
    post_error(f"No files were found in {scannable_directory}. Ticked File Enforcement has failed!")
    sys.exit(1)

for code_file in scannable_files:
    dm_path = ""

    if subdirectories is True:
        dm_path = code_file.replace('/', '\\')
    else:
        dm_path = os.path.basename(code_file)

    included = f"#include \"{dm_path}\"" in lines

    forbid_include = False
    for forbidable in FORBIDDEN_INCLUDES:
        if not fnmatch.fnmatch(code_file, forbidable):
            continue

        forbid_include = True

        if included:
            post_error(f"{dm_path} should NOT be included.")
            fail_no_include = True

    if forbid_include:
        continue

    if not included:
        if(dm_path == file_reference_basename):
            continue

        if(dm_path in excluded_files):
            continue

        post_error(f"Missing include for {dm_path}.")
        fail_no_include = True

if fail_no_include:
    sys.exit(1)

def compare_lines(a, b):
    # Remove initial include as well as the final quotation mark
    a = a[len("#include \""):-1].lower()
    b = b[len("#include \""):-1].lower()

    split_by_period = a.split('.')
    a_suffix = ""
    if len(split_by_period) >= 2:
        a_suffix = split_by_period[len(split_by_period) - 1]
    split_by_period = b.split('.')
    b_suffix = ""
    if len(split_by_period) >= 2:
        b_suffix = split_by_period[len(split_by_period) - 1]

    a_segments = a.split('\\')
    b_segments = b.split('\\')

    for (a_segment, b_segment) in zip(a_segments, b_segments):
        a_is_file = a_segment.endswith(file_extensions)
        b_is_file = b_segment.endswith(file_extensions)

        # code\something.dm will ALWAYS come before code\directory\something.dm
        if a_is_file and not b_is_file:
            return -1

        if b_is_file and not a_is_file:
            return 1

        # interface\something.dm will ALWAYS come after code\something.dm
        if a_segment != b_segment:
            # if we're at the end of a compare, then this is about the file name
            # files with longer suffixes come after ones with shorter ones
            if a_suffix != b_suffix:
                return (a_suffix > b_suffix) - (a_suffix < b_suffix)
            return (a_segment > b_segment) - (a_segment < b_segment)

    print(f"Two lines were exactly the same ({a} vs. {b})")
    sys.exit(1)

sorted_lines = sorted(lines, key = functools.cmp_to_key(compare_lines))
for (index, line) in enumerate(lines):
    if sorted_lines[index] != line:
        post_error(f"The include at line {index + offset} is out of order ({line}, expected {sorted_lines[index]})")
        sys.exit(1)

print(green(f"Ticked File Enforcement: [{file_reference}] All includes (for {len(scannable_files)} scanned files) are in order!"))
