tableextension 25006379 "Order Promising Line" extends "Order Promising Line" //99000880
{
    // 09.07.08 EDMS P1 - EDMS Service Management integration
    //  * Mofifyed option string of field "Source Type". New option added - Service Order EDMS
    //  * Added function TransferFromServiceLineEDMS

    fields
    {

    }
    procedure TransferFromServiceLineEDMS(var ServiceLine: Record "Service Line EDMS")
    begin
        "Source Type" := "source type"::"Service Order EDMS";
        "Source Subtype" := ServiceLine."Document Type";
        "Source ID" := ServiceLine."Document No.";
        "Source Line No." := ServiceLine."Line No.";
        "Item No." := ServiceLine."No.";
        "Location Code" := ServiceLine."Location Code";
        Validate("Requested Delivery Date", ServiceLine."Planned Service Date");
        "Original Shipment Date" := ServiceLine."Planned Service Date";
        Description := ServiceLine.Description;
        Quantity := ServiceLine.Quantity;
        "Unit of Measure Code" := ServiceLine."Unit of Measure Code";
        "Qty. per Unit of Measure" := ServiceLine."Qty. per Unit of Measure";
        "Quantity (Base)" := ServiceLine.Quantity;
    end;
}
