Table 25006388 "Vehicle Opt. Ledger Entry"
{
    // 11.04.2013 EDMS P8
    //   * Renamed field 'Manuf. Option Type' to 'Option Subtype'
    // 
    // 19.06.2004 EDMS P1
    //    * Created

    Caption = 'Vehicle Option Ledger Entry';
    DrillDownPageID = "Vehicle Opt. Ledger Entries";
    LookupPageID = "Vehicle Opt. Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Put On,Take Off';
            OptionMembers = "Put On","Take Off";
        }
        field(10; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(20; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(30; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(40; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(45; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(60; "Option Type"; Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Manufacturer Option,Own Option,Vehicle Base,Item,Comment';
            OptionMembers = "Manufacturer Option","Own Option","Vehicle Base","Item","Comment";
        }
        field(70; "Option Code"; Code[50])
        {
            Caption = 'Option Code';

            trigger OnLookup()
            var
                recManOption: Record "Manufacturer Option";
                recItem: Record Item;
                recOwnOption: Record "Own Option";
            begin
                case "Option Type" of
                    "option type"::"Vehicle Base":
                        ;
                    "option type"::"Manufacturer Option":
                        begin
                            recManOption.Reset;
                            recManOption.SetRange("Make Code", "Make Code");
                            recManOption.SetRange("Model Code", "Model Code");
                            recManOption.SetRange("Model Version No.", "Model Version No.");
                            recManOption.SetRange(Type, "Option Subtype");
                            if Page.RunModal(Page::"Manufacturer Options", recManOption) = Action::LookupOK then begin
                                Validate("Option Code", recManOption."Option Code");
                            end;
                        end;
                    "option type"::"Own Option":
                        begin
                            recOwnOption.Reset;
                            recOwnOption.SetRange("Make Code", "Make Code");
                            recOwnOption.SetRange("Model Code", "Model Code");

                            if Page.RunModal(Page::"Own Options", recOwnOption) = Action::LookupOK then begin
                                Validate("Option Code", recOwnOption."Option Code");
                            end;
                        end;
                    "Option Type"::Item:
                        begin
                            recItem.Reset;
                            recItem.SetRange("Item Type", recItem."Item Type"::Item);
                            if Page.RunModal(Page::"Item List", recItem) = Action::LookupOK then begin
                                Validate("Option Code", recItem."No.");
                            end;
                        end;
                    "Option Type"::Comment:
                        begin

                        end;
                end;
            end;
        }
        field(80; "External Code"; Code[50])
        {
            Caption = 'External Code';
            Editable = false;
        }
        field(90; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(100; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(110; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Editable = false;

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
                recItem.SetCurrentkey("Item Type", "Make Code", "Model Code");
                recItem.SetRange("Item Type", recItem."item type"::"Model Version");
                recItem.SetRange("Make Code", "Make Code");
                recItem.SetRange("Model Code", "Model Code");
                if Page.RunModal(Page::"Item List", recItem) = Action::LookupOK then //30.10.2012 EDMS
                 begin
                    //"Model Code" := recItem."No.";
                end;
            end;
        }
        field(120; Standard; Boolean)
        {
            Caption = 'Standard';
            Editable = false;
        }
        field(130; "Option Subtype"; Option)
        {
            Caption = 'Option Subtype';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(140; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(150; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
        }
        field(200; "User ID"; Code[50])
        {
            Caption = 'User ID';

            trigger OnLookup()
            var
                LoginMgt: Codeunit UserProfileManagement;
            begin
                LoginMgt.LookupUserID("User ID");
            end;
        }
        field(210; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(220; "Closed by Entry No."; Integer)
        {
            Caption = 'Closed by Entry No.';
            TableRelation = "Vehicle Opt. Ledger Entry";
        }
        field(230; "Cost Amount (LCY)"; Decimal)
        {
            Caption = 'Cost Amount (LCY)';
        }
        field(240; "Sales Price (LCY)"; Decimal)
        {
            Caption = 'Sales Price (LCY)';
        }
        field(250; "Sales Discount %"; Decimal)
        {
            Caption = 'Sales Discount %';
        }
        field(260; "Sales Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Sales Discount Amount (LCY)';
        }
        field(270; "Sales Amount (LCY)"; Decimal)
        {
            Caption = 'Sales Amount (LCY)';
            Editable = false;
        }
        field(280; "Assembly ID"; Code[20])
        {
            Caption = 'Assembly ID';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Posting Date")
        {
        }
        key(Key3; "Vehicle Serial No.", "Entry Type", "Option Type", "Option Code", Open)
        {
        }
    }

    fieldgroups
    {
    }
}

