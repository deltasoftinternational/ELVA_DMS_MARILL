/*
Codeunit 25006701 "SIE Exchange Mgt."
{

    trigger OnRun()
    var
        SIESetup: Record "SIE Setup";
        XMLFile: File;
        XMLin: InStream;
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
    begin
        SIESetup.Get;
        TempBlob.CreateInStream(XMLin);
        Xmlport.Import(Xmlport::"SIE Import", XMLin);
        if UploadIntoStream('Import', '', '', SIESetup."File Name", XMLin) then;


        // if Exists(SIESetup."File Name") then begin//FIXME
        //     XMLFile.Open(SIESetup."File Name");
        //     XMLFile.CreateInstream(XMLin);
        //     Xmlport.Import(Xmlport::"SIE Import", XMLin);
        //     XMLFile.Close;
        //     Erase(SIESetup."File Name");//FiME
        // end
    end;

    var
        SIE: Record "Special Inventory Equipment";
        Descr: Text[50];
        Text000: label 'SIE';
        Text001: label 'Special Inventory Equip. Journal';
        Text002: label 'Recurring';
        Text003: label 'Recurring Spec. Invt. Equip. Journal';
        Text004: label 'DEFAULT';
        Text005: label 'Default Journal';


    procedure CheckMandatoryFields(SIEJnl: Record "SIE Journal Line"): Text[200]
    var
        AppMgt: Codeunit DocumentManagementDMS;
        RecRef: RecordRef;
        RecRef2: RecordRef;
        FldRef: FieldRef;
        i: Integer;
        k: Integer;
        Txt: Text[200];
    begin
        GetSIE(SIEJnl."SIE No.", Descr);
        RecRef.GetTable(SIEJnl);
        RecRef2.GetTable(SIE);
        for i := 0 to 4 do begin
            FldRef := RecRef2.Field(SIE.FieldNo("Mand.1 Field") + (i * 10));
            k := FldRef.Value;
            if k <> 0 then begin
                FldRef := RecRef.Field(k);
                if IsEmptyFieldRef(FldRef) then
                    if Txt = '' then
                        Txt := AppMgt.CaptionClassTranslate_off(GlobalLanguage, SIEJnl.GetCaption(FldRef.Number))
                    else
                        Txt := Txt + ',' + AppMgt.CaptionClassTranslate_off(GlobalLanguage, SIEJnl.GetCaption(FldRef.Number))
            end;
        end;
        exit(Txt)
    end;


    procedure GetSIE(SIENo: Code[10]; var Descr: Text[50])
    begin
        if SIE."No." <> SIENo then begin
            Descr := '';
            if SIENo <> '' then
                if SIE.Get(SIENo) then
                    Descr := SIE.Description
        end
    end;


    procedure IsEmptyFieldRef(FRef: FieldRef): Boolean
    var
        Fld: Record "Field";
        intvar: Integer;
        txtvar: Text[20];
    begin
        Evaluate(Fld.Type, Format(FRef.Type));
        case Fld.Type of
            Fld.Type::Code, Fld.Type::Text:
                begin
                    txtvar := FRef.Value;
                    exit(txtvar = '');
                end;
            Fld.Type::Date:
                exit(Variant2Date(FRef.Value) = 0D);
            Fld.Type::Integer, Fld.Type::Decimal:
                begin
                    intvar := FRef.Value;
                    exit(intvar = 0);
                end;
            else begin
                Fld.Get(FRef.Record.Number, FRef.Number);
                Fld.FieldError(Type);
            end
        end
    end;


    procedure TemplateSelection(FormID: Integer; RecurringJnl: Boolean; var SIEJnlLine: Record "SIE Journal Line"; var JnlSelected: Boolean)
    var
        SIEJnlTemplate: Record "Item Journal Template";
    begin
        JnlSelected := true;

        SIEJnlTemplate.Reset;
        SIEJnlTemplate.SetRange("Page ID", FormID);
        SIEJnlTemplate.SetRange(Recurring, RecurringJnl);

        case SIEJnlTemplate.Count of
            0:
                begin
                    SIEJnlTemplate.Init;
                    SIEJnlTemplate.Recurring := RecurringJnl;
                    if not RecurringJnl then begin
                        SIEJnlTemplate.Name := Text000;
                        SIEJnlTemplate.Description := Text001;
                    end else begin
                        SIEJnlTemplate.Name := Text002;
                        SIEJnlTemplate.Description := Text003;
                    end;
                    SIEJnlTemplate.Validate("Page ID");
                    SIEJnlTemplate.Insert;
                    Commit;
                end;
            1:
                SIEJnlTemplate.Find('-');
            else
                JnlSelected := Page.RunModal(0, SIEJnlTemplate) = Action::LookupOK;
        end;
        if JnlSelected then begin
            SIEJnlLine.FilterGroup := 2;
            SIEJnlLine.SetRange("Journal Template Name", SIEJnlTemplate.Name);
            SIEJnlLine.FilterGroup := 0;
        end;
    end;


    procedure OpenJournal(var CurrentJnlBatchName: Code[10]; var SIEJnlLine: Record "SIE Journal Line")
    begin
        CheckTemplateName(SIEJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
        SIEJnlLine.FilterGroup := 2;
        SIEJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        SIEJnlLine.FilterGroup := 0;
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10]; var SIEJnlLine: Record "SIE Journal Line")
    var
        SIEJnlBatch: Record "Item Journal Batch";
    begin
        SIEJnlBatch.Get(SIEJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10]; var SIEJnlLine: Record "SIE Journal Line")
    begin
        SIEJnlLine.FilterGroup := 2;
        SIEJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        SIEJnlLine.FilterGroup := 0;
        if SIEJnlLine.Find('-') then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10]; var SIEJnlLine: Record "SIE Journal Line"): Boolean
    var
        SIEJnlBatch: Record "Item Journal Batch";
    begin
        Commit;
        SIEJnlBatch."Journal Template Name" := SIEJnlLine.GetRangemax("Journal Template Name");
        SIEJnlBatch.Name := SIEJnlLine.GetRangemax("Journal Batch Name");
        SIEJnlBatch.FilterGroup := 2;
        SIEJnlBatch.SetRange("Journal Template Name", SIEJnlBatch."Journal Template Name");
        SIEJnlBatch.FilterGroup := 0;
        if Page.RunModal(0, SIEJnlBatch) = Action::LookupOK then begin
            CurrentJnlBatchName := SIEJnlBatch.Name;
            SetName(CurrentJnlBatchName, SIEJnlLine);
        end;
    end;

    local procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        SIEJnlBatch: Record "Item Journal Batch";
    begin
        if not SIEJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            SIEJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
            if SIEJnlBatch.IsEmpty then begin
                SIEJnlBatch.Init;
                SIEJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                SIEJnlBatch.SetupNewBatch;
                SIEJnlBatch.Name := Text004;
                SIEJnlBatch.Description := Text005;
                SIEJnlBatch.Insert(true);
                Commit;
            end;
            CurrentJnlBatchName := SIEJnlBatch.Name;
        end;
    end;
}
*/