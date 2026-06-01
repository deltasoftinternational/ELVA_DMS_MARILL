Codeunit 25006118 "Ext.ServiceJnlManagement"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'EXTSERV';
        Text001: label 'Ext. Service Journals';
        Text004: label 'DEFAULT';
        Text005: label 'Default Journal';
        OldExtServiceNo: Code[20];


    procedure TemplateSelection(var ExtServiceJnlLine: Record "External Serv. Journal Line"; var JnlSelected: Boolean)
    var
        ExtServiceJnlTemplate: Record "Ext. Service Journal Template";
    begin
        JnlSelected := true;

        ExtServiceJnlTemplate.Reset;

        case ExtServiceJnlTemplate.Count of
            0:
                begin
                    ExtServiceJnlTemplate.Init;
                    ExtServiceJnlTemplate.Name := Text000;
                    ExtServiceJnlTemplate.Description := Text001;
                    //ExtServiceJnlTemplate.Validate("Form ID");
                    ExtServiceJnlTemplate.Insert;
                    Commit;
                end;
            1:
                ExtServiceJnlTemplate.FindFirst;
            else
                JnlSelected := Page.RunModal(0, ExtServiceJnlTemplate) = Action::LookupOK;
        end;
        if JnlSelected then begin
            ExtServiceJnlLine.FilterGroup := 2;
            ExtServiceJnlLine.SetRange("Journal Template Name", ExtServiceJnlTemplate.Name);
            ExtServiceJnlLine.FilterGroup := 0;
        end;
    end;


    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var ExtServiceJnlLine: Record "External Serv. Journal Line")
    begin
        CheckTemplateName(ExtServiceJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
        ExtServiceJnlLine.FilterGroup := 2;
        ExtServiceJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        ExtServiceJnlLine.FilterGroup := 0;
    end;


    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        ExtServiceJnlBatch: Record "External Serv. Journal Batch";
    begin
        ExtServiceJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
        if not ExtServiceJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if ExtServiceJnlBatch.IsEmpty then begin
                ExtServiceJnlBatch.Init;
                ExtServiceJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                ExtServiceJnlBatch.SetupNewBatch;
                ExtServiceJnlBatch.Name := Text004;
                ExtServiceJnlBatch.Description := Text005;
                ExtServiceJnlBatch.Insert(true);
                Commit;
            end;
            CurrentJnlBatchName := ExtServiceJnlBatch.Name;
        end;
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10]; var ExtServiceJnlLine: Record "External Serv. Journal Line")
    var
        ExtServiceJnlBatch: Record "External Serv. Journal Batch";
    begin
        ExtServiceJnlBatch.Get(ExtServiceJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10]; var ExtServiceJnlLine: Record "External Serv. Journal Line")
    begin
        ExtServiceJnlLine.FilterGroup := 2;
        ExtServiceJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        ExtServiceJnlLine.FilterGroup := 0;
        if ExtServiceJnlLine.FindSet then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10]; var ExtServiceJnlLine: Record "External Serv. Journal Line"): Boolean
    var
        ExtServiceJnlBatch: Record "External Serv. Journal Batch";
    begin
        Commit;
        ExtServiceJnlBatch."Journal Template Name" := ExtServiceJnlLine.GetRangemax("Journal Template Name");
        ExtServiceJnlBatch.Name := ExtServiceJnlLine.GetRangemax("Journal Batch Name");
        ExtServiceJnlBatch.FilterGroup := 2;
        ExtServiceJnlBatch.SetRange("Journal Template Name", ExtServiceJnlBatch."Journal Template Name");
        ExtServiceJnlBatch.FilterGroup := 0;
        if Page.RunModal(0, ExtServiceJnlBatch) = Action::LookupOK then begin
            CurrentJnlBatchName := ExtServiceJnlBatch.Name;
            SetName(CurrentJnlBatchName, ExtServiceJnlLine);
        end;
    end;


    procedure GetExtService(ExtServiceNo: Code[20]; var ExtServiceName: Text[50])
    var
        ExtService: Record "External Service";
    begin
        if ExtServiceNo <> OldExtServiceNo then begin
            ExtServiceName := '';
            if ExtServiceNo <> '' then
                if ExtService.Get(ExtServiceNo) then
                    ExtServiceName := ExtService.Description;
            OldExtServiceNo := ExtServiceNo;
        end;
    end;
}

