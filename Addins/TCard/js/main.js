var version = '0.12';
var debugmode = false;
var addinelement = '';
var refresh_timer;
var refresh_interval = 4000;
var stop_refresh = true;
var edit_mode = false;
var disable_sort_on_receive = false;

$(document).ready(function () {
    element_workspace = $(window.frameElement).parents('.control-addin-form');
    if (element_workspace.length > 0) { // Chack if web client    
        $(window.frameElement).parent().css("height", "100%");
        $(window.frameElement).parent().css("flex", "1 1 auto");

        $(window.frameElement).css("max-height", '');
        $(window.frameElement).css("height", $(element_workspace).height() - 70 + "px");

        element_workspace.resize(function () {
            $(window.frameElement).css("max-height", '');
            $(window.frameElement).css("height", $(element_workspace).height() - 100 + "px");
            $(window.frameElement).css("height", $(element_workspace).height() - 70 + "px");
        });
    }




});

function RequestRefreshTCardData() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestRefreshData');
}
function RequestPositionChange(ContainerNo, Top, Left) {
    //clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestPositionChange', [ContainerNo, Top, Left]);
}

function RequestSizeChange(ContainerNo, Size) {
    //clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestSizeChange', [ContainerNo, Size]);
}

function RequestItemToContainerChange(ContainerNo, ItemNo, ItemType, ItemIndex) {
    //clearRefreshProcedure();
    //alert(ContainerNo + ' ' + ItemNo + ' ' + ItemType +' ' +ItemIndex);
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestItemToContainerChange', [ContainerNo, ItemNo, ItemType, ItemIndex]);
}

function RequestEditItemCard(ItemNo, ItemType) {
    clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OpenItemEditCard', [ItemNo, ItemType]);
}

function RecieveInitTCardData(AddInData) {
    stop_refresh = false;
    window.onhashchange = function () {
        clearRefreshProcedure();
    }
    RecieveRefreshTCardData(AddInData);
}

function RequestTCardContainerSettings(ContainerNo) {
    clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestContainerSettings', [ContainerNo]);
}

function RequestTCardContainerDelete(ContainerNo) {
    //clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestContainerDelete', [ContainerNo]);
}


function RecieveRefreshTCardData(AddInData) {
    disable_sort_on_receive = false;
    $(".box-item").remove(); //Remove also boddy appended sortable lost box-items
    $('.box-container').remove(); // Removes all containers.

    $(window.frameElement).next().remove(); //workaraound to remove blocking div.

    if (debugmode) {
        $('#serviceInfoContainer').text(AddInData);
    }

    if (AddInData != '') {
        json = $.xml2json(AddInData);
        if (json.Containers['EditMode'] == 'Yes') {
            edit_mode = true;
        } else {
            edit_mode = false;
        }
        if (json.Containers.Container.length != undefined) {
            $.each(json.Containers.Container, function (i, val) {
                AddContainerElement(val);
            });
        } else {
            val = json.Containers.Container;
            AddContainerElement(val);
        }

        if (json.Items.Item.length != undefined) {
            $.each(json.Items.Item, function (i, val) {
                AddItemElement(val);
            });
        } else {
            val = json.Items.Item;
            AddItemElement(val);
        }
    }

    $(function () {
        var container_no;
        var item_no;
        if (edit_mode) {
            $(".box-container").draggable({
                handle: "div.box-header",
                stack: ".box-container",
                grid: [20, 20],
                stop: function (event, ui) {
                    container_no = $(this).attr('id').substr(14, $(this).attr('id').length);
                    RequestPositionChange(container_no, ui.position.left, ui.position.top);
                }
            });

            $(".box-container").resizable({
                handles: "s",
                minHeight: "100",
                grid: 10,
                stop: function (event, ui) {
                    container_no = $(this).attr('id').substr(14, $(this).attr('id').length);
                    RequestSizeChange(container_no, ui.size.height);
                }
            });
        }

        /*
        $(".box-item").draggable({
            connectToSortable: '.box-container',
            appendTo: "body",
            helper: "clone",
            //revert: "invalid",
            //cursor: "pointer",
            //stack: ".box-item",
            
            start: function (event, ui) {
                $(this).fadeTo(0, 0.2);
            },
            stop: function (event, ui) {
                $(this).fadeTo(0, 1);
            }
            
        });

        .droppable({
            activeClass: "box-state-default",
            hoverClass: "box-state-hover",
            accept: ".box-item",
            drop: function (event, ui) {
                ui.draggable.appendTo(this);
                item_no = ui.draggable.attr('id').substr(9, ui.draggable.attr('id').length);
                item_type = ui.draggable.attr('type').substr(14, ui.draggable.attr('type').length);
                container_no = $(this).attr('id').substr(14, $(this).attr('id').length);
                RequestItemToContainerChange(container_no, item_no, item_type);
            }
        })
         
         */

        $(".box-container").sortable({
            appendTo: 'body',
            containment: 'window',
            scroll: false,
            helper: 'clone',
            connectWith: '.box-container',
            items: ".box-item",
            start: function () {
                clearRefreshProcedure();
                //$('.box-item').tooltip('disable');                
                //$('.box-item').tooltip('hide');
            },
            sort: function () {
                $('.ui-tooltip').remove();
            },
            receive: function (event, ui) {
                disable_sort_on_receive = true;
                item_index = ui.item.index();
                item_no = ui.item.attr('id').substr(9, ui.item.attr('id').length);
                item_type = ui.item.attr('type').substr(14, ui.item.attr('type').length);
                container_no = $(this).attr('id').substr(14, $(this).attr('id').length);
                RequestItemToContainerChange(container_no, item_no, item_type, item_index);
            },
            stop: function (event, ui) {
                if (!disable_sort_on_receive) {
                    item_index = ui.item.index();
                    item_no = ui.item.attr('id').substr(9, ui.item.attr('id').length);
                    item_type = ui.item.attr('type').substr(14, ui.item.attr('type').length);
                    container_no = $(this).attr('id').substr(14, $(this).attr('id').length);
                    RequestItemToContainerChange(container_no, item_no, item_type, item_index);
                }
                disable_sort_on_receive = false;
            }
        });



        $('.box-button-refresh').click(function () {
            RequestRefreshTCardData();
        }).mouseup(function () {
            $(this).fadeTo(0, 1);
        }).mousedown(function () {
            $(this).fadeTo(0, 0.3);
        });

        $('.box-button-settings').click(function () {
            container_no = $(this).parents('.box-container').attr('id').substr(14, $(this).parents('.box-container').attr('id').length);
            RequestTCardContainerSettings(container_no);
        }).mouseup(function () {
            $(this).fadeTo(0, 1);
        }).mousedown(function () {
            $(this).fadeTo(0, 0.3);
        });

        $('.box-button-delete').click(function () {
            container_no = $(this).parents('.box-container').attr('id').substr(14, $(this).parents('.box-container').attr('id').length);
            RequestTCardContainerDelete(container_no);
        }).mouseup(function () {
            $(this).fadeTo(0, 1);
        }).mousedown(function () {
            $(this).fadeTo(0, 0.3);
        });

        $('.box-item').click(function () {
            item_no = $(this).attr('id').substr(9, $(this).attr('id').length);
            item_type = $(this).attr('type').substr(14, $(this).attr('type').length);
            RequestEditItemCard(item_no, item_type);
        });

        $(document).tooltip({
            items: ".box-item",
            open: function (event, ui) {
                clearRefreshProcedure();
            },
            close: function (event, ui) {
                stop_refresh = false;
                startRefreshProcedure();
            },
            content: function () {
                element = $(this);
                return $(this).find('.tooltip-content').html();
            }
        });


    });





    /*
    //Update timer for auto refresh
    clearInterval(current_timer);
    if (!debugmode && !edit_mode) {
        current_timer = setInterval(function () { RequestRefreshTCardData(); }, timer_interval);
    }
    */


    $('.dialog-close', window.parent.document).click(function () {
        clearRefreshProcedure();
    });
    if (edit_mode) {
        clearRefreshProcedure();
    }

    UpdateRefreshInterval(json);
    UpdateStopRefresh(json);

    startRefreshProcedure();

}


function AddContainerElement(val) {
    if (edit_mode) {
        resizable_handle = '<div class="ui-resizable-handle ui-resizable-s" id="sgrip" onMouseOver="this.style.backgroundColor=\'' + val.HeaderColor + '\'" onMouseOut="this.style.backgroundColor=\'transparent\'"></div>';
        container_buttons = '<div class="box-button-settings"><img src="' + Microsoft.Dynamics.NAV.GetImageResource('Addins/TCard/img/container_settings.png') + '"/></div>';
        container_buttons += '<div class="box-button-delete"><img src="' + Microsoft.Dynamics.NAV.GetImageResource('Addins/TCard/img/container_delete.png') + '"/></div>';
    } else {
        resizable_handle = '';
        container_buttons = '';
    }



    $('#' + addinelement).append('' +
        '<div id="box-container-' + val.EntryNo + '" class="box-container" style="background-color: ' + val.Color + ';height: ' + val.Size + 'px;top:' + val.PositionY + 'px;left:' + val.PositionX + 'px;">' +
        resizable_handle +
        '<div class="box-header" style="background-color: ' + val.HeaderColor + ';">' + val.Name + '</div>' +
        container_buttons +
        '</div>'
    );
}

function AddItemElement(val) {
    var TooltipTextHeader = '';
    var TooltipTextDescription = '';
    var TooltipTextContent = '';
    var ItemNo = '';
    if (val.TooltipText1 != undefined && val.TooltipText1 != '') {
        TooltipTextHeader = '<div class="tooltip-header">' + val.TooltipText1 + '</div>';
    }
    if (val.TooltipText2 != undefined && val.TooltipText2 != '') {
        TooltipTextDescription = '<div class="tooltip-description">' + val.TooltipText2 + '</div>';
    }
    if (TooltipTextHeader != '' || TooltipTextDescription != '') {
        TooltipTextContent = '<div class="tooltip-content">' + TooltipTextHeader + TooltipTextDescription + '</div>';
    }
    if (val.ItemText4 != undefined) {
        ItemNo = val.ItemText4;
    } else {
        ItemNo = val.ItemNo;
    }

    $('#box-container-' + val.ItemContainerNo).append('' +
        '<div class="box-item" id="box-item-' + val.ItemNo + '" type="box-item-type-' + val.ItemType + '">' +
        '<div class="item-text2">' + val.ItemText2 + '</div>' +
        '<div class="item-label1">' + val.ItemLabel1 + '</div>' +
        '<div class="item-text3">' + val.ItemText3 + '</div>' +
        '<div class="item-no">' + ItemNo + '</div>' +
        '<div style="display: none;">' + TooltipTextContent + '</div>' +
        '</div>' +
        ''); // + ' - ' + val.ItemText4
    if (val.ItemText1 != '') {
        if (val.ItemImage1 != '') {
            var image = new Image();
            image.src = 'data:image/png;base64,' + val.ItemImage1;
            image.className = 'item-image1';
            $('#box-item-' + val.ItemNo).append(image);
        } else {
            var image = new Image();
            image.src = Microsoft.Dynamics.NAV.GetImageResource('Addins/TCard/img/vehicle.png');
            image.className = 'item-image1';
            $('#box-item-' + val.ItemNo).append(image);
        }
    }

}

function InitializeApp() {
    resources = [];
    events = [];
    addinelement = 'tcard_element';

    //$('#controlAddIn').css("overflow", "auto");
    $('#controlAddIn').append(
        '<div id="' + addinelement + '" class="' + addinelement + '" style="padding:0;margin:0;width:100%;height:100%;overflow-y:auto;overflow-x:auto;position:relative;">' +

        '</div>'
    );

    var initialCss =
        '.ui-tooltip {background-color: white; padding: 8px;position: absolute;z-index: 9999;max-width: 300px;-webkit-box-shadow: 0 0 5px #aaa;box-shadow: 0 0 5px #aaa;}' +
        'body.ui-tooltip {border-width: 2px;}' +
        '.tooltip-header {font-weight:700;font-size: 0.9em; font-family: "Segoe UI","Segoe WP",Segoe,device-segoe,Tahoma,Helvetica,Arial,sans-serif;}' +
        '.tooltip-description {font-family: "Segoe UI","Segoe WP",Segoe,device-segoe,Tahoma,Helvetica,Arial,sans-serif;}' +
        '.item-no{width:150px;top:4px;right:20px;text-align:right;white-space:nowrap;overflow:hidden;}' +
        '.item-text2{width:80px; height: 15px; top: 35px; left: 5px;white-space:nowrap;overflow:hidden;}' +
        '.item-text3{width:80px; height: 15px; top: 35px; right: 5px;white-space:nowrap;overflow:hidden; text-align: right}' +
        //'.bmw {background: url('+ Microsoft.Dynamics.NAV.GetImageResource('Addins/TCard/img/bmw.png') + ');}' +
        //'.vw {background: url('+ Microsoft.Dynamics.NAV.GetImageResource('Addins/TCard/img/vw.png') + ');}' +		
        //'.landrover {background: url('+ Microsoft.Dynamics.NAV.GetImageResource('Addins/TCard/img/landrover.png') + ');}' +	
        //'.volvo {background: url('+ Microsoft.Dynamics.NAV.GetImageResource('Addins/TCard/img/volvo.png') + ');}' +
        //'.vauxhall {background: url(' + Microsoft.Dynamics.NAV.GetImageResource('Addins/TCard/img/vauxhall.png') + ');}' +
        ''
        ;

    $('<style>').text(initialCss).appendTo('head');

    if (debugmode) {
        $('#controlAddIn').append('<textarea id="serviceInfoContainer" style="position:absolute;z-index:9999; bottom:0; right:20;"></textarea>');
    }

}

function GetVehicleMakeIcon(DMSMake) {
    switch (DMSMake) {
        case 'LANDROVER':
            DMSMake = 'landrover.png';
            break;
        case 'VAUXHALL':
            DMSMake = 'vauxhall.png';
            break;
        case 'BMW':
            DMSMake = 'bmw.png';
            break;
        case 'VOLVO':
            DMSMake = 'volvo.png';
            break;
        case 'VW':
            DMSMake = 'vw.png';
            break;
        default:
            DMSMake = 'vehicle.png';
    }
    return DMSMake;
}

function UpdateRefreshInterval(json) {
    if (json.Status.RefreshInterval != undefined && json.Status.RefreshInterval != '0') {
        refresh_interval = parseInt(json.Status.RefreshInterval);
    }
}

function UpdateStopRefresh(json) {
    if (json.Status.StartRefresh != undefined && json.Status.StartRefresh == 'Yes') {
        stop_refresh = false;
    }
}

function clearRefreshProcedure() {
    clearInterval(refresh_timer);
    stop_refresh = true;
}

function startRefreshProcedure() {
    if (!stop_refresh && !debugmode && !edit_mode) {
        clearInterval(refresh_timer);
        refresh_timer = setInterval(function () {
            //console.log('refresh');
            RequestRefreshTCardData();
        }, refresh_interval);
    }
}