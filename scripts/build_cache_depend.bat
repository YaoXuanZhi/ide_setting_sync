@echo off

::判断是否已经获取了管理员身份
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo 请使用右键管理员身份运行&&Pause >NUL&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
SetLocal EnableDelayedExpansion

set localDirName=UserData

::切换到该脚本的所在目录
cd /d %~dp0

::创建并切换到自定义的缓存目录
call :create_local_dir %localDirName%
cd /d %localDirName%

call :create_link .nuget %USERPROFILE%
call :create_link .vscode %USERPROFILE%
call :create_link .vscode-insiders %USERPROFILE%
call :create_link .conda %USERPROFILE%
call :create_link JetBrains %LOCALAPPDATA%
call :create_link Unity %LOCALAPPDATA%
call :create_link Unity3dRider %TEMP%
call :create_link uTools %APPDATA%
call :create_link .logseq %USERPROFILE%
call :create_link UnrealEngine %LOCALAPPDATA%
call :create_link .ollama %USERPROFILE%

pause

::--------------------------- 方法 ---------------------------

::desc 创建指定目录并生成对应的目录链接
::source_dir [in] 源文件夹名
::target_path [in] 链接到的目标路径
:create_link
call :create_local_dir %1
if exist %2 (call :bind_link %1 %2) else (不存在%2，请重新确认该路径)
GOTO :eof

::desc 生成目录链接
::source_dir [in] 源文件夹名
::target_path [in] 链接到的目标路径
:bind_link
set tempDir=%2/%1
::去掉路径上的双引号
set "tempDir=%tempDir:"=%"

if not exist "%tempDir%" (
    mklink /d "%tempDir%" "%cd%/%1"
) else (
    echo "%tempDir%"已经存在，跳过
)
GOTO :eof

::desc 在当前目录下创建目录
::path [in] 待创建的目录路径
:create_local_dir
if not exist "%cd%/%1" (
    mkdir "%cd%/%1"
    echo 成功创建了"%cd%/%1"
)
GOTO :eof

::desc 去掉变量两侧的双引号
::var [in] 待替换双引号的变量
:removequotes
FOR /F "delims=" %%A IN ('echo %%%1%%') DO set %1=%%~A
GOTO :eof
