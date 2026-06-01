controladdin GaugeAddIn
{
    RequestedHeight = 150;
    RequestedWidth = 200;
    MinimumHeight = 150;
    MinimumWidth = 200;
    //MaximumHeight = 600;
    //MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts = 'Addins/Gauge/js/jquery.min.js',
        'Addins/Gauge/js/jquery-ui.min.js',
        'Addins/Gauge/js/jquery.xml2json.min.js',
        'Addins/Gauge/js/jquery.ba-resize.min.js',
        'Addins/Gauge/js/cmGauge.js',
        'Addins/Gauge/js/main.js';
    StartupScript = 'Addins/Gauge/js/startup.js';
    StyleSheets = 'Addins/Gauge/css/jquery-ui.css',
        'Addins/Gauge/css/cmGauge.css',
        'Addins/Gauge/css/Gauge.css';
    Images = 'Addins/Gauge/img/Action_Completed_32x32.png';

    //RecreateScript = 'recreateScript.js';
    //RefreshScript = 'refreshScript.js';

    event ControlAddInReady()
    event GaugeClick()
    procedure RecieveInitGaugeData(AddInData: text)
    procedure RecieveRefreshGaugeData(AddInData: text)
    procedure RecieveGaugeParams(AddInData: text)










}