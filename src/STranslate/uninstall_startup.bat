@echo off
setlocal enabledelayedexpansion

set "TASK_NAME=STranslate(Auto Run)"

:: ����Ƿ��Թ���ԱȨ������
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ���Թ���ԱȨ�����д˽ű���
    pause
    exit /b 1
)

schtasks /Delete /TN "%TASK_NAME%" /F

if %errorLevel% equ 0 (
    echo ����ƻ�ɾ���ɹ���
) else (
    echo ����ƻ�ɾ��ʧ�ܣ�
)

pause