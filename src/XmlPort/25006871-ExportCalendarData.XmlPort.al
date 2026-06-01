XmlPort 25006871 "Export Calendar Data"
{
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            textelement(Calendar)
            {
                textattribute(datefromtxt)
                {
                    XmlName = 'DateFrom';
                }
                textattribute(datetotxt)
                {
                    XmlName = 'DateTo';
                }
                textattribute(selecteddatetxt)
                {
                    XmlName = 'SelectedDate';

                    trigger OnBeforePassVariable()
                    begin
                        if SelectedDate = 0D then
                            SelectedDate := WorkDate;
                        SelectedDateTxt := Format(SelectedDate, 0, 9);
                    end;
                }
                tableelement(Date; Date)
                {
                    XmlName = 'Day';
                    fieldelement(Date; Date."Period Start")
                    {
                    }
                    textelement(bookingcounttxt)
                    {
                        XmlName = 'BookingCount';

                        trigger OnBeforePassVariable()
                        var
                            BookingCount: Integer;
                        begin

                            ServiceHeaderEDMS.Reset;
                            ServiceHeaderEDMS.SetRange("Location Code", LocationCode);
                            ServiceHeaderEDMS.SetFilter("Requested Starting Date", '..%1', Date."Period Start");
                            ServiceHeaderEDMS.SetFilter("Requested Finishing Date", '%1..', Date."Period Start");
                            OnBeforeBookingCountAddFilter(ServiceHeaderEDMS, SelectedDealType);
                            BookingCount := ServiceHeaderEDMS.Count;

                            ServiceHeaderEDMS.Reset;
                            ServiceHeaderEDMS.SetRange("Location Code", LocationCode);
                            ServiceHeaderEDMS.SetRange("Requested Starting Date", Date."Period Start");
                            ServiceHeaderEDMS.SetRange("Requested Finishing Date", 0D);
                            OnBeforeBookingCountAddFilter(ServiceHeaderEDMS, SelectedDealType);
                            BookingCount += ServiceHeaderEDMS.Count;

                            ServiceHeaderEDMS.Reset;
                            ServiceHeaderEDMS.SetRange("Location Code", LocationCode);
                            ServiceHeaderEDMS.SetRange("Requested Starting Date", 0D);
                            ServiceHeaderEDMS.SetRange("Requested Finishing Date", Date."Period Start");
                            OnBeforeBookingCountAddFilter(ServiceHeaderEDMS, SelectedDealType);
                            BookingCount += ServiceHeaderEDMS.Count;

                            BookingCountTxt := Format(BookingCount);
                        end;
                    }

                    trigger OnPreXmlItem()
                    begin
                        //MESSAGE(FORMAT(DateFrom)+' '+FORMAT(DateTo));
                        Date.SetRange(Date."Period Type", Date."period type"::Date);
                        Date.SetFilter(Date."Period Start", '%1..%2', DateFrom, DateTo);
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        SetCalendarPeriod(0D, 0D);
    end;

    var
        CalendarMgt: Codeunit "Service Calendar Management";
        DateFrom: Date;
        DateTo: Date;
        ServiceHeaderEDMS: Record "Service Header EDMS";
        LocationCode: Code[20];
        SelectedDate: Date;
        SelectedDealType: Code[10];


    procedure SetCalendarPeriod(DateFromToSet: Date; DateToToSet: Date)
    begin
        if (DateFromToSet = 0D) or (DateToToSet = 0D) then begin
            DateFromToSet := CalcDate('<CM-1M+1D>', WorkDate);
            DateToToSet := CalcDate('<CM>', WorkDate);
        end;
        DateFrom := DateFromToSet;
        DateTo := DateToToSet;
        DateFromTxt := Format(DateFrom, 0, 9);
        DateToTxt := Format(DateTo, 0, 9);
    end;


    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;


    procedure SetSelectedDate(SelectedDateToSet: Date)
    begin
        SelectedDate := SelectedDateToSet;
    end;

    procedure SetSelectedDealType(SelectedDealTypeToSet: Code[10])
    begin
        SelectedDealType := SelectedDealTypeToSet;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeBookingCountAddFilter(var ServiceHeaderEDMS: Record "Service Header EDMS"; SelectedDealType: Code[10])
    begin
    end;
}

