Codeunit 25006110 "Ext. Service Jnl.-Check Line"
{
    TableNo = "External Serv. Journal Line";

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


    procedure RunCheck(var ExtServiceJnlLine: Record "External Serv. Journal Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin

        ExtServiceJnlLine.TestField("Ext. Service No.");
        ExtServiceJnlLine.TestField("Posting Date");
        ExtServiceJnlLine.TestField(Quantity);

        if ExtServiceJnlLine."Posting Date" <> NormalDate(ExtServiceJnlLine."Posting Date") then
            ExtServiceJnlLine.FieldError("Posting Date", Text000);

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
        if (ExtServiceJnlLine."Posting Date" < AllowPostingFrom) or (ExtServiceJnlLine."Posting Date" > AllowPostingTo) then
            ExtServiceJnlLine.FieldError("Posting Date", Text001);
    end;
}

