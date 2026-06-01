Table 25006387 "Vehicle Opt. Jnl. Line"
{
    // 11.04.2013 EDMS P8
    //   * Renamed field 'Manuf. Option Type' to 'Option Subtype'
    // 
    // 19.06.2004 EDMS P1
    //    * Created

    Caption = 'Vehicle Option Jnl. Line';
    DrillDownPageID = "Vehicle Opt. Jnl. Lines";
    LookupPageID = "Vehicle Opt. Jnl. Lines";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Vehicle Opt. Jnl. Template";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
            begin
                Validate("Document Date", "Posting Date");
            end;
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Assemble,Disassemble';
            OptionMembers = Assemble,Disassemble;
        }
        field(10; Correction; Boolean)
        {
            Caption = 'Correction';

            trigger OnValidate()
            begin
                Validate("Applies-to Entry", 0);
            end;
        }
        field(41; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Vehicle Opt. Jnl. Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(42; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(43; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
        }
        field(50; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(140; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
        field(145; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
        }
        field(150; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
                if "Vehicle Serial No." = '' then begin
                    Validate("Make Code", '');
                    Validate("Model Code", '');
                    Validate("Model Version No.", '');
                end
                else begin
                    Vehicle.Get("Vehicle Serial No.");
                    Validate("Make Code", Vehicle."Make Code");
                    Validate("Model Code", Vehicle."Model Code");
                    Validate("Model Version No.", Vehicle."Model Version No.");
                end;
            end;
        }
        field(160; "Option Type"; Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Manufacturer Option,Own Option,Vehicle Base,Item,Comment';
            OptionMembers = "Manufacturer Option","Own Option","Vehicle Base","Item","Comment";
        }
        field(170; "Option Code"; Code[50])
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

            trigger OnValidate()
            var
                recManOption: Record "Manufacturer Option";
                recItem: Record Item;
                recOwnOption: Record "Own Option";
            begin
                if "Option Code" = '' then
                    exit;

                case "Option Type" of
                    "option type"::"Manufacturer Option":
                        begin
                            recManOption.Reset;
                            recManOption.Get("Make Code", "Model Code", "Model Version No.", "Option Subtype", "Option Code");
                            Validate(Description, recManOption.Description);
                            Validate("Description 2", recManOption."Description 2");
                            Validate("Option Subtype", recManOption.Type);
                            Validate(Standard, recManOption.Standard);
                            Validate("External Code", recManOption."External Code");
                        end;
                    "option type"::"Own Option":
                        begin
                            recOwnOption.Reset;
                            recOwnOption.Get("Make Code", "Model Code", "Option Code");
                            Validate(Description, recOwnOption.Description);
                            Validate("Description 2", recOwnOption."Description 2");
                        end;
                    "option type"::Item:
                        begin
                            recItem.Reset;
                            If StrLen("Option Code") > MaxStrLen(recItem."No.") then
                                Error(Text007, MaxStrLen(recItem."No."));
                            if recItem.Get("Option Code") then begin
                                Validate(Description, recItem.Description);
                                Validate("Description 2", recItem."Description 2");
                            end;
                        end;
                end;
            end;
        }
        field(180; "External Code"; Code[50])
        {
            Caption = 'External Code';
        }
        field(190; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(200; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(210; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';

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
                    "Model Version No." := recItem."No.";
                end;
            end;
        }
        field(230; Standard; Boolean)
        {
            Caption = 'Standard';
            Editable = false;
        }
        field(240; "Option Subtype"; Option)
        {
            Caption = 'Option Subtype';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(250; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(260; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
        }
        field(270; "Applies-to Entry"; Integer)
        {
            Caption = 'Applies-to Entry';
            TableRelation = "Vehicle Opt. Ledger Entry"."Entry No." where("Vehicle Serial No." = field("Vehicle Serial No."));

            trigger OnValidate()
            var
                recVehOptLedgEntry: Record "Vehicle Opt. Ledger Entry";
            begin
                if "Applies-to Entry" <> 0 then begin
                    recVehOptLedgEntry.Get("Applies-to Entry");
                    recVehOptLedgEntry.TestField(Open, true);
                end
            end;
        }
        field(280; "Assembly ID"; Code[20])
        {
            Caption = 'Assembly ID';
        }
        field(290; "Cost Amount (LCY)"; Decimal)
        {
            Caption = 'Cost Amount (LCY)';
        }
        field(300; "Update Sales Amounts"; Boolean)
        {
            Caption = 'Update Sales Amounts';
        }
        field(310; "Sales Price (LCY)"; Decimal)
        {
            Caption = 'Sales Price (LCY)';
            Editable = false;
        }
        field(320; "Sales Discount %"; Decimal)
        {
            Caption = 'Sales Discount %';
            Editable = false;
        }
        field(330; "Sales Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Sales Discount Amount (LCY)';
            Editable = false;
        }
        field(340; "Sales Amount (LCY)"; Decimal)
        {
            Caption = 'Sales Amount (LCY)';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //JnlLineDim.LOCKTABLE; //26.10.2012 EDMS
        LockTable;
        recVehOptJnlTemplate.Get("Journal Template Name");
        recVehOptJnlBatch.Get("Journal Template Name", "Journal Batch Name");
    end;

    var
        recVehOptJnlTemplate: Record "Vehicle Opt. Jnl. Template";
        recVehOptJnlBatch: Record "Vehicle Opt. Jnl. Batch";
        recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line";
        recItem: Record Item;
        cuNoSeriesMgt: Codeunit "No. Series";
        recNonstockItem: Record "Nonstock Item";
        Text007: Label 'Item No. must not exceed %1 number of characters';


    procedure fSetUpNewLine(recLastVehOptJnlLine: Record "Vehicle Opt. Jnl. Line")
    begin

        recVehOptJnlTemplate.Get("Journal Template Name");
        recVehOptJnlBatch.Get("Journal Template Name", "Journal Batch Name");
        recVehOptJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        recVehOptJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if recVehOptJnlLine.FindFirst then begin
            "Posting Date" := recLastVehOptJnlLine."Posting Date";
            "Document Date" := recLastVehOptJnlLine."Posting Date";
            "Document No." := recLastVehOptJnlLine."Document No.";
        end else begin
            "Posting Date" := WorkDate;
            "Document Date" := WorkDate;
            if recVehOptJnlBatch."No. Series" <> '' then begin
                Clear(cuNoSeriesMgt);
                "Document No." := cuNoSeriesMgt.PeekNextNo(recVehOptJnlBatch."No. Series", "Posting Date");
            end;
        end;
        "Source Code" := recVehOptJnlTemplate."Source Code";
    end;
}

