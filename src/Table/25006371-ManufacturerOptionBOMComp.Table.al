Table 25006371 "Manufacturer Option BOM Comp."
{
    Caption = 'Manufacturer Option BOM Component';
    DrillDownPageID = "Manufacturer Option BOM Comp.";
    LookupPageID = "Manufacturer Option BOM Comp.";

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));

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
                    "Model Code" := recItem."No.";
                end;
            end;
        }
        field(30; "Parent Option Code"; Code[50])
        {
            Caption = 'Parent Option Code';
            NotBlank = true;
            TableRelation = "Manufacturer Option"."Option Code" where("Make Code" = field("Make Code"),
                                                                       "Model Code" = field("Model Code"),
                                                                       "Model Version No." = field("Model Version No."),
                                                                       Type = const(Option));
        }
        field(40; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(45; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(50; "Option Code"; Code[50])
        {
            Caption = 'Option Code';
            TableRelation = "Manufacturer Option"."Option Code" where("Make Code" = field("Make Code"),
                                                                       "Model Code" = field("Model Code"),
                                                                       "Model Version No." = field("Model Version No."),
                                                                       Type = field(Type));
        }
        field(60; "Bill of Materials"; Boolean)
        {
            CalcFormula = exist("Manufacturer Option BOM Comp." where("Make Code" = field("Make Code"),
                                                                       "Model Code" = field("Model Code"),
                                                                       "Model Version No." = field("Model Version No."),
                                                                       "Parent Option Code" = field("Option Code")));
            Caption = 'Bill of Materials';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(80; "BOM Description"; Text[30])
        {
            Caption = 'BOM Description';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Make Code", "Model Code", "Model Version No.", "Parent Option Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

