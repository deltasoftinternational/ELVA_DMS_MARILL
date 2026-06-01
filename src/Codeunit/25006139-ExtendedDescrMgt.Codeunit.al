Codeunit 25006139 "Extended Descr. Mgt"
{

    trigger OnRun()
    begin
    end;

    procedure Input(ExistingText: Text; FieldLabel: Text; MaxTextLen: Integer; MultiLine: Boolean; var NewText: Text): Boolean
    var
        ExtendedDescrDiag: Page "Extended Descr. Dialog";
        UpdateText: Boolean;
    begin
        ExtendedDescrDiag.SetFieldLabel(FieldLabel);
        if (CurrentClientType = Clienttype::Web) OR (CURRENTCLIENTTYPE = CLIENTTYPE::Desktop) then begin
            ExtendedDescrDiag.SetFontSize(11);
            ExtendedDescrDiag.SetShowButtons(false);
            ExtendedDescrDiag.SetSingleLineField(not MultiLine);
            ExtendedDescrDiag.SetFieldData(ExistingText);
            if MaxTextLen > 0 then
                ExtendedDescrDiag.SetFieldLength(MaxTextLen);
            ExtendedDescrDiag.RunModal;
            NewText := ExtendedDescrDiag.GetFieldData();
            UpdateText := true;
        end
        else begin
            ExtendedDescrDiag.SetFontSize(11);
            ExtendedDescrDiag.SetShowButtons(true);
            ExtendedDescrDiag.SetSingleLineField(not MultiLine);
            ExtendedDescrDiag.SetFieldData(ExistingText);
            if MaxTextLen > 0 then
                ExtendedDescrDiag.SetFieldLength(MaxTextLen);
            ExtendedDescrDiag.RunModal;
            if ExtendedDescrDiag.DidUserPressOK then begin
                NewText := ExtendedDescrDiag.GetFieldData();
                UpdateText := true;
            end;
        end;

        exit(UpdateText);
    end;

    procedure ShowReadOnly(ExistingText: Text)
    var
        ExtendedDescrDiag: Page "Extended Descr. Dialog";
    begin
        ExtendedDescrDiag.SetFontSize(11);
        ExtendedDescrDiag.SetShowButtons(false);
        ExtendedDescrDiag.SetSingleLineField(true);
        ExtendedDescrDiag.SetFieldReadOnly(true);
        ExtendedDescrDiag.SetFieldData(ExistingText);
        ExtendedDescrDiag.RunModal;
    end;
}

