Codeunit 25006120 "Service-Explode BOM EDMS"
{
    TableNo = "Service Line EDMS";

    trigger OnRun()
    var
        DimMgt: Codeunit DimensionManagement;
        Selection: Integer;
    begin

        Rec.TestField(Type, Rec.Type::Item);

        if Rec."Purch. Order Line No." <> 0 then
            Error(
              Text000,
              Rec."Purchase Order No.");

        ServiceHeader.Get(Rec."Document Type", Rec."Document No.");
        ServiceHeader.TestField(Status, ServiceHeader.Status::Open);
        FromBOMComp.SetRange("Parent Item No.", Rec."No.");


        NoOfBOMComp := FromBOMComp.Count;
        if NoOfBOMComp = 0 then
            Error(
              Text001,
              Rec."No.");

        Selection := StrMenu(Text004, 2);
        if Selection = 0 then
            exit;

        ToServLine.Reset;

        ToServLine.SetRange("Document Type", rec."Document Type");
        ToServLine.SetRange("Document No.", rec."Document No.");
        ToServLine := Rec;
        if ToServLine.Find('>') then begin
            LineSpacing := (ToServLine."Line No." - rec."Line No.") DIV (1 + NoOfBOMComp);

            if LineSpacing = 0 then
                Error(Text003);
        end else
            LineSpacing := 10000;


        if rec."Document Type" in [rec."document type"::Order] then begin

            ToServLine := Rec;
            FromBOMComp.SetRange(Type, FromBOMComp.Type::Item);
            FromBOMComp.SetFilter("No.", '<>%1', '');
            if FromBOMComp.FindSet then
                repeat
                    FromBOMComp.TestField(Type, FromBOMComp.Type::Item);
                    Item.Get(FromBOMComp."No.");
                    ToServLine."Line No." := 0;
                    ToServLine."No." := FromBOMComp."No.";
                    ToServLine."Variant Code" := FromBOMComp."Variant Code";
                    ToServLine."Unit of Measure Code" := FromBOMComp."Unit of Measure Code";
                    ToServLine."Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, FromBOMComp."Unit of Measure Code");
                until FromBOMComp.Next = 0;
        end;


        if rec."BOM Item No." = '' then
            BOMItemNo := rec."No."
        else
            BOMItemNo := rec."BOM Item No.";

        ToServLine := Rec;
        ToServLine.Init;
        ToServLine.Description := rec.Description;
        ToServLine."Description 2" := rec."Description 2";

        ToServLine."BOM Item No." := BOMItemNo;
        ToServLine.Modify;

        FromBOMComp.Reset;

        FromBOMComp.SetRange("Parent Item No.", rec."No.");
        FromBOMComp.SetFilter(Type, '<>%1', FromBOMComp.Type::Resource); //Temporary, until service don't work with resources
        FromBOMComp.FindSet;
        NextLineNo := rec."Line No.";

        repeat
            ToServLine.Init;
            NextLineNo := NextLineNo + LineSpacing;
            ToServLine."Line No." := NextLineNo;
            case FromBOMComp.Type of
                FromBOMComp.Type::" ":
                    ToServLine.Type := ToServLine.Type::Comment;
                FromBOMComp.Type::Item:
                    ToServLine.Type := ToServLine.Type::Item;
            // FromBOMComp.Type::Resource:
            // ToServLine.Type := ToServLine.Type::Resource;
            end;
            if ToServLine.Type <> ToServLine.Type::Comment then begin
                FromBOMComp.TestField("No.");
                ToServLine.Validate("No.", FromBOMComp."No.");

                if ServiceHeader."Location Code" <> rec."Location Code" then
                    ToServLine.Validate("Location Code", rec."Location Code");
                if FromBOMComp."Variant Code" <> '' then
                    ToServLine.Validate("Variant Code", FromBOMComp."Variant Code");
                if ToServLine.Type = ToServLine.Type::Item then begin
                    ToServLine."Drop Shipment" := rec."Drop Shipment";
                    Item.Get(FromBOMComp."No.");
                    ToServLine.Validate(Quantity,
                      ROUND(
                        rec."Quantity (Base)" * FromBOMComp."Quantity per" *

                        UOMMgt.GetQtyPerUnitOfMeasure(Item, FromBOMComp."Unit of Measure Code") /
                        ToServLine."Qty. per Unit of Measure",
                        0.00001));
                end else
                    ToServLine.Validate(Quantity, rec."Quantity (Base)" * FromBOMComp."Quantity per");


            end;
            if ServiceHeader."Language Code" = '' then
                ToServLine.Description := FromBOMComp.Description
            else
                if not ItemTranslation.Get(FromBOMComp."No.", FromBOMComp."Variant Code", ServiceHeader."Language Code") then
                    ToServLine.Description := FromBOMComp.Description;

            ToServLine."BOM Item No." := BOMItemNo;
            ToServLine.Insert;

            if Selection = 1 then begin

                ToServLine."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                ToServLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";

                ToServLine.Modify;


            end;
        until FromBOMComp.Next = 0;
    end;

    var
        Text000: label 'The BOM cannot be exploded on the sales lines because it is associated with purchase order %1.';
        Text001: label 'Item %1 is not a bill of materials.';
        Text003: label 'There is not enough space to explode the BOM.';
        Text004: label '&Copy dimensions from BOM,&Retrieve dimensions from components';
        ToServLine: Record "Service Line EDMS";
        FromBOMComp: Record "BOM Component";
        ServiceHeader: Record "Service Header EDMS";
        ItemTranslation: Record "Item Translation";
        Item: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        BOMItemNo: Code[20];
        LineSpacing: Integer;
        NextLineNo: Integer;
        NoOfBOMComp: Integer;
}

