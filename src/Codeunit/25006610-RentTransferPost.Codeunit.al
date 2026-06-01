Codeunit 25006610 "RentTransfer-Post"
{
    Permissions = TableData "Item Entry Relation" = i;
    TableNo = "Rent Transfer Header";

    trigger OnRun()
    var
        Item: Record Item;
        SourceCodeSetup: Record "Source Code Setup";
        InvtSetup: Record "Inventory Setup";
        InventoryPostingSetup: Record "Inventory Posting Setup";
        ServiceLine: Record "Service Line EDMS";
        NoSeriesMgt: Codeunit "No. Series";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
        ServiceTransferMgt: Codeunit "Service Transfer Mgt.";
        ReservMgt: Codeunit "Reservation Management";
        ReserveServiceLine: Codeunit "Service Line EDMS-Reserve";
        Window: Dialog;
        LineCount: Integer;
        NextLineNo: Integer;
        FullAutoReservation: Boolean;
        RentAsset: Record "Rent Asset";
        RentSetup: Record "Rent Mgt. Setup";
    begin
        if Rec.Status = Rec.Status::Open then
            Rec.Status := Rec.Status::Released;

        TransHeader := Rec;

        TransHeader.TestField("Transfer-from Code");
        TransHeader.TestField("Transfer-to Code");
        if (TransHeader."Transfer-from Code" <> '') and
           (TransHeader."Transfer-from Code" = TransHeader."Transfer-to Code")
        then
            Error
              (Text000,
              TransHeader."No.", TransHeader.FieldCaption("Transfer-from Code"), TransHeader.FieldCaption("Transfer-to Code"));

        TransHeader.TestField(Status, TransHeader.Status::Released);
        TransHeader.TestField("Posting Date");

        TransLine.Reset;
        TransLine.SetRange("Document No.", TransHeader."No.");
        TransLine.SetFilter(Quantity, '<>0');
        if not TransLine.Find('-') then
            Error(Text001);


        Window.Open(
          '#1#################################\\' +
          Text003);

        Window.Update(1, StrSubstNo(Text004, TransHeader."No."));


        SourceCodeSetup.Get;
        SourceCode := SourceCodeSetup."Rent Management";


        // Insert posted shipment header
        PstTransHeader.LockTable;
        PstTransHeader.Init;
        PstTransHeader."Sell-to Customer No." := TransHeader."Sell-to Customer No.";
        PstTransHeader."Sell-to Customer Name" := TransHeader."Sell-to Customer Name";
        PstTransHeader."Sell-to Address" := TransHeader."Sell-to Address";
        PstTransHeader."Sell-to Address 2" := TransHeader."Sell-to Address 2";
        PstTransHeader."Sell-to Post Code" := TransHeader."Sell-to Post Code";
        PstTransHeader."Sell-to City" := TransHeader."Sell-to City";
        PstTransHeader."Sell-to County" := TransHeader."Sell-to County";
        PstTransHeader."Sell-to Country/Region Code" := TransHeader."Sell-to Country/Region Code";
        PstTransHeader."Sell-to Contact" := TransHeader."Sell-to Contact";

        PstTransHeader."Ship-to Code" := TransHeader."Ship-to Code";
        PstTransHeader."Ship-to Name" := TransHeader."Ship-to Name";
        PstTransHeader."Ship-to Name 2" := TransHeader."Ship-to Name 2";
        PstTransHeader."Ship-to Address" := TransHeader."Ship-to Address";
        PstTransHeader."Ship-to Address 2" := TransHeader."Ship-to Address 2";
        PstTransHeader."Ship-to Post Code" := TransHeader."Ship-to Post Code";
        PstTransHeader."Ship-to City" := TransHeader."Ship-to City";
        PstTransHeader."Ship-to County" := TransHeader."Ship-to County";
        PstTransHeader."Ship-to Country/Region Code" := TransHeader."Ship-to Country/Region Code";
        PstTransHeader."Ship-to Contact" := TransHeader."Ship-to Contact";

        PstTransHeader."Bill-to Customer No." := TransHeader."Bill-to Customer No.";

        PstTransHeader."Posting Date" := TransHeader."Posting Date";
        PstTransHeader."Shipment Date" := TransHeader."Shipment Date";
        PstTransHeader."Transfer-from Code" := TransHeader."Transfer-from Code";
        PstTransHeader."Transfer-to Code" := TransHeader."Transfer-to Code";

        if (TransHeader."Posting No." = '') then begin
            TransHeader.TestField("Posting No. Series");
            TransHeader."Posting No." := NoSeriesMgt.GetNextNo(TransHeader."Posting No. Series", TransHeader."Posting Date", true);
        end;

        PstTransHeader."No." := TransHeader."Posting No.";
        PstTransHeader.Description := TransHeader.Description;
        PstTransHeader."Transfer Type" := TransHeader."Transfer Type";
        PstTransHeader."Rent Order No." := TransHeader."Rent Order No.";
        PstTransHeader."Rent Order Type" := TransHeader."Rent Order Type";
        PstTransHeader."Bill-to Mobile Phone No." := TransHeader."Bill-to Mobile Phone No.";
        PstTransHeader."Ship-to Mobile Phone No." := TransHeader."Ship-to Mobile Phone No.";
        PstTransHeader."Contract No." := TransHeader."Contract No.";

        OnBeforeInsertRentTransferHeader(PstTransHeader, TransHeader);

        PstTransHeader.Insert;


        // Insert Posted Transfer lines
        LineCount := 0;
        PstTransLine.LockTable;

        TransLine.SetRange(Quantity);

        if TransLine.Find('-') then begin
            repeat
                LineCount := LineCount + 1;
                Window.Update(2, LineCount);

                if TransHeader."Transfer Type" <> TransHeader."Transfer Type"::Internal then
                    TransLine.TestField("Rent Item No.");

                TransLine.TestField("Rent Asset No.");

                if TransHeader."Rent Order No." <> '' then
                    if (TransHeader."Rent Order No." <> TransLine."Rent Order No.") or (TransLine."Rent Line No." = 0) then
                        Error(Text203, TransLine."Line No.", TransLine."Rent Item No.", TransLine."Rent Asset No.");

                CheckCounters(TransLine);

                CheckOrderQuantity(TransLine);

                PstTransLine.Init;
                PstTransLine."Document No." := PstTransHeader."No.";
                PstTransLine."Line No." := TransLine."Line No.";
                PstTransLine."Rent Item No." := TransLine."Rent Item No.";
                PstTransLine.Description := TransLine.Description;
                PstTransLine.Quantity := TransLine.Quantity;
                PstTransLine."Rent Asset No." := TransLine."Rent Asset No.";
                PstTransLine."Variable Field Run 1" := TransLine."Variable Field Run 1";
                PstTransLine."Variable Field Run 2" := TransLine."Variable Field Run 2";
                PstTransLine."Variable Field Run 3" := TransLine."Variable Field Run 3";
                PstTransLine."Rent Order No." := TransLine."Rent Order No.";
                PstTransLine."Rent Line No." := TransLine."Rent Line No.";
                PstTransLine."Service Order No." := TransLine."Service Order No.";
                PostRentJnlLine(PstTransHeader, PstTransLine);
                PostServJnlLine(PstTransHeader, PstTransLine);

                if RentLine.Get(RentLine."document type"::Order, TransLine."Rent Order No.", TransLine."Rent Line No.") then begin
                    RentAsset.Get(TransLine."Rent Asset No.");
                    RentSetup.Get;
                    //Update Rent Line with FA No. or ItemNo.
                    if RentLine."Rent Asset No." = '' then
                        RentLine."Rent Asset No." := TransLine."Rent Asset No.";
                    //Update Rent Line with Motorhours and Kilometrage
                    case PstTransHeader."Transfer Type" of
                        PstTransHeader."Transfer Type"::Shipment:
                            begin
                                RentLine.Status := RentLine.Status::Rented;
                                RentLine."VF Run 1 From" := TransLine."Variable Field Run 1";
                                RentLine."VF Run 2 From" := TransLine."Variable Field Run 2";
                                RentLine."VF Run 3 From" := TransLine."Variable Field Run 3";
                                if RentAsset."Asset Type" <> RentAsset."Asset Type"::Multiple then
                                    RentAsset.Validate(Status, RentAsset.Status::Rented);
                            end;
                        PstTransHeader."Transfer Type"::Receipt:
                            begin
                                RentLine."VF Run 1 To" := TransLine."Variable Field Run 1";
                                RentLine."VF Run 2 To" := TransLine."Variable Field Run 2";
                                RentLine."VF Run 3 To" := TransLine."Variable Field Run 3";
                                if PstTransHeader."Transfer-to Code" = RentSetup."Rent Service Location Code" then begin
                                    RentLine.Status := RentLine.Status::Returned;
                                    RentAsset.Validate(Status, RentAsset.Status::Service);
                                end else begin
                                    RentLine.Status := RentLine.Status::Returned;
                                    if RentAsset."Asset Type" <> RentAsset."Asset Type"::Multiple then begin
                                        RentAsset.Validate(Status, RentAsset.Status::Available);
                                    end;
                                end;
                            end;
                        PstTransHeader."Transfer Type"::Internal:
                            begin
                                if PstTransHeader."Transfer-to Code" = RentSetup."Rent Service Location Code" then begin
                                    RentLine.Status := RentLine.Status::"In Service";
                                    RentAsset.Validate(Status, RentAsset.Status::Service);
                                end
                                else
                                    if PstTransHeader."Transfer-to Code" = RentSetup."Default Cust. Location Code" then begin
                                        RentLine.Status := RentLine.Status::Rented;
                                        RentAsset.Validate(Status, RentAsset.Status::Rented);
                                    end
                                    else begin
                                        RentLine.CalcFields("Quantity Shipped", "Quantity Returned");
                                        If RentLine."Quantity Shipped" = 0 then begin
                                            RentLine.Status := RentLine.Status::Allocated;
                                            RentAsset.Validate(Status, RentAsset.Status::Reserved);
                                        end;
                                        If (RentLine."Quantity Shipped" = RentLine."Quantity Returned") and (RentLine."Quantity Shipped" <> 0) then begin
                                            RentLine.Status := RentLine.Status::Returned;
                                            RentAsset.Validate(Status, RentAsset.Status::Available);
                                        end;
                                    end;
                            end;
                    end;
                    RentAsset.Modify();
                    RentLine.Modify;
                end;

                if TransLine."Rent Order No." = '' then begin
                    RentAsset.Get(TransLine."Rent Asset No.");
                    RentSetup.Get;
                    case PstTransHeader."Transfer Type" of
                        PstTransHeader."Transfer Type"::Shipment:
                            begin
                            end;
                        PstTransHeader."Transfer Type"::Receipt:
                            begin
                            end;
                        PstTransHeader."Transfer Type"::Internal:
                            begin
                                if PstTransHeader."Transfer-to Code" = RentSetup."Rent Service Location Code" then begin
                                    RentAsset.Validate(Status, RentAsset.Status::Service);
                                end
                                else
                                    if RentAsset.Status = RentAsset.Status::Service then
                                        RentAsset.Validate(Status, RentAsset.Status::Available);
                            end;
                    end;
                    RentAsset.Modify();
                end;

                OnBeforeInsertRentTransferLine(PstTransLine, TransLine);

                PstTransLine.Insert;

                UpdateVehicle(TransLine);

                OnAfterInsertRentTransferLine(PstTransHeader, PstTransLine);

            until TransLine.Next = 0;
        end;

        //Update Panning entries
        /*
        IF "Transfer Type" <> "Transfer Type"::Internal THEN
          RentPlanningMgt.UpdatePlanningEntries("Rent Order No.");
        */

        ModifyProcessChecklist(TransHeader, Database::"Posted Rent Transfer Header", PstTransHeader."No.");

        HeaderDeleted := TransHeader.DeleteOneTransferOrder(TransHeader, TransLine);
        Commit;
        Window.Close;
        Rec := TransHeader;

    end;

    var
        Text000: label 'Transfer order %2 cannot be posted because %3 and %4 are the same.';
        Text001: label 'There is nothing to post.';
        Text003: label 'Posting transfer lines     #2######';
        Text004: label 'Transfer Order %1';
        RentSetup: Record "Rent Mgt. Setup";
        PstTransHeader: Record "Posted Rent Transfer Header";
        PstTransLine: Record "Posted Rent Transfer Line";
        TransHeader: Record "Rent Transfer Header";
        TransLine: Record "Rent Transfer Line";
        TransLine2: Record "Rent Transfer Line";
        Location: Record Location;
        RentJnlLine: Record "Rent Journal Line";
        ServJnlLine: Record "Serv. Journal Line";
        NoSeriesLine: Record "No. Series Line";
        GLEntry: Record "G/L Entry";
        RentLine: Record "Rent Line";
        RentJnlPostLine: Codeunit "Rent Jnl.-Post Line";
        ServJnlPostLine: Codeunit "Serv. Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        RentPost: Codeunit "Rent-Post";
        NoSeriesMgt: Codeunit "No. Series";
        SourceCode: Code[10];
        HideValidationDialog: Boolean;
        HeaderDeleted: Boolean;
        Text008: label 'This order must be a complete shipment.';
        Text009: label '&Ship,&Receive';
        Text010: label '%1 Transfer Orders created.';
        Text011: label 'Transfer Order %1 is created. Would you like to open Transfer Order?';
        Text012: label 'No Transfer Orders created.';
        Text013: label '&To Service,&From Service';
        Text100: label '%1 cannot be less than last posted. Rent Line %2, Rent Asset %3, last posted counter value %4';
        Text101: label '%1 must not be 0 in Rent Transfer Line %2, Rent Asset %3.';
        Text201: Label 'Nothing to ship for Rent Asset %1';
        Text202: Label 'Nothing to receive for Rent Asset %1';
        Text203: Label 'You cannot post manually added lines in Rent Transfer Order, if it is related to Rent Order. Rent Transfer Line No. %1, Rent Item No. %2, Rent Asset No. %3';

        RentOrderTranferQtyExceedErr: label 'Transfer Quantity exceeds Rent Line Quantity';
        RentVhehicleChangeCustomerLbl: Label 'Do you want to change Customer No in Vehicle Card?';

    /*
        local procedure PostRentJnlLine(TransHeader2: Record "Posted Rent Transfer Header"; TransLine2: Record "Posted Rent Transfer Line")
        begin
            RentJnlLine.Init;
            RentJnlLine."Posting Date" := TransHeader2."Posting Date";
            RentJnlLine."Document Date" := TransHeader2."Posting Date";
            RentJnlLine."Document No." := TransHeader2."No.";
            RentJnlLine."Entry Type" := RentJnlLine."entry type"::Inventory;
            if TransHeader2."Transfer Type" = TransHeader2."transfer type"::Shipment then
                RentJnlLine."Document Type" := RentJnlLine."document type"::Shipment
            else
                if TransHeader2."Transfer Type" = TransHeader2."transfer type"::Receipt then
                    RentJnlLine."Document Type" := RentJnlLine."document type"::Receipt;

            RentJnlLine."Document Line No." := TransLine2."Line No.";
            RentJnlLine."Rent Item No." := TransLine2."Rent Item No.";
            RentJnlLine.Description := TransLine2.Description;
            RentJnlLine."Transfer-from Code" := TransHeader."Transfer-from Code";
            RentJnlLine."Transfer-to Code" := TransHeader2."Transfer-to Code";
            RentJnlLine.Quantity := TransLine2.Quantity;
            RentJnlLine."Source Code" := SourceCode;
            RentJnlLine."Rent Order No." := TransHeader2."Rent Order No.";
            RentJnlLine."Rent Order Type" := TransHeader2."Rent Order Type";
            RentJnlLine."Rent Order Line No." := TransLine2."Rent Line No.";
            RentJnlLine."Rent Transfer Type" := TransHeader2."Transfer Type";
            RentJnlLine."Shipment Date" := TransHeader2."Shipment Date";
            RentJnlLine."Sell-to Customer No." := TransHeader2."Sell-to Customer No.";
            RentJnlLine."Bill-to Customer No." := TransHeader2."Bill-to Customer No.";
            RentJnlLine."Variable Field Run 1" := TransLine2."Variable Field Run 1";
            RentJnlLine."Variable Field Run 2" := TransLine2."Variable Field Run 2";
            RentJnlLine."Variable Field Run 3" := TransLine2."Variable Field Run 3";
            RentJnlLine."Service Order No." := TransLine2."Service Order No.";
            RentJnlLine."Rent Asset No." := TransLine2."Rent Asset No.";
            RentJnlPostLine.RunWithCheck(RentJnlLine);

        end;
    */

    local procedure PostRentJnlLine(TransHeader2: Record "Posted Rent Transfer Header"; TransLine2: Record "Posted Rent Transfer Line")
    begin
        RentJnlLine.Init;
        RentJnlLine."Posting Date" := TransHeader2."Posting Date";
        RentJnlLine."Document Date" := TransHeader2."Posting Date";
        RentJnlLine."Document No." := TransHeader2."No.";
        RentJnlLine."Entry Type" := RentJnlLine."Entry Type"::Inventory;

        RentJnlLine."Document Type" := RentJnlLine."document type"::Shipment;

        RentJnlLine."Document Line No." := TransLine2."Line No.";
        RentJnlLine."Rent Item No." := TransLine2."Rent Item No.";
        RentJnlLine.Description := TransLine2.Description;
        //RentJnlLine."Transfer-from Code" := TransHeader."Transfer-from Code";
        //RentJnlLine."Transfer-to Code" := TransHeader2."Transfer-to Code";
        RentJnlLine."Location Code" := TransHeader2."Transfer-from Code";
        RentJnlLine.Quantity := TransLine2.Quantity;
        RentJnlLine."Source Code" := SourceCode;
        RentJnlLine."Rent Order No." := TransHeader2."Rent Order No.";
        RentJnlLine."Rent Order Type" := TransHeader2."Rent Order Type";
        RentJnlLine."Rent Order Line No." := TransLine2."Rent Line No.";
        RentJnlLine."Rent Transfer Type" := TransHeader2."Transfer Type";
        RentJnlLine."Shipment Date" := TransHeader2."Shipment Date";
        RentJnlLine."Sell-to Customer No." := TransHeader2."Sell-to Customer No.";
        RentJnlLine."Bill-to Customer No." := TransHeader2."Bill-to Customer No.";
        RentJnlLine."Variable Field Run 1" := TransLine2."Variable Field Run 1";
        RentJnlLine."Variable Field Run 2" := TransLine2."Variable Field Run 2";
        RentJnlLine."Variable Field Run 3" := TransLine2."Variable Field Run 3";
        RentJnlLine."Service Order No." := TransLine2."Service Order No.";
        RentJnlLine."Rent Asset No." := TransLine2."Rent Asset No.";
        RentJnlPostLine.RunWithCheck(RentJnlLine);

        clear(RentJnlLine);
        RentJnlLine.Init;
        RentJnlLine."Posting Date" := TransHeader2."Posting Date";
        RentJnlLine."Document Date" := TransHeader2."Posting Date";
        RentJnlLine."Document No." := TransHeader2."No.";
        RentJnlLine."Entry Type" := RentJnlLine."Entry Type"::Inventory;

        RentJnlLine."Document Type" := RentJnlLine."document type"::Receipt;

        RentJnlLine."Document Line No." := TransLine2."Line No.";
        RentJnlLine."Rent Item No." := TransLine2."Rent Item No.";
        RentJnlLine.Description := TransLine2.Description;
        //RentJnlLine."Transfer-from Code" := TransHeader2."Transfer-to Code";
        //RentJnlLine."Transfer-to Code" := TransHeader."Transfer-from Code";        
        RentJnlLine."Location Code" := TransHeader2."Transfer-to Code";
        RentJnlLine.Quantity := TransLine2.Quantity;
        RentJnlLine."Source Code" := SourceCode;
        RentJnlLine."Rent Order No." := TransHeader2."Rent Order No.";
        RentJnlLine."Rent Order Type" := TransHeader2."Rent Order Type";
        RentJnlLine."Rent Order Line No." := TransLine2."Rent Line No.";
        RentJnlLine."Rent Transfer Type" := TransHeader2."Transfer Type";
        RentJnlLine."Shipment Date" := TransHeader2."Shipment Date";
        RentJnlLine."Sell-to Customer No." := TransHeader2."Sell-to Customer No.";
        RentJnlLine."Bill-to Customer No." := TransHeader2."Bill-to Customer No.";
        RentJnlLine."Variable Field Run 1" := TransLine2."Variable Field Run 1";
        RentJnlLine."Variable Field Run 2" := TransLine2."Variable Field Run 2";
        RentJnlLine."Variable Field Run 3" := TransLine2."Variable Field Run 3";
        RentJnlLine."Service Order No." := TransLine2."Service Order No.";
        RentJnlLine."Rent Asset No." := TransLine2."Rent Asset No.";
        RentJnlPostLine.RunWithCheck(RentJnlLine);

    end;

    local procedure PostServJnlLine(TransHeader2: Record "Posted Rent Transfer Header"; TransLine2: Record "Posted Rent Transfer Line")
    var
        RentItemRelation: Record "Rent Item Relation";
        FixedAsset: Record "Fixed Asset";
    begin
        /*RentItemRelation.RESET;
        RentItemRelation.SETRANGE("Rent Item No.",TransLine2."Rent Item No.");
        RentItemRelation.SETRANGE("Relation Type",RentItemRelation."Relation Type"::"1");
        IF RentItemRelation.FINDFIRST THEN
          IF FixedAsset.GET(RentItemRelation."Rent Asset No.") THEN
            IF FixedAsset."Vehicle Serial No." <> '' THEN BEGIN
              ServJnlLine.INIT;
              ServJnlLine."Entry Type" := ServJnlLine."Entry Type"::Info;
              ServJnlLine."Posting Date" := TransHeader2."Posting Date";
              ServJnlLine."Document Date" := TransHeader2."Posting Date";
              ServJnlLine."Document No." := TransHeader2."No.";
              //ServJnlLine."Document Type" := ServJnlLine."Document Type"::"Transfer Order";
              //ServJnlLine."Serial No." := FixedAsset."Vehicle Serial No.";
              //ServJnlLine."Rent Item No." := TransLine2."Rent Item No.";
              ServJnlLine.Description := TransLine2.Description;
              //ServJnlLine."Rent Order No." := TransHeader2."Rent Order No.";
              //ServJnlLine.Kilometrage := TransLine2.Kilometrage;
              //ServJnlLine."Motor Hours" := TransLine2."Motor Hours";
              ServJnlPostLine.RunWithCheck(ServJnlLine);
            END;
        */

    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local procedure AssignLineNo(FromDocNo: Code[20]): Integer
    var
        TransLine3: Record "Transfer Line";
    begin
        TransLine3.SetRange("Document No.", FromDocNo);
        if TransLine3.Find('+') then
            exit(TransLine3."Line No." + 10000);
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.GetLocationSetup(LocationCode, Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;


    procedure CreateRentTransferOrder(RentHeader: Record "Rent Header"; RentLineNo: Integer; CreateForLine: Boolean): Boolean
    var
        Selection: Option " ",Shipment,Receipt;
        DefaultNumber: Option " ",Shipment,Receipt;
        RentLine: Record "Rent Line";
        PrevLocationCode: Code[10];
        TransferType: Integer;
        TransferFrom: Code[10];
        TransferTo: Code[10];
        n: Integer;
        PrevTransferDate: Date;
        TransferDate: Date;
        RentTransferOrder: Page "Rent Transfer Order";

        ChooseRentLines: Page "Rent Order Choose Line";
        ChooseRentLinesFilter: Text;
    begin
        Selection := StrMenu(Text009, DefaultNumber);
        if Selection = 0 then
            exit;

        RentSetup.Get;
        RentSetup.TestField("Default Cust. Location Code");
        if Selection = 1 then begin
            //Ship
            TransferType := TransHeader."transfer type"::Shipment;
            TransferTo := RentSetup."Default Cust. Location Code";
        end else begin
            //Recieve
            TransferType := TransHeader."transfer type"::Receipt;
            TransferFrom := RentSetup."Default Cust. Location Code";
        end;

        RentLine.Reset;
        RentLine.SetRange("Document No.", RentHeader."No.");
        RentLine.SetRange("Document Type", RentHeader."Document Type");

        if not CreateForLine then begin
            //Choose Rent Lines
            RentLine.SetRange("Locks Line", 0);
            if RentLine.FindFirst() then begin
                RentLine.ClearMarks();
                repeat
                    RentLine.CalcFields("Quantity Shipped", "Quantity Returned");
                    if Selection = 1 then begin
                        if RentLine."Quantity Shipped" < RentLine."Rent Asset Quantity" then begin
                            RentLine.Mark(true);
                            //message('mark shipp: ' + format(RentLine."Quantity Shipped") + ' ' + format(RentLine."Rent Asset Quantity"));
                        end;
                    end else begin
                        if RentLine."Quantity Returned" < RentLine."Quantity Shipped" then begin
                            RentLine.Mark(true);
                            //message('mark return');
                        end;
                    end;
                until RentLine.Next() = 0;
            end;

            RentLine.MarkedOnly(true);

            if RentLine.Count > 1 then begin
                ChooseRentLines.SetRecord(RentLine);
                ChooseRentLines.SetTableView(RentLine);
                ChooseRentLines.LookupMode(true);

                if ChooseRentLines.RunModal = ACTION::LookupOK then begin
                    ChooseRentLines.SetSelectionFilter(RentLine);
                end else
                    Exit(false);
            end;
        end;


        //if RentLine.FindFirst() then
        //    repeat
        //        Message(Format(RentLine."Line No."));
        //    until RentLine.Next() = 0;




        n := 0;
        TransLine.LockTable;


        //if Selection = 1 then
        //    RentLine.SetFilter("Actual Shipment Date", '%1', 0D)
        //else
        //    RentLine.SetFilter("Actual Return Date", '%1', 0D);

        if CreateForLine then begin
            RentLine.SetRange("Line No.", RentLineNo);
            if RentLine.FindFirst then begin
                RentLine.CalcFields("Quantity Shipped", "Quantity Returned");
                if Selection = 1 then begin
                    if not (RentLine."Quantity Shipped" < RentLine."Rent Asset Quantity") then
                        Error(Text201, RentLine."Rent Asset No.");
                end else begin
                    if not (RentLine."Quantity Returned" < RentLine."Quantity Shipped") then
                        Error(Text202, RentLine."Rent Asset No.");
                end;
            end;
        end;

        if Selection = 1 then
            RentLine.SetCurrentkey("Location Code", "Planned Shipment Date")
        else begin
            if RentHeader."Rent Type" = RentHeader."Rent Type"::"Open End Date" then
                RentLine.SetCurrentkey("Location Code", "Last Date Invoiced")
            else
                RentLine.SetCurrentkey("Location Code", "Planned Return Date");
        end;

        if RentLine.FindFirst then begin
            repeat
                RentLine.CalcFields("Quantity Shipped", "Quantity Returned");
                RentLine.TestField("Location Code");
                if Selection = 1 then begin
                    TransferFrom := RentLine."Location Code";
                    TransferDate := RentLine."Planned Shipment Date"
                end else begin
                    TransferTo := RentLine."Location Code";
                    if RentHeader."Rent Type" = RentHeader."Rent Type"::"Open End Date" then
                        TransferDate := RentLine."Last Date Invoiced"
                    else
                        TransferDate := RentLine."Planned Return Date";
                    if TransferDate = 0D then
                        TransferDate := Today;
                end;
                if n = 0 then begin
                    InsertRentTransferHeader(RentHeader, TransHeader, TransferType, TransferFrom, TransferTo, Today);
                    n += 1;
                end else
                    if (PrevLocationCode <> RentLine."Location Code") and (PrevTransferDate <> TransferDate) then begin
                        InsertRentTransferHeader(RentHeader, TransHeader, TransferType, TransferFrom, TransferTo, Today);
                        n += 1;
                    end;
                PrevLocationCode := RentLine."Location Code";
                PrevTransferDate := TransferDate;
                TransLine.Init;
                TransLine."Document No." := TransHeader."No.";
                TransLine."Line No." := RentLine."Line No.";
                TransLine."Rent Item No." := RentLine."Rent Item No.";
                TransLine.Description := RentLine.Description;
                if Selection = 1 then
                    TransLine.Quantity := RentLine."Rent Asset Quantity" - RentLine."Quantity Shipped"
                else
                    TransLine.Quantity := RentLine."Quantity Shipped" - RentLine."Quantity Returned";
                TransLine.Validate("Rent Asset No.", RentLine."Rent Asset No.");
                TransLine."Rent Order No." := RentLine."Document No.";
                TransLine."Rent Line No." := RentLine."Line No.";
                TransLine.Insert;
            until RentLine.Next = 0;
        end;

        if n <> 0 then begin
            if Confirm(Text011, true, TransHeader."No.") then begin
                RentTransferOrder.SetRecord(TransHeader);
                RentTransferOrder.Run;
            end;
        end else
            Message(Text012);

        Clear(TransHeader);
    end;

    local procedure InsertRentTransferHeader(RentHeader: Record "Rent Header"; var RentTransferHeader: Record "Rent Transfer Header"; TransferType: Integer; TransferFrom: Code[10]; TransferTo: Code[10]; TransferDate: Date)
    begin

        TransHeader.LockTable;
        TransHeader.Init;
        TransHeader."No." := '';
        TransHeader."No." := NoSeriesMgt.GetNextNo(RentSetup."Rent Shipment Nos.", TransHeader."Posting Date", true);
        if NoSeriesMgt.IsAutomatic(RentSetup."Posted Rent Shpt. Nos.") then
            TransHeader."Posting No. Series" := RentSetup."Posted Rent Shpt. Nos.";
        TransHeader."Transfer-to Code" := TransferTo;
        TransHeader."Transfer-from Code" := TransferFrom;
        TransHeader."Sell-to Customer No." := RentHeader."Sell-to Customer No.";
        TransHeader."Sell-to Customer Name" := RentHeader."Sell-to Customer Name";
        TransHeader."Sell-to Address" := RentHeader."Sell-to Address";
        TransHeader."Sell-to Address 2" := RentHeader."Sell-to Address 2";
        TransHeader."Sell-to Post Code" := RentHeader."Sell-to Post Code";
        TransHeader."Sell-to City" := RentHeader."Sell-to City";
        TransHeader."Sell-to County" := RentHeader."Sell-to County";
        TransHeader."Sell-to Country/Region Code" := RentHeader."Sell-to Country/Region Code";
        TransHeader."Sell-to Contact" := RentHeader."Sell-to Contact";
        TransHeader."Ship-to Code" := RentHeader."Ship-to Code";
        TransHeader."Ship-to Name" := RentHeader."Ship-to Name";
        TransHeader."Ship-to Name 2" := RentHeader."Ship-to Name 2";
        TransHeader."Ship-to Address" := RentHeader."Ship-to Address";
        TransHeader."Ship-to Address 2" := RentHeader."Ship-to Address 2";
        TransHeader."Ship-to Post Code" := RentHeader."Ship-to Post Code";
        TransHeader."Ship-to City" := RentHeader."Ship-to City";
        TransHeader."Ship-to County" := RentHeader."Ship-to County";
        TransHeader."Ship-to Country/Region Code" := RentHeader."Ship-to Country/Region Code";
        TransHeader."Ship-to Contact" := RentHeader."Ship-to Contact";
        TransHeader."Bill-to Customer No." := RentHeader."Bill-to Customer No.";
        TransHeader."Bill-to Name" := RentHeader."Bill-to Name";
        TransHeader."Bill-to Name 2" := RentHeader."Bill-to Name 2";
        TransHeader."Bill-to Address" := RentHeader."Bill-to Address";
        TransHeader."Bill-to Address 2" := RentHeader."Bill-to Address 2";
        TransHeader."Bill-to Post Code" := RentHeader."Bill-to Post Code";
        TransHeader."Bill-to City" := RentHeader."Bill-to City";
        TransHeader."Bill-to County" := RentHeader."Bill-to County";
        TransHeader."Bill-to Country/Region Code" := RentHeader."Bill-to Country/Region Code";
        TransHeader."Bill-to Contact No." := RentHeader."Bill-to Contact No.";
        TransHeader."Bill-to Contact" := RentHeader."Bill-to Contact";
        TransHeader."Posting Date" := TransferDate;
        TransHeader."Shipment Date" := TransferDate;
        TransHeader.Description := RentHeader.Description;
        TransHeader."Rent Order No." := RentHeader."No.";
        TransHeader."Rent Order Type" := TransHeader."rent order type"::Order;
        TransHeader."Contract No." := RentHeader."Contract No.";
        TransHeader."Transfer Type" := TransferType;
        TransHeader.Insert;
    end;


    procedure ModifyProcessChecklist(RentTransferHeader: Record "Rent Transfer Header"; NewSourceType: Integer; NewSourceID: Code[20])
    var
        ProcessChecklistHdr: Record "Process Checklist Header";
    begin
        ProcessChecklistHdr.Reset;
        ProcessChecklistHdr.SetCurrentkey("Source Type", "Source Subtype", "Source ID");
        ProcessChecklistHdr.SetRange("Source Type", Database::"Rent Transfer Header");
        ProcessChecklistHdr.SetRange("Source ID", RentTransferHeader."No.");
        if ProcessChecklistHdr.FindFirst then
            repeat
                ProcessChecklistHdr."Source Type" := NewSourceType;
                ProcessChecklistHdr."Source Subtype" := 0;
                ProcessChecklistHdr."Source ID" := NewSourceID;
                ProcessChecklistHdr.Modify;
            until ProcessChecklistHdr.Next = 0;
    end;

    local procedure CheckOrderQuantity(var TransLineToCheck: Record "Rent Transfer Line")
    var
        TransHeaderToCheck: Record "Rent Transfer Header";
        RentLineToCheck: Record "Rent Line";
    begin
        if TransHeaderToCheck.Get(TransLineToCheck."Document No.") and RentLineToCheck.Get(RentLineToCheck."document type"::Order, TransLineToCheck."Rent Order No.", TransLineToCheck."Rent Line No.") then
            if (TransLineToCheck.Quantity + GetPostedTransferQuantity(TransHeaderToCheck, RentLineToCheck) > RentLineToCheck."Rent Asset Quantity") and (TransHeaderToCheck."Transfer Type" <> TransHeaderToCheck."Transfer Type"::Internal) then
                Error(RentOrderTranferQtyExceedErr);
    end;

    local procedure GetPostedTransferQuantity(var TransHeaderToCheck: Record "Rent Transfer Header"; var RentLineToCheck: Record "Rent Line"): Decimal
    var
        PstTransHeaderToCheck: Record "Posted Rent Transfer Header";
        PstTransLineToCheck: Record "Posted Rent Transfer Line";
        PstQuantity: Decimal;
    begin
        PstTransLineToCheck.Reset();
        PstTransLineToCheck.SetRange("Rent Order No.", RentLineToCheck."Document No.");
        PstTransLineToCheck.SetRange("Rent Line No.", RentLineToCheck."Line No.");
        if PstTransLineToCheck.FindFirst then
            repeat
                PstTransHeaderToCheck.get(PstTransLineToCheck."Document No.");
                if PstTransHeaderToCheck."Transfer Type" = TransHeaderToCheck."Transfer Type" then
                    PstQuantity += PstTransLineToCheck.Quantity;
            until PstTransLineToCheck.Next() = 0;
        Exit(PstQuantity);
    end;

    procedure CheckCounters(var TransLineToCheck: Record "Rent Transfer Line")
    var
        RentSetup: Record "Rent Mgt. Setup";
        RentAsset: Record "Rent Asset";
        RentCategory: Record "Rent Item Category";
        CheckVF1: Boolean;
        CheckVF2: Boolean;
        CheckVF3: Boolean;
        AppEventMgt: Codeunit "Application Event Management";
        RentInfoPaneMgt: Codeunit "Rent Info-Pane Mgt.";
    begin
        RentSetup.Get;
        if TransLineToCheck."Rent Asset No." <> '' then begin
            RentAsset.Get(TransLineToCheck."Rent Asset No.");
            if RentAsset."Rent Item Category Code" <> '' then begin
                RentCategory.Get(RentAsset."Rent Item Category Code");
                CheckVF1 := RentCategory."Check VF Run 1 on Release";
                CheckVF2 := RentCategory."Check VF Run 2 on Release";
                CheckVF3 := RentCategory."Check VF Run 3 on Release";
            end;
        end;

        if (RentSetup."Check VF Run 1 on Release" or CheckVF1) then begin
            TransLineToCheck.TestField("Rent Asset No.");
            if TransLineToCheck."Variable Field Run 1" = 0 then
                Error(Text101, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006626,570'), TransLineToCheck."Line No.", TransLineToCheck."Rent Asset No.");

            if TransLineToCheck."Variable Field Run 1" < RentInfoPaneMgt.CalcLastVFRun1(TransLineToCheck."Rent Asset No.") then
                Error(Text100, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006626,570'), TransLineToCheck."Line No.", TransLineToCheck."Rent Asset No.", RentInfoPaneMgt.CalcLastVFRun1(TransLineToCheck."Rent Asset No."));
        end;

        if (RentSetup."Check VF Run 2 on Release" or CheckVF2) then begin
            TransLineToCheck.TestField("Rent Asset No.");
            if TransLineToCheck."Variable Field Run 2" = 0 then
                Error(Text101, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006626,580'), TransLineToCheck."Line No.", TransLineToCheck."Rent Asset No.");

            if TransLineToCheck."Variable Field Run 2" < RentInfoPaneMgt.CalcLastVFRun2(TransLineToCheck."Rent Asset No.") then
                Error(Text100, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006626,580'), TransLineToCheck."Line No.", TransLineToCheck."Rent Asset No.", RentInfoPaneMgt.CalcLastVFRun2(TransLineToCheck."Rent Asset No."));
        end;

        if (RentSetup."Check VF Run 3 on Release" or CheckVF3) then begin
            TransLineToCheck.TestField("Rent Asset No.");
            if TransLineToCheck."Variable Field Run 3" = 0 then
                Error(Text101, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006626,590'), TransLineToCheck."Line No.", TransLineToCheck."Rent Asset No.");

            if TransLineToCheck."Variable Field Run 3" < RentInfoPaneMgt.CalcLastVFRun3(TransLineToCheck."Rent Asset No.") then
                Error(Text100, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006626,590'), TransLineToCheck."Line No.", TransLineToCheck."Rent Asset No.", RentInfoPaneMgt.CalcLastVFRun3(TransLineToCheck."Rent Asset No."));
        end;
    end;

    procedure CreateRentServiceTransferOrder(RentHeader: Record "Rent Header"; RentLineNo: Integer; CreateForLine: Boolean): Boolean
    var
        Selection: Option " ",Shipment,Receipt;
        DefaultNumber: Option " ",Shipment,Receipt;
        RentLine: Record "Rent Line";
        PrevLocationFrom: Code[10];
        PrevLocationTo: Code[10];
        TransferType: Integer;
        TransferFrom: Code[10];
        TransferTo: Code[10];
        n: Integer;
        PrevTransferDate: Date;
        TransferDate: Date;
        RentTransferOrder: Page "Rent Transfer Order";

        ChooseRentLines: Page "Rent Order Choose Line";
        ChooseRentLinesFilter: Text;
    begin
        Selection := StrMenu(Text013, DefaultNumber);
        if Selection = 0 then
            exit;

        RentSetup.Get;
        RentSetup.TestField("Rent Service Location Code");
        if Selection = 1 then begin
            //To Service
            TransferType := TransHeader."transfer type"::Internal;
            TransferTo := RentSetup."Rent Service Location Code";
        end else begin
            //From Service
            TransferType := TransHeader."transfer type"::Internal;
            TransferFrom := RentSetup."Rent Service Location Code";
        end;


        //Choose Rent Lines
        RentLine.Reset;
        RentLine.SetRange("Document No.", RentHeader."No.");
        RentLine.SetRange("Document Type", RentHeader."Document Type");
        RentLine.SetRange("Locks Line", 0);


        if RentLine.FindFirst() then begin
            RentLine.ClearMarks();
            repeat
                RentLine.CalcFields("Quantity Shipped", "Quantity Returned");
                if Selection = 1 then begin
                    if RentLine.Status <> RentLine.Status::"In Service" then begin
                        RentLine.Mark(true);
                        //message('mark shipp: ' + format(RentLine."Quantity Shipped") + ' ' + format(RentLine."Rent Asset Quantity"));
                    end;
                end else begin
                    if RentLine.Status = RentLine.Status::"In Service" then begin
                        RentLine.Mark(true);
                        //message('mark return');
                    end;
                end;
            until RentLine.Next() = 0;
        end;

        RentLine.MarkedOnly(true);

        //if RentLine.FindFirst() then
        //    repeat
        //        Message(Format(RentLine."Line No."));
        //    until RentLine.Next() = 0;


        if RentLine.Count > 1 then begin
            ChooseRentLines.SetRecord(RentLine);
            ChooseRentLines.SetTableView(RentLine);
            ChooseRentLines.LookupMode(true);

            if ChooseRentLines.RunModal = ACTION::LookupOK then begin
                ChooseRentLines.SetSelectionFilter(RentLine);
            end else
                Exit(false);
        end;

        n := 0;
        TransLine.LockTable;


        //if Selection = 1 then
        //    RentLine.SetFilter("Actual Shipment Date", '%1', 0D)
        //else
        //    RentLine.SetFilter("Actual Return Date", '%1', 0D);

        if CreateForLine then
            RentLine.SetRange("Line No.", RentLineNo);
        if Selection = 1 then
            RentLine.SetCurrentkey("Location Code", "Planned Shipment Date")
        else begin
            if RentHeader."Rent Type" = RentHeader."Rent Type"::"Open End Date" then
                RentLine.SetCurrentkey("Location Code", "Last Date Invoiced")
            else
                RentLine.SetCurrentkey("Location Code", "Planned Return Date");
        end;

        if RentLine.FindFirst then begin
            repeat
                RentLine.CalcFields("Quantity Shipped", "Quantity Returned");
                RentLine.TestField("Location Code");
                if Selection = 1 then begin
                    if RentLine."Quantity Shipped" > RentLine."Quantity Returned" then
                        TransferFrom := RentSetup."Default Cust. Location Code"
                    else
                        TransferFrom := RentLine."Location Code";
                    TransferDate := Today;
                end else begin
                    if RentLine."Quantity Shipped" > RentLine."Quantity Returned" then
                        TransferTo := RentSetup."Default Cust. Location Code"
                    else
                        TransferTo := RentLine."Location Code";
                    TransferDate := Today;
                end;
                if (PrevLocationFrom <> TransferFrom) or (PrevLocationTo <> TransferTo) then begin
                    InsertRentTransferHeader(RentHeader, TransHeader, TransferType, TransferFrom, TransferTo, Today);
                    n += 1;
                end;
                PrevLocationFrom := TransferFrom;
                PrevLocationTo := TransferTo;
                TransLine.Init;
                TransLine."Document No." := TransHeader."No.";
                TransLine."Line No." := RentLine."Line No.";
                TransLine."Rent Item No." := RentLine."Rent Item No.";
                TransLine.Description := RentLine.Description;
                TransLine.Quantity := RentLine."Rent Asset Quantity";
                TransLine."Rent Asset No." := RentLine."Rent Asset No.";
                TransLine."Rent Order No." := RentLine."Document No.";
                TransLine."Rent Line No." := RentLine."Line No.";
                TransLine.Insert;
            until RentLine.Next = 0;
        end;

        if n <> 0 then begin
            if Confirm(Text011, true, TransHeader."No.") then begin
                RentTransferOrder.SetRecord(TransHeader);
                RentTransferOrder.Run;
            end;
        end else
            Message(Text012);

        Clear(TransHeader);
    end;

    procedure UpdateVehicle(RentTransferLine: Record "Rent Transfer Line")
    var
        RentTransferOrder: Record "Rent Transfer Header";
        Vehicle: Record Vehicle;
        Location: Record Location;
        RentMgtSetup: Record "Rent Mgt. Setup";
        RentOrder: Record "Rent Header";
        RentAsset: Record "Rent Asset";
    begin
        RentMgtSetup.Get();
        if Not RentMgtSetup."Veh.Cust.Change on RentTransf." then
            Exit;

        RentTransferOrder.Get(RentTransferLine."Document No.");
        if RentOrder.Get(RentOrder."Document Type"::Order, RentTransferOrder."Rent Order No.") then begin
            CASE RentTransferOrder."Transfer Type" OF
                RentTransferOrder."Transfer Type"::Shipment:
                    begin
                        if Vehicle.Get(RentTransferLine."Vehicle Serial No.") then begin
                            Vehicle.Validate("Customer No.", RentTransferOrder."Sell-to Customer No.");
                            If RentTransferOrder."Ship-to Code" <> '' then
                                Vehicle."Customer Service Address Code" := RentTransferOrder."Ship-to Code";
                            if Location.Get(RentTransferOrder."Transfer-from Code") then begin
                                Vehicle.Validate("Bill-To Customer No.", Location."Rent Internal Customer No.");
                                if Location."Rent Vehicle Status Code" <> '' then
                                    Vehicle."Status Code" := Location."Rent Vehicle Status Code";
                            end;
                            Vehicle.Modify();
                        end;
                    end;
                RentTransferOrder."Transfer Type"::Receipt:
                    begin
                        if RentTransferOrder."Transfer-to Code" = RentMgtSetup."Rent Service Location Code" then begin
                            if GuiAllowed and CONFIRM(RentVhehicleChangeCustomerLbl, false) then begin
                                if Vehicle.Get(RentTransferLine."Vehicle Serial No.") then begin
                                    RentAsset.Get(RentTransferLine."Rent Asset No.");
                                    if Location.Get(RentAsset."Location Code") then begin
                                        Vehicle.Validate("Customer No.", Location."Rent Internal Customer No.");
                                        Vehicle.Validate("Bill-To Customer No.", '');
                                        Vehicle.Modify();
                                    end;
                                end;
                            end;
                        end else
                            if Vehicle.Get(RentTransferLine."Vehicle Serial No.") then begin
                                if Location.Get(RentTransferOrder."Transfer-to Code") then
                                    Vehicle.Validate("Customer No.", Location."Rent Internal Customer No.");
                                Vehicle.Validate("Bill-To Customer No.", '');
                                Vehicle.Modify();
                            end;
                    end;
            END;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertRentTransferLine(var PostedTransferHeader: Record "Posted Rent Transfer Header"; PostedRentTransferLine: Record "Posted Rent Transfer Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertRentTransferHeader(var PostedTransferHeader: Record "Posted Rent Transfer Header"; TransferHeader: Record "Rent Transfer Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertRentTransferLine(var PostedTransferLine: Record "Posted Rent Transfer Line"; TransferLine: Record "Rent Transfer Line")
    begin
    end;

}

