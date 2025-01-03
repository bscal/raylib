@echo off
setlocal

IF "%~2"=="" SET BuildName=Game
IF NOT "%~2"=="" SET BuildName=%~2

SET BuildName=/Fe".\Game.exe"
SET LinkDLL=-DLL

REM -FC &:: Produce the full path of the source code file , -Zi &:: Produce debug information --/fsanitize=address
SET CommonFlags=/I..\src /I..\src\external /I..\src\external\glfw\include /I..\src\external\glfw\src /nologo -Zi -FC /std:c++20
SET CommonDefines=-D_HAS_EXCEPTIONS=0 -DSCAL_WINDOWS=1 -DSCAL_CXX20=1 -D_CRT_SECURE_NO_WARNINGS -DGRAPHICS_API_OPENGL_43 -DPLATFORM_DESKTOP -D_WINSOCK_DEPRECATED_NO_WARNINGS -D_WIN32
SET WarnFlags=-MT -W4 -WX -wd4100 -wd4201 -wd4127 -wd4701 -wd4189 -wd4244 -wd4456 -wd4457 -wd4245 -wd4702 -wd4152 -wd4028
SET Libs=user32.lib gdi32.lib winmm.lib opengl32.lib Shell32.lib
SET LinkerFlags=-incremental:no -opt:ref
SET SrcDir=..\src\
SET SrcFiles=%SrcDir%Main.cpp %SrcDir%rcore.c %SrcDir%raudio.c %SrcDir%rmodels.c %SrcDir%rshapes.c %SrcDir%rtext.c %SrcDir%rtextures.c %SrcDir%rglfw.c %SrcDir%utils.c

IF "%~1"=="" SET BuildType=Release & GOTO :RELEASE
IF "%~1"=="D" SET BuildType=Debug & GOTO :DEBUG
IF "%~1"=="DEBUG" SET BuildType=Debug & GOTO :DEBUG

:RELEASE
SET CompilerFlags=%CommonFlags% /O2 %WarnFlags% -Oi -GR- -EHsc -arch:AVX2
SET Defines=-DSCAL_DEBUG=0 %CommonDefines%
GOTO :BUILD

:DEBUG
SET CompilerFlags=%CommonFlags% /Od /Ob1 %WarnFlags% -GR- -EHsc
SET Defines=-DSCAL_DEBUG=1 %CommonDefines%
GOTO :BUILD

:BUILD
IF NOT EXIST .\build_game mkdir .\build_game
pushd .\build_game

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

cl %BuildName% %CompilerFlags% %Defines% %SrcFiles% %Libs% /link %LinkerFlags%

popd

endlocal

REM -Wno-unused-value -Wno-unused-variable -Wno-missing-braces -Wno-missing-field-initializers