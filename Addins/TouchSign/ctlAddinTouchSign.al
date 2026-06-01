controladdin TouchSignAddIn
{
    RequestedHeight = 380;
    RequestedWidth = 480;
    MinimumHeight = 380;
    MinimumWidth = 480;
    //MaximumHeight = 600;
    //MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts = 'Addins/TouchSign/js/jquery.min.js',
        'Addins/TouchSign/js/jquery-ui.min.js',
        'Addins/TouchSign/js/jquery.xml2json.min.js',
        'Addins/TouchSign/js/jquery.ba-resize.min.js',
        'Addins/TouchSign/js/main.js';
    StartupScript = 'Addins/TouchSign/js/startup.js';
    StyleSheets = 'Addins/TouchSign/css/TouchSign.css';
    Images = 'Addins/TouchSign/img/Action_Completed_32x32.png';

    //RecreateScript = 'recreateScript.js';
    //RefreshScript = 'refreshScript.js';

    event ControlAddInReady()
    event RecieveTouchSignData(RecievedDocumentType: Code[20]; RecievedDocumentNo: Code[20]; SignImg: Text)
    event RecieveClearSignData(RecievedDocumentType: Code[20]; RecievedDocumentNo: Code[20]; SignImg: Text)
    procedure RecieveInitTouchSignData(AddInData: Text)
    procedure RecieveRefreshTouchSignData(AddInData: Text)
    procedure RecieveTouchSignParams(AddInData: Text)
    procedure RecieveSetDocumentNo(documenttype: Text; documentno: Text);










}