Codeunit 25006012 "Datetime Mgt."
{
    // 15.07.2008. EDMS P2
    //   * Move from Microsoft Dynamics 4.0


    trigger OnRun()
    begin
    end;


    procedure Datetime(Date: Date; Time: Time): Decimal
    begin
        if Date = 0D then
            Date := 00000101D;

        if Time = 0T then
            exit((Date - 00000101D) * 86.4)
        else
            exit(((Date - 00000101D) * 86.4) + (Time - 000000T) / 1000000);
    end;


    procedure Datetime2Time(Datetime: Decimal): Time
    begin
        if Datetime = 0 then
            exit(0T);
        exit(000000T + (Datetime MOD 86.4) * 1000000);
    end;


    procedure Datetime2Date(Datetime: Decimal): Date
    begin
        if Datetime = 0 then
            exit(0D);
        exit(00000101D + ROUND(Datetime / 86.4, 1, '<'));
    end;


    procedure Datetime2Text(Datetime: Decimal): Text[260]
    begin
        if Datetime = 0 then
            exit('')
        else
            exit(StrSubstNo('%1 %2', Datetime2Date(Datetime), Datetime2Time(Datetime)));
    end;


    procedure Text2Datetime(Text: Text[260]): Decimal
    var
        Pos: Integer;
        Date: Date;
        Time: Time;
    begin
        Text := DelChr(Text, '<>', ' ');
        if StrLen(Text) = 0 then
            exit(0);

        Pos := StrPos(Text, ' ');
        if Pos = 0 then
            Pos := StrPos(Text, '+');
        if Pos > 0 then begin
            Evaluate(Date, CopyStr(Text, 1, Pos - 1));
            Evaluate(Time, CopyStr(Text, Pos + 1));
        end else begin
            Evaluate(Date, Text);
            Time := 000000T;
        end;

        exit(Datetime(Date, Time));
    end;
}

