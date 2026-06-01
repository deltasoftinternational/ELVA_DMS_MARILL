Codeunit 25006106 "Serv. Jnl.-Check Line"
{
    // 2012.03.12 EDMS P8
    //   * Tire Management implement

    TableNo = "Serv. Journal Line";

    trigger OnRun()
    begin
        GLSetup.Get;

        RunCheck(Rec);
    end;

    var
        Text000: label 'cannot be a closing date';
        Text001: label 'is not within your range of allowed posting dates';
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;


    procedure RunCheck(var ServJnlLine: Record "Serv. Journal Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        DealType: Record "Deal Type";
        VehicleNotMandatory: Boolean;
    begin
        if ServJnlLine.EmptyLine then
            exit;
        VehicleNotMandatory := false;
        if ServJnlLine."Deal Type Code" <> '' then begin
            if DealType.Get(ServJnlLine."Deal Type Code") then
                VehicleNotMandatory := DealType."Vehicle Not Mandatory";
        end;
        if not VehicleNotMandatory then begin
            ServJnlLine.TestField("Make Code");
            ServJnlLine.TestField("Model Code");
            ServJnlLine.TestField("Vehicle Serial No.");
        end;
        ServJnlLine.TestField("Posting Date");

        ServJnlLine.TestField("Gen. Prod. Posting Group");
        ServJnlLine.TestField(Quantity);

        if ServJnlLine."Posting Date" <> NormalDate(ServJnlLine."Posting Date") then
            ServJnlLine.FieldError("Posting Date", Text000);

        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
            if UserId <> '' then
                if UserSetup.Get(UserId) then begin
                    AllowPostingFrom := UserSetup."Allow Posting From";
                    AllowPostingTo := UserSetup."Allow Posting To";
                end;
            if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                GLSetup.Get;
                AllowPostingFrom := GLSetup."Allow Posting From";
                AllowPostingTo := GLSetup."Allow Posting To";
            end;
            if AllowPostingTo = 0D then
                AllowPostingTo := 99991231D;
        end;
        if (ServJnlLine."Posting Date" < AllowPostingFrom) or (ServJnlLine."Posting Date" > AllowPostingTo) then
            ServJnlLine.FieldError("Posting Date", Text001);

        if (ServJnlLine."Document Date" <> 0D) then
            if (ServJnlLine."Document Date" <> NormalDate(ServJnlLine."Document Date")) then
                ServJnlLine.FieldError("Document Date", Text000);


        //2012.03.12 EDMS P8 >>
        if (ServJnlLine."Vehicle Axle Code" <> '') or (ServJnlLine."Tire Position Code" <> '') or (ServJnlLine."Tire Code" <> '') or
          (ServJnlLine."Tire Operation Type" > 0) or (ServJnlLine."New Vehicle Axle Code" <> '') or (ServJnlLine."New Tire Position Code" <> '') then begin
            // ,Put on,Take off,Position Change
            ServJnlLine.TestField("Vehicle Axle Code");
            ServJnlLine.TestField("Tire Position Code");
            if ServJnlLine."Tire Operation Type" = ServJnlLine."tire operation type"::"Position Change" then begin
                ServJnlLine.TestField("New Vehicle Axle Code");
                ServJnlLine.TestField("New Tire Position Code");
            end;
            if ServJnlLine."Tire Operation Type" = ServJnlLine."tire operation type"::"Put on" then
                ServJnlLine.TestField("Tire Code");
        end;
        //2012.03.12 EDMS P8 <<
    end;
}

