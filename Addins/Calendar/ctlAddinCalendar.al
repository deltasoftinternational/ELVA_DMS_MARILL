controladdin CalendarAddIn
{
    RequestedHeight = 280;
    RequestedWidth = 280;
    MinimumHeight = 280;
    MinimumWidth = 280;
    //MaximumHeight = 600;
    //MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts = 'Addins/Calendar/js/jquery.min.js',
        'Addins/Calendar/js/jquery-ui.min.js',
        'Addins/Calendar/js/jquery.xml2json.min.js',
        'Addins/Calendar/js/jquery.ba-resize.min.js',
        'Addins/Calendar/js/jquery.ui.touch-punch.min.js',
        'Addins/Calendar/js/crypto.min.js',
        'Addins/Calendar/js/md5.min.js',
        'Addins/Calendar/js/main.js';

    StartupScript = 'Addins/Calendar/js/startup.js';

    StyleSheets = 'Addins/Calendar/css/jquery-ui.min.css', 'Addins/Calendar/css/Calendar.min.css';

    Images = 'Addins/Calendar/img/ui-bg_diagonals-thick_18_b81900_40x40.png', 'Addins/Calendar/img/ui-bg_diagonals-thick_20_666666_40x40.png',
        'Addins/Calendar/img/ui-bg_flat_10_000000_40x100.png', 'Addins/Calendar/img/ui-bg_glass_65_ffffff_1x400.png',
        'Addins/Calendar/img/ui-bg_glass_100_f6f6f6_1x400.png', 'Addins/Calendar/img/ui-bg_glass_100_fdf5ce_1x400.png',
        'Addins/Calendar/img/ui-bg_gloss-wave_35_f6a828_500x100.png', 'Addins/Calendar/img/ui-bg_highlight-soft_75_ffe45c_1x100.png',
        'Addins/Calendar/img/ui-bg_highlight-soft_100_eeeeee_1x100.png', 'Addins/Calendar/img/ui-icons_444444_256x240.png',
        'Addins/Calendar/img/ui-icons_555555_256x240.png', 'Addins/Calendar/img/ui-icons_777620_256x240.png',
        'Addins/Calendar/img/ui-icons_777777_256x240.png', 'Addins/Calendar/img/ui-icons_cc0000_256x240.png',
        'Addins/Calendar/img/ui-icons_ffffff_256x240.png';



    //RecreateScript = 'recreateScript.js';
    //RefreshScript = 'refreshScript.js';

    event ControlAddInReady()
    event RequestRefreshData(Year: Integer; Month: Integer)
    event RequestSelectDate(SelectedYear: Integer; SelectedMonth: Integer; SelectedDay: Integer)
    procedure RecieveInitCalendarData(AddInData: Text)
    procedure RecieveRefreshCalendarData(AddInData: Text)

}