Codeunit 25006521 "BLSJnlManagement"
{

    trigger OnRun()
    begin
    end;

    var
        OpenFromBatch: Boolean;
        Text000: label 'SERVJNL';
        Text000DMS: label 'SERVJNLDMS';
        Text001: label 'BLS Service Journals';
        Text001DMS: label 'BLS Service Journals For DMS';
        Text002: label 'RECURRING';
        Text003: label 'Recurring BLS Service Journal';
        Text004: label 'DEFAULT';
        Text005: label 'Default Journal';


    procedure TemplateSelection(PageID: Integer; RecurringJnl: Boolean; var BLSJnlLine: Record "BLS Journal Line"; var JnlSelected: Boolean)
    var
        BLSJnlTemplate: Record "BLS Journal Template";
    begin
        JnlSelected := true;

        BLSJnlTemplate.Reset;
        BLSJnlTemplate.SetRange("Page ID", PageID);
        BLSJnlTemplate.SetRange(Recurring, RecurringJnl);

        case BLSJnlTemplate.Count of
            0:
                begin
                    BLSJnlTemplate.Init;
                    BLSJnlTemplate.Recurring := RecurringJnl;
                    if not RecurringJnl then begin
                        BLSJnlTemplate.Name := Text000DMS;
                        BLSJnlTemplate.Description := Text001DMS;
                    end else begin
                        BLSJnlTemplate.Name := Text002;
                        BLSJnlTemplate.Description := Text003;
                    end;
                    BLSJnlTemplate.Validate("Page ID", PageID);
                    BLSJnlTemplate.Insert;
                    Commit;
                end;
            1:
                BLSJnlTemplate.FindFirst;
            else
                JnlSelected := Page.RunModal(0, BLSJnlTemplate) = Action::LookupOK;
        end;
        if JnlSelected then begin
            BLSJnlLine.FilterGroup := 2;
            BLSJnlLine.SetRange("Journal Template Name", BLSJnlTemplate.Name);
            BLSJnlLine.FilterGroup := 0;
            if OpenFromBatch then begin
                BLSJnlLine."Journal Template Name" := '';
                Page.Run(BLSJnlTemplate."Page ID", BLSJnlLine);
            end;
        end;
    end;


    procedure TemplateSelectionFromBatch(var BLSJnlBatch: Record "BLS Journal Batch")
    var
        BLSJnlLine: Record "BLS Journal Line";
        BLSJnlTemplate: Record "BLS Journal Template";
    begin
        OpenFromBatch := true;
        BLSJnlTemplate.Get(BLSJnlBatch."Journal Template Name");
        BLSJnlTemplate.TestField("Page ID");
        BLSJnlBatch.TestField(Name);

        BLSJnlLine.FilterGroup := 2;
        BLSJnlLine.SetRange("Journal Template Name", BLSJnlTemplate.Name);
        BLSJnlLine.FilterGroup := 0;

        BLSJnlLine."Journal Template Name" := '';
        BLSJnlLine."Journal Batch Name" := BLSJnlBatch.Name;
        Page.Run(BLSJnlTemplate."Page ID", BLSJnlLine);
    end;


    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var BLSJnlLine: Record "BLS Journal Line")
    begin
        CheckTemplateName(BLSJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
        BLSJnlLine.FilterGroup := 2;
        BLSJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        BLSJnlLine.FilterGroup := 0;
    end;


    procedure OpenJnlBatch(var BLSJnlBatch: Record "BLS Journal Batch")
    var
        BLSJnlTemplate: Record "BLS Journal Template";
        BLSJnlLine: Record "BLS Journal Line";
        JnlSelected: Boolean;
    begin
        if BLSJnlBatch.GetFilter("Journal Template Name") <> '' then
            exit;
        BLSJnlBatch.FilterGroup(2);
        if BLSJnlBatch.GetFilter("Journal Template Name") <> '' then begin
            BLSJnlBatch.FilterGroup(0);
            exit;
        end;
        BLSJnlBatch.FilterGroup(0);

        if not BLSJnlBatch.Find('-') then begin
            //  FOR BLSJnlTemplate.Type := BLSJnlTemplate.Type::"0" TO BLSJnlTemplate.Type::"1" DO BEGIN
            //    BLSJnlTemplate.SETRANGE(Type,BLSJnlTemplate.Type);
            //    IF NOT BLSJnlTemplate.FINDFIRST THEN
            //      TemplateSelection(0,BLSJnlTemplate.Type,FALSE,BLSJnlLine,JnlSelected);
            //    IF BLSJnlTemplate.FINDFIRST THEN
            //      CheckTemplateName(BLSJnlTemplate.Name,BLSJnlBatch.Name);
            //    BLSJnlTemplate.SETRANGE(Recurring,TRUE);
            //    IF NOT BLSJnlTemplate.FINDFIRST THEN
            //      TemplateSelection(0,BLSJnlTemplate.Type,TRUE,BLSJnlLine,JnlSelected);
            //    IF BLSJnlTemplate.FINDFIRST THEN
            //      CheckTemplateName(BLSJnlTemplate.Name,BLSJnlBatch.Name);
            //    BLSJnlTemplate.SETRANGE(Recurring);
            //  END;
        end;

        BLSJnlBatch.Find('-');
        JnlSelected := true;
        BLSJnlBatch.CalcFields(Recurring);
        BLSJnlTemplate.SetRange(Recurring, BLSJnlBatch.Recurring);
        if BLSJnlBatch.GetFilter("Journal Template Name") <> '' then
            BLSJnlTemplate.SetRange(Name, BLSJnlBatch.GetFilter("Journal Template Name"));
        case BLSJnlTemplate.Count of
            1:
                BLSJnlTemplate.FindFirst;
            else
                JnlSelected := Page.RunModal(0, BLSJnlTemplate) = Action::LookupOK;
        end;
        if not JnlSelected then
            Error('');

        BLSJnlBatch.FilterGroup(2);
        BLSJnlBatch.SetRange("Journal Template Name", BLSJnlTemplate.Name);
        BLSJnlBatch.FilterGroup(0);
    end;


    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        BLSJnlBatch: Record "BLS Journal Batch";
    begin
        BLSJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
        if not BLSJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if not BLSJnlBatch.FindFirst then begin
                BLSJnlBatch.Init;
                BLSJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                BLSJnlBatch.SetupNewBatch;
                BLSJnlBatch.Name := Text004;
                BLSJnlBatch.Description := Text005;
                BLSJnlBatch.Insert(true);
                Commit;
            end;
            CurrentJnlBatchName := BLSJnlBatch.Name;
        end;
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10]; var BLSJnlLine: Record "BLS Journal Line")
    var
        BLSJnlBatch: Record "BLS Journal Batch";
    begin
        BLSJnlBatch.Get(BLSJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10]; var BLSJnlLine: Record "BLS Journal Line")
    begin
        BLSJnlLine.FilterGroup := 2;
        BLSJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        BLSJnlLine.FilterGroup := 0;
        if BLSJnlLine.Find('-') then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10]; var BLSJnlLine: Record "BLS Journal Line"): Boolean
    var
        BLSJnlBatch: Record "BLS Journal Batch";
    begin
        Commit;
        BLSJnlBatch."Journal Template Name" := BLSJnlLine.GetRangemax("Journal Template Name");
        BLSJnlBatch.Name := BLSJnlLine.GetRangemax("Journal Batch Name");
        BLSJnlBatch.FilterGroup(2);
        BLSJnlBatch.SetRange("Journal Template Name", BLSJnlBatch."Journal Template Name");
        BLSJnlBatch.FilterGroup(0);
        if Page.RunModal(0, BLSJnlBatch) = Action::LookupOK then begin
            CurrentJnlBatchName := BLSJnlBatch.Name;
            SetName(CurrentJnlBatchName, BLSJnlLine);
        end;
    end;
}

