pageextension 25006002 "General Ledger Entries" extends "General Ledger Entries" //20
{
    layout
    {
        addafter("Shortcut Dimension 8 Code")
        {
            field("Deal Type Code"; Rec."Deal Type Code")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Vehicle Serial No."; Rec."Vehicle Serial No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("VIN"; rec."VIN")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Vehicle Registration No."; Rec."Vehicle Registration No.")
            {
                ApplicationArea = Basic;
                Editable = false;
                Visible = false;
            }
            field("Vehicle Accounting Cycle No."; Rec."Vehicle Accounting Cycle No.")
            {
                ApplicationArea = Basic;
                Editable = false;
                Visible = false;
            }
            field("Contract No."; Rec."Contract No.")
            {
                ToolTip = 'Specifies the number of the Contract.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(IncomingDocument)
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
                    Clear(VehCycleMgt);
                    VehCycleMgt.ChangeCycleInGLEntry(Rec);
                end;
            }
        }
    }
}