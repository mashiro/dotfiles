if exists("current_compiler")
    finish
endif
let current_compiler = "msbuild"

if exists(":CompilerSet") != 2
    command -nargs=* COmpilerSet setlocal <args>
endif

CompilerSet errorformat=
    \%E%f(%l):\ error\ %m,
    \%E%f(%l):\ warning\ %m,
    \%E%f(%l\\,%c):\ error\ %m,
    \%E%f(%l\\,%c):\ warning\ %m,
    \%-G%.%#

CompilerSet makeprg=MSBuild
    \\ /nologo
    \\ /consoleloggerparameters:
      \NoItemAndPropertyList;
      \ForceNoAlign;

