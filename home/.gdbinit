# GDB Configuration for Pretty Printing

# Enable pretty printing for STL containers
set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style gnu-v3
set print sevenbit-strings off

# Load GCC STL pretty printers (python-based)
python
import sys
import glob

# Find the latest gcc python printers directory
gcc_paths = glob.glob('/usr/share/gcc-*/python')
if gcc_paths:
    gcc_paths.sort(reverse=True)  # Latest version first
    sys.path.insert(0, gcc_paths[0])
    from libstdcxx.v6.printers import register_libstdcxx_printers
    register_libstdcxx_printers(None)
end

# Note: String/path printers may show errors with clang++-compiled binaries
# Workaround: Use .c_str() to inspect strings manually (e.g., p myString.c_str())

# Disable pagination (useful for DAP)
set pagination off

# Show source context when stopping
set listsize 10

# History settings
set history save on
set history size 10000
set history filename ~/.gdb_history
