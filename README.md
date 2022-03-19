# `cc`

`cc` is a C++ library to create graphical user interfaces with GLFW, OpenGL and 
FreeType, tested with GoogleTest.

## Build & Run

One may check the provided makefile to see how an application may be built in
details.
We enable warnings, warning errors and fatal errors; disabled language
extensions; and enforce language C ANSI and C++ 20 standards.

To build the application you may type `make` and press enter.

    # Aliases utilized in .bashrc file
    alias make='make -j$(nproc)'
    alias makeall='_makeall(){ make clean; make -j$(nproc); make run; }; _makeall'

Since we use an alias to invoke make with multiple job slots, we also use an
alias to clean, build and run the application.
You may add similar aliases to your system too, using slots reduce compilation
times and enables faster development cycles.
Alternatively, one can create an `all` target and manually invoke `make`,
without using job slots.

As you may have noted, `make clean` remove derived files and `make run` runs the
application.


## Tests




## Docs


