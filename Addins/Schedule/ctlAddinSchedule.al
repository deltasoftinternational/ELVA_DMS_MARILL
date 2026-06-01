controladdin ScheduleAddIn
{
    RequestedHeight = 400;
    RequestedWidth = 900;
    MinimumHeight = 400;
    MinimumWidth = 900;
    //MaximumHeight = 600;
    //MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts = 'Addins/Schedule/js/jquery.min.js',
        'Addins/Schedule/js/jquery-ui.min.js',
        'Addins/Schedule/js/jquery.xml2json.min.js',
        'Addins/Schedule/js/jquery.ba-resize.min.js',
        'Addins/Schedule/js/dhtmlxscheduler.js',
        'Addins/Schedule/js/dhtmlxmenu.js',
        'Addins/Schedule/js/dhtmlxscheduler_limit.js',
        'Addins/Schedule/js/dhtmlxscheduler_timeline.js',
        'Addins/Schedule/js/dhtmlxscheduler_tooltip.js',
        'Addins/Schedule/js/main.js';

    StartupScript = 'Addins/Schedule/js/startup.js';
    StyleSheets = 'Addins/Schedule/css/dhtmlxmenu.css', 'Addins/Schedule/css/dhtmlxscheduler.css';

    Images = 'Addins/Schedule/img/arrow_left.png',
        'Addins/Schedule/img/arrow_right.png',
        'Addins/Schedule/img/but_repeat.png',
        'Addins/Schedule/img/buttons.png',
        'Addins/Schedule/img/calendar.png',
        'Addins/Schedule/img/clock_big.png',
        'Addins/Schedule/img/clock_small.png',
        'Addins/Schedule/img/clock.png',
        'Addins/Schedule/img/close_icon.png',
        'Addins/Schedule/img/collapse_expand_icon.png',
        'Addins/Schedule/img/controls.png',
        'Addins/Schedule/img/databg_now.png',
        'Addins/Schedule/img/databg.png',
        'Addins/Schedule/img/dhxmenu_arrow_down_dis.png',
        'Addins/Schedule/img/dhxmenu_arrow_down.png',
        'Addins/Schedule/img/dhxmenu_arrow_up_dis.png',
        'Addins/Schedule/img/dhxmenu_arrow_up.png',
        'Addins/Schedule/img/dhxmenu_chrd.png',
        'Addins/Schedule/img/dhxmenu_loader.png',
        'Addins/Schedule/img/dhxmenu_subar.png',
        'Addins/Schedule/img/export_ical.png',
        'Addins/Schedule/img/export_pdf.png',
        'Addins/Schedule/img/i.png',
        'Addins/Schedule/img/icon.png',
        'Addins/Schedule/img/images.png',
        'Addins/Schedule/img/loading.png',
        'Addins/Schedule/img/resize_dots.png',
        'Addins/Schedule/img/resizing.png';

    //RecreateScript = 'recreateScript.js';
    //RefreshScript = 'refreshScript.js';

    event ControlAddInReady()
    event RequestScheduleData()
    event ProcessAllocation(EventType: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    event ProcessReallocation(EntryNo: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    event ProcessAllocationEdit(EntryNo: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    event ProcessCommands(Index: Integer; EntryNo: Integer; ResNo: Code[20]; CommStartDT: Decimal; CommEndDT: Decimal)
    procedure RecieveInitScheduleData(AddInData: Text)
    procedure RecieveRefreshScheduleData(AddInData: Text)
}