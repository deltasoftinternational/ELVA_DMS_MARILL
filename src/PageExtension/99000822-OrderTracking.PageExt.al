pageextension 25006471 "Order Tracking" extends "Order Tracking"//99000822
{
    var
        OrderTrackingMgt: Codeunit OrderTrackingManagement;
        DocumentManagementDMS: Codeunit DocumentManagementDMS;
        CurrItemNo: Code[20];
        CurrQuantity: Decimal;
        StartingDate: Date;
        EndingDate: Date;

    procedure SetServiceLine(var CurrentServiceLine: Record "Service Line EDMS")
    begin
        DocumentManagementDMS.SetServiceLine(CurrentServiceLine);
        CurrItemNo := CurrentServiceLine."No.";
        CurrQuantity := CurrentServiceLine."Outstanding Qty. (Base)";
        StartingDate := CurrentServiceLine."Planned Service Date";
        EndingDate := CurrentServiceLine."Planned Service Date";
    end;
}