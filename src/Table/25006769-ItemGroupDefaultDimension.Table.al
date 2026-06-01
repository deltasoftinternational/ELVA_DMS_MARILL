Table 25006769 "Item Group Default Dimension"
{
    // 06.12.2017 EB.P7 #T007
    //   Removed field "Product Subgroup Code"
    // 
    // 05.06.2015 EB.P21 #T0047
    //   Added "Dimension Code" to primary key
    // 
    // 10.05.2007 EDMS P2
    //   * Added fields: "Product Group Code" and "Product Subgroup Code"
    //   * Changed primary key
    //   * Added function "FillItemCategoryDim"

    Caption = 'Item Group Default Dimension';

    fields
    {
        field(10; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(15; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
        }
        field(20; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension;
        }
        field(30; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code"));
        }
    }

    keys
    {
        key(Key1; "Item Category Code", "Dimension Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure FillItemCategoryDim(Item: Record Item; Item2: Record Item)
    var
        recDefDim: Record "Default Dimension";
        recInvSetup: Record "Inventory Setup";
    begin
        recInvSetup.Get;
        if not recInvSetup."Fill Item Group Def. Dimension" then
            exit;

        if Get(Item2."Item Category Code")
          and ("Dimension Value Code" <> '') then begin
            recDefDim.Reset;
            recDefDim.SetRange("Table ID", Database::Item);
            recDefDim.SetRange("No.", Item2."No.");
            recDefDim.SetRange("Dimension Code", "Dimension Code");
            if recDefDim.FindSet then
                recDefDim.Delete;
        end;

        if (not Get(Item."Item Category Code"))
          or ("Dimension Value Code" = '') then
            exit;

        recDefDim.Reset;
        recDefDim.SetRange("Table ID", Database::Item);
        recDefDim.SetRange("No.", Item."No.");
        recDefDim.SetRange("Dimension Code", "Dimension Code");
        if recDefDim.FindSet then begin
            recDefDim."Dimension Value Code" := "Dimension Value Code";
            recDefDim."Value Posting" := recDefDim."value posting"::" ";
            recDefDim.Modify;
        end
        else begin
            recDefDim.Init;
            recDefDim."Table ID" := Database::Item;
            recDefDim."No." := Item."No.";
            recDefDim."Dimension Code" := "Dimension Code";
            recDefDim."Dimension Value Code" := "Dimension Value Code";
            recDefDim."Value Posting" := recDefDim."value posting"::" ";
            recDefDim.Insert;
        end;
    end;
}

