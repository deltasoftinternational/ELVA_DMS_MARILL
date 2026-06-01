controladdin ExtendedTextAddIn
{
    RequestedHeight = 374;
    RequestedWidth = 200;
    MinimumHeight = 374;
    MinimumWidth = 200;
    MaximumHeight = 600;
    MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    Scripts = 'Addins/ExtendedText/js/jquery.min.js',
              'Addins/ExtendedText/js/jquery-ui.min.js',
              'Addins/ExtendedText/js/main.js'; //,'js/jquery.ba-resize.min.js', 'js/jquery.xml2json.min.js'
    StartupScript = 'Addins/ExtendedText/js/startup.js';
    StyleSheets = 'Addins/ExtendedText/css/jquery-ui.css', 'Addins/ExtendedText/css/ExtendedText.css';
    //RecreateScript = 'recreateScript.js';
    //RefreshScript = 'refreshScript.js';
    //Images = 'image1.png','image2.png';

    event ControlAddInReady()
    event ExtendedButtonOk(AddInData: text)
    event ExtendedButtonCancel(AddInData: text)
    event UpdateField(AddInData: text)
    event ExtendedTextClose();
    event RequestClosePage();
    event UpdateFieldByKey(AddInData: text)
    procedure RequestExtendedTextClose(AddInData: text)
    procedure RecieveInitExtendedTextData(AddInData: text)
    procedure RecieveRefreshExtendedTextData(AddInData: text)
    procedure RecieveExtendedTextParams(AddInData: text)





}