Page 25006108 "Extended Descr. Dialog"
{
    Caption = 'Extended Description Dialog';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Integer";

    layout
    {
        area(content)
        {
            usercontrol(ExtendedText; ExtendedTextAddIn)
            {
                ApplicationArea = Basic;

                trigger ControlAddInReady()
                begin
                    //FieldLength := 10000;
                    //FieldLabel := 'Test';
                    //FieldShowButtons := TRUE;
                    //FieldSingleLine := TRUE;
                    //FieldFontSize:= 14;
                    //FieldSingleLine := TRUE;
                    //FieldReadOnly := TRUE;
                    CurrPage.ExtendedText.RecieveExtendedTextParams(Format(FieldLength) + ';' + FieldLabel + ';' + Format(FieldShowButtons) + ';' + Format(FieldSingleLine) + ';' + Format(FieldFontSize) + ';' + Format(FieldReadOnly));
                    CurrPage.ExtendedText.RecieveInitExtendedTextData(FieldData);
                end;

                trigger UpdateField(Value: Text)
                begin
                    FieldData := Value;
                    //if CurrentClientType = Clienttype::Web then
                    //    CurrPage.Close;
                end;

                trigger UpdateFieldByKey(Value: Text)
                begin
                    FieldData := Value;
                end;

                trigger ExtendedButtonOk(Value: Text)
                begin
                    UserPressedOK := true;
                    FieldData := Value;
                    CurrPage.Close;
                end;

                trigger ExtendedButtonCancel(Value: Text)
                begin
                    CurrPage.Close;
                end;

                trigger RequestClosePage()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    actions
    {
    }


    trigger OnClosePage()
    begin
        //MESSAGE('onclose');
    end;

    trigger OnOpenPage()
    begin
        FormChanged := true;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if FormChanged then begin
            FormChanged := false;
            CurrPage.ExtendedText.RequestExtendedTextClose('');
            EXIT(false);
        end;
        //IF CloseAction = ACTION::OK THEN
        //  UserPressedOK := TRUE;
        //MESSAGE('CLOSE ACTION %1',CloseAction);
    end;

    var
        FieldData: Text;
        FieldLength: Integer;
        FieldLabel: Text;
        TestText: Text;
        FieldShowButtons: Boolean;
        FieldSingleLine: Boolean;
        FieldFontSize: Integer;
        UserPressedOK: Boolean;
        FieldReadOnly: Boolean;
        FormChanged: boolean;


    procedure SetShowButtons(Value: Boolean)
    begin
        FieldShowButtons := Value;

    end;

    procedure GetFieldData(): Text
    begin
        exit(FieldData);
    end;

    procedure SetFieldData(Value: Text)
    begin
        FieldData := Value;
    end;

    procedure SetFieldLength(Value: Integer)
    begin
        FieldLength := Value;
    end;

    procedure SetFieldLabel(Value: Text)
    begin
        FieldLabel := Value;
    end;

    procedure SetSingleLineField(Value: Boolean)
    begin
        FieldSingleLine := Value;

    end;

    procedure SetFontSize(Value: Integer)
    begin
        FieldFontSize := Value;

    end;

    procedure DidUserPressOK(): Boolean
    begin
        exit(UserPressedOK);
    end;

    procedure SetFieldReadOnly(Value: Boolean)
    begin
        FieldReadOnly := Value;

    end;
}

