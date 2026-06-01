tableextension 25006058 "Item Substitution" extends "Item Substitution" //5715
{
    // 10.10.2018 EB.RC DE012WAE3-15
    //   Fields added:
    //     Entry Type option added "Discontinued"
    // 
    // 23.05.2016 EB.RC POD.DMS.Parts P439.PAR28
    //   Fields added:
    //     25006070Superseding Quantity
    //     25006080Condition Group
    // 
    // 10.05.2016 EB.P7 #PAR_28
    //   Fields added
    //     Superseding Quantity
    //     Condition Group
    // 
    // 05.05.2016 EB.P7 #PAR_96
    //   OnInsert Trigger modified
    // 
    // 01.04.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Fixed bug. Disabled call of ItemSubSync.Functions:
    //     - InsertItemSub
    //     - ModifyItemSub
    //     - DeleteItemSub
    //     - RenameItemSub
    // 
    // 27.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added field: Posting Date
    // 
    // 25.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Changed "Type" - OnValidate trigger
    // 
    // 20.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Changed "Substitute Type" - OnValidate
    //   * Changed "Substitute No." - OnValidate
    //   * Modified function SetItemVariantDescription
    // 
    // 19.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added field: "Entry Type" - Option: Substitution, Replacement
    // 
    // 24.02.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added F:MakeItemReplmntOneToOne
    // 
    // 08.04.2008. EDMS P2
    //   * Added new function DontDeleteInterchangableItem
    //   * Added new global variable DontDelete
    // 
    // 17.10.2007. EDMS P2
    //   * Added field Substitute
    // 
    // 16.10.2007. EDMS P2
    //   * Added code OnInsert, OnModify, OnDelete, OnRename
    fields
    {
        field(25006000; "Replacement Info."; Option)
        {
            Caption = 'Replacement Info.';
            OptionCaption = ' ,Replaced by,Replaces';
            OptionMembers = " ",Replace,Replacement;

            trigger OnValidate()
            begin
                //17.10.2007. EDMS P2 >>
                if "Replacement Info." <> xRec."Replacement Info." then
                    //19.03.2014 Elva Baltiv P15 #F124 MMG7.00 >>
                    if "Replacement Info." = "replacement info."::" " then
                        "Entry Type" := "entry type"::Substitution
                    else
                        "Entry Type" := "entry type"::Replacement;
                //19.03.2014 Elva Baltiv P15 #F124 MMG7.00 <<

                if ItemSub.Get("Substitute Type", "Substitute No.", "Substitute Variant Code",
                              Type, "No.", "Variant Code")
                then begin
                    if "Replacement Info." = "replacement info."::" " then begin
                        ItemSub."Replacement Info." := ItemSub."replacement info."::" ";
                        ItemSub."Entry Type" := ItemSub."entry type"::Substitution; //19.03.2014 Elva Baltiv P15 #F124 MMG7.00
                        ItemSub.Modify;
                    end;
                    if "Replacement Info." = "replacement info."::Replace then begin
                        ItemSub."Replacement Info." := ItemSub."replacement info."::Replacement;
                        ItemSub."Entry Type" := ItemSub."entry type"::Replacement; //19.03.2014 Elva Baltiv P15 #F124 MMG7.00
                        ItemSub.Modify;
                    end;
                    if "Replacement Info." = "replacement info."::Replacement then begin
                        ItemSub."Replacement Info." := ItemSub."replacement info."::Replace;
                        ItemSub."Entry Type" := ItemSub."entry type"::Replacement; //19.03.2014 Elva Baltiv P15 #F124 MMG7.00
                        ItemSub.Modify;
                    end;
                end;

                //17.10.2007. EDMS P2 <<
            end;
        }
        field(25006001; "EDMS Interchangeable"; Boolean)
        {
            Caption = 'Interchangeable';

            trigger OnValidate()
            begin
                TestField("No.");
                TestField("Substitute No.");
                if not "EDMS Interchangeable" then
                    DeleteInterchangeableItem(Type, "No.", "Variant Code", "Substitute Type", "Substitute No.", "Substitute Variant Code")
                else
                    CreateInterchangeableItem();
                Interchangeable := "EDMS Interchangeable";
            end;
        }
        field(25006020; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(25006030; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(25006040; "Reserved Qty. on Inventory"; Decimal)
        {
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("Substitute No."),
                                                                           "Source Type" = const(32),
                                                                           "Source Subtype" = const(0),
                                                                           "Reservation Status" = const(Reservation),
                                                                           "Location Code" = field("Location Filter")));
            Caption = 'Reserved Qty. on Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006050; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            Description = 'P15';
            OptionCaption = 'Substitution,Replacement,Discontinued';
            OptionMembers = Substitution,Replacement,Discontinued;

            trigger OnValidate()
            begin
                if Rec."Entry Type" <> xRec."Entry Type" then
                    if "Entry Type" = "entry type"::Substitution then
                        Validate("Replacement Info.", "replacement info."::" ");
            end;
        }
        field(25006060; "Posting Date"; Date)
        {
            Description = 'P15';
        }
        field(25006070; "Superseding Quantity"; Decimal)
        {
            Caption = 'Superseding Quantity';
            Description = 'Replacement Qty';
        }
        field(25006080; "Condition Group"; Text[50])
        {
            Caption = 'Condition Group';
            Description = 'Replacment Condition Group';
        }


        field(25006100; "EDMS Inventory"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Substitute No."),
                                                                  "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                  "Location Code" = field("Location Filter")));
            Caption = 'EDMS Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }


        modify("Substitute No.")
        {
            trigger OnBeforeValidate()
            var
                ItemSubstitution: Record "Item Substitution";
            begin
                if (Type = "Substitute Type") and
                                  ("No." = "Substitute No.") and
                                  //20.03.2014 Elva Baltic P15 #F124 MMG7.00 >>
                                  //("Variant Code" = "Substitute Variant Code")
                                  ("Variant Code" = "Substitute Variant Code") and
                                  ("No." <> '')
                               //20.03.2014 Elva Baltic P15 #F124 MMG7.00 <<
                               then
                    Error(Text000);
                if "Substitute No." <> xRec."Substitute No." then
                    if "EDMS Interchangeable" then begin
                        ItemSubstitution.Type := Type;
                        ItemSubstitution."No." := "No.";
                        ItemSubstitution."Variant Code" := "Variant Code";
                        ItemSubstitution."Substitute Type" := "Substitute Type";
                        ItemSubstitution."Substitute No." := xRec."Substitute No.";
                        ItemSubstitution."Substitute Variant Code" := "Substitute Variant Code";
                        if ItemSubstitution.Find() then begin
                            "EDMS Interchangeable" := false;
                        end;
                    end;
            END;
        }
        modify("Substitute Type")
        {
            trigger OnBeforeValidate()
            begin
                if (Type = "Substitute Type") and
                   ("No." = "Substitute No.") and
                   //20.03.2014 Elva Baltic P15 #F124 MMG7.00 >>
                   //("Variant Code" = "Substitute Variant Code")
                   ("Variant Code" = "Substitute Variant Code") and
                   ("No." <> '')
                //20.03.2014 Elva Baltic P15 #F124 MMG7.00 <<
                then
                    Error(Text000);
            END;
        }
    }
    trigger OnInsert()
    begin
        //16.10.2007. EDMS P2 >>
        //ItemSubSync.InsertItemSub(Rec); //01.04.2014 Elva Baltic P15 #F124 MMG7.00
        //16.10.2007. EDMS P2 <<
        //05.05.2016 EB.P7 #PAR_96 >>
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate;
        //05.05.2016 EB.P7 #PAR_96 <<
    end;

    var
        Text000: Label 'You can not set up an item to be substituted by itself.';
        DontDelete: Boolean;
        ItemSubSync: Codeunit "Item Substitution Sync";
        ItemSub: Record "Item Substitution";
        SubCondition: Record "Substitution Condition";

    procedure DeleteInterchangeableItem(XType: Enum "Item Substitute Type"; XNo: Code[20]; XVariantCode: Code[10]; XSubstType: Enum "Item Substitution Type"; XSubstNo: Code[20]; XSubstVariantCode: Code[10])
    var
        ItemSubstitution: Record "Item Substitution";
    begin
        ItemSubstitution.Type := XSubstType;
        ItemSubstitution."No." := XSubstNo;
        ItemSubstitution."Variant Code" := XSubstVariantCode;
        ItemSubstitution."Substitute Type" := XType;
        ItemSubstitution."Substitute No." := XNo;
        ItemSubstitution."Substitute Variant Code" := XVariantCode;
        if ItemSubstitution.Find then begin
            ItemSubstitution.CalcFields(Condition);
            if ItemSubstitution.Condition then begin
                SubCondition.SetRange(Type, XType);
                SubCondition.SetRange("No.", XNo);
                SubCondition.SetRange("Variant Code", XVariantCode);
                SubCondition.SetRange("Substitute Type", XSubstType);
                SubCondition.SetRange("Substitute No.", XSubstNo);
                SubCondition.SetRange("Substitute Variant Code", XSubstVariantCode);
                SubCondition.DeleteAll();
            end;
            ItemSubstitution.Delete();
            "EDMS Interchangeable" := false;
            Interchangeable := false;
        end;
    end;

    procedure CreateInterchangeableItem()
    var
        ItemSubstitution: Record "Item Substitution";
    begin
        ItemSubstitution.Type := "Substitute Type";
        ItemSubstitution."No." := "Substitute No.";
        ItemSubstitution."Variant Code" := "Substitute Variant Code";
        ItemSubstitution."Substitute Type" := Type;
        ItemSubstitution."Substitute No." := "No.";
        ItemSubstitution."Substitute Variant Code" := "Variant Code";
        SetDescription(Type.AsInteger(), "No.", Description);
        ItemSubstitution."Interchangeable" := true;
        ItemSubstitution."EDMS Interchangeable" := true;

        //17.10.2007. EDMS P2 >>
        ItemSubstitution."Entry Type" := "Entry Type";      // 19.03.2014 Elva Baltic P15 #F124 MMG7.00
        ItemSubstitution."Posting Date" := "Posting Date";  // 27.03.2014 Elva Baltic P15 #F124 MMG7.00
        if "Replacement Info." = "replacement info."::Replace then
            ItemSubstitution."Replacement Info." := ItemSubstitution."replacement info."::Replacement;
        if "Replacement Info." = "replacement info."::Replacement then
            ItemSubstitution."Replacement Info." := ItemSubstitution."replacement info."::Replace;
        //17.10.2007. EDMS P2 <<

        if ItemSubstitution.Find then
            ItemSubstitution.Modify
        else
            ItemSubstitution.Insert();
    end;

    procedure DontDeleteInterchangeableItem()
    begin
        DontDelete := true;
    end;

    procedure CreateReplacement(Type1: Option Item,"Nonstock Item"; No1: Code[20]; VariantCode1: Code[10]; Type2: Option Item,"Nonstock Item"; No2: Code[20]; VariantCode2: Code[10]; InterchangeablePar: Boolean) RetVal: Boolean
    begin
        RetVal := false;
        Init;
        Type := Type1;
        "No." := No1;
        "Variant Code" := VariantCode1;

        "Substitute Type" := Type2;
        Validate("Substitute No.", No2);
        "Substitute Variant Code" := VariantCode2;
        "Entry Type" := "entry type"::Replacement;
        "Replacement Info." := "replacement info."::Replace;
        "Posting Date" := WorkDate;

        if not Insert(true) then
            Modify(true);

        if InterchangeablePar then begin
            Validate("EDMS Interchangeable", InterchangeablePar);
            Modify(true);
        end;
        RetVal := true;
    end;
}