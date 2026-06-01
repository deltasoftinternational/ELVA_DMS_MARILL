Page 25006897 "Service Booking Calendar"
{
    Caption = 'Booking Calendar';
    PageType = StandardDialog;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            usercontrol(Calendar; CalendarAddIn)
            {
                ApplicationArea = Basic;

                trigger ControlAddInReady()
                var
                    AddInData: Text;
                begin
                    //AddInReady := TRUE;
                    CalendarMgt.SetSelectedDate(SelectedDate);
                    CalendarMgt.SetLocationCode(LocationCode);
                    CalendarMgt.FillAddInData(AddInData);
                    CurrPage.Calendar.RecieveInitCalendarData(AddInData);
                end;

                trigger RequestRefreshData(Year: Integer; Month: Integer)
                var
                    AddInData: Text;
                    DateFrom: Date;
                    DateTo: Date;
                begin
                    DateFrom := Dmy2date(1, Month, Year);
                    DateTo := CalcDate('<CM>', DateFrom);
                    CalendarMgt.SetLocationCode(LocationCode);
                    CalendarMgt.SetSelectedDate(SelectedDate);
                    CalendarMgt.SetCalendarPeriod(DateFrom, DateTo);
                    CalendarMgt.FillAddInData(AddInData);
                    CurrPage.Calendar.RecieveRefreshCalendarData(AddInData);
                end;

                trigger RequestSelectDate(SelectedYear: Integer; SelectedMonth: Integer; SelectedDay: Integer)
                begin
                    SelectedDate := Dmy2date(SelectedDay, SelectedMonth, SelectedYear);
                    Rec.SetRange(Rec."Period Type", Rec."period type"::Date);
                    Rec.SetRange(Rec."Period Start", SelectedDate);
                    CurrPage.Update;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        LocationCode := BookingMgt.GetDefaultLocationCode;
        if SelectedDate = 0D then
            SelectedDate := WorkDate;
    end;

    var
        CalendarMgt: Codeunit "Service Calendar Management";
        LocationCode: Code[20];
        BookingMgt: Codeunit "Booking Management";
        AddInReady: Boolean;
        SelectedDate: Date;


    procedure UpdateCalendar()
    var
        AddInData: Text;
        DateFrom: Date;
        DateTo: Date;
    begin
        //IF NOT AddInReady THEN
        //  EXIT;


        CalendarMgt.SetLocationCode(LocationCode);
        CalendarMgt.SetCalendarPeriod(DateFrom, DateTo);
        CalendarMgt.FillAddInData(AddInData);
        CurrPage.Calendar.RecieveRefreshCalendarData(AddInData);
    end;


    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin

        LocationCode := LocationCodeToSet;
    end;


    procedure SetSelectedDate(SelectedDateToSet: Date)
    begin
        SelectedDate := SelectedDateToSet;
        Rec.SetRange(Rec."Period Type", Rec."period type"::Date);
        Rec.SetRange(Rec."Period Start", SelectedDate);
        CurrPage.Update;
    end;

    procedure GetSelectedDate(): Date
    begin
        exit(SelectedDate);
    end;
}

