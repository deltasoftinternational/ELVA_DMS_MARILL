Codeunit 25006615 "Rent Event Management"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Rent Asset", 'OnAfterModifyEvent', '', true, true)]
    local procedure AfterOnRentAssetModify(var Rec: Record "Rent Asset"; var xRec: Record "Rent Asset"; RunTrigger: Boolean)
    var
        RentAssetChangeLogEntry: Record "Rent Asset Status Change Log";
    begin
        // IF Rec.ISTEMPORARY THEN
        //  EXIT;
        //
        // IF Rec.Status <> xRec.Status THEN
        //  RentAssetChangeLogEntry.AddChangeLogEntry(Rec."No.",Rec.Status,xRec.Status);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Rent Asset", 'OnAfterValidateEvent', 'Status', true, true)]
    local procedure AfterOnRentAssetStatusValidate(var Rec: Record "Rent Asset"; var xRec: Record "Rent Asset"; CurrFieldNo: Integer)
    var
        RentAssetChangeLogEntry: Record "Rent Asset Status Change Log";
    begin
        if Rec.IsTemporary then
            exit;

        RentAssetChangeLogEntry.AddChangeLogEntry(Rec."No.", Rec.Status, xRec.Status);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Rent Line", 'OnAfterValidateEvent', 'Rent Asset No.', true, true)]
    local procedure AfterOnRentAssetNoValidate(var Rec: Record "Rent Line"; var xRec: Record "Rent Line"; CurrFieldNo: Integer)
    var
        RentAsset: Record "Rent Asset";
    begin
        if Rec.IsTemporary then
            exit;

        if (xRec."Rent Asset No." <> '') and (Rec."Rent Asset No." = '') then begin
            RentAsset.Get(xRec."Rent Asset No.");
            if (RentAsset."Asset Type" <> RentAsset."Asset Type"::Multiple) and (RentAsset.Status = RentAsset.Status::Reserved) then begin
                RentAsset.Status := RentAsset.Status::Available;
                RentAsset.Modify;
            end;
        end;

        if (Rec."Rent Asset No." <> '') and (xRec."Rent Asset No." = '') then begin
            RentAsset.Get(Rec."Rent Asset No.");
            if (RentAsset."Asset Type" <> RentAsset."Asset Type"::Multiple) and (RentAsset.Status = RentAsset.Status::Available) then begin
                RentAsset.Status := RentAsset.Status::Reserved;
                RentAsset.Modify;
            end;
        end;

        if (Rec."Rent Asset No." <> '') and (xRec."Rent Asset No." <> '') then begin
            RentAsset.Get(Rec."Rent Asset No.");
            if (RentAsset."Asset Type" <> RentAsset."Asset Type"::Multiple) and (RentAsset.Status = RentAsset.Status::Available) then begin
                RentAsset.Status := RentAsset.Status::Reserved;
                RentAsset.Modify;
            end;
            RentAsset.Get(xRec."Rent Asset No.");
            if (RentAsset."Asset Type" <> RentAsset."Asset Type"::Multiple) and (RentAsset.Status = RentAsset.Status::Reserved) then begin
                RentAsset.Status := RentAsset.Status::Available;
                RentAsset.Modify;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Rent Line", 'OnAfterDeleteEvent', '', true, true)]
    local procedure AfterOnDeleteRentLine(var Rec: Record "Rent Line"; RunTrigger: Boolean)
    var
        RentAsset: Record "Rent Asset";
        RentLineCheck: Record "Rent Line";
    begin
        if Rec.IsTemporary then
            exit;

        if Rec."Rent Asset No." <> '' then begin
            RentAsset.Get(Rec."Rent Asset No.");
            if RentAsset."Asset Type" <> RentAsset."Asset Type"::Multiple then begin
                RentLineCheck.Reset();
                RentLineCheck.SetRange("Rent Asset No.", Rec."Rent Asset No.");
                if not RentLineCheck.FindSet() then begin
                    RentAsset.Status := RentAsset.Status::Available;
                    RentAsset.Modify;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Header EDMS", 'OnAfterValidateEvent', 'Vehicle Serial No.', true, true)]
    local procedure AfterOnServiceOrderVehicleSerialNoValidate(var Rec: Record "Service Header EDMS"; var xRec: Record "Service Header EDMS"; CurrFieldNo: Integer)
    var
        RentAsset: Record "Rent Asset";
    begin
        if Rec.IsTemporary then
            exit;

        if xRec."Vehicle Serial No." <> '' then begin
            RentAsset.Reset;
            RentAsset.SetRange("Vehicle Serial No.", xRec."Vehicle Serial No.");
            if RentAsset.FindFirst and (RentAsset."Asset Type" <> RentAsset."Asset Type"::Multiple) then begin
                RentAsset.Status := RentAsset.Status::Available;
                RentAsset.Modify;
            end;
        end;

        if Rec."Vehicle Serial No." <> '' then begin
            RentAsset.Reset;
            RentAsset.SetRange("Vehicle Serial No.", Rec."Vehicle Serial No.");
            if RentAsset.FindFirst and (RentAsset."Asset Type" <> RentAsset."Asset Type"::Multiple) and (RentAsset.Status <> RentAsset.Status::Disposed) then begin
                RentAsset.Status := RentAsset.Status::"Service Planned";
                RentAsset.Modify;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Header EDMS", 'OnAfterDeleteEvent', '', true, true)]
    local procedure AfterOnServiceOrderDelete(var Rec: Record "Service Header EDMS"; RunTrigger: Boolean)
    var
        RentAsset: Record "Rent Asset";
        RentLine: Record "Rent Line";
    begin
        if Rec.IsTemporary then
            exit;

        if (Rec."Vehicle Serial No." <> '') and (Rec."Document Type" = Rec."document type"::Order) then begin
            RentAsset.Reset;
            RentAsset.SetRange("Vehicle Serial No.", Rec."Vehicle Serial No.");
            if RentAsset.FindFirst AND (RentAsset."Asset Type" <> RentAsset."Asset Type"::Multiple) and (RentAsset.Status <> RentAsset.Status::Disposed) then begin
                RentLine.Reset();
                RentLine.SetRange("Rent Asset No.", RentAsset."No.");
                Rentline.SetRange(Status, RentLine.Status::Rented);
                If RentLine.FindFirst() then begin
                    RentAsset.Status := RentAsset.Status::Rented;
                    RentAsset.Modify;
                end else begin
                    Rentline.SetRange(Status, RentLine.Status::Allocated);
                    If RentLine.FindFirst() then begin
                        RentAsset.Status := RentAsset.Status::Reserved;
                        RentAsset.Modify;
                    end else begin
                        RentAsset.Status := RentAsset.Status::Available;
                        RentAsset.Modify;
                    end;
                end;
            end;
        end;
    end;

    /*
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Rent Jnl.-Post Line", 'OnAfterPostRentJnlLine', '', true, true)]
        local procedure AfterOnPostRentJnlLine(var RentJnlLine: Record "Rent Journal Line")
        var
            RentSetup: Record "Rent Mgt. Setup";
            RentAsset: Record "Rent Asset";
        begin        
              if RentJnlLine."Entry Type" = RentJnlLine."entry type"::Inventory then begin
                RentSetup.Get;
                RentAsset.Get(RentJnlLine."Rent Asset No.");
                if RentSetup."Default Cust. Location Code" = RentJnlLine."Transfer-from Code" then
                  RentAsset.Status := RentAsset.Status::Available
                else
                  RentAsset.Status := RentAsset.Status::Rented;
                RentAsset.Modify;
              end;
        end;
        */
}

