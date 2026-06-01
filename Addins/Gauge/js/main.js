var version = '0.01';
var debugmode = false;
var addinelementid = '';
var GaugeValue = '';
var GaugeLabel = '';
var GaugeColors = '';

function RequestGaugeClick() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('GaugeClick');
}

function RecieveGaugeParams(AddInData) {
    if (AddInData != '') {
        var res = AddInData.split(";");
        //alert(res[0]+' - '+res[1]+' - '+res[2]);

        var _GaugeValue = parseInt(res[0]);
        if (_GaugeValue >= 0) {
            GaugeValue = _GaugeValue;
        }
        if (res[1] != undefined && res[1] != '') {
            GaugeLabel = res[1];
        }
        if (res[2] != undefined && res[2] != '') {
            GaugeColors = res[2];
        }
    }
}

function RecieveInitGaugeData(AddInData) {
    RecieveRefreshGaugeData(AddInData);
}

function RecieveRefreshGaugeData(AddInData) {
    if (debugmode) {
        $('#serviceInfoContainer').text(AddInData);
    }

    CreateGauge();
    InitEvents();
    UpdateCSS();
    //ProcessScroll();
}

function UpdateCSS() {
    //$(parent.document).find('.control-addin-container').last().attr('style', 'height:100%;');
    //$(parent.document).find('.control-addin-container iframe').last().attr('style', 'border-style: none; margin: 0px; padding: 0px; height: 99%; width: 100%;');
    if (GaugeColors != '') {
        var c = GaugeColors.split(",");
        colors_css = '';
        if (c[0] != undefined) {
            colors_css += '.gauge-red.gauge:before {border-color: ' + c[0] + ';}';
        }
        if (c[1] != undefined) {
            colors_css += '.gauge-orange.gauge:before {border-color: ' + c[1] + ';}';
        }
        if (c[2] != undefined) {
            colors_css += '.gauge-yellow.gauge:before {border-color: ' + c[2] + ';}';
        }
        if (c[3] != undefined) {
            colors_css += '.gauge-green.gauge:before {border-color: ' + c[3] + ';}';
        }
        if (c[4] != undefined) {
            colors_css += '.gauge-blue.gauge:before {border-color: ' + c[4] + ';}';
        }
        $('<style>').text(colors_css).appendTo('head');
    }
}

function InitializeApp() {
    var addinelement = 'gauge_element';
    addinelementid = addinelement;


    $('#controlAddIn').css("overflow", "auto").append(
        '<div id="' + addinelement + '" class="' + addinelement + '" style="padding:0;margin:0;width:100%;height:96%; text-align:center;">' +

        '</div>'
    );

    var initialCss = '' +
        '#gaugeLabel {cursor:pointer; font-family: \'Segoe UI\', \'Segoe WP\', Segoe, device-segoe, Tahoma, Helvetica, Arial, sans-serif;font-size:14pt; margin-top: 5px;}' +
        '' +
        '' +
        '';

    $('<style>').text(initialCss).appendTo('head');

    if (debugmode) {
        $('#controlAddIn').append('<textarea id="serviceInfoContainer" style="position:absolute;z-index:9999; bottom:0; right:20;"></textarea>');
    }

}



function InitEvents() {
    $('#gaugeLabel').click(function () {
        RequestGaugeClick();
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

function CreateGauge() {
    $('#' + addinelementid).empty();
    $('#' + addinelementid).append('<div style="margin-top:20px; overflow:hidden;font-size: 50vmin;" id="gaugeDms" class="gauge gauge-big gauge-green"><div class="gauge-arrow" data-percentage="' + GaugeValue + '" style= "transform: rotate(0deg);"></div></div><div style="text-align:center;" id="gaugeLabel">' + GaugeLabel + '</div>');
    $('#gaugeDms .gauge-arrow').cmGauge();
}