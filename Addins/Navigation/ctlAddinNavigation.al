controladdin NavigationAddIn
{
    RequestedHeight = 490;
    RequestedWidth = 320;
    MinimumHeight = 490;
    MinimumWidth = 320;
    //MaximumHeight = 600;
    //MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts = 'Addins/Navigation/js/jquery.min.js',
        'Addins/Navigation/js/jquery-ui.min.js',
        'Addins/Navigation/js/jquery.xml2json.min.js',
        'Addins/Navigation/js/jquery.ba-resize.min.js',
        'Addins/Navigation/js/main.js';
    StartupScript = 'Addins/Navigation/js/startup.js';

    //StyleSheets = '';

    Images = 'Addins/Navigation/img/Action_Completed_32x32.png',
        'Addins/Navigation/img/Action_Delivery.png',
        'Addins/Navigation/img/Action_Error_32x32.png',
        'Addins/Navigation/img/Action_NewLine_32x32.png',
        'Addins/Navigation/img/Action_NewOpportunity_32x32.png',
        'Addins/Navigation/img/Action_NewOrder_32x32.png',
        'Addins/Navigation/img/Action_NewTimesheet_32x32.png',
        'Addins/Navigation/img/Action_NewToDo_32x32.png',
        'Addins/Navigation/img/Action_NewToDoGroup_32x32.png',
        'Addins/Navigation/img/Action_Pause_32x32.png',
        'Addins/Navigation/img/Action_SetCurrTime_32x32.png',
        'Addins/Navigation/img/Action_Start_32x32.png',
        'Addins/Navigation/img/time_start_blue_32x32.png',
        'Addins/Navigation/img/time_stop_blue_32x32.png';


    //RecreateScript = 'recreateScript.js';
    //RefreshScript = 'refreshScript.js';

    event ControlAddInReady()
    event RequestNavigationData()
    event ProcessControlCommand(ControlNo: Integer)
    event ProcessTaskCompleteCommand(EntryNo: Integer)
    event ProcessTaskPauseCommand(EntryNo: Integer)
    event ProcessTaskStartCommand(EntryNo: Integer)
    event ProcessWorktimeCommand()
    event ProcessLookupCommand(EntryNo: Integer)
    procedure RecieveInitNavigationData(AddInData: Text)
    procedure RecieveRefreshNavigationData(AddInData: Text)
    procedure RecieveNavigationParams(AddInData: Text)










}