var version = '0.15';
var debugmode = false;
var addinelement = '';
var clickcontrol = false;

UpdateSize();


function RequestCheckListTextChange(LineNo, Text) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestTextChange', [LineNo, Text]);
}

function RequestCheckListRadioChange(LineNo, Value) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestRadioChange', [LineNo, Value]);
}

function RequestCheckListCheckChange(LineNo, Value) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestCheckChange', [LineNo, Value]);
}

function RequestCheckListAssistEditButton(LineNo) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestAssistEditButton', [LineNo]);
}

function RequestCheckListButton(LineNo) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestButton', [LineNo]);
}

function RequestExtendedText(LineNo, Value) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestExtendedText', [LineNo, Value]);
}

function RecieveOnCloseCheckListData(AddInData) {
    $('.checklistcomment,.checklistsmallcomment').each(function (index, element) {
        RequestCheckListTextChange($(this).attr('lineno'), $(this).val());
    });
    RequestClosePage();
}

function RecieveSaveAllData(AddInData) {
    $('.checklistcomment,.checklistsmallcomment').each(function (index, element) {
        RequestCheckListTextChange($(this).attr('lineno'), $(this).val());
    });
}

function RequestLastFocusedField(LineNo) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestLastFocusField', [LineNo]);
}

function RequestClosePage() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestClosePage');
}



function RecieveInitCheckListData(AddInData) {
    if (AddInData != '') {
        RecieveRefreshCheckListData(AddInData);
    }
}

function RecieveRefreshCheckListData(AddInData) {
    if (debugmode) {
        $('#serviceInfoContainer').text(AddInData);
    }
    if (AddInData != '') {
        json = $.xml2json(AddInData);

        if (json.CheckList.Item != undefined) {
            if (json.CheckList.Item.length != undefined) {
                $('.listdata').empty();
                $.each(json.CheckList.Item, function (i, val) {
                    AddListRow(val);
                });
            } else {
                val = json.CheckList.Item;
                $('.listdata').empty();
                AddListRow(val);
            }
        }
    }

    InitEvents();
    UpdateSize();
}

function InitializeApp() {    //
    addinelement = 'checklist_element';
    $('#controlAddIn').css("overflow", "auto").append(
        '<div id="' + addinelement + '" class="' + addinelement + '" style="padding:0;margin:0;width:100%;height:100%;overflow-y:auto;overflow-x:auto;position:relative;">' +
        '<table class="listdata" border="1"></table>' +
        '</div>'
    );

    var initialCss = '#controlAddIn .listdata-row-desc td {border-bottom: 1px solid #ddd;margin:0; padding-bottom: 5px;}' +
        '#controlAddIn table {border-collapse: collapse;margin-top: 0px;}' +
        '#controlAddIn table td {border:1px solid gray}' +
        '#controlAddIn {font-family: "Segoe UI","Segoe WP",Segoe,device-segoe,Tahoma,Helvetica,Arial,sans-serif; font-size: 0.8em;}' +
        '#controlAddIn table {width: 100%;}' +
        '#controlAddIn .commentcontainer {overflow:hidden; min-width: 150px;}' +
        '#controlAddIn .commentsmallcontainer {overflow:hidden; min-width: 150px; max-width: 150px; float:left;}' +
        '#controlAddIn .inputcontainer {margin-right:45px;}' +
        '#controlAddIn .checklistcomment {float: left;width:100%; height: 42px;-ms-box-sizing: border-box;-khtml-box-sizing: border-box;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;box-sizing: border-box;}' +
        '#controlAddIn .checklistsmallcomment {float: left; width:100%; height: 42px;-ms-box-sizing: border-box;-khtml-box-sizing: border-box;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;box-sizing: border-box;}' +
        '#controlAddIn .checklistcommentbutton {height: 42px; width: 45px}' +
        '#controlAddIn .checkliststandardbutton {height: 42px; }' +
        '#controlAddIn .checklistradio {width:35px; height:35px; margin:4px;}' +
        '#controlAddIn .checklistradioinnercontainer {width:42px; height:42px;float: left;}' +
        '#controlAddIn .checklistradiooutercontainer {float: left;margin-right:2px;}' +
        '#controlAddIn .checklistcheck {width:34px; height:34px; margin:4px;}' +
        '#controlAddIn .checklistdescription {margin-left: 5px;}' +
        '#controlAddIn .radiolabel {height:42px; line-height:42px; display: inline-block;vertical-align: middle; margin: 0 5px 0 3px;}' +
        '#controlAddIn .groupdescription {padding: 5px 0; color: #0072C6; font-size: 18pt; font-family: "Segoe UI Semilight","Segoe WP SemiLight",device-segoe-semilight,"Segoe UI",Segoe,device-segoe-light,Tahoma,Helvetica,Arial,sans-serif;}' +
        '#controlAddIn .regulardescription {margin-right: 5px;cursor:pointer; font-size: 12pt; font-family: "Segoe UI","Segoe WP",Segoe,device-segoe,Tahoma,Helvetica,Arial,sans-serif;line-height:1.8em;}' +
        '.ui-dialog-titlebar {display:none}' +
        '.ui-dialog-buttonpane {margin-top: 0px !important; border-width: 0 0 0 0 !important;}' +
        '.ui-dialog .ui-dialog-content {padding:0 !important;}' +
        '.ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset {padding-right: 30px !important;}' +
        '.dialog-button-ok {border: 1px solid green !important; color: green !important;}' +
        '.dialog-button-cancel {border: 1px solid #da1616 !important; color: #da1616 !important;}' +
        '';

    $('<style>').text(initialCss).appendTo('head');

    if (debugmode) {
        $('#controlAddIn').append('<textarea id="serviceInfoContainer" style="position:absolute;z-index:9999; bottom:0; right:20;"></textarea>');
    }

}



function AddListRow(rowdata) {
    rowclass = '';
    if (rowdata.Type == '1') {
        $('.listdata').append(
            '<tr class="listdata-row-main ' + rowclass + '" id="list-row-' + rowdata.LineNo + '" lineno="' + rowdata.LineNo + '">' +
            '<td colspan="2"><div class="checklistdescription groupdescription" lineno="' + rowdata.LineNo + '">' + rowdata.Caption + '</div></td>' +
            '</tr>'
        );
    }
    if (rowdata.Type == '2') {
        AddItem(rowdata)
    }
}

function AddItem(rowdata) {
    rowclass = '';
    controls = '';

    if (rowdata.Controls.Control != undefined) {
        if (rowdata.Controls.Control.length != undefined) {
            $.each(rowdata.Controls.Control, function (i, val) {
                controls += GetControl(val);
            });
        } else {
            val = rowdata.Controls.Control;
            controls += GetControl(val);
        }
    }


    $('.listdata').append(
        '<tr class="listdata-row-main ' + rowclass + '" id="list-row-' + rowdata.LineNo + '" lineno="' + rowdata.LineNo + '">' +
        '<td class="column-first"><div class="checklistdescription regulardescription" lineno="' + rowdata.LineNo + '">' + rowdata.Caption + '</div></td>' +
        '<td class="column-second">' + controls +
        '</td>' +
        '</tr>'
    );
}

function GetControl(controldata) {
    if (controldata.Selected == 'true') {
        checked = 'checked="checked"';
    } else {
        checked = '';
    }

    if (controldata.Extended != undefined && (controldata.Extended == 'true' || controldata.Extended == 'True')) {
        extended = 'extended';
    } else {
        extended = '';
    }
    if (controldata.SingleLine != undefined && (controldata.SingleLine == 'true' || controldata.SingleLine == 'True')) {
        singleline = 'singleline';
    } else {
        singleline = '';
    }

    switch (controldata.SubType) {
        case '3':
            if (controldata.Value != '') {
                radiolabel = '<div class="radiolabel">' + controldata.Value + '</div>';
            } else {
                radiolabel = '';
            }
            $control = '<div class="checklistradiooutercontainer"><div class="checklistradioinnercontainer" style="background-color: ' + controldata.Color + '"><input class="checklistradio checklistradio1" type="radio" name="checklistradio' + controldata.ParentLineNo + '" lineno="' + controldata.LineNo + '" value="' + controldata.Value + '" ' + checked + '/></div>' + radiolabel + '</div>';
            break;
        case '4':
            $control = '<div class="checklistradiooutercontainer"><div class="checklistradioinnercontainer" style="background-color: ' + controldata.Color + '"><input class="checklistcheck checklistradio1" type="checkbox" name="checklistradio' + controldata.ParentLineNo + '" lineno="' + controldata.LineNo + '" value="' + controldata.Value + '" ' + checked + '/></div>';
            break;
        case '5':
            $control = '<input class="checkliststandardbutton" name="checklitcommentbutton-' + controldata.ParentLineNo + '" type="button" lineno="' + controldata.LineNo + '" value="' + controldata.Caption + '" />';
            break;
        case '1':
            if (controldata.AssistEdit == 'true') {
                $assistedit = '<input class="checklistcommentbutton" name="checklitcommentbutton-' + controldata.ParentLineNo + '" type="button" lineno="' + controldata.LineNo + '" value="..." />';
                $assiststyle = '';
            } else {
                $assistedit = '';
                $assiststyle = 'margin:0;';
            }
            //$control = '<div class="commentsmallcontainer"><div class="inputcontainer"><input placeholder="' + controldata.Caption + '" class="checklistsmallcomment ' + extended +'" type="text" name="checklistcommentsmall-' + controldata.ParentLineNo + '" lineno="' + controldata.LineNo + '" value="' + controldata.Value + '" maxlength="' + controldata.TextLength + '" /></div>' + $assistedit + '</div>';
            $control = '<div class="commentsmallcontainer"><div class="inputcontainer" style="' + $assiststyle + '"><textarea placeholder="' + controldata.Caption + '" class="checklistsmallcomment ' + extended + ' ' + singleline + '" type="text" name="checklistcommentsmall-' + controldata.ParentLineNo + '" lineno="' + controldata.LineNo + '" maxlength="' + controldata.TextLength + '" >' + controldata.Value + '</textarea></div>' + $assistedit + '</div>'; //data-autosize-input=\'{ "space": 40 }\'
            break;
        case '2':
            if (controldata.AssistEdit == 'true') {
                $assistedit = '<input class="checklistcommentbutton" name="checklitcommentbutton-' + controldata.ParentLineNo + '" type="button" lineno="' + controldata.LineNo + '" value="..." />';
                $assiststyle = '';
            } else {
                $assistedit = '';
                $assiststyle = 'margin:0;';
            }
            //$control = '<div class="commentcontainer"><div class="inputcontainer"><input placeholder="' + controldata.Caption + '" class="checklistcomment '+extended+'" type="text" name="checklistcomment-' + controldata.ParentLineNo + '" lineno="' + controldata.LineNo + '" value="' + controldata.Value + '" maxlength="' + controldata.TextLength + '" /></div>' + $assistedit + '</div>';
            $control = '<div class="commentcontainer"><div class="inputcontainer" style="' + $assiststyle + '"><textarea placeholder="' + controldata.Caption + '" class="checklistcomment ' + extended + ' ' + singleline + '" type="text" name="checklistcomment-' + controldata.ParentLineNo + '" lineno="' + controldata.LineNo + '" maxlength="' + controldata.TextLength + '" >' + controldata.Value + '</textarea></div>' + $assistedit + '</div>'; //data-autosize-input=\'{ "space": 30 }\'
            break;
        default:
            $control = '';
    }
    return $control;
}




function InitEvents() {
    clickcontrol = false;
    $('.checklistcomment.extended,.checklistsmallcomment.extended').click(function () {
        if (!clickcontrol) {
            clickcontrol = true;
            $(this).prop('disabled', true);
            RequestExtendedText($(this).attr('lineno'), $(this).val());
        }
    });

    $('.checklistcomment,.checklistsmallcomment').click(function () {
        RequestLastFocusedField($(this).attr('lineno'));
    });

    $('.checklistcomment,.checklistsmallcomment').change(function () {
        if ($(this).hasClass('singleline')) {
            $(this).val($(this).val().replace(/\n/g, " "));
            this.style.height = 'auto';
            this.setAttribute('style', 'height:' + (this.scrollHeight) + 'px;overflow-y:hidden;');
        }
        RequestCheckListTextChange($(this).attr('lineno'), $(this).val());
    });

    $('.singleline').keydown(function (e) {
        if (e.keyCode == 13 && !e.shiftKey) {
            e.preventDefault();
        }
        return true;
    });

    $('input[type=radio]').change(function () {
        RequestCheckListRadioChange($(this).attr('lineno'), $(this).val());
    });


    $('.checklistcommentbutton').click(function () {
        RequestCheckListAssistEditButton($(this).attr('lineno'));
    });
    /*
    $('.checkliststandardbutton').click(function () {
        RequestCheckListAssistEditButton($(this).attr('lineno'));
    });  
    */
    $('.checkliststandardbutton').click(function () {
        RequestCheckListButton($(this).attr('lineno'));
    });
    $('input[type=checkbox]').click(function () {
        RequestCheckListCheckChange($(this).attr('lineno'), $(this).val());
    });

    $('.checklistcomment,.checklistsmallcomment').each(function () {
        this.style.height = 'auto';
        this.setAttribute('style', 'height:' + (this.scrollHeight) + 'px;overflow-y:hidden;');
    }).on('input', function () {
        //if ($(this).val() == '') {
        //    this.style.height = 'auto';
        //} else {
        this.style.height = 'auto';
        this.style.height = (this.scrollHeight) + 'px';
        UpdateSize();
        //}
    });

    $('.singleline').change(function () {
        $(this).val($(this).val().replace(/\n/g, " "));

        RequestExtendedTextUpdate($(this).val());
        return true;
    });

}

function UpdateSize() {
    $(document).ready(function () {
        element_workspace = $(window.frameElement).parents('.control-addin-form');
        if (element_workspace.length > 0) { // Chack if web client    
            $(window.frameElement).parent().css("height", "100%");
            $(window.frameElement).parent().css("flex", "1 1 auto");

            $('table.listdata').ready(function () {
                $(window.frameElement).css("max-height", '');
                $(window.frameElement).css("height", $('table.listdata').height() + 3 + "px");
            });

            element_workspace.resize(function () {
                $(window.frameElement).css("max-height", '');
                $(window.frameElement).css("height", $('table.listdata').height() + 3 + "px");
            });
        }
    });
}

function TextDialog(element) {
    var maxlength = $(element).attr('maxlength');
    var Label = $(element).parents('.listdata-row-main').find(".regulardescription").text();
    var content = '<div class="custom-lot-label" style="font-size:0.8em; margin: 0 0 5px 25px;">' + Label + ':</div><textarea maxlength="' + maxlength + '" style="margin: 0 0 30px 25px;" rows="3" cols="20" name="description" class="custom-lot-value"></textarea >';
    var _insert = $('<div class="custom-dialog" style="padding: 10px;">' + content + '</div>').css('display', 'none').attr('id', 'dialog-confirm');
    _insert.prependTo($("body"));
    $("#dialog-confirm").dialog({
        draggable: false,
        resizable: false,
        height: "auto",
        width: 270,
        modal: true,
        open: function (event, ui) {

            $(this).prepend($(this).parent().find('.ui-dialog-buttonpane'));

            var my_dialog = this;
            $('.custom-lot-value').val($(element).val());
            $('.custom-lot-value').focus();
        },
        buttons: {
            Ok: {
                text: 'Ok',
                class: 'dialog-button-ok',
                click: function () {
                    var LotNo = $('.custom-lot-value').val();
                    $(this).dialog("close");
                    $('.custom-lot-value').val('').blur();
                    $(this).dialog('destroy').remove();
                    $(element).val(LotNo).blur();
                    RequestCheckListTextChange($(element).attr('lineno'), $(element).val());
                }
            },
            "Cancel": {
                text: 'Cancel',
                class: 'dialog-button-cancel',
                click: function () {
                    $(this).dialog("close");
                    $('.custom-lot-value').val('').blur();
                    $(this).dialog('destroy').remove();
                    $(element).blur();
                }
            }
        }
    });
}
