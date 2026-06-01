Codeunit 25006131 "Service-Disc. EDMS (Yes/No)"
{
    TableNo = "Service Line EDMS";

    trigger OnRun()
    begin
        ServLine.Copy(Rec);
        if Confirm(Text000, false) then
            SalesCalcDisc.Run(ServLine);
        Rec := ServLine;
    end;

    var
        Text000: label 'Do you want to calculate the invoice discount?';
        ServLine: Record "Service Line EDMS";
        SalesCalcDisc: Codeunit "Service-Calc. Discount EDMS";
}

