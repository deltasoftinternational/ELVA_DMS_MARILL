Table 25006375 "Option Translation"
{
    // 11.04.2013 EDMS P8
    //   * added field 'Option Subtype', to primary as well

    Caption = 'Option Translation';
    LookupPageID = "Option Translations";

    fields
    {
        field(10; "Option Type"; Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Manufacturer Option,Own Option';
            OptionMembers = "Manufacturer Option","Own Option","Vehicle Base";
        }
        field(20; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(30; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(40; "Model Version No."; Code[20])
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
                    "Model Code" := recItem."No.";
                end;
            end;
        }
        field(45; "Option Subtype"; Option)
        {
            Caption = 'Option Subtype';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(50; "Option Code"; Code[50])
        {
            Caption = 'Option Code';
            TableRelation = if ("Option Type" = const("Manufacturer Option")) "Manufacturer Option"."Option Code" where("Make Code" = field("Make Code"),
                                                                                                                       "Model Code" = field("Model Code"),
                                                                                                                       "Model Version No." = field("Model Version No."),
                                                                                                                       Type = field("Option Subtype"))
            else
            if ("Option Type" = const("Vehicle Base")) Item."No." where("Item Type" = const("Model Version"))
            else
            if ("Option Type" = const("Own Option")) "Own Option"."Option Code" where("Make Code" = field("Make Code"),
                                                                                                                                                                                                     "Model Code" = field("Model Code"));
        }
        field(200; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            NotBlank = true;
            TableRelation = Language;
        }
        field(300; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(400; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
        }
    }

    keys
    {
        key(Key1; "Option Type", "Make Code", "Model Code", "Model Version No.", "Option Subtype", "Option Code", "Language Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField("Make Code");
        TestField("Model Code");
        if "Option Type" = "option type"::"Manufacturer Option" then
            TestField("Model Version No.");
        TestField("Option Code");
        TestField("Language Code");
    end;
}

