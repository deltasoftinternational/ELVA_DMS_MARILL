Table 25006398 "Aftersales CRM Chart Setup"
{

    fields
    {
        field(1; "User ID"; Text[132])
        {
            Caption = 'User ID';
        }
        field(2; "Period Length"; Option)
        {
            Caption = 'Period Length';
            OptionCaption = 'Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;
        }
        field(3; "Show Orders"; Option)
        {
            Caption = 'Show Orders';
            OptionCaption = 'All Orders,Orders Until Today,Delayed Orders';
            OptionMembers = "All Orders","Orders Until Today","Delayed Orders";
        }
        field(4; "Use Work Date as Base"; Boolean)
        {
            Caption = 'Use Work Date as Base';
        }
        field(5; "Value to Calculate"; Option)
        {
            Caption = 'Value to Calculate';
            OptionCaption = 'Amount Excl. VAT,No. of Orders';
            OptionMembers = "Amount Excl. VAT","No. of Orders";
        }
        field(6; "Chart Type"; Option)
        {
            Caption = 'Chart Type';
            OptionCaption = 'Line,Step Line,Stacked Area (%),Stacked Column,Stacked Column (%)';
            OptionMembers = Line,"Step Line","Stacked Area (%)","Stacked Column","Stacked Column (%)";
        }
        field(7; "Latest Order Document Date"; Date)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = max("Posted Serv. Order Header"."Posting Date");
            Caption = 'Latest Order Document Date';
            FieldClass = FlowField;
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
    begin
        exit(Format("Show Orders") + '|' +
          Format("Period Length") + '|' +
          Format("Value to Calculate") + '|. (' +
          StrSubstNo(Text001, Time) + ')');
    end;


    procedure GetStartDate(): Date
    var
        StartDate: Date;
    begin
        if "Use Work Date as Base" then
            StartDate := WorkDate
        else
            StartDate := Today;
        if "Show Orders" = "show orders"::"All Orders" then begin
            CalcFields("Latest Order Document Date");
            if "Latest Order Document Date" <> 0D then
                StartDate := "Latest Order Document Date";
        end;

        exit(StartDate);
    end;


    procedure GetChartType(): Integer
    var
        BusinessChartBuf: Record "Business Chart Buffer";
    begin
        case "Chart Type" of
            "chart type"::Line:
                exit(BusinessChartBuf."chart type"::Line.AsInteger());
            "chart type"::"Step Line":
                exit(BusinessChartBuf."chart type"::StackedArea100.AsInteger());
            "chart type"::"Stacked Area (%)":
                exit(BusinessChartBuf."chart type"::StackedColumn.AsInteger());
            "chart type"::"Stacked Column":
                exit(BusinessChartBuf."chart type"::StackedColumn100.AsInteger());
        end;
    end;


    procedure SetPeriodLength(PeriodLength: Option)
    begin
        Get(UserId);
        "Period Length" := PeriodLength;
        Modify;
    end;


    procedure SetShowOrders(ShowOrders: Integer)
    begin
        Get(UserId);
        "Show Orders" := ShowOrders;
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
}

