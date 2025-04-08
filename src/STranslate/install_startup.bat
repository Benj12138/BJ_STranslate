@echo off
setlocal enabledelayedexpansion

:: ���ñ������ɫ
title STranslate �Զ���������
color 0A

:: ��ȡ��ǰĿ¼��Ӧ����Ϣ
set "CURRENT_DIR=%~dp0"
set "EXE_NAME=STranslate.exe"
set "TASK_NAME=STranslate(Auto Run)"
set "CURRENT_USER=%USERNAME%"

echo =========================================
echo    STranslate �Զ��������ù���
echo    ��ǰ�û�: %CURRENT_USER%
echo    ��ǰĿ¼: %CURRENT_DIR%
echo =========================================
echo.

:: ����Ƿ��Թ���ԱȨ������
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0C
    echo [����] ���Թ���ԱȨ�����д˽ű���
    echo.
    echo ���Ҽ�����˽ű���ѡ��"�Թ���Ա�������"
    echo.
    pause
    exit /b 1
)

:: ���Ŀ������Ƿ����
if not exist "%CURRENT_DIR%%EXE_NAME%" (
    color 0C
    echo [����] δ�ҵ� %EXE_NAME%��
    echo ��ȷ���˽ű��� %EXE_NAME% λ��ͬһĿ¼��
    echo.
    pause
    exit /b 1
)

:: ѯ���û��Ƿ���Ҫ����ԱȨ�����г���
choice /C YN /M "�Ƿ���Ҫ�Թ���ԱȨ�����г���(Y=��, N=��)"
set ADMIN_RUN=%ERRORLEVEL%

echo.
echo ���ڴ����ƻ�����...

:: ɾ���ɵ�����ƻ���������ڣ�
schtasks /Query /TN "%TASK_NAME%" >nul 2>&1
if !errorLevel! equ 0 (
    echo ������������ƻ��������Ƴ�...
    schtasks /Delete /TN "%TASK_NAME%" /F >nul 2>&1
)

:: ��������ƻ� XML �ļ��Ա��������Ŀ¼
echo ^<?xml version="1.0" encoding="UTF-16"?^> > "%TEMP%\stask.xml"
echo ^<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^> >> "%TEMP%\stask.xml"
echo   ^<RegistrationInfo^> >> "%TEMP%\stask.xml"
echo     ^<Description^>STranslate �Զ���������^</Description^> >> "%TEMP%\stask.xml"
echo     ^<Author^>%CURRENT_USER%^</Author^> >> "%TEMP%\stask.xml"
echo   ^</RegistrationInfo^> >> "%TEMP%\stask.xml"
echo   ^<Triggers^> >> "%TEMP%\stask.xml"
echo     ^<LogonTrigger^> >> "%TEMP%\stask.xml"
echo       ^<Enabled^>true^</Enabled^> >> "%TEMP%\stask.xml"
echo     ^</LogonTrigger^> >> "%TEMP%\stask.xml"
echo   ^</Triggers^> >> "%TEMP%\stask.xml"
echo   ^<Principals^> >> "%TEMP%\stask.xml"
echo     ^<Principal id="Author"^> >> "%TEMP%\stask.xml"

:: �����û�ѡ������Ȩ�޼���
if %ADMIN_RUN% equ 1 (
    echo       ^<RunLevel^>HighestAvailable^</RunLevel^> >> "%TEMP%\stask.xml"
) else (
    echo       ^<RunLevel^>LeastPrivilege^</RunLevel^> >> "%TEMP%\stask.xml"
)

echo       ^<UserId^>%USERDOMAIN%\%USERNAME%^</UserId^> >> "%TEMP%\stask.xml"
echo       ^<LogonType^>InteractiveToken^</LogonType^> >> "%TEMP%\stask.xml"
echo     ^</Principal^> >> "%TEMP%\stask.xml"
echo   ^</Principals^> >> "%TEMP%\stask.xml"
echo   ^<Settings^> >> "%TEMP%\stask.xml"
echo     ^<MultipleInstancesPolicy^>IgnoreNew^</MultipleInstancesPolicy^> >> "%TEMP%\stask.xml"
echo     ^<DisallowStartIfOnBatteries^>false^</DisallowStartIfOnBatteries^> >> "%TEMP%\stask.xml"
echo     ^<StopIfGoingOnBatteries^>false^</StopIfGoingOnBatteries^> >> "%TEMP%\stask.xml"
echo     ^<AllowHardTerminate^>true^</AllowHardTerminate^> >> "%TEMP%\stask.xml"
echo     ^<StartWhenAvailable^>false^</StartWhenAvailable^> >> "%TEMP%\stask.xml"
echo     ^<RunOnlyIfNetworkAvailable^>false^</RunOnlyIfNetworkAvailable^> >> "%TEMP%\stask.xml"
echo     ^<IdleSettings^> >> "%TEMP%\stask.xml"
echo       ^<StopOnIdleEnd^>false^</StopOnIdleEnd^> >> "%TEMP%\stask.xml"
echo       ^<RestartOnIdle^>false^</RestartOnIdle^> >> "%TEMP%\stask.xml"
echo     ^</IdleSettings^> >> "%TEMP%\stask.xml"
echo     ^<AllowStartOnDemand^>true^</AllowStartOnDemand^> >> "%TEMP%\stask.xml"
echo     ^<Enabled^>true^</Enabled^> >> "%TEMP%\stask.xml"
echo     ^<Hidden^>false^</Hidden^> >> "%TEMP%\stask.xml"
echo     ^<RunOnlyIfIdle^>false^</RunOnlyIfIdle^> >> "%TEMP%\stask.xml"
echo     ^<WakeToRun^>false^</WakeToRun^> >> "%TEMP%\stask.xml"
echo     ^<ExecutionTimeLimit^>PT0S^</ExecutionTimeLimit^> >> "%TEMP%\stask.xml"
echo     ^<Priority^>7^</Priority^> >> "%TEMP%\stask.xml"
echo   ^</Settings^> >> "%TEMP%\stask.xml"
echo   ^<Actions Context="Author"^> >> "%TEMP%\stask.xml"
echo     ^<Exec^> >> "%TEMP%\stask.xml"
echo       ^<Command^>%CURRENT_DIR%%EXE_NAME%^</Command^> >> "%TEMP%\stask.xml"
echo       ^<WorkingDirectory^>%CURRENT_DIR%^</WorkingDirectory^> >> "%TEMP%\stask.xml"
echo     ^</Exec^> >> "%TEMP%\stask.xml"
echo   ^</Actions^> >> "%TEMP%\stask.xml"
echo ^</Task^> >> "%TEMP%\stask.xml"

:: ��������ƻ�
schtasks /Create /TN "%TASK_NAME%" /XML "%TEMP%\stask.xml" /F
set TASK_RESULT=%ERRORLEVEL%

:: ������ʱ�ļ�
del "%TEMP%\stask.xml" >nul 2>&1

:: �������ƻ��Ƿ񴴽��ɹ�
if %TASK_RESULT% equ 0 (
    color 0A
    echo.
    echo [�ɹ�] ����ƻ������ɹ���
    echo.
    echo ��������:
    echo   - ����·��: %CURRENT_DIR%%EXE_NAME%
    echo   - ����Ŀ¼: %CURRENT_DIR%
    if %ADMIN_RUN% equ 1 (
        echo   - Ȩ�޼���: ����ԱȨ��
    ) else (
        echo   - Ȩ�޼���: ��ͨ�û�Ȩ��
    )
    echo   - ��������: �û���¼ʱ
    echo.
    echo ������ͨ��"����ƻ�����"�鿴���޸Ĵ�����
) else (
    color 0C
    echo.
    echo [����] ����ƻ�����ʧ�ܣ��������: %TASK_RESULT%
    echo.
    echo ���ܵ�ԭ��:
    echo   - Ȩ�޲���
    echo   - ����ƻ�����δ����
    echo   - XML�ļ���ʽ����
    echo.
    echo �볢���������д˽ű����ֶ���������ƻ���
)

echo.
echo =========================================
echo.
pause
exit /b 0