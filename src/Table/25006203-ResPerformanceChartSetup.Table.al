Table 25006203 "Res. Performance Chart Setup"
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
            OptionCaption = 'Amount,Quantity';
            OptionMembers = Amount,Quantity;
        }
        field(50; "Chart Type"; Option)
        {
            Caption = 'Chart Type';
            OptionCaption = 'Line,Step Line,Column,StackedColumn';
            OptionMembers = Line,"Step Line",Column,StackedColumn;
        }
        field(60; Location; Code[10])
        {
            Caption = 'Location';
            TableRelation = Location;
        }
        field(70; "Service Person"; Code[10])
        {
            Caption = 'Service Advisor';
            TableRelation = "Salesperson/Purchaser";
        }
        field(80; "Resource No."; Code[20])
        {
        }
        field(90; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(100; "End Date"; Date)
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
        Text001: label 'Updated at %1.';


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
          Format(GetStartDate(0)) + ' | ' +
          Format("Period Length"));
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
            "chart type"::StackedColumn:
                exit(BusinessChartBuf."chart type"::StackedColumn.AsInteger());
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
        exit("Service Person");
    end;


    procedure GetResource(): Code[20]
    begin
        exit("Resource No.");
    end;

    local procedure CurrDate(): Date
    begin
        if "Use Work Date as Base" then
            exit(WorkDate)
        else
            exit(Today);
    end;

    local procedure GetPeriodLength(): Text[1]
    begin
        case "Period Length" of
            "period length"::Day:
                exit('W');
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


    procedure GetStartDate(Period: Option " ",Next,Previos): Date
    var
        StartDate: Date;
    begin
        case Period of
            Period::" ":
                begin
                    StartDate := CurrDate;
                    if "Period Length" = "period length"::Day then
                        StartDate := CalcDate('<WD7>', CurrDate);
                end;
            Period::Next:
                begin
                    StartDate := CalcDate('<1' + GetPeriodLength + '>', "Start Date");
                end;
            Period::Previos:
                begin
                    StartDate := CalcDate('<-1' + GetPeriodLength + '>', "Start Date");
                end;
        end;
        exit(StartDate);
    end;
}

