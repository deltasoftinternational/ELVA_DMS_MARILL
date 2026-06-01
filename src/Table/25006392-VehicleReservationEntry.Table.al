Table 25006392 "Vehicle Reservation Entry"
{
    Caption = 'Vehicle Reservation Entry';
    DrillDownPageID = "Vehicle Reservation Entries";
    LookupPageID = "Vehicle Reservation Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item;
        }
        field(3; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(10; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(11; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(12; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(13; "Source Batch Name"; Code[10])
        {
            Caption = 'Source Batch Name';
        }
        field(15; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(24; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = "Vehicle Serial No. Buffer";
        }
        field(25; "Created By"; Code[50])
        {
            Caption = 'Created By';

            trigger OnLookup()
            var
                LoginMgt: Codeunit UserProfileManagement;
            begin
                LoginMgt.LookupUserID("Created By");
            end;
        }
        field(27; "Changed By"; Code[50])
        {
            Caption = 'Changed By';

            trigger OnLookup()
            var
                LoginMgt: Codeunit UserProfileManagement;
            begin
                LoginMgt.LookupUserID("Changed By");
            end;
        }
        field(28; Positive; Boolean)
        {
            Caption = 'Positive';
            Editable = false;
        }
        field(30; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(41; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            Editable = false;
        }
        field(60; "Make Code"; Code[20])
        {
            CalcFormula = lookup(Item."Make Code" where("No." = field("Model Version No.")));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Model Code"; Code[20])
        {
            CalcFormula = lookup(Item."Model Code" where("No." = field("Model Version No.")));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5817; Correction; Boolean)
        {
            Caption = 'Correction';
        }
    }

    keys
    {
        key(Key1; "Entry No.", Positive)
        {
            Clustered = true;
        }
        key(Key2; "Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name")
        {
        }
        key(Key3; "Model Version No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: label 'Line';


    procedure TextCaption(): Text[255]
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        SalesLine: Record "Sales Line";
        ReqLine: Record "Requisition Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        TransLine: Record "Transfer Line";
        ServInvLine: Record "Service Line";
    begin
        case "Source Type" of
            Database::"Item Ledger Entry":
                exit(ItemLedgEntry.TableCaption);
            Database::"Sales Line":
                exit(SalesLine.TableCaption);
            Database::"Requisition Line":
                exit(ReqLine.TableCaption);
            Database::"Purchase Line":
                exit(PurchLine.TableCaption);
            Database::"Item Journal Line":
                exit(ItemJnlLine.TableCaption);
            Database::"Transfer Line":
                exit(TransLine.TableCaption);
            else
                exit(Text001);
        end;
    end;


    procedure Lock()
    var
        Rec2: Record "Vehicle Reservation Entry";
    begin
        if RECORDLEVELLOCKING then begin
            Rec2.SetCurrentkey("Model Version No.");
            if "Model Version No." <> '' then
                Rec2.SetRange("Model Version No.", "Model Version No.");
            Rec2.LockTable;
            if Rec2.FindLast then;
        end else
            LockTable;
    end;
}

