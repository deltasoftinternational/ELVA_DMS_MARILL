controladdin MapViewAddIn
{
    RequestedHeight = 200;
    RequestedWidth = 200;
    MinimumHeight = 200;
    MinimumWidth = 200;
    //MaximumHeight = 600;
    //MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts = 'Addins/MapView/js/jquery.min.js',
        'Addins/MapView/js/jquery-ui.min.js',
        'Addins/MapView/js/jquery.xml2json.min.js',
        'Addins/MapView/js/jquery.ba-resize.min.js',
        'Addins/MapView/js/main.js';

    StartupScript = 'Addins/MapView/js/startup.js';

    StyleSheets = 'Addins/MapView/css/MapView.css';

    Images = 'Addins/MapView/img/Action_Completed_32x32.png';

    //RecreateScript = 'recreateScript.js';
    //RefreshScript = 'refreshScript.js';

    event ControlAddInReady()
    procedure RecieveInitMapViewData(AddInData: Text)
    procedure RecieveRefreshMapViewData(AddInData: Text)
}