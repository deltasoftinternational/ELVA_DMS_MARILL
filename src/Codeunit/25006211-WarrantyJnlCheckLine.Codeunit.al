Codeunit 25006211 "Warranty Jnl.-Check Line"
{
    TableNo = "Warranty Journal Line";

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


    procedure RunCheck(var WarrantyJnlLine: Record "Warranty Journal Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        if WarrantyJnlLine.EmptyLine then
            exit;

        //TESTFIELD("Vehicle Serial No.");
        WarrantyJnlLine.TestField("Posting Date");
        //TESTFIELD("Make Code");
        //TESTFIELD("Model Code");

        if WarrantyJnlLine."Posting Date" <> NormalDate(WarrantyJnlLine."Posting Date") then
            WarrantyJnlLine.FieldError("Posting Date", Text000);

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
        if (WarrantyJnlLine."Posting Date" < AllowPostingFrom) or (WarrantyJnlLine."Posting Date" > AllowPostingTo) then
            WarrantyJnlLine.FieldError("Posting Date", Text001);

        if (WarrantyJnlLine."Document Date" <> 0D) then
            if (WarrantyJnlLine."Document Date" <> NormalDate(WarrantyJnlLine."Document Date")) then
                WarrantyJnlLine.FieldError("Document Date", Text000);
    end;
}

