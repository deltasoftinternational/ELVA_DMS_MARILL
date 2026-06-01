controladdin RentScheduleAddIn
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

    Scripts = 'Addins/RentSchedule/js/jquery.min.js',
        'Addins/RentSchedule/js/jquery-ui.min.js',
        'Addins/RentSchedule/js/jquery.xml2json.min.js',
        'Addins/RentSchedule/js/jquery.ba-resize.min.js',
        'Addins/RentSchedule/js/dhtmlxscheduler.js',
        'Addins/RentSchedule/js/dhtmlxmenu.js',
        'Addins/RentSchedule/js/dhtmlxscheduler_limit.js',
        'Addins/RentSchedule/js/dhtmlxscheduler_timeline.js',
        'Addins/RentSchedule/js/dhtmlxscheduler_tooltip.js',
        'Addins/RentSchedule/js/main.js';

    StartupScript = 'Addins/RentSchedule/js/startup.js';
    StyleSheets = 'Addins/RentSchedule/css/dhtmlxmenu.css', 'Addins/RentSchedule/css/dhtmlxscheduler.css';

    Images = 'Addins/RentSchedule/img/arrow_left.png',
        'Addins/RentSchedule/img/arrow_right.png',
        'Addins/RentSchedule/img/but_repeat.png',
        'Addins/RentSchedule/img/buttons.png',
        'Addins/RentSchedule/img/calendar.png',
        'Addins/RentSchedule/img/clock_big.png',
        'Addins/RentSchedule/img/clock_small.png',
        'Addins/RentSchedule/img/clock.png',
        'Addins/RentSchedule/img/close_icon.png',
        'Addins/RentSchedule/img/collapse_expand_icon.png',
        'Addins/RentSchedule/img/controls.png',
        'Addins/RentSchedule/img/databg_now.png',
        'Addins/RentSchedule/img/databg.png',
        'Addins/RentSchedule/img/dhxmenu_arrow_down_dis.png',
        'Addins/RentSchedule/img/dhxmenu_arrow_down.png',
        'Addins/RentSchedule/img/dhxmenu_arrow_up_dis.png',
        'Addins/RentSchedule/img/dhxmenu_arrow_up.png',
        'Addins/RentSchedule/img/dhxmenu_chrd.png',
        'Addins/RentSchedule/img/dhxmenu_loader.png',
        'Addins/RentSchedule/img/dhxmenu_subar.png',
        'Addins/RentSchedule/img/export_ical.png',
        'Addins/RentSchedule/img/export_pdf.png',
        'Addins/RentSchedule/img/i.png',
        'Addins/RentSchedule/img/icon.png',
        'Addins/RentSchedule/img/images.png',
        'Addins/RentSchedule/img/loading.png',
        'Addins/RentSchedule/img/resize_dots.png',
        'Addins/RentSchedule/img/resizing.png';

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