table 25006633 "Rent Asset Component"
{
    Caption = 'Rent Asset Component';

    fields
    {
        field(1; "Main Asset No."; Code[20])
        {
            Caption = 'Main Asset No.';
            Editable = false;
            NotBlank = true;
            TableRelation = "Rent Asset";

            trigger OnValidate()
            begin
                if (Rec."Main Asset No." <> xRec."Main Asset No.") then
                    Validate("Rent Asset No.", '');
            end;
        }
        field(3; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            NotBlank = true;
            TableRelation = "Rent Asset";

            trigger OnValidate()
            begin
                if ("Rent Asset No." = '') or ("Main Asset No." = '') then begin
                    if ("Rent Asset No." = '') and (xRec."Rent Asset No." <> '') then begin
                        RentAsset.Get(xRec."Rent Asset No.");
                        UpdateMainAsset(RentAsset, 0);
                    end;


                end else begin
                    RentAsset.Get("Main Asset No.");
                    if RentAsset."Rent Item Category Code" <> '' then begin
                        RentItemCategory.get(RentAsset."Rent Item Category Code");
                        If RentItemCategory."Only as Child Asset" then
                            Error(Text005, "Main Asset No.");
                    end;

                    RentAsset.Get("Rent Asset No.");
                    if RentAsset."Rent Item Category Code" <> '' then begin
                        RentItemCategory.get(RentAsset."Rent Item Category Code");
                        If RentItemCategory."Only as Main Asset" then
                            Error(Text006, "Rent Asset No.");
                    end;

                    RentAssetComp.reset;
                    RentAssetComp.SetRange("Rent Asset No.", "Rent Asset No.");
                    RentAssetComp.SetFilter("Main Asset No.", '<>%1', Rec."Main Asset No.");
                    if RentAssetComp.FindFirst then
                        Error(Text007, "Rent Asset No.", RentAssetComp."Main Asset No.");

                    if "Rent Asset No." = "Main Asset No." then
                        CreateError("Rent Asset No.", 1);
                    Description := RentAsset.Description;
                    RentAssetComp.SetRange("Main Asset No.", "Rent Asset No.");
                    if RentAssetComp.FindFirst then
                        CreateError("Rent Asset No.", 1);
                    RentAssetComp.SetRange("Main Asset No.");
                    RentAssetComp.SetCurrentKey("Rent Asset No.");
                    RentAssetComp.SetRange("Rent Asset No.", "Rent Asset No.");
                    if RentAssetComp.FindFirst then
                        CreateError("Rent Asset No.", 2);
                    RentAssetComp.SetRange("Rent Asset No.", "Main Asset No.");
                    if RentAssetComp.FindFirst then
                        CreateError("Main Asset No.", 2);
                    UpdateMainAsset(RentAsset, 2);
                    RentAsset.Get("Main Asset No.");
                    if RentAsset."Main Asset/Component" <> RentAsset."Main Asset/Component"::"Main Asset" then begin
                        RentAsset."Main Asset/Component" := RentAsset."Main Asset/Component"::"Main Asset";
                        Error(
                          Text001,
                          "Main Asset No.", RentAsset."Main Asset/Component");
                    end;
                end;

            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Main Asset No.", "Rent Asset No.")
        {
            Clustered = true;
        }
        key(Key2; "Rent Asset No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Rent Asset No." <> '' then begin
            RentAsset.Get("Rent Asset No.");
            If RentAsset.Status = RentAsset.Status::Rented then
                Error(Text004);
            UpdateMainAsset(RentAsset, 0);
        end;
    end;

    trigger OnRename()
    begin
        Error(Text000, TableCaption);
    end;

    trigger OnInsert()
    begin

    end;

    var
        Text000: Label 'You cannot rename a %1.';
        Text001: Label '%1 is not a %2.';
        Text002: Label '%1 is a %2.';
        RentAsset: Record "Rent Asset";
        RentAssetComp: Record "Rent Asset Component";
        RentItemCategory: Record "Rent Item Category";
        Text003: Label 'Main Asset,Component';
        Text004: Label 'You cannot remove a componnent while it is still rented';
        Text005: Label 'Asset %1 can be only as Child Asset';
        Text006: Label 'Asset %1 can be only as Main Asset';
        Text007: Label 'Asset %1 is already linked to Main Asset %2';
        Text008: Label 'You cannot set %1 as Main Asset, because it is already set as Component';

    local procedure UpdateMainAsset(var RentAsset: Record "Rent Asset"; ComponentType: Option " ","Main Asset",Component)
    var
        RentAsset2: Record "Rent Asset";
    begin
        if ComponentType = ComponentType::" " then begin
            if RentAsset."No." <> RentAsset."Component of Main Asset" then begin
                RentAssetComp.Reset;
                RentAssetComp.SetRange("Main Asset No.", RentAsset."Component of Main Asset");
                RentAssetComp.SetFilter("Rent Asset No.", '<>%1', RentAsset."No.");
                if not RentAssetComp.FindFirst then begin
                    RentAsset2.Get(RentAsset."Component of Main Asset");
                    RentAsset2."Main Asset/Component" := RentAsset."Main Asset/Component"::" ";
                    RentAsset2."Component of Main Asset" := '';
                    RentAsset2.Modify(true);
                end;
            end;
            RentAsset."Main Asset/Component" := RentAsset."Main Asset/Component"::" ";
            RentAsset."Component of Main Asset" := '';
        end;
        if ComponentType = ComponentType::Component then begin
            RentAsset2.Get("Main Asset No.");
            if RentAsset2."Main Asset/Component" = RentAsset2."Main Asset/Component"::Component then
                Error(Text008, "Main Asset No.");
            RentAsset2."Main Asset/Component" := RentAsset."Main Asset/Component"::"Main Asset";
            RentAsset2."Component of Main Asset" := "Main Asset No.";
            RentAsset2.Modify(true);

            RentAsset."Component of Main Asset" := "Main Asset No.";
            RentAsset."Main Asset/Component" := RentAsset."Main Asset/Component"::Component;
        end;
        RentAsset.Modify(true);


        /*RentAsset.Reset();
        RentAsset.SetCurrentKey("Component of Main Asset");
        RentAsset.SetRange("Component of Main Asset", "Main Asset No.");
        RentAsset.SetRange("Main Asset/Component", RentAsset2."Main Asset/Component"::Component);
        RentAsset2.Get("Main Asset No.");
        if RentAsset.Find('=><') then begin
            if RentAsset2."Main Asset/Component" <> RentAsset2."Main Asset/Component"::"Main Asset" then begin
                RentAsset2."Main Asset/Component" := RentAsset2."Main Asset/Component"::"Main Asset";
                RentAsset2."Component of Main Asset" := RentAsset2."No.";
                RentAsset2.Modify(true);
            end;
        end else begin
            RentAsset2."Main Asset/Component" := RentAsset2."Main Asset/Component"::" ";
            RentAsset2."Component of Main Asset" := '';
            RentAsset2.Modify(true);
        end;*/
    end;

    local procedure CreateError(RentAssetNo: Code[20]; MainAssetComponent: Option " ","Main Asset",Component)
    begin
        RentAsset."No." := RentAssetNo;
        Error(
          Text002,
          RentAssetNo, SelectStr(MainAssetComponent, Text003));
    end;
}

