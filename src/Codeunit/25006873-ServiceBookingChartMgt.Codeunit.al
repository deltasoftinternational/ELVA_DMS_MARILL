Codeunit 25006873 "Service Booking Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        QuantityTxt: label 'Quantity';
        LocationCode: Code[20];
        SelectedDate: Date;


    procedure ResourceCapacity(var BusChartBuf: Record "Business Chart Buffer")
    var
        Resource: Record Resource;
    begin
        InitializeBusinessChart(BusChartBuf);
        AddMeasure(BusChartBuf);
        SetXAxis(BusChartBuf);
        SetResourceCapacity(BusChartBuf);
    end;

    local procedure InitializeBusinessChart(var BusChartBuf: Record "Business Chart Buffer")
    begin
        BusChartBuf.Initialize;
    end;

    local procedure AddMeasure(var BusChartBuf: Record "Business Chart Buffer")
    begin
        BusChartBuf.AddMeasure('Allocated Time', 1, BusChartBuf."data type"::Decimal, BusChartBuf."chart type"::StackedColumn);
        BusChartBuf.AddMeasure('Overscheduled', 1, BusChartBuf."data type"::Decimal, BusChartBuf."chart type"::StackedColumn);
        BusChartBuf.AddMeasure('Available Capacity', 1, BusChartBuf."data type"::Decimal, BusChartBuf."chart type"::StackedColumn);
    end;

    local procedure SetXAxis(var BusChartBuf: Record "Business Chart Buffer")
    begin
        BusChartBuf.SetXAxis(QuantityTxt, BusChartBuf."data type"::String);
    end;

    local procedure SetResourceCapacity(var BusChartBuf: Record "Business Chart Buffer")
    var
        Index: Integer;
        ScheduleResourceGroup: Record "Schedule Resource Group";
        ScheduleResourceGroupSpec: Record "Schedule Resource Group Spec.";
    begin
        ScheduleResourceGroup.SetRange("Location Code", LocationCode);
        ScheduleResourceGroup.FindFirst;
        ScheduleResourceGroupSpec.Reset;
        ScheduleResourceGroupSpec.SetRange("Group Code", ScheduleResourceGroup.Code);

        if ScheduleResourceGroupSpec.FindFirst then
            repeat
                SetCapacityByResource(BusChartBuf, Index, ScheduleResourceGroupSpec."Resource No.");
            until ScheduleResourceGroupSpec.Next = 0;
    end;

    local procedure SetCapacityByResource(var BusChartBuf: Record "Business Chart Buffer"; var Index: Integer; ResourceNo: Code[20])
    var
        AllocatedTime: Decimal;
        Overscheduled: Decimal;
        AvailableCapacity: Decimal;
        Resource: Record Resource;
        BookingOrder: Record "Service Header EDMS";
    begin
        if Resource.Get(ResourceNo) then begin
            Index += 1;


            //Calc >>
            //Allocated Time
            BookingOrder.Reset;
            BookingOrder.SetRange("Document Type", BookingOrder."document type"::Booking);
            BookingOrder.SetRange(BookingOrder."Booking Resource No.", ResourceNo);
            BookingOrder.SetRange(BookingOrder."Location Code", LocationCode);
            BookingOrder.SetFilter("Requested Starting Date", '..%1', SelectedDate);
            BookingOrder.SetFilter("Requested Finishing Date", '%1..', SelectedDate);
            if BookingOrder.FindFirst then
                repeat
                    AllocatedTime += BookingOrder."Total Work (Hours)";
                until BookingOrder.Next = 0;

            //Capacity
            if SelectedDate = 0D then
                SelectedDate := WorkDate;

            Resource.SetRange("Date Filter", SelectedDate);
            Resource.CalcFields(Capacity);

            //AvailableCapacity := 100 - AllocatedTime;
            AvailableCapacity := Resource.Capacity - AllocatedTime;
            if AvailableCapacity < 0 then begin
                Overscheduled := AvailableCapacity * -1;
                AllocatedTime := AllocatedTime - Overscheduled;
                AvailableCapacity := 0;
            end else
                Overscheduled := 0;

            //Calc <<

            BusChartBuf.AddColumn(Resource.Name);
            BusChartBuf.SetValue('Allocated Time', Index - 1, AllocatedTime);//Allocated time
            BusChartBuf.SetValue('Available Capacity', Index - 1, AvailableCapacity); //Capacity
            BusChartBuf.SetValue('Overscheduled', Index - 1, Overscheduled); // Overflow
        end;
    end;


    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;


    procedure SetSelectedDate(SelectedDateToSet: Date)
    begin
        SelectedDate := SelectedDateToSet;
    end;
}

