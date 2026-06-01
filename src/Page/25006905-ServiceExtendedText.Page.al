Page 25006905 "Service Extended Text"
{
    Caption = 'Extended Text';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
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
                    FieldShowButtons := true;
                    FieldSingleLine := true;
                    //FieldFontSize:= 14;
                    CurrPage.ExtendedText.RecieveExtendedTextParams(Format(FieldLength) + ';' + FieldLabel + ';' + Format(FieldShowButtons) + ';' + Format(FieldSingleLine) + ';' + Format(FieldFontSize) + ';' + Format(FieldReadOnly));
                    CurrPage.ExtendedText.RecieveInitExtendedTextData(FieldData);
                end;

                trigger UpdateField(Value: Text)
                var
                    AddInData: Text;
                    DateFrom: Date;
                    DateTo: Date;
                begin
                    FieldData := Value;
                    CurrPage.Close;
                end;

                trigger ExtendedButtonOk(Value: Text)
                var
                    AddInData: Text;
                    DateFrom: Date;
                    DateTo: Date;
                begin
                    //MESSAGE('button ok');
                    FieldData := Value;
                    CurrPage.Close;
                end;

                trigger ExtendedButtonCancel(Value: Text)
                var
                    AddInData: Text;
                    DateFrom: Date;
                    DateTo: Date;
                begin
                    //MESSAGE('button cancel');
                    CurrPage.Close;
                end;
            }
        }
    }

    actions
    {
    }

    var
        FieldData: Text;
        FieldLength: Integer;
        FieldLabel: Text;
        FieldShowButtons: Boolean;
        FieldSingleLine: Boolean;
        FieldFontSize: Integer;
        FieldReadOnly: Boolean;


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

    procedure SetShowButtons(Value: Boolean)
    begin
        FieldShowButtons := Value;
    end;

    procedure SetSingleLineField(Value: Boolean)
    begin
        FieldSingleLine := Value;
    end;

    procedure SetFontSize(Value: Integer)
    begin
        FieldFontSize := Value;
    end;

    procedure SetFieldReadOnly(Value: Boolean)
    begin
        FieldReadOnly := Value;
    end;
}

