@echo off
setlocal enabledelayedexpansion

:: ���ñ������ɫ
title STranslate �Զ������Ƴ�����
color 0B

:: �����������ƺ��û���Ϣ
set "TASK_NAME=STranslate(Auto Run)"
set "CURRENT_USER=ZGGSONG"

echo =========================================
echo    STranslate �Զ������Ƴ�����
echo    ��ǰ�û�: %CURRENT_USER%
echo    ��ǰʱ��: %DATE% %TIME%
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

:: ��������Ƿ����
schtasks /Query /TN "%TASK_NAME%" >nul 2>&1
if %errorLevel% neq 0 (
    color 0E
    echo [����] δ�ҵ���Ϊ"%TASK_NAME%"�ļƻ�����
    echo.
    echo ���ܵ�ԭ��:
    echo   - ����ƻ���δ����
    echo   - ���������ѱ�����
    echo   - �����ѱ��ֶ�ɾ��
    echo.
    choice /C YN /M "�Ƿ���Ҫ����ɾ����(Y=��, N=��)"
    if !ERRORLEVEL! equ 2 (
        echo.
        echo ������ȡ����
        goto :end
    )
    echo.
)

echo �����Ƴ��Զ���������...
echo.

:: ɾ������ƻ�
schtasks /Delete /TN "%TASK_NAME%" /F
set TASK_RESULT=%ERRORLEVEL%

:: �������ɾ���Ƿ�ɹ�
if %TASK_RESULT% equ 0 (
    color 0A
    echo [�ɹ�] ����ƻ�"%TASK_NAME%"�ѳɹ��Ƴ���
    echo.
    echo STranslate �������ڵ�¼ʱ�Զ�������
) else (
    color 0C
    echo [����] ����ƻ�ɾ��ʧ�ܣ��������: %TASK_RESULT%
    echo.
    echo ���ܵ�ԭ��:
    echo   - Ȩ�޲���
    echo   - ����ƻ�����δ����
    echo   - ���������������޷�ֹͣ
    echo.
    echo �����Գ���:
    echo   1. ȷ���Թ���Ա������д˽ű�
    echo   2. ������ƻ��������ֶ�ɾ��������
    echo   3. ������������ٴγ���
)

:end
echo.
echo =========================================
echo.
pause
exit /b 0