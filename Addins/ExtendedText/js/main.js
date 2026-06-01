var version = '2.0';
var debugmode = false;
var addinelementid = '';
var ExtendedTextCharacterLength = 10000;
var ExtendedTextLabel = '';
var ExtendedTextShowButtons = false;
var ExtendedTextSingleLine = false;
var ExtendedTextFontSize = 10; //default 10pt;
var ExtendedTextReadOnly = false;

function RequestExtendedTextClose() {
    if (ExtendedTextSingleLine) {
        $('#extendedTextControl').val($('#extendedTextControl').val().replace(/\n/g, " "));
    }
    RequestExtendedTextUpdate($('#extendedTextControl').val());
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestClosePage');
}

function RequestExtendedTextUpdate(Value) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('UpdateField', [Value]);
}

function RequestExtendedTextUpdateKey(Value) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('UpdateFieldByKey', [Value]);
}

function RequestExtendedTextButtonClose(Value) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ExtendedButtonCancel', [Value]);
}
function RequestExtendedTextButtonOk(Value) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ExtendedButtonOk', [Value]);
}

//function onUpdateExtendedText() {
//    RequestExtendedTextClose();
//}

function RecieveExtendedTextParams(AddInData) {
    if (AddInData != '') {
        var res = AddInData.split(";");
        //alert(res[0]+' - '+res[1]+' - '+res[2]);

        var _ExtendedTextCharacterLength = parseInt(res[0]);
        if (_ExtendedTextCharacterLength > 0) {
            ExtendedTextCharacterLength = _ExtendedTextCharacterLength;
        }

        if (res[1] != undefined && res[1] != '') {
            ExtendedTextLabel = res[1];
        }
        if (res[2] != undefined && res[2] == 'Yes') {
            ExtendedTextShowButtons = true;
        }
        if (res[3] != undefined && res[3] == 'Yes') {
            ExtendedTextSingleLine = true;
        }
        if (res[4] != undefined && parseInt(res[4]) != 0) {
            ExtendedTextFontSize = parseInt(res[4]);
        }
        if (res[5] != undefined && res[5] == 'Yes') {
            ExtendedTextReadOnly = true;
        }
    }
}

function RecieveInitExtendedTextData(AddInData) {
    RecieveRefreshExtendedTextData(AddInData);
}

function RecieveRefreshExtendedTextData(AddInData) {
    $(document).ready(function () {
        if (debugmode) {
            $('#serviceInfoContainer').text(AddInData);
        }

        CreateExtendedTextField(AddInData);
        InitEvents();
        UpdateCSS();
        //ProcessScroll();
    });
}

function UpdateCSS() {
    $(parent.document).find('.control-addin-container').last().attr('style', 'height:100%;');
    $(parent.document).find('.control-addin-container iframe').last().attr('style', 'border-style: none; margin: 0px; padding: 0px; height: 99%; width: 100%;');

    if (ExtendedTextShowButtons) {
        $('#' + addinelementid).css('height', 'calc(99% - 80px)');
    }
    if (ExtendedTextReadOnly) {
        $('#extendedTextControl').prop('disabled', true);
    }
}

function InitializeApp() {    //
    addinelement = 'extendedtext_element';
    addinelementid = addinelement;


    $('#controlAddIn').css("overflow", "auto").append(
        '<div id="' + addinelement + '" class="' + addinelement + '" style="padding:0;margin:0;width:100%;height:96%;">' +

        '</div>'
    );

    var areaHeight = '99%';
    if (navigator.userAgent.match(/(iPod|iPhone|iPad)/i)) {
        areaHeight = '30%';
    }

    var initialCss = '' +
        '.extendedTextControlArea {margin:0;padding:4px;width:96% !important;height: ' + areaHeight + ';}' +
        '.extendedTextControlInput {margin:0;padding:4px;width:96% !important;}' +
        '' +
        '';

    $('<style>').text(initialCss).appendTo('head');

    if (debugmode) {
        $('#controlAddIn').append('<textarea id="serviceInfoContainer" style="position:absolute;z-index:9999; bottom:0; right:20;"></textarea>');
    }

}



function InitEvents() {

    if (ExtendedTextSingleLine) {
        $("#extendedTextControl").keydown(function (e) {
            if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {
                window.focus();
                $(':focus').focus();
            }

            if (e.keyCode == 13 && !e.shiftKey) {
                e.preventDefault();
            }
            return true;
        });
    } else {
        $("#extendedTextControl").keydown(function (e) {
            if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {
                window.focus();
                $(':focus').focus();
            }
            return true;
        });
    }

    /*
    $('#extendedTextControl').last().focus();
    if (navigator.userAgent.match(/(iPod|iPhone|iPad|Android)/)) {
        $('#extendedTextControl').off("blur");
        $('#extendedTextControl').on("blur", function () {
            if (ExtendedTextSingleLine) {
                $('#extendedTextControl').val($('#extendedTextControl').val().replace(/\n/g, " "));
            }
            txtval = $('#extendedTextControl').val();
            RequestExtendedTextUpdate(txtval);
            setTimeout(function () { onUpdateExtendedText() }, 100);
            return true;
        });
    } else {
        $('#extendedTextControl').off("change");
        $('#extendedTextControl').change(function () {
            if (ExtendedTextSingleLine) {
                $(this).val($(this).val().replace(/\n/g, " "));
            }
            txtval = $(this).val();
            RequestExtendedTextUpdate(txtval);
            //setTimeout(function () { onUpdateExtendedText() }, 500);
            return true;
        });
    }
    */

    $('.extended-text-button-cancel').off("click");
    $('.extended-text-button-cancel').click(function () {
        setTimeout(
            function () {
                RequestExtendedTextButtonOk($('#extendedTextControl').val());
            }, 500);
        return true;
    });

    $('.extended-text-button-ok').off("click");
    $('.extended-text-button-ok').click(function () {
        setTimeout(
            function () {
                RequestExtendedTextButtonOk($('#extendedTextControl').val());
            }, 500);

        return true;
    });

}

function ProcessScroll() {
    var w = $('#controlAddIn');
    var row = $("#controlAddIn div.active-group").first();
    var top = 0;
    if (row.length) {
        top = ScrollTo;
        if (ScrollTo < 0) {
            //var HeaderHeight = $('#document-header-container').height();
            top = row.offset().top - row.height();
        } else {
            top = ScrollTo;
        }
        w.scrollTop(0);
        //w.scrollTop(top - row.height() - 30);
        //w.scrollTop(top - row.height());
        //w.scrollTop(top - row.height());
        w.scrollTop(top);
    }
}

function CreateExtendedTextField(FieldValue) {
    $('#' + addinelementid).empty();
    if (ExtendedTextShowButtons) {
        $('#' + addinelementid).append('<div class="ms-nav-actionbar-container has-actions"><button class="cursorinherit ms-nav-button highlight-btn theme-popp-g1-emph-bgcolor theme-popp-h3-bgcolor--hover theme-popp-a2-font-stack theme-popp-a2-color-2 extended-text-button-ok" id="" title="OK" type="button"><span>OK</span></button><button class="cursorinherit ms-nav-button theme-popp-h1-bgcolor--hover theme-popp-h1-bdrcolor--hover theme-popp-a2-font-stack theme-popp-a2-color-2 extended-text-button-cancel" id="" title="Cancel" type="button"><span>Cancel</span></button></div>');
    }

    //if (ExtendedTextSingleLine) {
    //    $('#' + addinelementid).append('<input class="extendedTextControlInput" type="text" placeholder="' + ExtendedTextLabel + '" maxlength="' + ExtendedTextCharacterLength + '" id="extendedTextControl" style="font-family: \'Segoe UI\', \'Segoe WP\', Segoe, device-segoe, Tahoma, Helvetica, Arial, sans-serif;font-size:' + ExtendedTextFontSize + 'pt;" value="' + FieldValue+'"/>');
    //} else {
    //    $('#' + addinelementid).append('<textarea class="extendedTextControlArea" placeholder="' + ExtendedTextLabel + '" maxlength="' + ExtendedTextCharacterLength + '" id="extendedTextControl" style="font-family: \'Segoe UI\', \'Segoe WP\', Segoe, device-segoe, Tahoma, Helvetica, Arial, sans-serif;font-size:' + ExtendedTextFontSize + 'pt;">' + FieldValue + '</textarea>');    
    //}   
    //$('#' + addinelementid).append('<textarea class="extendedTextControlArea" placeholder="' + ExtendedTextLabel + '" maxlength="' + ExtendedTextCharacterLength + '" id="extendedTextControl" style="font-family: \'Segoe UI\', \'Segoe WP\', Segoe, device-segoe, Tahoma, Helvetica, Arial, sans-serif;font-size:' + ExtendedTextFontSize + 'pt;">' + FieldValue + '</textarea>');    

    var FontSize = ExtendedTextFontSize + 'pt';
    if (navigator.userAgent.match(/(iPod|iPhone|iPad)/i)) {
        FontSize = '16px';
    }
    $('#' + addinelementid).append('<textarea class="extendedTextControlArea" placeholder="' + ExtendedTextLabel + '" maxlength="' + ExtendedTextCharacterLength + '" id="extendedTextControl" style="font-family: \'Segoe UI\', \'Segoe WP\', Segoe, device-segoe, Tahoma, Helvetica, Arial, sans-serif;font-size:' + FontSize + ';" ontouchstart="">' + FieldValue + '</textarea>');
}

function forceScrollTop() {
    var scrollTop = $(window).scrollTop();
    if (scrollTop != 0) {
        $(window).scrollTop(0);
        //$(selector).css('opacity', 1);
        //$(window).off('scroll', forceScrollTop);
    }
}