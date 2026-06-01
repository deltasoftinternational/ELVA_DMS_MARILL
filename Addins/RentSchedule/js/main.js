var version = '1.02';
var debugmode = false;
var addinelement = '';
var resources = [];
var events = [];
var contextmenu_events = '';
var contextmenu_resources = '';
var contextmenu_timeregentry = '';
var context_event_id = '';
var context_section_id = '';
var context_date = new Date();
var start_dt = new Date();
var end_dt = new Date();
var period_type = 'timelineweek';
var start_dt_hour;
var end_dt_hour;
var shown_time_start_hour;
var shown_time_end_hour;
var contextmenu_active = false;
var event_time_step;
var refresh_interval = 4000;
var refresh_timer;
var month_size = 31;
var timeline_day_minutes_step = 5; //5min step
var time_format = '%H:%i';
var weektype = 'workweek';


$(window.frameElement).parent().css("height", "100%");
$(window.frameElement).parent().css("flex", "1 1 auto");

element_workspace = $(window.frameElement).parent();

$(window.frameElement).css("max-height", '');
$(window.frameElement).css("height", $(element_workspace).height() - 10 + "px");


element_workspace.resize(function () {
    $(window.frameElement).css("max-height", '');
    $(window.frameElement).css("height", $(element_workspace).height() - 100 + "px");
    $(window.frameElement).css("height", $(element_workspace).height() - 10 + "px");
});



function RequestScheduleData() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestScheduleData');//, ['']
}
function RequestEventAllocation(allocationType, ResourceId, StartTime, EndTime) {
    clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ProcessAllocation', [allocationType, ResourceId, Date2DecDateTime(StartTime), Date2DecDateTime(EndTime)]);
}
function RequestEventReallocation(EventId, ResourceId, StartTime, EndTime) {
    //move event
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ProcessReallocation', [EventId, ResourceId+'', Date2DecDateTime(StartTime), Date2DecDateTime(EndTime)]);
}
function RequestEventAllocationEdit(EventId, ResourceId, StartTime, EndTime) {
    //Not used    
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ProcessAllocationEdit', [EventId, ResourceId + '', Date2DecDateTime(StartTime), Date2DecDateTime(EndTime)]);
}
function RequestMenuCommand(CommandId, EventId, ResourceId, StartTime, EndTime) {
    clearRefreshProcedure();
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ProcessCommands', [CommandId, EventId, ResourceId + '', Date2DecDateTime(StartTime), Date2DecDateTime(EndTime)]);
}


//function RequestEventPage() {
//    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('RequestScheduleData');//, ['']
//}

//Function to recieve Schedule Data from NAV
function RecieveInitScheduleData(NavScheduleData) {
    stop_refresh = false;
    window.onhashchange = function () {
        clearRefreshProcedure();
    }

    json = $.xml2json(NavScheduleData);

    ResetSchedule();
    FillDebugMode(json);
    FillPeriod(json);
    FillResourcesArray(json);
    FillEventsArray(json);
    FillContextMenuEvents(json);
    FillContextMenuResources(json);
    FillContextMenuTimeRegEntry(json);
    FillMarkedTimespans(json);
    FillTimerInterval(json);
    FillTimeFormat(json);
    AddDebugContainer(NavScheduleData);

    DrawCalendar(addinelement);
    UpdatePeriod();
    xmlDoc = '';
    xml = '';
    events = [];
    resources = [];

    UpdateRefreshInterval(json);
    UpdateStopRefresh(json);

    if (!stop_refresh) {
        clearInterval(refresh_timer);
        refresh_timer = setInterval(function () {
            //console.log('refresh');
            RequestScheduleData();
        }, refresh_interval);
    }

}

//Function to recieve Schedule Data from NAV
function RecieveRefreshScheduleData(NavScheduleData) {

    json = $.xml2json(NavScheduleData);

    ResetSchedule();
    FillDebugMode(json);
    FillPeriod(json);
    UpdatePeriod();
    FillResourcesArray(json);
    FillEventsArray(json);
    FillContextMenuEvents(json);
    FillContextMenuResources(json);
    FillMarkedTimespans(json);
    FillTimerInterval(json);
    FillTimeFormat(json);
    AddDebugContainer(NavScheduleData);
    
    scheduler.clearAll();
    scheduler.parse(events, "json");
    scheduler.updateView(start_dt, period_type);

    ////scheduler.updateView(start_datetime, "timelineday");
    ////scheduler.updateView(start_datetime, "timelinemonth");
    
    scheduler.updateCollection(period_type + "_sections", resources);
    scheduler.updateCollection(period_type + "_sections", resources);
    scheduler.updateCollection(period_type + "_sections", resources);
    //alert(period_type);

    xmlDoc = '';
    xml = '';
    events = [];
    resources = [];


    
    $('.dialog-close', window.parent.document).click(function () {
        clearRefreshProcedure();       
    });

    UpdateRefreshInterval(json);
    UpdateStopRefresh(json);

    if (!stop_refresh) {
        clearInterval(refresh_timer);
        refresh_timer = setInterval(function () {
            //console.log('refresh');
            RequestScheduleData();
        }, refresh_interval);
    }
    
}



function InitializeApp() { 
	calendarElement = 'scheduler_element';
    resources = [];
    events = [];
    addinelement = calendarElement;    

    $('#controlAddIn').css("overflow", "auto");
    $('#controlAddIn').append(
        '<div id="scheduler_element" class="dhx_cal_container" style="width:100%; height:100%;">' +
            '<div class="dhx_cal_navline">' +
                //'<div class="dhx_cal_prev_button">&nbsp;</div>' +
                //'<div class="dhx_cal_next_button">&nbsp;</div>' +
                //'<div class="dhx_cal_today_button"></div>' +
                '<div class="dhx_cal_date"></div>' +
                //'<div class="dhx_cal_tab" name="day_tab" style="right:204px;"></div>' +
                //'<div class="dhx_cal_tab" name="week_tab" style="right:140px;"></div>' +
                //'<div class="dhx_cal_tab" name="month_tab" style="right:76px;"></div>' +
                //'<div class="dhx_cal_tab timelineday_tab" name="timelineday_tab" style=""></div>' + //right:76px;
                //'<div class="dhx_cal_tab timelineweek_tab" name="timelineweek_tab" style=""></div>' + //left:280px;
                //'<div class="dhx_cal_tab timelinemonth_tab" name="timelinemonth_tab" style=""></div>' + //left:280px;
            '</div>' +
            '<div class="dhx_cal_header">' +
            '</div>' +
            '<div class="dhx_cal_data">' +
            '</div>' +
        '</div>'        
    );
    $('#controlAddIn').parent().append(
        '<div id="ajax-loader" style="visibility:hidden;"><img src="' + Microsoft.Dynamics.NAV.GetImageResource('i.png') + '"/><span>Please wait...</span></div>'
    );


    /*
    .dhx_cal_event:hover .dhx_footer {
        background: url(imgs_flat/resizing.png) no-repeat center center;
    }
    .dhx_cal_event_line:hover div {
        background: url(imgs_flat/resize_dots.png) repeat-y;
    }
    */
    
    var initialCss =
        '.dhx_cal_prev_button {background:url("' + Microsoft.Dynamics.NAV.GetImageResource('arrow_left.png') + '") no-repeat center center; }' +
        '.dhx_cal_next_button {background:url("' + Microsoft.Dynamics.NAV.GetImageResource('arrow_right.png') + '") no-repeat center center; }' +
        '.dhx_cal_event .dhx_footer:hover {background:url("' + Microsoft.Dynamics.NAV.GetImageResource('resizing.png') + '") no-repeat center center; }' +
        '.dhx_cal_event:hover .dhx_footer {background:url("' + Microsoft.Dynamics.NAV.GetImageResource('resizing.png') + '") no-repeat center center; }' +
        '.div.dhx_menu_head, div.dhx_menu_icon {background-image:url("' + Microsoft.Dynamics.NAV.GetImageResource('controls.png') + '"); }' +
        'div.sub_item_text {font-size: 1em !important;}' +
        //'.dhx_cal_event_line .dhx_event_resize:hover {background:url("' + Microsoft.Dynamics.NAV.GetImageResource('resize_dots.png') + '") repeat-y;}' +
        //'.dhx_cal_event_line:hover .dhx_event_resize {background:url("' + Microsoft.Dynamics.NAV.GetImageResource('resize_dots.png') + '") repeat-y;}' +
        '.dhx_cal_event_line .dhx_event_resize_start {background-color: black; opacity:0.3;width: 7px;}' +
        //'.dhx_cal_event_line .dhx_event_resize_end {background-color: none; width: 7px;}' +
        '.dhx_cal_event_line {border:none; font-size: 8pt;opacity:0.8;}' +
        '.dhx_cal_date {display:none;}' +
        '.dhx_cal_event_line {-webkit-border-radius: 0px;-moz-border-radius: 0px;border-radius: 0px;}' +
        '.timeline-resource-cell {font-size: 1em; font-family: "Segoe UI","Segoe",Tahoma,Helvetica,Arial,sans-serif;}' +
        //'.dhx_scale_bar_one {text-align:left; font-size: 1.3em !important;}' +
        //'.dhx_scale_bar {font-size: 9pt; font-family: "Segoe UI","Segoe",Tahoma,Helvetica,Arial,sans-serif;}' +
        '.yellow_section {background-color: #E2E2E2;}' +
		'.time_reg_section {'+
            'background-image: -webkit-repeating-linear-gradient(135deg, rgba(0,0,0,.1), rgba(0,0,0,.1) 1px, transparent 2px, transparent 2px, rgba(0,0,0,.1) 3px);'+
            'background-image: -moz-repeating-linear-gradient(135deg, rgba(0,0,0,.1), rgba(0,0,0,.1) 1px, transparent 2px, transparent 2px, rgba(0,0,0,.1) 3px);'+
            'background-image: -o-repeating-linear-gradient(135deg, rgba(0,0,0,.1), rgba(0,0,0,.1) 1px, transparent 2px, transparent 2px, rgba(0,0,0,.1) 3px);'+
            'background-image: repeating-linear-gradient(135deg, rgba(0,0,0,.1), rgba(0,0,0,.1) 1px, transparent 2px, transparent 2px, rgba(0,0,0,.1) 3px);'+
            '-webkit-background-size: 4px 4px;'+
            '-moz-background-size: 4px 4px;'+
            'background-size: 4px 4px;}' +
        '.dhx_tooltip_header {text-align:center; font-weight:bold}' +
        '.dhtmlXTooltip {font-size:0.8em !important;}' +
        '.timelineday_tab {left:0px !important;}' +
        '.timelineweek_tab {left:80px !important;}' +
        '.timelinemonth_tab {left:160px !important;}' +
        '.yellow_cell {background-color: #F0F0F0;}' +
        //'.dhx_scale_bar_one .sup {vertical-align: top; font-size: .59em;position:relative; top:-4px;left:-2px;font-family:Verdana !important; font-weight:normal;}' +
        'html, body{margin:0;padding:0;height:100%;overflow:hidden;}'+
        '#ajax-loader {position:absolute; z-index:9999999;background-color:white; padding:20px; border:1px solid #ababab;top:160px; left:50%;margin-left: -80px;color:#262626;}' +
        '#ajax-loader img {vertical-align:middle;margin:-3px 20px 0 0;}'+
        '#version {position:absolute; top:13px; left:25px; color: #CC0000; font-size:9pt; font-family: "Segoe UI","Segoe",Tahoma,Helvetica,Arial,sans-serif;}'+
        '#scheduler_element td {padding: 0; margin: 0;}';


    if (isIE()) {
        initialCss = initialCss + '.dhx_cal_event .dhx_body, .dhx_cal_select_menu.dhx_cal_event .dhx_body {padding:0px;} ' +
            'div.dhx_menu_icon {margin-left:0px;}';
    }

    $('<style>').text(initialCss).appendTo('head');


  


    /*
    $('#controlAddIn').append('<button id="callRequestMethod" style="position:absolute;z-index:9999; bottom:0; right:200px;">Refresh Schedule Data</button>');
    $('#callRequestMethod').click(function () {
        RequestScheduleData();
    });
    */

}

function DrawCalendar(calendarElement) {

    //Params
    //var control_date = new Date(2013, 5, 11);
    var control_date = start_dt;
    var format = scheduler.date.date_to_str(GetTimeFormat());
    var format_tooltip_time = scheduler.date.date_to_str("%d.%m.%Y " + GetTimeFormat());
    //var sections = resources;

    var timelineweek_config = {
        name: "timelineweek",
        x_unit: "hour",
        x_date: GetTimeFormat(),
        x_step: 2,
        x_size: 84,
        x_length: 168,
        y_unit: scheduler.serverList("timelineweek_sections", resources),
        y_property: "section_id",
        render: "bar",
        dx: 100,
        dy: 44,
        section_autoheight: false,
        second_scale: {
            x_unit: "day",
            x_date: "%F %d"
        }
    }

    var timelineworkweek_config = {
        name: "timelineworkweek",
        x_unit: "hour",
        x_date: GetTimeFormat(),
        x_step: 2,
        x_size: 60,
        x_length: 168,
        y_unit: scheduler.serverList("timelineweek_sections", resources),
        y_property: "section_id",
        render: "bar",
        dx: 100,
        dy: 44,
        section_autoheight: false,
        second_scale: {
            x_unit: "day",
            x_date: "%F %d"
        }
    }


    if (timeline_day_minutes_step == '0' || timeline_day_minutes_step == undefined) {
        var timelineday_config = {
            name: "timelineday",
            x_unit: "hour",
            x_date: GetTimeFormat(),
            x_step: 1,
            x_size: 24,
            x_length: 24,
            y_unit: scheduler.serverList("timelineday_sections", resources),
            y_property: "section_id",
            render: "bar",
            dx: 100,
            dy: 44,
            section_autoheight: false,
            second_scale: {
                x_unit: "day",
                x_date: "%F %d"
            }
        }
    } else {        
        var timelineday_config = {
            name: "timelineday",
            x_unit: "minute",
            x_date: '%i',//GetTimeFormat()
            x_step: timeline_day_minutes_step,
            x_size: 1440 / timeline_day_minutes_step,
            x_length: 1440 / timeline_day_minutes_step,
            y_unit: scheduler.serverList("timelineday_sections", resources),
            y_property: "section_id",
            render: "bar",
            dx: 100,
            dy: 44,
            section_autoheight: false,
            second_scale: {
                x_unit: "hour",
                x_date: GetTimeFormat()
            }
        }
    }

    var timelinemonth_config = {
        name: "timelinemonth",
        x_unit: "day",
        x_date: "%d",
        x_step: 1,
        x_size: month_size,
        //x_length: 24,
        y_unit: scheduler.serverList("timelinemonth_sections", resources),
        y_property: "section_id",
        render: "bar",
        dx: 100,
        dy: 44,
        section_autoheight: false,
        second_scale: {
            x_unit: "week",
            x_date: "Week %W"
        }
    }


    //Config
    scheduler.templates.tooltip_date_format = scheduler.date.date_to_str("%d.%m.%Y " + GetTimeFormat());
    scheduler.locale.labels.timelineweek_tab = "Week";
    scheduler.locale.labels.timelineday_tab = "Day";
    scheduler.locale.labels.timelinemonth_tab = "Month";
    scheduler.locale.labels.section_custom = "Section";
    //scheduler.xy.scale_height = "5px";
    scheduler.xy.nav_height = 0;
    scheduler.xy.bar_height = 45;
    scheduler.config.time_step = event_time_step;
    //scheduler.config.details_on_create = true;
    //scheduler.config.details_on_dblclick = true;

    //scheduler.config.details_on_dblclick = false;
    //scheduler.config.details_on_create = false;
    //scheduler.config.dblclick_create = false;

    scheduler.config.xml_date = "%Y-%m-%d %H:%i";
    //scheduler.config.lightbox.sections = [
    //    { name: "description", height: 130, map_to: "text", type: "textarea", focus: true },
    //    { name: "custom", height: 23, type: "select", options: resources, map_to: "section_id" },
    //    { name: "time", height: 72, type: "time", map_to: "auto" }
    //];
    //scheduler.config.hour_size_px = (60 / 15) * 22;

    
    scheduler.createTimelineView(timelineday_config);
    scheduler.createTimelineView(timelineweek_config);
    scheduler.createTimelineView(timelineworkweek_config);
    scheduler.createTimelineView(timelinemonth_config);

    //Advanced Config


    //scheduler.date.add_workweek = function (date, inc) {
    //    return scheduler.date.add(date, inc, "day");
    //}
    
    scheduler.showLightbox = function (id) {//Switch off details window
        var ev = scheduler.getEvent(id);
        scheduler.startLightbox(id);
        scheduler.endLightbox(true);
    };
    
    /*
    scheduler.addMarkedTimespan({
        start_date: new Date(2014, 8, 22, 10, 30),
        end_date: new Date(2014, 8, 22, 12, 00),
        css: "time_reg_section ",
        sections: {timelineday:'R0010'}
    });
    */



    //scheduler.addMarkedTimespan({ start_date: new Date(2013, 5, 14, 15, 00), end_date: new Date(2013, 5, 14, 18, 00), css: "yellow_section" });
    /*
    scheduler.addMarkedTimespan({
        days: "fullweek",
        zones: [shown_time_start_hour * 60, shown_time_end_hour * 60],        
        invert_zones: true,
        css: "yellow_section"
    });
    */
    /*scheduler.addMarkedTimespan({ start_date: new Date(2013, 5, 12, 18, 00), end_date: new Date(2013, 5, 13, 9, 00), css: "yellow_section" });
    scheduler.addMarkedTimespan({ start_date: new Date(2013, 5, 13, 18, 00), end_date: new Date(2013, 5, 14, 9, 00), css: "yellow_section" });
    scheduler.addMarkedTimespan({ start_date: new Date(2013, 5, 14, 18, 00), end_date: new Date(2013, 5, 15, 9, 00), css: "yellow_section" });
    scheduler.addMarkedTimespan({ start_date: new Date(2013, 5, 15, 18, 00), end_date: new Date(2013, 5, 16, 9, 00), css: "yellow_section" });
    */

    /*
    scheduler.date.timelineday_start = function (date) {
        return scheduler.date.timeline_start(date);//
    }
    scheduler.date.get_timelineday_end = function (start_date) {
        return scheduler.date.add(start_date, 5, "day");
    }
    scheduler.date.add_timelineday = function (date, inc) {
        return scheduler.date.add(date, inc * 7, "day");
    }
    */
    //Templates

    //scheduler.templates.timelineday_date = scheduler.templates.timeline_date;
    //scheduler.templates.timelineday_scale_date = scheduler.templates.timeline_scale_date;

    scheduler.templates.event_bar_text = function (sd, ed, ev) {
        var event_text = ev.text.replace(/{Time}/g,format(sd) + ' - ' + format(ed)+' ');
        return event_text;
    }
    scheduler.templates.event_class = function (start, end, event) {
        if (start < control_date) // event start before control date
            return "past_event";
        if (event.subject) // if event has subject property then special class should be assigned
            return "event_" + event.subject;
        return "";
    };
    
    scheduler.templates.tooltip_text = function (start, end, event) {
        var event_text = event.text.replace(/{Time}/g, '');
        if (end.getFullYear() == 9999) {
            return '<div class="dhx_tooltip_header">' + event.section_id + "</div>" + event_text + "<br/><b>From:</b> " + format_tooltip_time(start);
        } else {
            return '<div class="dhx_tooltip_header">' + event.section_id + "</div>" + event_text + "<br/><b>From:</b> " + format_tooltip_time(start) + "<br/><b>To:</b> " + format_tooltip_time(end);
        }
    };
    

    scheduler.templates.timelineday_scalex_class = function () {
        return 'dhx_scale_bar_one';
    }
    scheduler.templates.timelineday_second_scalex_class = function () {
        return 'dhx_scale_bar_two';
    }
    scheduler.templates.timelineweek_scalex_class = function () {
        return 'dhx_scale_bar_one';
    }
    scheduler.templates.timelineweek_second_scalex_class = function () {
        return 'dhx_scale_bar_two';
    }
    scheduler.templates.timelinemonth_scalex_class = function () {
        return 'dhx_scale_bar_one';
    }
    scheduler.templates.timelinemonth_second_scalex_class = function () {
        return 'dhx_scale_bar_two';
    }

    /*
    scheduler.templates.timelineday_scale_date = function (date) {
        var func = scheduler.date.date_to_str(timelineday_config.x_date);
        return func(date);
    }
    */


    scheduler.templates.timelineday_scale_label = function (key, label, section) {
        return '<span style="color:' + section.textColor + '">' + label + '</span>';
    };
    scheduler.templates.timelineday_scaley_class = function (key, label, section) {
        return "timeline-resource-cell";
    };

    scheduler.templates.timelineweek_scale_label = function (key, label, section) {
        return '<span style="color:' + section.textColor + '">' + label + '</span>';
    };
    scheduler.templates.timelineweek_scaley_class = function (key, label, section) {
        return "timeline-resource-cell";
    };

    scheduler.templates.timelinemonth_scale_label = function (key, label, section) {
        return '<span style="color:' + section.textColor + '">' + label + '</span>';
    };
    scheduler.templates.timelinemonth_scaley_class = function (key, label, section) {
        return "timeline-resource-cell";
    };

    scheduler.templates.timelinemonth_cell_class = function (evs, x, y) {
        var day = x.getDay();
        return (day == 0 || day == 6) ? "yellow_cell" : "white_cell";
    };
    scheduler.templates.timelinemonth_scalex_class = function (date) {
        if (date.getDay() == 0 || date.getDay() == 6) return "yellow_cell";
        return "";
    }
    scheduler.templates.timelineweek_cell_class = function (evs, x, y) {
        var day = x.getDay();
        return (day == 0 || day == 6) ? "yellow_cell" : "white_cell";
    };
    scheduler.templates.timelineweek_scalex_class = function (date) {
        if (date.getDay() == 0 || date.getDay() == 6) return "yellow_cell dhx_scale_bar_one";
        return "dhx_scale_bar_one";
    }

    scheduler.ignore_timelineday = function (date) {        
        if (date.getHours() < start_dt_hour || (date.getHours() > end_dt_hour )) return true; //&& date.getMinutes()>=1
    };
    scheduler.ignore_timelineweek = function (date) {
        if (date.getHours() < start_dt_hour || (date.getHours() > end_dt_hour)) return true; //&& date.getMinutes() >= 1
    };
    //scheduler.ignore_timelinemonth = function (date) {
    //    if (date.getHours() < start_worktime_hour || date.getHours() > end_worktime_hour) return true;
    //};

    scheduler.dhtmlXTooltip.config.delta_x = 100;



    /*
    scheduler.attachEvent("onDblClick", function (id, e) {
        ev = scheduler.getEvent(id);
        if (ev.editable != 'false') {
            if (ev.type == 'AllocationEntry') {
                alert('te1');
                //alert('click');
                //clear timer for auto refresh  
                clearInterval(current_timer);
                RequestEventReallocation(id, ev.section_id, ev.start_date, ev.end_date);
            }
            alert('te3');
        } else {
            alert('te2');
            RequestScheduleData();
        }
        alert('te4');
        return true;
    });
    */


    //Init and data load
    scheduler.init(calendarElement, control_date, period_type);
    scheduler.parse(events, "json");

    //Events
    AttachEvents();

}    
   

function AttachEvents() {

    //---------------------//
    //   SCHEDULE EVENTS   //
    //---------------------//

    
    //scheduler.attachEvent("onBeforeViewChange", function (old_mode, old_date, mode, date) {
    //    if (mode == 'my') {
    //        scheduler.createTimelineView(timeline_day_config);            
    //        scheduler.templates.my_scale_label = function (key, label, section) {
    //            return '<span style="color:' + section.textColor + '">' + label + '</span>';
    //        };
    //        scheduler.templates.my_scaley_class = function (key, label, section) {
    //            return "timeline-resource-cell";
    //        };
            
    //    }

    //    return true;
    //});
    

    scheduler.attachEvent("onOptionsLoadStart", function () {
        $('#ajax-loader').css("visibility", "visible");
    });
    scheduler.attachEvent("onOptionsLoadFinal", function () {
        $('#ajax-loader').css("visibility", "hidden");
    });

    scheduler.attachEvent("onEventAdded", function (id, ev) {
        if (ev.editable != 'false') {
            //clear timer for auto refresh  
            clearRefreshProcedure();
            if (ev) {
                if (ev.end_date != 'Invalid Date') {
                    RequestMenuCommand(1210, 0, ev.section_id, ev.start_date, ev.end_date);
                }
            }
            scheduler.deleteEvent(id);
        }
    });

    scheduler.attachEvent("onDblClick", function (id, ev) {
        return false;
    });

    
    
    scheduler.attachEvent("onEventChanged", function (id, ev) {        
        if (ev.editable != 'false') {
            if (ev.type == 'AllocationEntry') {
                //clear timer for auto refresh  
                clearRefreshProcedure();
                RequestEventReallocation(id, ev.section_id, ev.start_date, ev.end_date);
            }
        } else {
            RequestScheduleData();
        }        
    });
    

    // Hangs system (probably the same when adding event backwards)
    //scheduler.attachEvent("onClick", function (id, ev) {
    //    if (ev.editable != 'false') {
    //        //clear timer for auto refresh  
    //        clearInterval(current_timer);
    //        RequestEventReallocation(id, ev.section_id, ev.start_date, ev.end_date);
    //    }
    //});
    
    
    //scheduler.attachEvent("onClick", function (id, e) {        
    //    ev = scheduler.getEvent(id);
    //    if (ev.editable != 'false') {
    //        if (ev.type == 'AllocationEntry') {
    //            //clear timer for auto refresh  
    //            clearInterval(current_timer);
    //            RequestEventReallocation(id, ev.section_id, ev.start_date, ev.end_date);
    //        }
    //    } else {         
    //        RequestScheduleData();
    //    }
    //    return false;        
    //});
    

    
    
    //scheduler.attachEvent("onBeforeDrag", function () {
    //    alert('te6');
    //        //clear timer for auto refresh  
    //        clearInterval(current_timer);
    //        return true;
    //});
    


    //---------------------//
    //    TOOLTIP EVENTS   //
    //---------------------//




    scheduler.attachEvent("onBeforeTooltip", function () {
        if (contextmenu_active)
            return false;
        //clear timer for auto refresh  
        //clearRefreshProcedure();
        return true;
    });

    //---------------------//
    // CONTEXT MENU EVENTS //
    //---------------------//
    //Context menu    
    var menu = new dhtmlXMenuObject();
    //menu.setIconsPath("./data/imgs/");
    menu.renderAsContextMenu();
    //menu.loadStruct(contextmenu_events, function () { });

    
    scheduler.attachEvent("onContextMenu", function (event_id, native_event_object) {

            //clear timer for auto refresh  
            clearRefreshProcedure();

            context_event_id = '';
            context_section_id = '';
            context_date = scheduler.getState().date;

            $('.dhtmlXTooltip').css("visibility", "hidden");

            if (scheduler._locate_cell_timeline(native_event_object)) {
                //resources
                var section = scheduler.matrix.timelineday.y_unit[scheduler._locate_cell_timeline(native_event_object).y];
                context_section_id = section.key;

                var pos = scheduler._mouse_coords(native_event_object);
                var clicktimestamp = scheduler._min_date.valueOf() + (pos.y * scheduler.config.time_step + (scheduler._table_view ? 0 : pos.x) * 24 * 60) * 60000;
                context_date = new Date(clicktimestamp);

                //events
                if (event_id) {
                    if (scheduler.getEvent(event_id).editable != 'false') {
                        context_event_id = event_id;
                        //alert('Context Menu on Event. Event Id: ' + event_id);
                        var posx = 0;
                        var posy = 0;
                        if (native_event_object.pageX || native_event_object.pageY) {
                            posx = native_event_object.pageX;
                            posy = native_event_object.pageY;
                        } else if (native_event_object.clientX || native_event_object.clientY) {
                            posx = native_event_object.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
                            posy = native_event_object.clientY + document.body.scrollTop + document.documentElement.scrollTop;
                        }
                        menu.clearAll();
                        if (scheduler.getEvent(event_id).type == 'AllocationEntry') {
                            menu.loadStruct(contextmenu_events, function () {
                                contextmenu_active = true;
                                menu.showContextMenu(posx, posy);
                            });
                        }
                        if (scheduler.getEvent(event_id).type == 'TimeRegEntry') {
                            menu.loadStruct(contextmenu_timeregentry, function () {
                                contextmenu_active = true;
                                menu.showContextMenu(posx, posy);
                            });
                        }
                    }   
                    return false;
                } else {
                    //var section = scheduler.matrix.timeline;//[scheduler._locate_cell_timeline(native_event_object).y]
                    var posx = 0;
                    var posy = 0;
                    if (native_event_object.pageX || native_event_object.pageY) {
                        posx = native_event_object.pageX;
                        posy = native_event_object.pageY;
                    } else if (native_event_object.clientX || native_event_object.clientY) {
                        posx = native_event_object.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
                        posy = native_event_object.clientY + document.body.scrollTop + document.documentElement.scrollTop;
                    }
                    menu.clearAll();
                    if (contextmenu_resources.length > 0) {
                        menu.loadStruct(contextmenu_resources, function () {
                            contextmenu_active = true;
                            menu.showContextMenu(posx, posy);
                        });
                    }
                    return false;
                }
            } else {
                //
            }
            return true;
        
    });
    
    menu.attachEvent("onClick", function (id, zoneId, cas) {
        //clear timer for auto refresh  
        clearRefreshProcedure();

        ev = null;
        ev = scheduler.getEvent(context_event_id);

        if (ev) {
            if (ev.type == 'AllocationEntry') {
                RequestMenuCommand(id, context_event_id, context_section_id, ev.start_date, ev.end_date);
            }
            if (ev.type == 'TimeRegEntry') {
                RequestMenuCommand(id, ev.AllocationEntryNo, context_section_id, ev.start_date, ev.end_date);
            }
        } else {
            RequestMenuCommand(id, 0, context_section_id, context_date, new Date(context_date.getTime() + (1*60000)));
        }
        
    });
    

}

function FillContextMenuTimeRegEntry(json) {    
    contextmenu_timeregentry = '';
    var root = $('<root />');
    root.append('<menu />');
    menu = $('menu', root);
    menu.append('<item id="1020" text="Lookup"/>');
    contextmenu_timeregentry = root.html();
}

function FillContextMenuEvents(json) {
    contextmenu_events = '';
    var root = $('<root />');
    root.append('<menu />');    
    menu = $('menu', root);

    $.each(json.ScheduleCaptions.ScheduleCaption, function (i, val) {
        if (val.GroupingCode == 'ALLOC') {
            menu_item_id = val.ID;
            menu_item_caption = val.Caption;
            if (menu_item_id < 10000) {//should be asked
                menu.append('<item id="' + menu_item_id + '" text="' + menu_item_caption + '"/>');
            }
        }
    });
    contextmenu_events = root.html();

    /*
    xml.find("ScheduleCaptions ScheduleCaption").each(function () {//
        grouping_code = $(this).find('GroupingCode').text();
        if (grouping_code == 'ALLOC') {
            menu_item_id = $(this).find('ID').text();
            menu_item_caption = $(this).find('Caption').text();
            if (menu_item_id < 10000) {//should be asked
                menu.append('<item id="' + menu_item_id + '" text="' + menu_item_caption + '"/>');
            }
        }
    });
    */
}

function FillContextMenuResources(json) {
    contextmenu_resources = '';
    contextmenu_item_count = 0;
    var root = $('<root />');
    root.append('<menu />');
    menu = $('menu', root);

    $.each(json.ScheduleCaptions.ScheduleCaption, function (i, val) {
        if (val.GroupingCode == 'ITEM' || val.GroupingCode == 'ENABLED') {
            menu_item_id = val.ID;
            menu_item_caption = val.Caption;
            if (menu_item_id < 10000) {//should be asked
                menu.append('<item id="' + menu_item_id + '" text="' + menu_item_caption + '"/>');
                contextmenu_item_count += 1;
            }
        }
    });
    if (contextmenu_item_count>0){
        contextmenu_resources = root.html();
    }
    

    /*
    xml.find("ScheduleCaptions ScheduleCaption").each(function () {//
        grouping_code = $(this).find('GroupingCode').text();
        if (grouping_code == 'ITEM' || grouping_code == 'ENABLED') {
            menu_item_id = $(this).find('ID').text();
            menu_item_caption = $(this).find('Caption').text();
            if (menu_item_id < 10000) {//should be asked
                menu.append('<item id="' + menu_item_id + '" text="' + menu_item_caption + '"/>');
            }
        }
    });
    */

}

function FillDebugMode(json) {
    //debugmode = false;
    if (json.DebugMode != undefined) {
        if (json.DebugMode == 'Yes') {
            debugmode = true;
        }
    }
}

function FillTimeFormat(json) {
    time_format = json.TimeFormat;
}

function FillTimerInterval(json) {
    timer_interval = json.TimerInterval;
}

function FillPeriod(json) {
    
    var start_dt_decimal = json.StartDT;
    var end_dt_decimal = json.EndDT;
    var shown_time_start_dec = json.ShownTimeStart;
    var shown_time_end_dec = json.ShownTimeEnd;

    if (json.WeekType != undefined && json.WeekType != '') {
        weektype = json.WeekType;
    }

    event_time_step = json.TimeStep;
    timeline_day_minutes_step = json.TimeLineDayMinutesStep;

    start_dt = DecDateTime2Date(start_dt_decimal);
    end_dt = DecDateTime2Date(end_dt_decimal);

    //Calculate start and end hours
    shown_time_start_hour = DecHours2Hours(shown_time_start_dec);
    shown_time_end_hour = DecHours2Hours(shown_time_end_dec) + 1;

    start_dt_hour = start_dt.getHours();
    end_dt_hour = end_dt.getHours() + 1;
    

    one_day = 24*60*60*1000; 
    day_count = Math.round(Math.abs((end_dt.getTime() - start_dt.getTime()) / (one_day)));

    switch (day_count) {
        case 0:
            period_type = "timelineday";
            break;
        case 1:
            period_type = "timelineday";
            break;
        case 6:
            if (weektype == 'week') {
                period_type = "timelineweek";
            } else {
                period_type = "timelineworkweek";
            }
            break;
        case 7:
            if (weektype == 'week') {
                period_type = "timelineweek";
            } else {
                period_type = "timelineworkweek";
            }
            break;
        case 27:
            period_type = "timelinemonth";
            month_size = day_count+1;
            break;
        case 28:
            period_type = "timelinemonth";
            month_size = day_count+1;
            break;
        case 29:
            period_type = "timelinemonth";
            month_size = day_count+1;
            break;
        case 30:
            period_type = "timelinemonth";
            month_size = day_count + 1;
            break;
        case 31:
            period_type = "timelinemonth";
            month_size = day_count+1;
            break;
    }
    

    //period_type = "timelineweek";//temp
    //alert('start_dt: ' + start_dt + ' end: ' + end_dt + ' start_dt_hour: ' + start_dt_hour + ' end_dt_hour: ' + end_dt_hour + ' shown_time_start_hour:' + shown_time_start_hour + ' shown_time_end_hour:' + shown_time_end_hour + ' day_count: ' + day_count + ' period:' + period_type);
    
    
}

function UpdatePeriod() {
    scheduler.matrix.timelinemonth.x_size = month_size;
}

function FillResourcesArray(json) {
    resources = [];
    if (json.Items.Item.length != undefined) {
        $.each(json.Items.Item, function (i, val) {
            resources.push({
                "key": val.ItemNo,
                "label": val.Description,
                "color": XmlColorConvert(val.ForeColor),
                "textColor": XmlColorConvert(val.ForeColor)
            });
        });
    } else {
        val = json.Items.Item;
        resources.push({
            "key": val.ItemNo,
            "label": val.Description,
            "color": XmlColorConvert(val.ForeColor),
            "textColor": XmlColorConvert(val.ForeColor)
        });
    }

    /*
    xml.find("Items Item").each(function () {
        resources.push({
            "key": $(this).find('ItemNo').text(),
            "label": $(this).find('Description').text(),
            "color": XmlColorConvert($(this).find('ForeColor')),
            "textColor": XmlColorConvert($(this).find('ForeColor'))
        });
    });
    */
}

function FillMarkedTimespans(json){    
    if (json.Allocations.Allocation.length != undefined) {
        $.each(json.Allocations.Allocation, function (i, val) {
            if (val.GroupingCode == 'DISABLED') {
                scheduler.addMarkedTimespan({
                    //days: "fullweek",
                    //zones: [shown_time_start_hour * 60, shown_time_end_hour * 60],        
                    //invert_zones: true,
                    start_date: DecDateTime2Date(val.StartDT),
                    end_date: DecDateTime2Date(val.EndDT),
                    css: "yellow_section",
                    type:  "noblock", 
                    sections: { timelineday: val.ItemNo,timelineweek: val.ItemNo,timelinemonth: val.ItemNo} 
                });                
            }
        });
    } else {
        val = json.Allocations.Allocation;
        if (val.GroupingCode == 'DISABLED') {
            scheduler.addMarkedTimespan({
                //days: "fullweek",
                //zones: [shown_time_start_hour * 60, shown_time_end_hour * 60],        
                //invert_zones: true,
                start_date: DecDateTime2Date(val.StartDT),
                end_date: DecDateTime2Date(val.EndDT),
                css: "yellow_section",
                type:  "noblock", 
                sections: { timelineday: val.ItemNo,timelineweek: val.ItemNo,timelinemonth: val.ItemNo} 
            });
        }
    }
}

function FillTimeRegEntries(json) {
    var time_start;
    var time_end;
    if (json.TimeRegEntries != undefined && json.TimeRegEntries.TimeRegEntry != undefined && json.TimeRegEntries.TimeRegEntry.length != undefined) {
        $.each(json.TimeRegEntries.TimeRegEntry, function (i, val) {
            if (val.EntryType == '1' && json.TimeRegEntries.TimeRegEntry[i + 1] != undefined) { //In process
                if (json.TimeRegEntries.TimeRegEntry[i + 1].EntryType != '1') {   
                    /*
                    time_start = DBDate2JDate(val.Date + ' ' + val.Time);
                    time_end = DBDate2JDate(json.TimeRegEntries.TimeRegEntry[i + 1].Date + ' ' + json.TimeRegEntries.TimeRegEntry[i + 1].Time);
                    scheduler.addMarkedTimespan({
                        start_date: time_start,
                        end_date: time_end,
                        css: "time_reg_section ",
                        sections: { timelineday: val.ItemID, timelineweek: val.ItemID, timelinemonth: val.ItemID }
                    });
                    */
                    //alert(time_start + ' ' + time_end);
                    time_start = DBDate2JDate(val.Date + ' ' + val.Time);
                    time_end = DBDate2JDate(json.TimeRegEntries.TimeRegEntry[i + 1].Date + ' ' + json.TimeRegEntries.TimeRegEntry[i + 1].Time);
                    events.push({
                        "id": val.EntryNo,
                        "text": 'Worked:'+json.Description,
                        "start_date": time_start,
                        "end_date": time_end,
                        "section_id": val.ItemID,
                        "color": '#fff',
                        "textColor": '#8c8c8c',
                        'editable': 'true',
                        'type': 'TimeRegEntry',
                        'AllocationEntryNo': val.AllocationEntryNo
                    });
                }
            }            
        });
    }
    
    
    //}
    /*if (json.TimeRegEntries.length != undefined) {
        if (json.TimeRegEntries.TimeRegEntry.length != undefined) {
            $.each(json.TimeRegEntries.TimeRegEntry, function (i, val) {
                alert(val.EntryType);
            });
        }
    }*/
            //resources = [];
                /*
                $.each(json.Items.Item, function (i, val) {
                    resources.push({
                        "key": val.ItemNo,
                        "label": val.Description,
                        "color": XmlColorConvert(val.ForeColor),
                        "textColor": XmlColorConvert(val.ForeColor)
                    });
                });
                */
            /*
            if (val.GroupingCode == 'DISABLED') {
                scheduler.addMarkedTimespan({
                    //days: "fullweek",
                    //zones: [shown_time_start_hour * 60, shown_time_end_hour * 60],        
                    //invert_zones: true,
                    start_date: DecDateTime2Date(val.StartDT),
                    end_date: DecDateTime2Date(val.EndDT),
                    css: "yellow_section",
                    type: "dhx_time_block",
                    sections: { timelineday: val.ItemNo, timelineweek: val.ItemNo, timelinemonth: val.ItemNo }
                });
            }
            */

    //} else {
     //   val = json.TimeRegEntries.TimeRegEntry;
        /*
        if (val.GroupingCode == 'DISABLED') {
            scheduler.addMarkedTimespan({
                //days: "fullweek",
                //zones: [shown_time_start_hour * 60, shown_time_end_hour * 60],        
                //invert_zones: true,
                start_date: DecDateTime2Date(val.StartDT),
                end_date: DecDateTime2Date(val.EndDT),
                css: "yellow_section",
                type: "dhx_time_block",
                sections: { timelineday: val.ItemNo, timelineweek: val.ItemNo, timelinemonth: val.ItemNo }
            });
        }
        */
 
}

function FillEventsArray(json) {
    events = [];    
    $('#serviceInfoContainer').append(JSON.stringify(json));
    if (json.Allocations.Allocation.length != undefined) {
        $.each(json.Allocations.Allocation, function (i, val) {
            //alert(DecDateTime2Date(val.StartDT) + ' ' + DecDateTime2Date(val.EndDT));
            if (val.GroupingCode == 'ALLOC' && val.StartDT * 1 != 0) {
                FillTimeRegEntries(val);
                if (val.EndDT * 1 != 0) {
                    event_end_date = DecDateTime2Date(val.EndDT);
                } else {
                    event_end_date = new Date(9999, 1, 1);
                }
                events.push({
                    "id": val.EntryNo,
                    "text": val.Description,
                    "start_date": DecDateTime2Date(val.StartDT),
                    "end_date": event_end_date,
                    "section_id": val.ItemNo,
                    "color": XmlColorConvert(val.BackColor),
                    "textColor": XmlColorConvert(val.ForeColor),
                    'editable': val.Editable,
                    'type': 'AllocationEntry'
                });
            }
        });
    } else {
        val = json.Allocations.Allocation;
        if (val.GroupingCode == 'ALLOC' && val.StartDT * 1 != 0) {
            FillTimeRegEntries(val);
            if (val.EndDT * 1 != 0) {
                event_end_date = DecDateTime2Date(val.EndDT);
            } else {
                event_end_date = new Date(9999, 1, 1);
            }
            events.push({
                "id": val.EntryNo,
                "text": val.Description,
                "start_date": DecDateTime2Date(val.StartDT),
                "end_date": event_end_date,
                "section_id": val.ItemNo,
                "color": XmlColorConvert(val.BackColor),
                "textColor": XmlColorConvert(val.ForeColor),
                'editable': val.Editable,
                'type': 'AllocationEntry'
            });
        }
    }

    /*
    xml.find("Allocations Allocation").each(function () {
        //alert(DecDateTime2Date($(this).find('StartDT').text()) + ' -- ' + DecDateTime2Date($(this).find('EndDT').text()) + ' ' + $(this).find('ItemNo').text());
        if ($(this).find('GroupingCode').text() == 'ALLOC') {
            
            events.push({
                "id": $(this).find('EntryNo').text(),
                "text": $(this).find('Description').text(),
                "start_date": DecDateTime2Date($(this).find('StartDT').text()),
                "end_date": DecDateTime2Date($(this).find('EndDT').text()),
                "section_id": $(this).find('ItemNo').text(),
                "color": XmlColorConvert($(this).find('BackColor')),
                "textColor": XmlColorConvert($(this).find('ForeColor'))
            });
        }
    });
    */
}

function ResetSchedule() {
    scheduler.deleteMarkedTimespan();
}

function DecDateTime2Date(datetime) {
    tickKoeficient = 316224000000000;
    miliKoeficient = 621355968000000000;

    if ((datetime * 10000000000) >= tickKoeficient) {
        ticks = (datetime * 10000000000) - tickKoeficient;
        miliseconds = (ticks - miliKoeficient) / 10000;
        return GetTimeFromMilliseconds(miliseconds);
    } else {
        if (datetime < 1000) {
            ticks = (datetime * 10000000000);
            miliseconds = (ticks - miliKoeficient) / 10000;
            return GetTimeFromMilliseconds(miliseconds);
        } else {
            return new Date(0);
        }
    } 
}

function DBDate2JDate(datetime) {
    var darr = datetime.split('.');
    datetime = darr[0];
    darr = datetime.split(/[- :]/);
    return new Date(darr[0], darr[1] - 1, darr[2], darr[3], darr[4], darr[5]);
}

function Date2DecDateTime(datetime) {
    miliseconds = Date.parse(datetime);
    miliseconds = GetMillisecondsFromTime(miliseconds);

    tickKoeficient = 316224000000000;
    miliKoeficient = 621355968000000000;
    ticks = miliseconds * 10000 + miliKoeficient;
    return ((miliseconds * 10000) + miliKoeficient + tickKoeficient) / 10000000000;


}

function DecHours2Hours(dechours) {
    var secs = dechours * 1000000 / 1000;
    var hours = Math.floor(secs / (60 * 60));

    var divisor_for_minutes = secs % (60 * 60);
    var minutes = Math.floor(divisor_for_minutes / 60);

    var divisor_for_seconds = divisor_for_minutes % 60;
    var seconds = Math.ceil(divisor_for_seconds);

    //var obj = {
    //    "h": hours,
    //    "m": minutes,
    //    "s": seconds
    //};
    return hours;
}


function XmlColorConvert(elem) {
    var rgb_color_string = '';
    if (elem) {
        rgb_color_string = 'rgb('+elem.R + ',' + elem.G + ',' + elem.B +')';
    }

    return rgb_color_string;
}

function isIE() {
    var ua = window.navigator.userAgent;
    var msie = ua.indexOf("MSIE ");
    if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer, return version number
        //alert(parseInt(ua.substring(msie + 5, ua.indexOf(".", msie))));
        return true;
    else                 // If another browser, return 0
        return false;
}


function GetTimeFromMilliseconds(millisecs) {
    secs = millisecs / 1000;
    var t = new Date(1970, 0, 1);
    t.setSeconds(secs);    
    return t;
}

function GetMillisecondsFromTime(millisecs) {
    t = new Date(millisecs);
    return t.getTime() + t.getTimezoneOffset() * -1 * 60 * 1000;
}

function GetTimeFormat() {
    return time_format;
    /*
    if (minuteZero == undefined) {
        minuteZero = false;
    }
    var d = new Date();
    try {
        var language = window.navigator.userLanguage || window.navigator.language;        
        //locale_time_string = d.toLocaleTimeString(language);
        locale_time_string = d.toLocaleTimeString('lv-LV');
        //alert(language+' '+locale_time_string);
        if (locale_time_string.indexOf('A')>=0 || locale_time_string.indexOf('P')>=0 || locale_time_string.indexOf('a')>=0 || locale_time_string.indexOf('p')>=0) {
            if (minuteZero) {
                return '%g <span class=\'sup\'>%A</span>';
            } else {
                return '%g:%i <span class=\'sup\'>%A</span>';
            }
        };
    }
    catch (err) {
        if (minuteZero) {
            return '%H:00';
        } else {
            return '%H:%i';
        }
    }
    if (minuteZero) {
        return '%H:00';
    } else {
        return '%H:%i';
    }
    */
}

function AddDebugContainer(NavScheduleData) {
    $('#version').remove();
    $('#serviceInfoContainer').remove();
    if (debugmode) {
        $('#controlAddIn').parent().append('<div id="version">[ v' + version + ' ]</div>');
        $('#controlAddIn').append('<textarea id="serviceInfoContainer" style="position:absolute;z-index:9999; bottom:0; right:20;"></textarea>');
        $('#serviceInfoContainer').text(NavScheduleData);
    }
}

function UpdateRefreshInterval(json) {
    if (json.RefreshInterval != undefined && json.RefreshInterval != '0') {
        refresh_interval = parseInt(json.RefreshInterval);
    }
}

function UpdateStopRefresh(json) {
    if (json.StartRefresh != undefined && json.StartRefresh == 'Yes') {
        stop_refresh = false;
    }
}

function clearRefreshProcedure() {
    clearInterval(refresh_timer);
    stop_refresh = true;
}