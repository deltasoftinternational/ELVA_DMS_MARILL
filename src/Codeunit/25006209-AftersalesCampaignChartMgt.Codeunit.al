Codeunit 25006209 "Aftersales Campaign Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        CustomerXCaptionTxt: label 'Customer Name';
        SalesLCYYCaptionTxt: label 'Sales (LCY)';
        AllOtherCustomersTxt: label 'All Other Customers';
        AftersalesCRMSetup: Record "Aftersales CRM Chart Setup";
        ServiceHeaderEDMS: Record "Service Header EDMS";


    procedure OnOpenPage(AftersalesCRMSetup: Record "Aftersales CRM Chart Setup")
    begin
        if not AftersalesCRMSetup.Get(UserId) then begin
            AftersalesCRMSetup."User ID" := UserId;
            AftersalesCRMSetup."Use Work Date as Base" := true;
            AftersalesCRMSetup."Period Length" := AftersalesCRMSetup."period length"::Month;
            AftersalesCRMSetup."Value to Calculate" := AftersalesCRMSetup."value to calculate"::"No. of Orders";
            AftersalesCRMSetup."Chart Type" := AftersalesCRMSetup."chart type"::Line;
            AftersalesCRMSetup.Insert;
        end;
    end;


    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var
        ServiceHeaderEDMS: Record "Service Header EDMS";
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 3) then
            exit;
        AftersalesCRMSetup.Get(UserId);
        //ServiceHeaderEDMS.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
        if AftersalesCRMSetup."Show Orders" = AftersalesCRMSetup."show orders"::"Delayed Orders" then
            ServiceHeaderEDMS.SetFilter("Shipment Date", '<%1', AftersalesCRMSetup.GetStartDate);
        if Evaluate(ServiceHeaderEDMS.Status, BusChartBuf.GetMeasureValueString(Measure), 9) then
            ServiceHeaderEDMS.SetRange(Status, ServiceHeaderEDMS.Status);

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        ServiceHeaderEDMS.SetRange("Document Date", 0D, ToDate);
        //PAGE.RUN(PAGE::"Sales Order List",SalesHeader);
    end;


    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        ChartToMap: array[2] of Integer;
        ToDate: array[5] of Date;
        FromDate: array[5] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        SalesHeaderStatus: Integer;
        n: Integer;
        Campaign: Record Campaign;
    begin
        AftersalesCRMSetup.Get(UserId);
        BusChartBuf.Initialize;
        BusChartBuf."Period Length" := AftersalesCRMSetup."Period Length";
        BusChartBuf.SetPeriodXAxis;

        //CreateMap(ChartToMap);
        n := 0;
        Campaign.Reset;
        if Campaign.Find('-') then
            if CalcPeriods(FromDate, ToDate, BusChartBuf) then
                BusChartBuf.AddPeriods(ToDate[1], ToDate[ArrayLen(ToDate)]);
        repeat
            n += 1;
            BusChartBuf.AddMeasure(Campaign."No." + ' ' + Campaign.Description, n, BusChartBuf."data type"::Decimal, AftersalesCRMSetup.GetChartType);
            for ColumnNo := 1 to ArrayLen(ToDate) do begin
                Value := GetServiceOrderValue(Campaign."No.", FromDate[ColumnNo], ToDate[ColumnNo]);
                if ColumnNo = 1 then
                    TotalValue := Value
                else
                    TotalValue += Value;
                BusChartBuf.SetValueByIndex(n - 1, ColumnNo - 1, Value);
            end;
        until Campaign.Next = 0;
    end;

    local procedure CalcPeriods(var FromDate: array[5] of Date; var ToDate: array[5] of Date; var BusChartBuf: Record "Business Chart Buffer"): Boolean
    var
        MaxPeriodNo: Integer;
        i: Integer;
    begin
        MaxPeriodNo := ArrayLen(ToDate);
        ToDate[MaxPeriodNo] := AftersalesCRMSetup.GetStartDate;
        if ToDate[MaxPeriodNo] = 0D then
            exit(false);
        for i := MaxPeriodNo downto 1 do begin
            if i > 1 then begin
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i]);
                ToDate[i - 1] := FromDate[i] - 1;
            end else
                FromDate[i] := 0D
        end;
        exit(true);
    end;

    local procedure GetServiceOrderValue(Map: Code[20]; FromDate: Date; ToDate: Date): Decimal
    begin
        if AftersalesCRMSetup."Value to Calculate" = AftersalesCRMSetup."value to calculate"::"No. of Orders" then
            exit(GetServiceOrderCount(Map, FromDate, ToDate));
        exit(GetServiceOrderAmount(Map, FromDate, ToDate));
    end;

    local procedure GetServiceOrderAmount(Map: Code[20]; FromDate: Date; ToDate: Date): Decimal
    var
        CurrExchRate: Record "Currency Exchange Rate";
        ServiceOrderQry: Query "Campaign Query";
        Amount: Decimal;
        TotalAmount: Decimal;
        MapType: Text;
    begin
        //IF AftersalesCRMSetup."Show Orders" = AftersalesCRMSetup."Show Orders"::"Delayed Orders" THEN
        //  TrailingSalesOrderQry.SETFILTER(ShipmentDate,'<%1',AftersalesCRMSetup.GetStartDate);

        //TrailingSalesOrderQry.SETRANGE(Status,Status);
        //IF Map=1 THEN
        //  MapType := 'Labor'
        //ELSE
        //  MapType := 'Item';

        ServiceOrderQry.SetRange(PostingDate, FromDate, ToDate);
        ServiceOrderQry.SetRange(Campaign_No, Map);
        ServiceOrderQry.Open;
        while ServiceOrderQry.Read do begin
            if ServiceOrderQry.CurrencyCode = '' then
                Amount := ServiceOrderQry.Amount
            else
                Amount := ROUND(ServiceOrderQry.Amount / CurrExchRate.ExchangeRate(Today, ServiceOrderQry.CurrencyCode));
            TotalAmount := TotalAmount + Amount;
        end;
        exit(TotalAmount);
    end;

    local procedure GetServiceOrderCount(Map: Code[20]; FromDate: Date; ToDate: Date): Decimal
    begin
        //SHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
        //IF AftersalesCRMSetup."Show Orders" = TrailingSalesOrdersSetup."Show Orders"::"Delayed Orders" THEN
        //  SalesHeader.SETFILTER("Shipment Date",'<%1',TrailingSalesOrdersSetup.GetStartDate)
        //ELSE
        //  SalesHeader.SETRANGE("Shipment Date");
        //SalesHeader.SETRANGE(Status,Status);
        ServiceHeaderEDMS.Reset;
        ServiceHeaderEDMS.SetRange("Campaign No.", Map);
        ServiceHeaderEDMS.SetRange("Document Date", FromDate, ToDate);
        exit(ServiceHeaderEDMS.Count);
    end;


    procedure CreateMap(var Map: array[2] of Integer)
    var
        SalesHeader: Record "Sales Header";
    begin
        Map[1] := SalesHeader.Status::Released.AsInteger();
        Map[2] := SalesHeader.Status::"Pending Prepayment".AsInteger();
    end;
}

