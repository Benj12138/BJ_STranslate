@echo off
setlocal enabledelayedexpansion

:: ��ȡ��ǰĿ¼
set "CURRENT_DIR=%~dp0"
set "EXE_NAME=STranslate.exe"
set "TASK_NAME=STranslate(Auto Run)"

:: ����Ƿ��Թ���ԱȨ������
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ���Թ���ԱȨ�����д˽ű���
    pause
    exit /b 1
)

:: ѯ���û��Ƿ���Ҫ����ԱȨ�����г���
set /p ADMIN_RUN="�Ƿ���Ҫ�Թ���ԱȨ�����г���(Y/N): "

:: ת������Ϊ��д
call :ToUpper ADMIN_RUN

if "%ADMIN_RUN%"=="Y" (
    :: ������Ҫ����ԱȨ�޵�����ƻ�
    schtasks /Create /TN "%TASK_NAME%" /TR "\"%CURRENT_DIR%%EXE_NAME%\"" /SC ONLOGON /RL HIGHEST /F
    if !errorLevel! equ 0 (
        echo ����ƻ������ɹ���
        echo �������û���¼ʱ�Թ���ԱȨ������
    ) else (
        echo ����ƻ�����ʧ�ܣ�
    )
) else (
    :: ������ͨȨ�޵�����ƻ�
    schtasks /Create /TN "%TASK_NAME%" /TR "\"%CURRENT_DIR%%EXE_NAME%\"" /SC ONLOGON /F
    if !errorLevel! equ 0 (
        echo ����ƻ������ɹ���
        echo �������û���¼ʱ����ͨȨ������
    ) else (
        echo ����ƻ�����ʧ�ܣ�
    )
)

pause
exit /b 0

:ToUpper
:: ������ת��Ϊ��д
for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do set %1=!%1:%%L=%%L!
exit /b