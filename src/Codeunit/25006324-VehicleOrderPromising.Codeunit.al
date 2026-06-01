Codeunit 25006324 "Vehicle Order Promising"
{

    trigger OnRun()
    begin
    end;


    procedure CreateReqLine(var SalesLine: Record "Sales Line")
    var
        ReqLine: Record "Requisition Line";
        NewLineNo: Integer;
        VehOrderPromSetup: Record "Veh. Order Promising Setup";
        ModelVersion: Record Item;
    begin
        VehOrderPromSetup.Get;

        NewLineNo := 0;
        ReqLine.LockTable;
        ReqLine.SetRange("Worksheet Template Name", VehOrderPromSetup."Order Promising Template");
        ReqLine.SetRange("Journal Batch Name", VehOrderPromSetup."Order Promising Worksheet");
        if ReqLine.FindLast then
            NewLineNo := ReqLine."Line No.";
        NewLineNo += 10000;



        ReqLine.Init;
        ReqLine."Worksheet Template Name" := VehOrderPromSetup."Order Promising Template";
        ReqLine."Journal Batch Name" := VehOrderPromSetup."Order Promising Worksheet";
        ReqLine."Document Profile" := ReqLine."document profile"::"Vehicles Trade";
        ReqLine."Line No." := NewLineNo;
        ReqLine.Type := ReqLine.Type::Item;
        ReqLine."Vehicle Assembly ID" := SalesLine."Vehicle Assembly ID";
        ReqLine."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
        ReqLine."Vehicle Accounting Cycle No." := SalesLine."Vehicle Accounting Cycle No.";
        ReqLine.Validate("No.", SalesLine."No.");
        ReqLine.Description := SalesLine.Description;
        ReqLine."Description 2" := SalesLine."Description 2";
        ReqLine."Location Code" := SalesLine."Location Code";
        ReqLine.Quantity := SalesLine.Quantity;
        ReqLine."Make Code" := SalesLine."Make Code";
        ReqLine."Model Code" := SalesLine."Model Code";
        ReqLine."Model Version No." := SalesLine."Model Version No.";
        ReqLine."Accept Action Message" := true;

        if ModelVersion.Get(SalesLine."No.") then
            ReqLine."Vendor No." := ModelVersion."Vendor No.";

        ReqLine.Insert;

        CreateReservation(SalesLine, ReqLine);
    end;


    procedure CreateReservation(var SalesLine: Record "Sales Line"; var ReqLine: Record "Requisition Line")
    var
        ReservEntry: Record "Vehicle Reservation Entry";
        ReservMgt: Codeunit "Veh. Reservation Management";
        ReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
        ReservQty: Decimal;
    begin
        ReservMgt.SetReqLine(ReqLine);
        ReservEntry."Source Type" := Database::"Sales Line";
        ReserveSalesLine.CreateReservationSetFrom(
            Database::"Requisition Line", 0,
            ReqLine."Worksheet Template Name",
            ReqLine."Journal Batch Name", ReqLine."Line No.",
            ReqLine."Location Code");
        ReserveSalesLine.CreateReservation(
            SalesLine,
            ReqLine.Description);
    end;
}

