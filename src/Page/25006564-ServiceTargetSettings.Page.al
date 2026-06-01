Page 25006564 "Service Target Settings"
{
    Caption = 'Service Target Settings';

    layout
    {
        area(content)
        {
            group(Period)
            {
                Caption = 'Period';
                field(StartDate; StartDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Starting Date';
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ending Date';

                    trigger OnValidate()
                    begin
                        if StartDate > EndDate then
                            Error(Text004);
                    end;
                }
            }
            group(General)
            {
                Caption = 'General';
                field(LocationCode; LocationCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Location';
                    TableRelation = Location;
                }
                field(ServicePersonCode; ServicePersonCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Advisor';
                    TableRelation = "Salesperson/Purchaser";
                }
                field(ResourceCode; ResourceCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource';
                    TableRelation = Resource;
                }
                field(ServicePrice; ServiceRate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Rate';

                    trigger OnValidate()
                    begin
                        SumWeekTotal;
                    end;
                }
            }
            group(Week)
            {
                Caption = 'Week';
                field(Monday; Monday)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Monday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        MondayOnAfterV;
                    end;
                }
                field(Tuesday; Tuesday)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Tuesday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        TuesdayOnAfterV;
                    end;
                }
                field(Wednesday; Wednesday)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Wednesday (Hours)';

                    trigger OnValidate()
                    begin
                        WednesdayOnAfterV;
                    end;
                }
                field(Thursday; Thursday)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Thursday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        ThursdayOnAfterV;
                    end;
                }
                field(Friday; Friday)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Friday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        FridayOnAfterV;
                    end;
                }
                field(Saturday; Saturday)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Saturday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        SaturdayOnAfterV;
                    end;
                }
                field(Sunday; Sunday)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Sunday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        SundayOnAfterV;
                    end;
                }
                field(WeekTotalAmount; WeekTotalAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Week Total Amount';
                    DecimalPlaces = 0 : 2;
                    Editable = false;
                }
                field(WeekTotalQuantity; WeekTotalQuantity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Week Total Hours';
                    DecimalPlaces = 0 : 2;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(FillTargetPeriod)
            {
                ApplicationArea = Basic;
                Caption = 'Fill Target Period';
                Image = DateRange;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if StartDate = 0D then
                        Error(Text002);
                    if EndDate = 0D then
                        Error(Text003);
                    if StartDate > EndDate then
                        Error(Text004);

                    ServiceTarget.Reset;
                    ServiceTarget.SetFilter(Date, '%1..%2', StartDate, EndDate);
                    if LocationCode = '' then
                        ServiceTarget.SetFilter(Location, '=%1', '')
                    else
                        ServiceTarget.SetFilter(Location, LocationCode);

                    if ServicePersonCode = '' then
                        ServiceTarget.SetFilter("Service Advisor", '=%1', '')
                    else
                        ServiceTarget.SetFilter("Service Advisor", ServicePersonCode);

                    if ResourceCode = '' then
                        ServiceTarget.SetFilter(Resource, '=%1', '')
                    else
                        ServiceTarget.SetFilter(Resource, ResourceCode);

                    ServiceTarget.DeleteAll;

                    ServiceTarget.Reset;
                    i := 0;
                    Date := StartDate;
                    while Date <= EndDate do begin
                        case Date2dwy(Date, 1) of
                            1:
                                NewTargetEntry(Date, Monday);
                            2:
                                NewTargetEntry(Date, Tuesday);
                            3:
                                NewTargetEntry(Date, Wednesday);
                            4:
                                NewTargetEntry(Date, Thursday);
                            5:
                                NewTargetEntry(Date, Friday);
                            6:
                                NewTargetEntry(Date, Saturday);
                            7:
                                NewTargetEntry(Date, Sunday);
                        end;
                        i += 1;
                        Date := StartDate + i;
                    end;
                    Message(Text001);
                end;
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        WeekTotalQuantity: Decimal;
        WeekTotalAmount: Decimal;
        Monday: Decimal;
        Tuesday: Decimal;
        Wednesday: Decimal;
        Thursday: Decimal;
        Friday: Decimal;
        Saturday: Decimal;
        Sunday: Decimal;
        Text001: label 'Target Period Filled!';
        Text002: label 'Start Date not specified';
        Text003: label 'End Date not specified';
        Text004: label 'The starting date is later than the ending date.';
        ServiceRate: Decimal;
        LocationCode: Code[10];
        ResourceCode: Code[10];
        ServicePersonCode: Code[10];
        ServiceTarget: Record "Service Target";
        Date: Date;
        i: Integer;

    local procedure SumWeekTotal()
    begin
        WeekTotalQuantity := Monday + Tuesday + Wednesday +
          Thursday + Friday + Saturday + Sunday;
        WeekTotalAmount := WeekTotalQuantity * ServiceRate;
    end;

    local procedure MondayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure TuesdayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure WednesdayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure ThursdayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure FridayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure SaturdayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure SundayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure NewTargetEntry(DatePar: Date; Quantity: Decimal)
    var
        NewServiceTarget: Record "Service Target";
    begin
        if Quantity <= 0 then
            exit;
        ServiceTarget.Init;
        ServiceTarget.Date := Date;
        ServiceTarget.Location := LocationCode;
        ServiceTarget.Resource := ResourceCode;
        ServiceTarget."Service Advisor" := ServicePersonCode;
        ServiceTarget.Amount := ServiceRate * Quantity;
        ServiceTarget.Quantity := Quantity;
        ServiceTarget.Insert;
    end;
}

