controladdin CheckListAddIn
{
    RequestedHeight = 340;
    RequestedWidth = 200;
    MinimumHeight = 340;
    MinimumWidth = 200;
    //MaximumHeight = 600;
    //MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts = 'Addins/CheckList/js/jquery.min.js',
        'Addins/CheckList/js/jquery-ui.min.js',
        'Addins/CheckList/js/jquery.xml2json.min.js',
        'Addins/CheckList/js/jquery.ba-resize.min.js',
        'Addins/CheckList/js/main.js';
    StartupScript = 'Addins/CheckList/js/startup.js';
    StyleSheets = 'Addins/CheckList/css/jquery-ui.css',
        'Addins/CheckList/css/CheckList.css';
    Images = 'Addins/CheckList/img/Action_Completed_32x32.png',
        'Addins/CheckList/img/ui-icons_888888_256x240.png';

    //RecreateScript = 'recreateScript.js';
    //RefreshScript = 'refreshScript.js';

    event ControlAddInReady()
    event RequestRefreshPage(ActLineNo: Integer)
    event RequestTextChange(LineNo: Integer; CommentText: Text)
    event RequestRadioChange(LineNo: Integer; RadioValue: Text)
    event RequestCheckChange(LineNo: Integer; CheckValue: Text)
    event RequestAssistEditButton(LineNo: Integer)
    event RequestButton(LineNo: Integer)
    event RequestExtendedText(LineNo: Integer; CommentText: Text)
    event RequestClosePage()
    event RequestLastFocusField(LineNo: Integer)
    procedure RecieveInitCheckListData(AddInData: Text)
    procedure RecieveRefreshCheckListData(AddInData: Text)
    procedure RecieveOnCloseCheckListData(AddInData: text)










}