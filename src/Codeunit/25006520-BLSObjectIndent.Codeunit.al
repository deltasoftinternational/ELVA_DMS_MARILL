Codeunit 25006520 "BLS Object-Indent"
{
    TableNo = "BLS Object";

    trigger OnRun()
    begin
        if not
           Confirm(Text000 + Text001 + Text002 + Text003, true)
        then
            exit;

        Indent;
    end;

    var
        BLSObject: Record "BLS Object";
        Window: Dialog;
        ObjectCode: array[10] of Code[20];
        i: Integer;
        Text000: label 'This function updates the indentation of all the obejcts. ';
        Text001: label 'All objects between a Begin-Total and the matching End-Total are indented by one level. ';
        Text002: label 'The Totaling field for each End-Total is also updated.\\';
        Text003: label 'Do you want to indent the objects?';
        Text004: label 'Indenting Objects @1@@@@@@@@@@@@@@@@@@';
        Text005: label 'End-Total %1 is missing a matching Begin-Total.';


    procedure Indent()
    var
        NoOfBillObjects: Integer;
        Progress: Integer;
    begin
        Window.Open(Text004);

        NoOfBillObjects := BLSObject.Count;
        if NoOfBillObjects = 0 then
            NoOfBillObjects := 1;

        if BLSObject.Find('-') then
            repeat
                Progress := Progress + 1;
                Window.Update(1, 10000 * Progress DIV NoOfBillObjects);

                if BLSObject."Object Type" = BLSObject."object type"::"End-Total" then begin
                    if i < 1 then
                        Error(
                          Text005,
                          BLSObject.Code);
                    BLSObject.Totaling := ObjectCode[i] + '..' + BLSObject.Code;
                    i := i - 1;
                end;

                BLSObject.Indentation := i;
                BLSObject.Modify;

                if BLSObject."Object Type" = BLSObject."object type"::"Begin-Total" then begin
                    i := i + 1;
                    ObjectCode[i] := BLSObject.Code;
                end;
            until BLSObject.Next = 0;

        Window.Close;
    end;
}

