Table 25006374 "Manufacturer Option Condition"
{
    // 11.04.2013 EDMS P8
    //   * added field Type. That field added to primary code.

    Caption = 'Manufacturer Option Condition';

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                if ("Make Code" <> xRec."Make Code") and (xRec."Make Code" <> '') and
                   ("Condition Option Code" <> '') and ("Option Code" <> '')
                then begin
                    DeleteConnectiveEntries(xRec."Make Code", "Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                    CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                end;
            end;
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));

            trigger OnValidate()
            begin
                if ("Model Code" <> xRec."Model Code") and (xRec."Model Code" <> '') and
                   ("Condition Option Code" <> '') and ("Option Code" <> '')
                then begin
                    DeleteConnectiveEntries("Make Code", xRec."Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                    CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                end;
            end;
        }
        field(25; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));

            trigger OnLookup()
            var
                Item: Record Item;
            begin
                Item.SetCurrentkey("Item Type", "Make Code", "Model Code");
                Item.SetRange("Item Type", Item."item type"::"Model Version");
                Item.SetRange("Make Code", "Make Code");
                Item.SetRange("Model Code", "Model Code");
                if Page.RunModal(Page::"Item List", Item) = Action::LookupOK then //30.10.2012 EDMS
                 begin
                    "Model Code" := Item."No.";
                end;
            end;

            trigger OnValidate()
            begin
                if ("Model Version No." <> xRec."Model Version No.") and (xRec."Model Version No." <> '') and
                   ("Condition Option Code" <> '') and ("Option Code" <> '')
                then begin
                    DeleteConnectiveEntries("Make Code", "Model Code", xRec."Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                    CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                end;
            end;
        }
        field(26; "Option Type"; Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(30; "Option Code"; Code[50])
        {
            Caption = 'Option Code';
            TableRelation = "Manufacturer Option"."Option Code" where("Make Code" = field("Make Code"),
                                                                       "Model Code" = field("Model Code"),
                                                                       "Model Version No." = field("Model Version No."),
                                                                       Type = field("Option Type"));

            trigger OnValidate()
            begin
                if ("Option Code" <> xRec."Option Code") and (xRec."Option Code" <> '') and
                   ("Condition Option Code" <> '') and ("Option Code" <> '')
                then begin
                    DeleteConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", xRec."Option Type", xRec."Option Code");
                    CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                end;
            end;
        }
        field(35; "Option Description"; Text[250])
        {
            CalcFormula = lookup("Manufacturer Option".Description where("Make Code" = field("Make Code"),
                                                                          "Model Code" = field("Model Code"),
                                                                          "Model Version No." = field("Model Version No."),
                                                                          "Option Code" = field("Option Code")));
            Caption = 'Option Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50; "Option External Code"; Code[50])
        {
            CalcFormula = lookup("Manufacturer Option"."External Code" where("Make Code" = field("Make Code"),
                                                                              "Model Code" = field("Model Code"),
                                                                              "Model Version No." = field("Model Version No.")));
            Caption = 'Option External Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Condition Type"; Option)
        {
            Caption = 'Condition Type';
            OptionCaption = 'Only with,Not with';
            OptionMembers = "Only with","Not with";

            trigger OnValidate()
            begin
                if ("Condition Type" <> xRec."Condition Type") and
                   ("Condition Option Code" <> '') and ("Option Code" <> '')
                then begin
                    DeleteConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", xRec."Condition Type", "Option Type", "Option Code");
                    CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                end;
            end;
        }
        field(76; "Condition Option Type"; Option)
        {
            Caption = 'Condition Option Type';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(80; "Condition Option Code"; Code[20])
        {
            Caption = 'Condition Option Code';
            TableRelation = "Manufacturer Option"."Option Code" where("Make Code" = field("Make Code"),
                                                                       "Model Code" = field("Model Code"),
                                                                       "Model Version No." = field("Model Version No."));

            trigger OnValidate()
            var
                ManufacturerOptionCondition: Record "Manufacturer Option Condition";
            begin
                if ("Condition Option Code" <> xRec."Condition Option Code") and
                   ("Condition Option Code" <> '') and ("Option Code" <> '')
                then begin
                    DeleteConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                            xRec."Condition Option Type", xRec."Condition Option Code", "Condition Type", "Option Type", "Option Code");
                    CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                end;
            end;
        }
        field(85; "Condition Option Description"; Text[250])
        {
            CalcFormula = lookup("Manufacturer Option".Description where("Make Code" = field("Make Code"),
                                                                          "Model Code" = field("Model Code"),
                                                                          "Model Version No." = field("Model Version No."),
                                                                          "Option Code" = field("Condition Option Code")));
            Caption = 'Condition Option Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Make Code", "Model Code", "Model Version No.", "Option Type", "Option Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DeleteConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
    end;


    procedure CreateConnectiveEntries(MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionNo: Code[20]; OptionType: Integer; OptionCode: Code[20]; ConditionType: Integer; ConditionOptionType: Integer; ConditionOptionCode: Code[20])
    var
        Condition: Record "Manufacturer Option Condition";
        LineNo: Integer;
    begin
        if ConditionType <> "condition type"::"Not with" then
            exit;
        Condition.Reset;
        Condition.SetRange("Make Code", MakeCode);
        Condition.SetRange("Model Code", ModelCode);
        Condition.SetRange("Model Version No.", ModelVersionNo);
        Condition.SetRange("Option Type", OptionType);
        Condition.SetRange("Option Code", OptionCode);
        if Condition.FindLast then
            LineNo := Condition."Line No." + 10000
        else
            LineNo := 10000;

        Condition.Init;
        Condition."Make Code" := MakeCode;
        Condition."Model Code" := ModelCode;
        Condition."Model Version No." := ModelVersionNo;
        Condition."Option Type" := OptionType;
        Condition."Option Code" := OptionCode;
        Condition."Line No." := LineNo;
        Condition."Condition Type" := ConditionType;
        Condition."Condition Option Type" := ConditionOptionType;
        Condition."Condition Option Code" := ConditionOptionCode;
        if Condition.Insert then;
    end;


    procedure DeleteConnectiveEntries(MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionNo: Code[20]; OptionType: Integer; OptionCode: Code[20]; ConditionType: Integer; ConditionOptionType: Integer; ConditionOptionCode: Code[20])
    var
        Condition: Record "Manufacturer Option Condition";
    begin
        Condition.SetRange("Make Code", MakeCode);
        Condition.SetRange("Model Code", ModelCode);
        Condition.SetRange("Model Version No.", ModelVersionNo);
        Condition.SetRange("Option Type", OptionType);
        Condition.SetRange("Option Code", OptionCode);
        Condition.SetRange("Condition Type", ConditionType);
        Condition.SetRange("Condition Option Type", ConditionOptionType);
        Condition.SetRange("Condition Option Code", ConditionOptionCode);
        Condition.DeleteAll;
    end;
}

