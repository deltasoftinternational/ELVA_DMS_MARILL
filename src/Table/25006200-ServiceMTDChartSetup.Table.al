Table 25006200 "Service MTD Chart Setup"
{

    fields
    {
        field(10; "User ID"; Text[132])
        {
            Caption = 'User ID';
        }
        field(20; "Period Length"; Option)
        {
            Caption = 'Period Length';
            OptionCaption = 'Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;
        }
        field(30; "Use Work Date as Base"; Boolean)
        {
            Caption = 'Use Work Date as Base';
        }
        field(40; "Value to Calculate"; Option)
        {
            Caption = 'Value to Calculate';
            OptionCaption = 'Amount,Quantity,Percent';
            OptionMembers = Amount,Quantity,Percent;
        }
        field(50; "Chart Type"; Option)
        {
            Caption = 'Chart Type';
            OptionCaption = 'Line,Step Line,Column';
            OptionMembers = Line,"Step Line",Column;
        }
        field(60; Location; Code[10])
        {
            Caption = 'Location';
            TableRelation = Location;
        }
        field(70; "Service Advisor"; Code[10])
        {
            Caption = 'Service Advisor';
            TableRelation = "Salesperson/Purchaser";
        }
        field(80; Resource; Code[20])
        {
            Caption = 'Resource';
        }
        field(90; "Group By"; Option)
        {
            Caption = 'Group By';
            OptionCaption = 'Total,Location,Service Advisor,Resource';
            OptionMembers = Total,Location,"Service Advisor",Resource;
        }
        field(100; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(110; "End Date"; Date)
        {
            Caption = 'End Date';
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        YearTxt: label 'Year';
        QuarterTxt: label 'Quarter';


    procedure GetCurrentSelectionText(): Text[100]
    var
        LocationTxt: Text;
        ServicePersonTxt: Text;
        ResourceTxt: Text;
    begin
        LocationTxt := '';
        if GetLocation <> '' then
            LocationTxt := Format(GetLocation) + ' | ';
        ServicePersonTxt := '';
        if GetServicePerson <> '' then
            ServicePersonTxt := Format(GetServicePerson) + ' | ';
        ResourceTxt := '';
        if GetResource <> '' then
            ResourceTxt := Format(GetResource) + ' | ';

        exit(LocationTxt +
          ServicePersonTxt +
          ResourceTxt +
          GetPeriodText);
    end;


    procedure GetChartType(): Integer
    var
        BusinessChartBuf: Record "Business Chart Buffer";
    begin
        case "Chart Type" of
            "chart type"::Line:
                exit(BusinessChartBuf."chart type"::Line.AsInteger());
            "chart type"::"Step Line":
                exit(BusinessChartBuf."chart type"::StepLine.AsInteger());
            "chart type"::Column:
                exit(BusinessChartBuf."chart type"::Column.AsInteger());
        end;
    end;


    procedure SetPeriodLength(PeriodLength: Option)
    begin
        Get(UserId);
        "Period Length" := PeriodLength;
        Modify;
    end;


    procedure SetValueToCalcuate(ValueToCalc: Integer)
    begin
        Get(UserId);
        "Value to Calculate" := ValueToCalc;
        Modify;
    end;


    procedure SetChartType(ChartType: Integer)
    begin
        Get(UserId);
        "Chart Type" := ChartType;
        Modify;
    end;


    procedure GetLocation(): Code[10]
    begin
        exit(Location);
    end;


    procedure GetServicePerson(): Code[10]
    begin
        exit("Service Advisor");
    end;


    procedure GetResource(): Code[20]
    begin
        exit(Resource);
    end;


    procedure GetStartDate(Period: Option " ",Next,Previos): Date
    var
        StartDate: Date;
    begin
        case Period of
            Period::" ":
                StartDate := CurrDate;
            Period::Next:
                begin
                    StartDate := AdjustedStartDate(CalcDate('<1' + GetPeriodLength + '>', "Start Date"));
                end;
            Period::Previos:
                begin
                    StartDate := AdjustedStartDate(CalcDate('<-1' + GetPeriodLength + '>', "Start Date"));
                end;
        end;
        exit(StartDate);
    end;

    local procedure GetPeriodLength(): Text[1]
    begin
        case "Period Length" of
            "period length"::Day:
                exit('D');
            "period length"::Week:
                exit('W');
            "period length"::Month:
                exit('M');
            "period length"::Quarter:
                exit('Q');
            "period length"::Year:
                exit('Y');
        end;
    end;

    local procedure CurrDate(): Date
    begin
        if "Use Work Date as Base" then
            exit(WorkDate)
        else
            exit(Today);
    end;

    local procedure AdjustedStartDate(StartDatePar: Date): Date
    begin
        case "Period Length" of
            "period length"::Day:
                exit(StartDatePar);
            "period length"::Week:
                begin
                    if CalcDate('<CW>', StartDatePar) > CurrDate then
                        exit(CurrDate)
                    else
                        exit(CalcDate('<CW>', StartDatePar));
                end;
            "period length"::Month:
                begin
                    if CalcDate('<CM>', StartDatePar) > CurrDate then
                        exit(CurrDate)
                    else
                        exit(CalcDate('<CM>', StartDatePar));
                end;
            "period length"::Quarter:
                begin
                    if CalcDate('<CQ>', StartDatePar) > CurrDate then
                        exit(CurrDate)
                    else
                        exit(CalcDate('<CQ>', StartDatePar));
                end;
            "period length"::Year:
                begin
                    if CalcDate('<CY>', StartDatePar) > CurrDate then
                        exit(CurrDate)
                    else
                        exit(CalcDate('<CY>', StartDatePar));
                end;
        end;
    end;

    local procedure GetPeriodText(): Text
    begin
        case "Period Length" of
            "period length"::Day:
                exit(Format("Start Date", 0, ' <Day> <Month Text> <Year4> '));
            "period length"::Week:
                exit(Format("Start Date" - 7, 0, ' <Day> <Month Text> <Year4> ') + Format("Start Date", 0, ' - <Day> <Month Text> <Year4> '));
            "period length"::Month:
                exit(Format("Start Date", 0, ' <Month Text> <Year4> '));
            "period length"::Quarter:
                exit(QuarterTxt + Format("Start Date", 0, ' <Quarter> ') + YearTxt + Format("Start Date", 0, ' <Year4>'));
            "period length"::Year:
                exit(YearTxt + Format("Start Date", 0, ' <Year4>'));
        end;
    end;


    procedure GetEndDate(StartDate: Date): Date
    begin
        exit(CalcDate('<C' + GetPeriodLength + '-1' + GetPeriodLength + '+1D>', StartDate));
    end;
}

