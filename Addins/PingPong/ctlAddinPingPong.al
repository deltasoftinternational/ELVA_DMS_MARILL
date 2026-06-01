controladdin PingPongAddIn
{
    RequestedHeight = 414;
    RequestedWidth = 200;
    MinimumHeight = 414;
    MinimumWidth = 200;
    //MaximumHeight = 600;
    //MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts = 'Addins/PingPong/js/main.js';
    StartupScript = 'Addins/PingPong/js/startup.js';

    //StyleSheets = '';
    //Images = '';
    //RecreateScript = 'recreateScript.js';
    //RefreshScript = 'refreshScript.js';

    event ControlAddInReady()
    event Pong()
    procedure Ping(textmessage: Integer);










}