﻿using System.Diagnostics;
using System.IO;
using System.Windows;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using STranslate.Helper;
using STranslate.Log;
using STranslate.Model;
using STranslate.Style.Controls;
using STranslate.Util;

namespace STranslate.ViewModels.Preference;

public partial class AboutViewModel : ObservableObject
{
    [ObservableProperty] private bool _isChecking;

    [ObservableProperty] private string _version = "";

    [ObservableProperty] private string _fileSize = "";

    private readonly DirectoryInfo _logInfo;

    public AboutViewModel()
    {
        Version = Constant.AppVersion;

        if (!Directory.Exists(Constant.LogPath))
        {
            Directory.CreateDirectory(Constant.LogPath);
        }

        _logInfo = new DirectoryInfo(Constant.LogPath);
    }

    [RelayCommand]
    private void CheckLog()
    {
        var length = _logInfo.GetFiles().Sum(f => f.Length);
        FileSize = CommonUtil.CountSize(length);
    }

    [RelayCommand]
    private void CleanLog()
    {
        if (MessageBox_S.Show(AppLanguageManager.GetString("About.ConfirmClearAllLog"), AppLanguageManager.GetString("About.Warning"), MessageBoxButton.YesNo) != MessageBoxResult.Yes)
            return;

        LogService.UnRegister();

        foreach (var file in _logInfo.GetFiles())
        {
            try
            {
                File.Delete(file.FullName);
            }
            catch (Exception e)
            {
                LogService.Logger.Error($"删除日志失败: {file.Name}", e);
            }
        }

        CheckLog();

        LogService.Register();

        ToastHelper.Show(AppLanguageManager.GetString("Toast.ClearSuccess"), WindowType.Preference);
    }

    [RelayCommand]
    private void OpenLog()
    {
        Process.Start("explorer.exe", Constant.LogPath);
    }

    [RelayCommand] private void OpenConfig()
    {
        Process.Start("explorer.exe", Constant.CnfPath);
    }

    [RelayCommand]
    private void OpenLink(string url)
    {
        Process.Start(new ProcessStartInfo { FileName = url, UseShellExecute = true });
    }

    [RelayCommand(IncludeCancelCommand = true)]
    private async Task CheckUpdateAsync(CancellationToken token)
    {
        try
        {
            const string updateFolder = "Update";

            string GetPath(string fileName)
            {
                return Path.Combine(AppDomain.CurrentDomain.BaseDirectory, fileName);
            }

            string GetCachePath(string fileName)
            {
                return Path.Combine(AppDomain.CurrentDomain.BaseDirectory, updateFolder, fileName);
            }

            string[] requiredFiles = ["Updater.exe"];

            if (requiredFiles.All(file => File.Exists(GetPath(file))))
            {
                Directory.CreateDirectory(GetPath(updateFolder));

                foreach (var file in requiredFiles) File.Copy(GetPath(file), GetCachePath(file), true);

                CommonUtil.ExecuteProgram(GetCachePath("Updater.exe"), [Version]);
            }
            else
            {
                throw new Exception(AppLanguageManager.GetString("About.NoUpdateExe"));
            }
        }
        catch (Exception ex)
        {
            try
            {
                IsChecking = true;
                var result = await UpdateUtil.CheckForUpdates(token);
                var canUpdate = result != null;
                var remoteVer = result?.Version ?? Constant.AppVersion;
                var desc = result?.Body ?? "";

                var newVersionInfo = $"# {AppLanguageManager.GetString("About.GetNewer")}: {remoteVer}\n{(string.IsNullOrEmpty(desc) ? "" : $"\n{desc}")}";
                if (canUpdate)
                    MessageBox_S_MD.Show(newVersionInfo);
                else
                    MessageBox_S.Show(AppLanguageManager.GetString("Constant.NeweastVersionInfo"));
            }
            catch (OperationCanceledException)
            {
            }
            catch (Exception e)
            {
                MessageBox_S.Show(AppLanguageManager.GetString("About.UpdateFailed"));
                LogService.Logger.Warn($"检查更新出错, 请检查网络情况, {e.Message}");
            }
            finally
            {
                IsChecking = false;
            }

            LogService.Logger.Warn($"更新程序已打开或无法正确启动检查更新程序, {ex.Message}");
        }
    }
}