var version = '0.05';
var debugmode = false;
var addinelement = '';
var timer_interval = 4000;
var current_timer;
var edit_mode = false;
var dynamicCSSRules = [];
var current_shown_year;
var current_shown_month;

function RequestRefreshCalendarData(year,month) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestRefreshData',[year,month]);
}

function RecieveInitCalendarData(AddInData) {
    json = {};
    if (AddInData != '') {
        json = $.xml2json(AddInData);
    }

    if (debugmode) {
        $('#serviceInfoContainer').text(AddInData);
    }
    setSelectedDate(json);
    updateDatePickerCells(json);
}

function RequestSelectDate(year,month,day) {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestSelectDate', [year, month, day]);
}


function RecieveRefreshCalendarData(AddInData) {
    json = {};
    if (AddInData != '') {
        json = $.xml2json(AddInData);
    }

    if (debugmode) {
        $('#serviceInfoContainer').text(AddInData);
    }

    updateDatePickerCells(json);    
}

function InitializeApp() {
	HtmlElement = 'calendar_element';
    $(window.frameElement).next().remove(); //workaraound to remove blocking div.

 
    $('#controlAddIn').css("overflow", "auto");
    $('#controlAddIn').append('<div id="' + HtmlElement + '" class="' + HtmlElement + '" style="padding:0;margin:0;width:100%;"></div>');
    if (debugmode) {
        $('#controlAddIn').append('<textarea id="serviceInfoContainer" style="position:absolute;z-index:9999; bottom:0; right:20;"></textarea>');
    }
  
    initCSS();


    $("#calendar_element").datepicker({
        changeMonth: true,
        changeYear: true,
        firstDay: 1,
        //The calendar is recreated OnSelect for inline calendar
        
        onSelect: function (date, dp) {
            var date = $(this).datepicker('getDate'),
            day = date.getDate(),
            month = date.getMonth() + 1,
            year = date.getFullYear();
            current_shown_year = year;
            current_shown_month = month;
            RequestRefreshCalendarData(year, month);
            RequestSelectDate(year, month, day);
        },
        
        onChangeMonthYear: function (year, month, dp) {
            current_shown_year = year;
            current_shown_month = month;
            RequestRefreshCalendarData(year,month);
        },
        beforeShow: function (elem, dp) { //This is for non-inline datepicker
            var date = $(this).datepicker('getDate'),
            day = date.getDate(),
            month = date.getMonth() + 1,
            year = date.getFullYear();
            current_shown_year = year;
            current_shown_month = month;
            RequestRefreshCalendarData(year, month);
        }
    });

    var date = $('#calendar_element').datepicker('getDate');
    current_shown_month = date.getMonth() + 1,
    current_shown_year = date.getFullYear();
    
    //Update timer for auto refresh
    clearInterval(current_timer);
    if (!debugmode && !edit_mode) {
        current_timer = setInterval(function () { RequestRefreshCalendarData(current_shown_year,current_shown_month); }, timer_interval);
    }    
}

function initCSS() {
    var initialCss =		
        //'.ui-widget-header .ui-icon {background-image: url("' + Microsoft.Dynamics.NAV.GetImageResource('ui-icons_ffffff_256x240.png') + '");}' +
        '.ui-datepicker td a:after {content: "";display: block;text-align: center;color: Blue;font-size: small;font-weight: bold;}'+
        '.ui-datepicker {width: 260px}'+
        '.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default {height:25px;width:28px;}'+
        '.ui-state-highlight {border:1px solid #d3d3d3 !important; background-color:#d4d4d4 !important;}'
    ;

    $('<style>').text(initialCss).appendTo('head');
}

function updateDatePickerCells(json) {
    
    setTimeout(function () {
        clearCSSRules();
        $('.ui-datepicker td > *').each(function (idx, elem) {
            date = $(elem).parent().attr('data-year') + '-' + pad((parseInt($(elem).parent().attr('data-month'))+1),2) + '-' + pad((idx+1),2);
            var value = getDayValue(json, date);
            var className = 'datepicker-content-' + CryptoJS.MD5(value).toString();

            if (value == 0) {
                addCSSRule('.ui-datepicker td a.' + className + ':after {content: "\\a0";}'); //&nbsp;
            } else{
                addCSSRule('.ui-datepicker td a.' + className + ':after {content: "' + value + '";}');
            }
            $(this).addClass(className);
        });
    }, 0);
    
}

function setSelectedDate(json) {
    if (json.Calendar['SelectedDate'] != undefined) {
        var selectedDate = new Date(json.Calendar['SelectedDate']);
        $('#calendar_element').datepicker("setDate", selectedDate);
    }
}

function getDayValue(json, day) {
    value = 0;
    if (json.Calendar.Day.length != undefined) {
        $.each(json.Calendar.Day, function (i, val) {
            if (val.Date == day) {
                value = val.BookingCount;
            }
        });
    } else {
        val = json.Calendar.Day;
        if (val.Date == day) {
            value = val.BookingCount;
        }
    }
    return value;
}

function pad(num, size) {
    var s = num + "";
    while (s.length < size) s = "0" + s;
    return s;
}

function addCSSRule(rule) {
    if ($.inArray(rule, dynamicCSSRules) == -1) {
        $('head').append('<style>' + rule + '</style>');
        dynamicCSSRules.push(rule);
    }
}

function clearCSSRules() {
    $('head style').each(function (idx, elem) {
        if ($(elem).attr('for') == 'calendar') {
            $(elem).remove();
        }
    });
    dynamicCSSRules = [];
}