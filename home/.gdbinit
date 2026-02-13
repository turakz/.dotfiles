# GDB Configuration for Pretty Printing

# Enable pretty printing for STL containers
set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style gnu-v3
set print sevenbit-strings off

# Load GCC libstdc++ pretty printers (python-based) — active when debugging libstdc++ binaries
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

# Load LLVM libc++ pretty printers — active when debugging libc++ binaries.
# printers.py is fetched from LLVM's release/18.x tree into ~/.gdb/libcxx/;
# Ubuntu's libc++-dev packages don't ship it. See install one-liner in dotfiles README.
python
import os
import sys
libcxx_root = os.path.expanduser('~/.gdb')
if os.path.isfile(os.path.join(libcxx_root, 'libcxx', 'printers.py')):
    sys.path.insert(0, libcxx_root)
    try:
        from libcxx.printers import register_libcxx_printer_loader
        register_libcxx_printer_loader()
    except ImportError as e:
        print('libc++ printers found but failed to load:', e)
end

# Disable pagination (useful for DAP)
set pagination off

# Show source context when stopping
set listsize 10

# History settings
set history save on
set history size 10000
set history filename ~/.gdb_history
add-auto-load-safe-path /home/fractals/dev/sandbox/cpp/learning
