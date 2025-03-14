﻿using System.Globalization;
using System.Windows.Data;
using STranslate.Model;

namespace STranslate.Style.Converters;

public class BooleanToContentConverter : IValueConverter
{
    /// <summary>
    ///     True False 控制图标
    /// </summary>
    /// <param name="value"></param>
    /// <param name="targetType"></param>
    /// <param name="parameter"></param>
    /// <param name="culture"></param>
    /// <returns></returns>
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        if (value is bool bValue)
        {
            if (parameter.Equals("ICON"))
                return bValue ? Constant.HideIcon : Constant.ShowIcon;
            if (parameter.Equals("HISTORY"))
                return bValue ? AppLanguageManager.GetString("Constant.Loading") : AppLanguageManager.GetString("Constant.Unloading");
        }

        return "";
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
    {
        throw new NotImplementedException();
    }
}