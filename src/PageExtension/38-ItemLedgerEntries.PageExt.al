pageextension 25006010 "Item Ledger Entries" extends "Item Ledger Entries" //38
{
    layout
    {
        addafter("Document No.")
        {
            field(ExternalDocumentNo; Rec."External Document No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Serial No.")
        {
            field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Shortcut Dimension 8 Code")
        {
            field(TransferSourceType; Rec."Transfer Source Type")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(TransferSourceSubtype; Rec."Transfer Source Subtype")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(TransferSourceNo; Rec."Transfer Source No.")
            {
                ApplicationArea = Basic;
            }
            field(VIN; Rec.VIN)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(SourceNo; Rec."Source No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(SourceType; Rec."Source Type")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(DealTypeCode; Rec."Deal Type Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter("Order &Tracking")
        {
            action("<Action1101904000>")
            {
                ApplicationArea = Basic;
                Caption = 'Change Veh. Acc. Cycle';
                Image = Change;

                trigger OnAction()
                var
                    VehCycleMgt: Codeunit VehicleAccountingCycleMgt;
                begin
                    //EDMS
                    Clear(VehCycleMgt);
                    VehCycleMgt.ChangeCycleInItemLedgerEntry(Rec);
                end;
            }
        }
    }
}