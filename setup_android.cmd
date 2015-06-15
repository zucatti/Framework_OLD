@ECHO OFF

rem -- Uncomment the line below if you use a standard proxy
rem SET PROXY_HOST=my.proxy
rem SET PROXY_PORT=proxy.port


rem --
rem --   OMNEEDIA Setup
rem --   v1.00
rem --

@SETLOCAL
@SET CURRENT_DIR=%~dp0
@SET CURRENT_BIN=%CURRENT_DIR%bin\
@SET ANDROID_HOME=%CURRENT_BIN%android-sdk\
@SET ANDROID_SDK_HOME=%CURRENT_BIN%android-sdk\
@SET ANDROID_STUDIO_JDK=%CURRENT_BIN%jdk
@SET JAVA_HOME=%CURRENT_BIN%jdk
@SET PATH=%PATH%;%JAVA_HOME%\bin;%ANDROID_HOME%platform-tools;%ANDROID_HOME%build-tools\%ANDROID_BUILD_VERSION%;%ANDROID_HOME%tools;%CURRENT_BIN%;%CURRENT_BIN%git;%CURRENT_BIN%git\bin;%CURRENT_BIN%git\libexec\git-core;%CURRENT_BIN%npm;%CURRENT_BIN%ant\bin;%CURRENT_BIN%node_modules\.bin;%CURRENT_BIN%git\bin;%CURRENT_BIN%git\cmd;%CURRENT_BIN%editor;%CURRENT_BIN%chrome;
@ECHO.
@ECHO   --------------
@ECHO   Omneedia SETUP
@ECHO   --------------
@ECHO.
@ECHO   Please wait while we initialize the magic!
@ECHO.
if not exist .tmp mkdir .tmp.
if not exist bin mkdir bin

@ECHO var WinHttpReq = new ActiveXObject("WinHttp.WinHttpRequest.5.1"); > .tmp\download.js
if "%PROXY_HOST%"=="" (
	@ECHO.
) ELSE (
	@ECHO WinHttpReq.SetProxy(2,"http://%PROXY_HOST%:%PROXY_PORT%"^); >> .tmp\download.js
)
@ECHO WinHttpReq.Open("GET", WScript.Arguments(0), false); >> .tmp\download.js
@ECHO WinHttpReq.Send(); >> .tmp\download.js
@ECHO BinStream = new ActiveXObject("ADODB.Stream"); >> .tmp\download.js
@ECHO BinStream.Type = 1; >> .tmp\download.js
@ECHO BinStream.Open(); >> .tmp\download.js
@ECHO BinStream.Write(WinHttpReq.ResponseBody); >> .tmp\download.js
@ECHO BinStream.SaveToFile(WScript.Arguments(1)); >> .tmp\download.js

@ECHO.
@ECHO   * Downloading files
@ECHO   -------------------

if defined ProgramFiles(x86) (
    @SET ARCHITECTURE=64	
	if not exist .tmp\jdk.exe (
		@ECHO   - Downloading OpenJDK - 64 bits 
		@CSCRIPT /nologo //E:jscript .tmp\download.js https://bitbucket.org/alexkasko/openjdk-unofficial-builds/downloads/openjdk-1.7.0-u60-unofficial-windows-amd64-image.zip .tmp\jdk.exe
	) else (
		@ECHO   - JDK: downloaded
	)
) else (
    @SET ARCHITECTURE=32
	if not exist .tmp\jdk.exe (
		@ECHO   - Downloading OpenJDK - 32 bits 
		@CSCRIPT /nologo //E:jscript .tmp\download.js https://bitbucket.org/alexkasko/openjdk-unofficial-builds/downloads/openjdk-1.7.0-u60-unofficial-windows-i586-image.zip .tmp\jdk.exe
	) else (
		@ECHO   - OpenJDK: downloaded
	)
)

if not exist .tmp\ant.zip (
	@ECHO   - Downloading ANT
	@CSCRIPT /nologo //E:jscript .tmp\download.js http://apache.arvixe.com//ant/binaries/apache-ant-1.9.5-bin.zip .tmp\ant.zip
) else (
	@ECHO   - ant: downloaded
)
if not exist .tmp\android.zip (
	@ECHO   - Downloading android sdk
	@CSCRIPT /nologo //E:jscript .tmp\download.js http://dl.google.com/android/android-sdk_r24.0.2-windows.zip .tmp\android.zip
) else (
	@ECHO   - android sdk: downloaded
)

if not exist .tmp\unzip.exe (
	@ECHO   - Downloading unzip utility
	@CSCRIPT /nologo //E:jscript .tmp\download.js http://www2.cs.uidaho.edu/~jeffery/win32/unzip.exe .tmp\unzip.exe
) else (
	@ECHO   - unzip: downloaded
)

@ECHO.
@ECHO   * Installing files
@ECHO   ------------------
if not exist %CURRENT_BIN% mkdir %CURRENT_BIN%
if not exist %CURRENT_BIN%\.appdata mkdir %CURRENT_BIN%\.appdata.
if not exist %CURRENT_BIN%\.appdata\npm mkdir %CURRENT_BIN%\.appdata\npm
if not exist %APPDATA%\npm mkdir %APPDATA%\npm

if not exist bin\ant (
	@ECHO   - Installing ant
	@.tmp\unzip.exe .tmp\ant.zip -d .tmp\ant >nul 2>&1
	@move .tmp\ant\apache-ant-1.9.4 bin\ant >nul 2>&1
) else (
	@ECHO   - ant: installed
)

if not exist bin\jdk (
	@ECHO   - Installing jdk
	@.tmp\unzip.exe .tmp\jdk.exe -d bin\ >nul 2>&1
	@move bin\openjdk-1.7.0-u60-unofficial-windows-amd64-image bin\jdk >nul 2>&1
	@move bin\openjdk-1.7.0-u60-unofficial-windows-i586-image bin\jdk >nul 2>&1
) else (
	@ECHO   - jdk: installed
)

if not exist bin\android-sdk (
	@ECHO   - Installing android sdk
	@.tmp\unzip.exe .tmp\android.zip -d bin\ >nul 2>&1
	@move bin\android-sdk-windows bin\android-sdk >nul 2>&1
	if "%PROXY_HOST%"=="" (
		@bin\android-sdk\tools\android.bat update sdk --no-ui
	) ELSE (
		@bin\android-sdk\tools\android.bat update sdk --no-ui --proxy-host %PROXY_HOST% --proxy-port %PROXY_PORT% --filter tool,platform-tool,doc
	)
) else (
	@ECHO   - android sdk: installed
)