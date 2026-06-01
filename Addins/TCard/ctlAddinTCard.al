controladdin TCardAddIn
{
    RequestedHeight = 320;
    RequestedWidth = 300;
    MinimumHeight = 320;
    MinimumWidth = 200;
    //MaximumHeight = 600;
    //MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts = 'Addins/TCard/js/jquery.min.js',
        'Addins/TCard/js/jquery-ui.min.js',
        'Addins/TCard/js/jquery.xml2json.min.js',
        'Addins/TCard/js/jquery.ba-resize.min.js',
        'Addins/TCard/js/jquery.ui.touch-punch.min.js',
        'Addins/TCard/js/main.js';
    StartupScript = 'Addins/TCard/js/startup.js';
    StyleSheets = 'Addins/TCard/css/tcard.css';
    Images = 'Addins/TCard/img/container_delete.png', 'Addins/TCard/img/container_settings.png', 'Addins/TCard/img/vehicle.png';

    //RecreateScript = 'recreateScript.js';
    //RefreshScript = 'refreshScript.js';

    event ControlAddInReady()
    event RequestPositionChange(ContainerEntryNo: Integer; PosX: Integer; PosY: Integer)
    event RequestSizeChange(ContainerEntryNo: Integer; Size: Integer)
    event RequestItemToContainerChange(ContainerEntryNo: Integer; ItemEntryNo: Code[20]; ItemEntryType: Option; ItemSortIndex: Integer)
    event RequestRefreshData()
    event OpenItemEditCard(ItemEntryNo: Code[20]; ItemEntryType: Option Estimate,Jobsheet,"Return Jobsheet",)
    event RequestContainerSettings(ContainerEntryNo: Integer)
    event RequestContainerDelete(ContainerEntryNo: Integer)
    procedure RecieveInitTCardData(AddInData: Text)
    procedure RecieveRefreshTCardData(AddInData: Text)
    procedure RecieveTCardParams(AddInData: Text)










}