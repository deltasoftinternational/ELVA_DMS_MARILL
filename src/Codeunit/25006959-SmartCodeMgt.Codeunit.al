Codeunit 25006959 "Smart Code Mgt"
{
    // 18/06/2018 EB.P30 GH
    //   Added functions:
    //     ProcessSmartcodeOnBeforePurchaseLineNoValidate
    //     ProcessSmartcodeOnBeforeServiceLineNoValidate
    //   Modified function;
    //     ProcessSmartCode


    trigger OnRun()
    begin
        RunAdvancedLookupNoContext
    end;

    var
        UserProfileMgt: Codeunit UserProfileManagement;
        BranchProfileSetup: Record "Branch Profile Setup";


    procedure ProcessSmartCode(SmartCode: Code[20]; var NewNo: Code[20]; ShowMessage: Boolean): Boolean
    var
        CleanCode: Code[20];
        Int: Integer;
    begin

        if SmartCode = '' then
            exit;

        //Check if is a tire
        if StrLen(SmartCode) = 8 then
            if CopyStr(SmartCode, 1, 1) = 'T' then
                if Evaluate(Int, CopyStr(SmartCode, 2, 7)) then begin
                    CleanCode := Format(Int);
                    if ProcessTyreSnippet(CleanCode, NewNo) then
                        exit(true);
                end;

        if ProcessNonstockItemSnippet(SmartCode, NewNo) then
            exit(true);

        if ProcessItemSnippet(SmartCode, NewNo) then
            exit(true);

        if ShowMessage then         // 18/06/2018 EB.P30
            Message('Smart Code ''%1'' not recognized.', SmartCode);
        //IF CONFIRM('Smart Code %1 not recognized. Do you want to create a Item?',FALSE,SmartCode) THEN
        //  IF CreateNewItem(SmartCode,NewNo) Then
        //    EXIt(TRUE);
    end;

    local procedure ProcessTyreSnippet(SmartCode: Code[20]; var NewNo: Code[20]): Boolean
    var
        NoValueOld: Code[20];
        NoValueNew: Code[20];
        Int1: Integer;
        DataBuffer: Record "Data Buffer" temporary;
        EntryNo: Integer;
        NonstockItem: Record "Nonstock Item";
        Item: Record Item;
        NonstockItemMgt: Codeunit "Catalog Item Management";
        LocationCode: Code[20];
        NonstockSalesPrice: Record "Nonstock Item Price";
    begin
        /*
        IF NOT EVALUATE(Int1,SmartCode) THEN
          EXIT;
        
        IF BranchProfileSetup.GET(UserProfileMgt.CurrProfileID,UserProfileMgt.CurrBranchNo) THEN
          LocationCode := BranchProfileSetup."Default Location Code";
        
        //MESSAGE('Location Code %1',LocationCode);
        
        EntryNo := 0;
        
        NonstockItem.RESET;
        NonstockItem.SETCURRENTKEY(Tire,"Vendor Item No.");
        NonstockItem.SETRANGE(Tire,TRUE); //!!
        NonstockItem.SETFILTER("Vendor Item No.",SmartCode + '*');
        NonstockItem.SETRANGE("Location Filter",LocationCode);
        //MESSAGE(NonstockItem.GETFILTERS);
        IF NonstockItem.FINDFIRST THEN
          REPEAT
            EntryNo +=1;
            DataBuffer.INIT;
            DataBuffer."Entry No." := EntryNo;
            DataBuffer."Code Field 1" := NonstockItem."Vendor No.";
            DataBuffer."Code Field 2" := NonstockItem."Vendor Item No.";
            DataBuffer."Text Field 1" := COPYSTR(NonstockItem.Description,1,MAXSTRLEN(DataBuffer."Text Field 1"));
            DataBuffer."Integer Field 1" := 1; //Source - > Nonstock
            DataBuffer."Code Field 5" := NonstockItem."Item No.";
            DataBuffer."Code Field 6" := NonstockItem."Entry No.";
            DataBuffer."Code Field 7" := LocationCode;
        
            DataBuffer."Boolean Field 1" := NonstockItem."Tire Extra Load";
            DataBuffer."Boolean Field 2" := NonstockItem."Tire Run Flat";
            DataBuffer."Text Field 2" := FORMAT(NonstockItem."Tire Season");
            DataBuffer."Text Field 3" := COPYSTR(FORMAT(NonstockItem."Tire Homologation"),1,MAXSTRLEN(DataBuffer."Text Field 3"));
            DataBuffer."Code Field 4" := NonstockItem."Manufacturer Code";
            DataBuffer."Decimal Field 2" := NonstockItem."Vendor Inventory";
        
            IF NonstockItem."Item No." <> '' THEN
              IF Item.GET(NonstockItem."Item No.") THEN BEGIN
                Item.SETRANGE("Location Filter",LocationCode);
                Item.CALCFIELDS(Inventory,"Qty. on Service Order EDMS");
                DataBuffer."Decimal Field 1" := Item.Inventory;
                DataBuffer."Decimal Field 6" := Item."Qty. on Service Order EDMS";
              END;
        
            NonstockSalesPrice.RESET;
            NonstockSalesPrice.SETRANGE("Nonstock Item Entry No.",NonstockItem."Entry No.");
            NonstockSalesPrice.SETRANGE("Sales Type",NonstockSalesPrice."Sales Type"::"All Customers");
            NonstockSalesPrice.SETRANGE("Location Code",LocationCode);
            NonstockSalesPrice.SETRANGE("Price Includes VAT",FALSE);
            IF NonstockSalesPrice.FINDLAST THEN
              DataBuffer."Decimal Field 4" := NonstockSalesPrice."Unit Price";
        
            DataBuffer."Decimal Field 5" := ROUND(DataBuffer."Decimal Field 4" * 1.2,0.01);
        
            DataBuffer."Decimal Field 7" := NonstockItem."Published Cost";
        
            DataBuffer.INSERT;
          UNTIL NonstockItem.NEXT = 0;
        
        Item.RESET;
        Item.SETRANGE("Created From Nonstock Item",FALSE);
        Item.SETRANGE("Item Category Code",'B-TY'); //!!
        Item.SETFILTER("No.",SmartCode + '*');
        Item.SETRANGE("Location Filter",LocationCode);
        
        IF Item.FINDFIRST THEN
          REPEAT
            EntryNo +=1;
            DataBuffer.INIT;
            DataBuffer."Entry No." := EntryNo;
            DataBuffer."Code Field 1" := Item."Vendor No.";
            DataBuffer."Code Field 2" := Item."Vendor Item No.";
            DataBuffer."Text Field 1" := COPYSTR(Item.Description,1,MAXSTRLEN(DataBuffer."Text Field 1"));
            DataBuffer."Integer Field 1" := 2; //Source - > Item
            DataBuffer."Code Field 5" := Item."No.";
        
            DataBuffer."Boolean Field 1" := Item."Tire Extra Load";
            DataBuffer."Boolean Field 2" := Item."Tire Run Flat";
            DataBuffer."Text Field 2" := FORMAT(Item."Tire Season");
            DataBuffer."Text Field 3" := COPYSTR(FORMAT(Item."Tire Homologation"),1,MAXSTRLEN(DataBuffer."Text Field 3"));
            DataBuffer."Code Field 4" := Item."Manufacturer Code";
            DataBuffer."Code Field 7" := LocationCode;
        
            Item.CALCFIELDS(Inventory,"Qty. on Service Order EDMS");
            DataBuffer."Decimal Field 1" := Item.Inventory;
            DataBuffer."Decimal Field 6" := Item."Qty. on Service Order EDMS";
        
            DataBuffer.INSERT;
          UNTIL Item.NEXT = 0;
        
        IF EntryNo >0 THEN
          IF PAGE.RUNMODAL(PAGE::Page25006697,DataBuffer) = ACTION::LookupOK THEN BEGIN
            CASE DataBuffer."Integer Field 1" OF
              1: //Nonstock Item
                BEGIN
                  IF DataBuffer."Code Field 5" = '' THEN BEGIN
                    NonstockItem.RESET;
                    NonstockItem.GET(DataBuffer."Code Field 6");
                    NonstockItemMgt.NonstockAutoItem(NonstockItem);
                    NonstockItem.GET(NonstockItem."Entry No.");
                    NewNo := NonstockItem."Item No.";
                  END
                  ELSE
                    NewNo := DataBuffer."Code Field 5"
                END;
              2: //Item
                BEGIN
                  NewNo := DataBuffer."Code Field 5";
                END;
            END;
          END;
        
        EXIT(TRUE);
        */

    end;

    local procedure ProcessNonstockItemSnippet(SmartCode: Code[20]; var NewNo: Code[20]): Boolean
    var
        NoValueOld: Code[20];
        NoValueNew: Code[20];
        Int1: Integer;
        DataBuffer: Record "Data Buffer" temporary;
        EntryNo: Integer;
        NonstockItem: Record "Nonstock Item";
        NonstockItem2: Record "Nonstock Item";
        Item: Record Item;
        NonstockItemMgt: Codeunit "Catalog Item Management";
        LocationCode: Code[20];
        NonstockSalesPrice: Record "Nonstock Item Price";
    begin

        NonstockItem.Reset;
        NonstockItem.SetCurrentkey("Vendor Item No.");
        NonstockItem.SetRange("Vendor Item No.", SmartCode);
        if not NonstockItem.FindFirst then
            exit(false);

        if Page.RunModal(Page::"Catalog Item List", NonstockItem) = Action::LookupOK then begin
            if NonstockItem."Item No." = '' then begin
                NonstockItem2.Reset;
                NonstockItem2.Get(NonstockItem."Entry No.");
                NonstockItemMgt.NonstockAutoItem(NonstockItem2);
                NonstockItem2.Get(NonstockItem2."Entry No.");
                NewNo := NonstockItem2."Item No.";
            end else
                NewNo := NonstockItem."Item No.";
        end;

        /*
        IF NOT EVALUATE(Int1,SmartCode) THEN
          EXIT;
        
        IF BranchProfileSetup.GET(UserProfileMgt.CurrProfileID,UserProfileMgt.CurrBranchNo) THEN
          LocationCode := BranchProfileSetup."Default Location Code";
        
        EntryNo := 0;
        
        NonstockItem.RESET;
        NonstockItem.SETCURRENTKEY("Item Category Code","Vendor Item No.");
        NonstockItem.SETRANGE("Item Category Code",'B-TY'); //!!
        NonstockItem.SETFILTER("Vendor Item No.",SmartCode + '*');
        NonstockItem.SETRANGE("Location Filter",LocationCode);
        //MESSAGE(NonstockItem.GETFILTERS);
        IF NonstockItem.FINDFIRST THEN
          REPEAT
            EntryNo +=1;
            DataBuffer.INIT;
            DataBuffer."Entry No." := EntryNo;
            DataBuffer."Code Field 1" := NonstockItem."Vendor No.";
            DataBuffer."Code Field 2" := NonstockItem."Vendor Item No.";
            DataBuffer."Text Field 1" := COPYSTR(NonstockItem.Description,1,MAXSTRLEN(DataBuffer."Text Field 1"));
            DataBuffer."Integer Field 1" := 1; //Source - > Nonstock
            DataBuffer."Code Field 5" := NonstockItem."Item No.";
            DataBuffer."Code Field 6" := NonstockItem."Entry No.";
            DataBuffer."Code Field 7" := LocationCode;
        
            DataBuffer."Boolean Field 1" := NonstockItem."Tire Extra Load";
            DataBuffer."Boolean Field 2" := NonstockItem."Tire Run Flat";
            DataBuffer."Text Field 2" := FORMAT(NonstockItem."Tire Season");
            DataBuffer."Text Field 3" := COPYSTR(FORMAT(NonstockItem."Tire Homologation"),1,MAXSTRLEN(DataBuffer."Text Field 3"));
            DataBuffer."Code Field 4" := NonstockItem."Manufacturer Code";
            DataBuffer."Decimal Field 2" := NonstockItem."Vendor Inventory";
        
            IF NonstockItem."Item No." <> '' THEN
              IF Item.GET(NonstockItem."Item No.") THEN BEGIN
                Item.SETRANGE("Location Filter",LocationCode);
                Item.CALCFIELDS(Inventory,"Qty. on Service Order EDMS");
                DataBuffer."Decimal Field 1" := Item.Inventory;
                DataBuffer."Decimal Field 6" := Item."Qty. on Service Order EDMS";
              END;
        
            NonstockSalesPrice.RESET;
            NonstockSalesPrice.SETRANGE("Nonstock Item Entry No.",NonstockItem."Entry No.");
            NonstockSalesPrice.SETRANGE("Sales Type",NonstockSalesPrice."Sales Type"::"All Customers");
            NonstockSalesPrice.SETRANGE("Location Code",LocationCode);
            NonstockSalesPrice.SETRANGE("Price Includes VAT",FALSE);
            IF NonstockSalesPrice.FINDLAST THEN
              DataBuffer."Decimal Field 4" := NonstockSalesPrice."Unit Price";
        
            DataBuffer."Decimal Field 5" := ROUND(DataBuffer."Decimal Field 4" * 1.2,0.01);
        
            DataBuffer."Decimal Field 7" := NonstockItem."Published Cost";
        
            DataBuffer.INSERT;
          UNTIL NonstockItem.NEXT = 0;
        
        Item.RESET;
        Item.SETRANGE("Created From Nonstock Item",FALSE);
        Item.SETRANGE("Item Category Code",'B-TY'); //!!
        Item.SETFILTER("No.",SmartCode + '*');
        Item.SETRANGE("Location Filter",LocationCode);
        
        IF Item.FINDFIRST THEN
          REPEAT
            EntryNo +=1;
            DataBuffer.INIT;
            DataBuffer."Entry No." := EntryNo;
            DataBuffer."Code Field 1" := Item."Vendor No.";
            DataBuffer."Code Field 2" := Item."Vendor Item No.";
            DataBuffer."Text Field 1" := COPYSTR(Item.Description,1,MAXSTRLEN(DataBuffer."Text Field 1"));
            DataBuffer."Integer Field 1" := 2; //Source - > Item
            DataBuffer."Code Field 5" := Item."No.";
        
            DataBuffer."Boolean Field 1" := Item."Tire Extra Load";
            DataBuffer."Boolean Field 2" := Item."Tire Run Flat";
            DataBuffer."Text Field 2" := FORMAT(Item."Tire Season");
            DataBuffer."Text Field 3" := COPYSTR(FORMAT(Item."Tire Homologation"),1,MAXSTRLEN(DataBuffer."Text Field 3"));
            DataBuffer."Code Field 4" := Item."Manufacturer Code";
            DataBuffer."Code Field 7" := LocationCode;
        
            Item.CALCFIELDS(Inventory,"Qty. on Service Order EDMS");
            DataBuffer."Decimal Field 1" := Item.Inventory;
            DataBuffer."Decimal Field 6" := Item."Qty. on Service Order EDMS";
        
            DataBuffer.INSERT;
          UNTIL Item.NEXT = 0;
        
        IF EntryNo >0 THEN
          IF PAGE.RUNMODAL(PAGE::"Advanced Tire Lookup",DataBuffer) = ACTION::LookupOK THEN BEGIN
            CASE DataBuffer."Integer Field 1" OF
              1: //Nonstock Item
                BEGIN
                  IF DataBuffer."Code Field 5" = '' THEN BEGIN
                    NonstockItem.RESET;
                    NonstockItem.GET(DataBuffer."Code Field 6");
                    NonstockItemMgt.NonstockAutoItem(NonstockItem);
                    NonstockItem.GET(NonstockItem."Entry No.");
                    NewNo := NonstockItem."Item No.";
                  END
                  ELSE
                    NewNo := DataBuffer."Code Field 5"
                END;
              2: //Item
                BEGIN
                  NewNo := DataBuffer."Code Field 5";
                END;
            END;
          END;
        */
        exit(true);

    end;

    local procedure ProcessItemSnippet(SmartCode: Code[20]; var NewNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        Item.Reset;
        if not Item.Get(SmartCode) then
            exit(false);


        Item.SetRange("No.", SmartCode);
        if Page.RunModal(Page::"Item List", Item) = Action::LookupOK then begin
            NewNo := Item."No.";
        end;

        exit(true);
    end;

    local procedure RunAdvancedLookupNoContext()
    var
        ItemNo: Code[20];
    begin
        /*
        IF SmartCodeParameter.RUNMODAL = ACTION::OK THEN;
        
        ProcessSmartCode(SmartCodeParameter.GetSmartCode,ItemNo,TRUE)
        */

    end;

    local procedure CreateNewItem(SmartCode: Code[20]; var NewNo: Code[20]): Boolean
    var
        MiniItemTemplate: Record "Item Templ.";
        Item: Record Item;
        NewItemCode: Code[20];
    begin
        //MERGE 2018 Rethink
        /*
        EXIT(FALSE);
        NewNo := MiniItemTemplate.NewItemFromTemplate;
        IF NewNo <> '' THEN
          EXIT(TRUE);
        */

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure ProcessSmartcodeOnBeforePurchaseLineNoValidate(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        NewNo: Code[20];
        Item: Record Item;
    begin
        if Rec.IsTemporary then
            exit;
        if Rec.Type <> Rec.Type::Item then
            exit;
        if CurrFieldNo <> Rec.FieldNo("No.") then
            exit;

        if Item.Get(Rec."No.") then begin
            Rec."No." := Item."No.";
            exit;
        end;

        if ProcessSmartCode(Rec."No.", NewNo, false) then
            Rec."No." := NewNo;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Line EDMS", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure ProcessSmartcodeOnBeforeServiceLineNoValidate(var Rec: Record "Service Line EDMS"; var xRec: Record "Service Line EDMS"; CurrFieldNo: Integer)
    var
        NewNo: Code[20];
        Item: Record Item;
    begin
        if Rec.IsTemporary then
            exit;
        if Rec.Type <> Rec.Type::Item then
            exit;
        if CurrFieldNo <> Rec.FieldNo("No.") then
            exit;

        if Item.Get(Rec."No.") then begin
            Rec."No." := Item."No.";
            exit;
        end;

        if ProcessSmartCode(Rec."No.", NewNo, false) then
            Rec."No." := NewNo;
    end;
}

