var version = '0.15';
var debugmode = false;
var addinelement = '';
var refresh_timer;
var refresh_interval = 1500;
var stop_refresh = true;
var disable_onhold = false;


function RequestNavigationData() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestNavigationData');
}
function RequestProcessControlCommand(ControlNo) {
    clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ProcessControlCommand', [ControlNo]);
}
function RequestTaskCompleteCommand(EntryNo) {
    clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ProcessTaskCompleteCommand', [EntryNo]);
}
function RequestTaskStartCommand(EntryNo) {
    clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ProcessTaskStartCommand', [EntryNo]);
}
function RequestTaskPauseCommand(EntryNo) {
    clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ProcessTaskPauseCommand', [EntryNo]);
}
function RequestWorktimeCommand() {
    clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ProcessWorktimeCommand');
}
function RequestLookupCommand(EntryNo) {
    clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ProcessLookupCommand', [EntryNo]);
}
function RecieveInitNavigationData(AddInData) {
    stop_refresh = false;
    window.onhashchange = function () {
        clearRefreshProcedure();
    }
    RecieveRefreshNavigationData(AddInData);
}

function RecieveRefreshNavigationData(AddInData) {
    var control_description = '';
    var control_class = 'navigation-control-text';

    $(window.frameElement).next().remove(); //workaraound to remove blocking div.

    if (debugmode) {
        $('#serviceInfoContainer').text(AddInData);
    }


    if (AddInData != '') {
        json = $.xml2json(AddInData);

        UpdateRefreshInterval(json);
        UpdateStopRefresh(json);
        UpdateDisableOnHold(json);


        $('#' + addinelement).empty();
        $('#' + addinelement).append('<div class="ms-nav-actions"><ul></ul></div>');
        $('#' + addinelement + ' ul').append('<li class="navigation-control-text"><div class="columns-caption-container"><span class="ms-nav-columns-caption icon-RightCaret-after">My Status</span></div></li>');

        if (json.Status.ResourceNo != undefined) {
            var navigation_status_class = '';
            var navigation_worktime_switch_img = '';
            if (json.Status.IsWorking == 'Yes') {
                navigation_status_class = 'navigation-status-green';
                navigation_worktime_switch_img = Microsoft.Dynamics.NAV.GetImageResource('Addins/Navigation/img/time_stop_blue_32x32.png');
            } else {
                navigation_status_class = 'navigation-status-red';
                navigation_worktime_switch_img = Microsoft.Dynamics.NAV.GetImageResource('Addins/Navigation/img/time_start_blue_32x32.png');
            }
            //$('#' + addinelement + ' ul').append('' +
            //    '<li class="navigation-control-status">' +
            //    '<span class="' + navigation_status_class + '">' + GetDashboardCaption(json) + '</span>' +
            //    '<a draggable="false" role="button" aria-disabled="false" href="javascript:return false;" class="easy-worktime-button"><span class="ms-nav-actions-iconContainer"><img class="button-complete-status' + 'on' + '" draggable="false" alt="Service Quote" src="' + navigation_worktime_switch_img + '" role="presentation"/></span></a>' +
            //    '</li>'
            //);
            $('#' + addinelement + ' ul').append('<li class="navigation-control-status"><a draggable="false" role="button" aria-disabled="false" href="javascript:;" class="easy-worktime-button"><span class="ms-nav-actions-iconContainer"><img draggable="false" alt="Service Quote" src="' + navigation_worktime_switch_img + '" role="presentation"/></span><span class="ms-nav-actions-label"><span class="' + navigation_status_class + '">' + GetWorktimeCaption(json) + '</span><p>' + GetWorktimeDescription(json) + '</p></span></a></li>');
        }

        $('#' + addinelement + ' ul').append('<li class="navigation-control-text"><div class="columns-caption-container"><span class="ms-nav-columns-caption icon-RightCaret-after">My Current Tasks</span></div></li>');


        if (json.Tasks.Task.length != undefined) {
            $.each(json.Tasks.Task, function (i, val) {
                travel_element = '';
                if (val.IsIdle == 'True') {
                    val.Status = '-disabled';
                }
                if (val.Travel == 'true') {
                    travel_element = '<span class="task-travel">[Travel]</span>';
                }
                task_description = val.Description.replace(/{Time}/g, '');
                if (disable_onhold) {
                    on_hold_button = '';
                } else {
                    on_hold_button = '<a draggable="false" role="button" aria-disabled="false" href="javascript:return false;" class="easy-pause-button" id="control' + parseInt(val.EntryNo) + '"><span class="ms-nav-actions-iconContainer"><img class="button-pause-status' + val.Status + '" draggable="false" alt="Service Quote" src="' + Microsoft.Dynamics.NAV.GetImageResource('Addins/Navigation/img/Action_Pause_32x32.png') + '" role="presentation"/></span></a>';
                }
                $('#' + addinelement + ' ul').append('' +
                    '<li class="navigation-control-task">' +
                    '<a draggable="false" role="button" aria-disabled="false" href="javascript:return false;" class="easy-complete-button" id="control' + parseInt(val.EntryNo) + '"><span class="ms-nav-actions-iconContainer"><img class="button-complete-status' + val.Status + '" draggable="false" alt="Service Quote" src="' + Microsoft.Dynamics.NAV.GetImageResource('Addins/Navigation/img/Action_Completed_32x32.png') + '" role="presentation"/></span></a>' +
                    '<a draggable="false" role="button" aria-disabled="false" href="javascript:return false;" class="easy-start-button" id="control' + parseInt(val.EntryNo) + '"><span class="ms-nav-actions-iconContainer"><img class="button-start-status' + val.Status + '" draggable="false" alt="Service Quote" src="' + Microsoft.Dynamics.NAV.GetImageResource('Addins/Navigation/img/Action_Start_32x32.png') + '" role="presentation"/></span></a>' +
                    on_hold_button +
                    '<a class="ms-nav-actions-label" id="lookup' + parseInt(val.EntryNo) + '"><span class="task-status' + val.Status + '">' + val.SourceId + '</span> ' + travel_element + '<br/><p>' + task_description + '</p></a></li>'
                );
            }
            );
        } else {
            travel_element = '';
            val = json.Tasks.Task;
            if (val.IsIdle == 'True') {
                val.Status = '-disabled';
            }
            if (val.Travel == 'true') {
                travel_element = '<span class="task-travel">[Travel]</span>';
            }
            if (val.EntryNo != '0,0') {
                task_description = val.Description.replace(/{Time}/g, '');
                if (disable_onhold) {
                    on_hold_button = '';
                } else {
                    on_hold_button = '<a draggable="false" role="button" aria-disabled="false" href="javascript:return false;" class="easy-pause-button" id="control' + parseInt(val.EntryNo) + '"><span class="ms-nav-actions-iconContainer"><img class="button-pause-status' + val.Status + '"  draggable="false" alt="Service Quote" src="' + Microsoft.Dynamics.NAV.GetImageResource('Addins/Navigation/img/Action_Pause_32x32.png') + '" role="presentation"/></span></a>';
                }
                $('#' + addinelement + ' ul').append('' +
                    '<li class="navigation-control-task">' +
                    '<a draggable="false" role="button" aria-disabled="false" href="javascript:return false;" class="easy-complete-button" id="control' + parseInt(val.EntryNo) + '"><span class="ms-nav-actions-iconContainer"><img class="button-complete-status' + val.Status + '" draggable="false" alt="Service Quote" src="' + Microsoft.Dynamics.NAV.GetImageResource('Addins/Navigation/img/Action_Completed_32x32.png') + '" role="presentation"/></span></a>' +
                    '<a draggable="false" role="button" aria-disabled="false" href="javascript:return false;" class="easy-start-button" id="control' + parseInt(val.EntryNo) + '"><span class="ms-nav-actions-iconContainer"><img class="button-start-status' + val.Status + '" draggable="false" alt="Service Quote" src="' + Microsoft.Dynamics.NAV.GetImageResource('Addins/Navigation/img/Action_Start_32x32.png') + '" role="presentation"/></span></a>' +
                    on_hold_button +
                    '<a draggable="false" class="ms-nav-actions-label" id="lookup' + parseInt(val.EntryNo) + '"><span class="task-status' + val.Status + '">' + val.SourceId + '</span> ' + travel_element + '<br/><p>' + task_description + '</p></a></li>'
                );
            }
        }

        if (json.Controls.Control.length != undefined) {
            $.each(json.Controls.Control, function (i, val) {
                if (val.Type == 0) {
                    $('#' + addinelement + ' ul').append('<li class="navigation-control-text"><div class="columns-caption-container"><span class="ms-nav-columns-caption icon-RightCaret-after">' + val.Caption + '</span></div></li>');
                }
                if (val.Type == 1) {
                    $('#' + addinelement + ' ul').append('<li class="navigation-control-button"><a draggable="false" role="button" aria-disabled="false" href="javascript:;" class="easy-standard-button" id="control' + val.No + '"><span class="ms-nav-actions-iconContainer"><img draggable="false" alt="Service Quote" src="' + Microsoft.Dynamics.NAV.GetImageResource('Addins/Navigation/img/' + val.Icon) + '" role="presentation"/></span><span class="ms-nav-actions-label"><span>' + val.Caption + '</span><p>' + control_description + '</p></span></a></li>');
                }
            });
        } else {
            val = json.Controls.Control;
            if (val.Type == 0) {
                $('#' + addinelement + ' ul').append('<li class="navigation-control-text"><div class="columns-caption-container"><span class="ms-nav-columns-caption icon-RightCaret-after">' + val.Caption + '</span></div></li>');
            }
            if (val.Type == 1) {
                $('#' + addinelement + ' ul').append('<li class="navigation-control-button"><a draggable="false" role="button" aria-disabled="false" href="javascript:;" class="easy-standard-button" id="control' + val.No + '"><span class="ms-nav-actions-iconContainer"><img draggable="false" alt="Service Quote" src="' + Microsoft.Dynamics.NAV.GetImageResource('Addins/Navigation/img/' + val.Icon) + '" role="presentation"/></span><span class="ms-nav-actions-label"><span>' + val.Caption + '</span><p>' + control_description + '</p></span></a></li>');
            }
        }

    } else {
        alert('No data received from nav service.');
    }

    $('.easy-standard-button').click(function () {
        control_id = $(this).attr('id').substr(7, $(this).attr('id').length);
        togle_element = $(this).children('.ms-nav-actions-iconContainer');
        if (control_id != '') {
            togle_element.addClass('ms-nav-action-item-feedback-ontouch');
            setTimeout(function () {
                togle_element.removeClass('ms-nav-action-item-feedback-ontouch');
                RequestProcessControlCommand(control_id);
            }, 5);
        }
    });

    $('.easy-complete-button').click(function () {
        control_id = $(this).attr('id').substr(7, $(this).attr('id').length);
        togle_element = $(this).children('.ms-nav-actions-iconContainer');
        if (control_id != '') {
            togle_element.addClass('ms-nav-action-item-feedback-ontouch');
            setTimeout(function () {
                togle_element.removeClass('ms-nav-action-item-feedback-ontouch');
                RequestTaskCompleteCommand(control_id);
            }, 5);
        }
    });

    $('.easy-start-button').click(function () {
        control_id = $(this).attr('id').substr(7, $(this).attr('id').length);
        togle_element = $(this).children('.ms-nav-actions-iconContainer');
        if (control_id != '') {
            togle_element.addClass('ms-nav-action-item-feedback-ontouch');
            setTimeout(function () {
                togle_element.removeClass('ms-nav-action-item-feedback-ontouch');
                RequestTaskStartCommand(control_id);
            }, 5);
        }
    });

    $('.easy-pause-button').click(function () {
        control_id = $(this).attr('id').substr(7, $(this).attr('id').length);
        togle_element = $(this).children('.ms-nav-actions-iconContainer');
        if (control_id != '') {
            $(this).children('.ms-nav-actions-iconContainer').addClass('ms-nav-action-item-feedback-ontouch');
            togle_element.addClass('ms-nav-action-item-feedback-ontouch');
            setTimeout(function () {
                togle_element.removeClass('ms-nav-action-item-feedback-ontouch');
                RequestTaskPauseCommand(control_id);
            }, 5);
        }
    });

    $('.easy-worktime-button').click(function () {
        togle_element = $(this).children('.ms-nav-actions-iconContainer');
        $(this).children('.ms-nav-actions-iconContainer').addClass('ms-nav-action-item-feedback-ontouch');
        togle_element.addClass('ms-nav-action-item-feedback-ontouch');
        setTimeout(function () {
            togle_element.removeClass('ms-nav-action-item-feedback-ontouch');
            RequestWorktimeCommand();
        }, 5);
    });


    $('a.ms-nav-actions-label').click(function () {
        entry_no = $(this).attr('id').substr(6, $(this).attr('id').length);
        if (entry_no != '') {
            RequestLookupCommand(entry_no);
        }
    });


    $('.dialog-close', window.parent.document).click(function () {
        clearRefreshProcedure();
        //wait(3000);        
    });



    //console.log('te');


    if (!stop_refresh) {
        clearInterval(refresh_timer);
        refresh_timer = setInterval(function () {
            RequestNavigationData();
        }, refresh_interval);
    }

}


function InitializeApp() {
    resources = [];
    events = [];
    addinelement = 'navigation_element';

    $('#controlAddIn').css("overflow", "auto");
    $('#controlAddIn').append(
        '<div id="' + addinelement + '" class="' + addinelement + '" style="padding:0;margin:0;width:100%;">' +

        '</div>'
    );

    var initialCss =
        '* {box-sizing: border-box; -moz-box-sizing: border-box;-webkit-box-sizing: border-box;}' +
        'body {-webkit-touch-callout:none;-webkit-text-size-adjust:none;-webkit-tap-highlight-color:transparent;-webkit-user-select:none;-ms-user-select:none;user-select:none;-ms-touch-select:none}' +
        'body {font-family: "Segoe UI","Segoe WP",Segoe,device-segoe,Tahoma,Helvetica,Arial,sans-serif;}' +
        'li {display: list-item; text-align: -webkit-match-parent;}' +
        'a:visited {text-decoration: none; color: inherit;}' +
        'a {cursor: pointer;} a {text-decoration: none; color: #0072c6;}' +
        'img {border: 0;} img, iframe {border: currentColor;} img {-webkit-tap-highlight-color: transparent;}' +
        'p {display: block; -webkit-margin-before: 1em; -webkit-margin-after: 1em; -webkit-margin-start: 0px; -webkit-margin-end: 0px;}' +
        '.columns-caption-container {margin-bottom: 0px;}' +
        '.ms-nav-action-feedback-ontouch {transition-duration:.2s;-webkit-transform:scale(.96);transform:scale(.96)}' +
        '.ms-nav-action-item-feedback-ontouch{transition-duration:.4s;background-color:rgba(0,0,0,.2)}' +
        '.ms-nav-action-item-feedback-ontouch img{opacity:.2}' +
        '.ms-nav-columns-caption {font-size: 14pt; color: #888; margin: 0; padding: 0 0 6px; font-family: "Segoe UI","Segoe WP",Segoe,device-segoe,Tahoma,Helvetica,Arial,sans-serif;}' +

        '.ms-nav-actions ul {margin: 0; padding: 0; clear: both; overflow: hidden;}' +
        '.ms-nav-actions ul li {list-style-type: none; white-space: nowrap; min-height: 50px;}' +
        '.ms-nav-actions ul li a {padding: 0; border: 0; margin-top: 14px; margin-bottom: 10px; display: block;}' +
        '.ms-nav-actions-iconContainer {border: 1px solid #111; display: block; float: left; width: 50px; height: 50px;}' +
        '.ms-nav-actions-iconContainer>img:last-child {margin-bottom: 9px;}' +
        '.ms-nav-actions-iconContainer img {width: 32px; height: 32px; margin: 9px 9px 0;}' +
        '.ms-nav-actions-label {display: inline-block; margin: 0 0 0 20px;}' +
        '.ms-nav-actions-label span:first-child {font-size: 12pt; color: #111; vertical-align: top;}' +
        '.ms-nav-actions-label p:last-child {font-size: 10pt; color: #888; margin: 4px 0 0; padding: 0; max-width: 210px; display: block; text-overflow: ellipsis; overflow: hidden; word-wrap: break-word; word-break: break-word; white-space: normal;}' +
        'a.ms-nav-actions-label {max-width: 205px;}' +

        '.ms-nav-action-item-feedback-ontouch {transition-duration:.4s;background-color:rgba(0,0,0,.2)}' +
        '.ms-nav-action-item-feedback-ontouch img{opacity:.2}' +

        '.ms-nav-actions ul li.navigation-control-text {font-size: 14pt; display: block; color: #888; margin: 10px 0 0 0; min-height:20px;}' +

        '.ms-nav-actions ul li.navigation-control-task .ms-nav-actions-label {margin:0;}' + //display: inline-block;
        '.ms-nav-actions ul li.navigation-control-task a.easy-complete-button {display: block; width: 35px;height: 35px; float: right; margin:5px 0 0 3px; padding:0;border:0;}' +
        '.ms-nav-actions ul li.navigation-control-task a.easy-start-button {display: block; width: 35px;height: 35px; float: right; margin:5px 0 0 3px; padding:0;border:0;}' +
        '.ms-nav-actions ul li.navigation-control-task a.easy-pause-button {display: block; width: 35px;height: 35px; float: right; margin:5px 0 0 3px; padding:0;border:0;}' +
        '.ms-nav-actions ul li.navigation-control-task .ms-nav-actions-iconContainer {border: 1px solid #111; display: block;width: 35px;height: 35px;}' +
        '.ms-nav-actions ul li.navigation-control-task .ms-nav-actions-iconContainer img {width: 32px;height: 32px;margin: 1px 1px 0;}' +
        '.ms-nav-actions ul li.navigation-control-task {border-bottom: 1px solid #888;}' +
        '.ms-nav-actions ul li.navigation-control-task p {margin: 0; max-width: 205px;}' +
        '.ms-nav-actions ul li.navigation-control-task .task-status3 {color: #C32121;}' +
        '.ms-nav-actions ul li.navigation-control-task .button-start-status1 {opacity:0.4;}' +
        '.ms-nav-actions ul li.navigation-control-task .button-start-status3 {}' +
        '.ms-nav-actions ul li.navigation-control-task .button-pause-status1 {}' +
        '.ms-nav-actions ul li.navigation-control-task .button-pause-status3 {opacity:0.4;}' +
        '.ms-nav-actions ul li.navigation-control-task .button-pause-status-disabled {opacity:0.4;}' +
        '.ms-nav-actions ul li.navigation-control-task .button-start-status-disabled {opacity:0.4;}' +
        '.ms-nav-actions ul li.navigation-control-task .button-complete-status-disabled {opacity:0.4;}' +
        //'.ms-nav-actions ul li.navigation-control-button {margin-bottom: 5px; clear:both;}' +

        //'.ms-nav-actions ul li.navigation-control-status {margin-bottom: 5px; min-height: 30px; position:relative;}' +
        //'.ms-nav-actions ul li.navigation-control-status a {display: block; width: 35px;height: 35px; margin:0; padding:0;border:0;position:absolute; top:-10px;right:0;}' +
        //'.ms-nav-actions ul li.navigation-control-status .ms-nav-actions-iconContainer {border: 1px solid #111; display: block;width: 35px;height: 35px;}' +
        //'.ms-nav-actions ul li.navigation-control-status .ms-nav-actions-iconContainer img {width: 32px;height: 32px;margin: 1px 1px 0;}' +
        //'.ms-nav-actions ul li.navigation-control-status .ms-nav-actions-iconContainer {border:1px solid black;}' +
        //'.ms-nav-actions ul li.navigation-control-status {border-bottom: 1px solid #888;}' +

        '.ms-nav-actions ul li.navigation-control-status {margin-bottom: 5px; clear:both; border-bottom: 1px solid #888;padding-bottom: 6px;}' +


        '.ms-nav-actions ul li.navigation-control-status .navigation-status-red {color: red;font-size: 1em; margin-right: 35px; display:block; white-space:normal;}' +
        '.ms-nav-actions ul li.navigation-control-status .navigation-status-green {color: green; font-size: 1em; margin-right: 35px; display:block; white-space:normal;}' +
        '.task-travel {color: red;}' +
        ''
        ;

    $('<style>').text(initialCss).appendTo('head');

    if (debugmode) {
        $('#controlAddIn').append('<textarea id="serviceInfoContainer" style="position:absolute;z-index:9999; bottom:0; right:20;"></textarea>');
    }
}

function GetWorktimeCaption(json) {
    dashboard_caption = '';
    if (json.Status.ResourceNo != undefined) {
        dashboard_caption = json.Status.IsWorkingCaption;
    }
    return dashboard_caption;
}

function GetWorktimeDescription(json) {
    dashboard_caption = '';
    if (json.Status.ResourceNo != undefined) {
        if (json.Status.CustomCurrentTimeTxt != '') {
            dashboard_caption = json.Status.ResourceCaption + ' : <span style="color: blue;">' + json.Status.CurrentPeriodCaption + ' ' + json.Status.CustomCurrentTimeTxt + '</span>';
        } else {
            dashboard_caption = json.Status.ResourceCaption + ' : ' + json.Status.CurrentPeriodCaption;
        }
    }
    return dashboard_caption;
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

function UpdateDisableOnHold(json) {
    if (json.Status.DisableOnHold != undefined && json.Status.DisableOnHold == 'Yes') {
        disable_onhold = true;
    }
}


function clearRefreshProcedure() {
    clearInterval(refresh_timer);
    stop_refresh = true;
}

function wait(ms) {
    var start = new Date().getTime();
    var end = start;
    while (end < start + ms) {
        end = new Date().getTime();
    }
}