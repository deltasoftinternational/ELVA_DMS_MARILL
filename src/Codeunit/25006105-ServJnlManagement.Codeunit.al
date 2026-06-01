Codeunit 25006105 "ServJnlManagement"
{
    Permissions = TableData "Serv. Journal Template" = rimd,
                  TableData "Serv. Journal Batch" = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'SERVICE';
        Text001: label 'Service Journals';
        Text002: label 'RECURRING';
        Text003: label 'Recurring Service Journal';
        Text004: label 'DEFAULT';
        Text005: label 'Default Journal';
        OldVehNo: Code[20];


    procedure TemplateSelection(FormID: Integer; RecurringJnl: Boolean; var ServJnlLine: Record "Serv. Journal Line"; var JnlSelected: Boolean)
    var
        ServJnlTemplate: Record "Serv. Journal Template";
    begin
        JnlSelected := true;

        ServJnlTemplate.Reset;
        ServJnlTemplate.SetRange("Form ID", FormID);
        ServJnlTemplate.SetRange(Recurring, RecurringJnl);

        case ServJnlTemplate.Count of
            0:
                begin
                    ServJnlTemplate.Init;
                    ServJnlTemplate.Recurring := RecurringJnl;
                    if not RecurringJnl then begin
                        ServJnlTemplate.Name := Text000;
                        ServJnlTemplate.Description := Text001;
                    end else begin
                        ServJnlTemplate.Name := Text002;
                        ServJnlTemplate.Description := Text003;
                    end;
                    ServJnlTemplate.Validate("Form ID");
                    ServJnlTemplate.Insert;
                    Commit;
                end;
            1:
                ServJnlTemplate.FindFirst;
            else
                JnlSelected := Page.RunModal(0, ServJnlTemplate) = Action::LookupOK;
        end;
        if JnlSelected then begin
            ServJnlLine.FilterGroup := 2;
            ServJnlLine.SetRange("Journal Template Name", ServJnlTemplate.Name);
            ServJnlLine.FilterGroup := 0;
        end;
    end;


    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var ServJnlLine: Record "Serv. Journal Line")
    begin
        CheckTemplateName(ServJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
        ServJnlLine.FilterGroup := 2;
        ServJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        ServJnlLine.FilterGroup := 0;
    end;


    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        ServJnlBatch: Record "Serv. Journal Batch";
    begin
        ServJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
        if not ServJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if not ServJnlBatch.FindFirst then begin
                ServJnlBatch.Init;
                ServJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                ServJnlBatch.SetupNewBatch;
                ServJnlBatch.Name := Text004;
                ServJnlBatch.Description := Text005;
                ServJnlBatch.Insert(true);
                Commit;
            end;
            CurrentJnlBatchName := ServJnlBatch.Name;
        end;
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10]; var ServJnlLine: Record "Serv. Journal Line")
    var
        ServJnlBatch: Record "Serv. Journal Batch";
    begin
        ServJnlBatch.Get(ServJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10]; var ServJnlLine: Record "Serv. Journal Line")
    begin
        ServJnlLine.FilterGroup := 2;
        ServJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        ServJnlLine.FilterGroup := 0;
        if ServJnlLine.FindSet then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10]; var ServJnlLine: Record "Serv. Journal Line"): Boolean
    var
        ServJnlBatch: Record "Serv. Journal Batch";
    begin
        Commit;
        ServJnlBatch."Journal Template Name" := ServJnlLine.GetRangemax("Journal Template Name");
        ServJnlBatch.Name := ServJnlLine.GetRangemax("Journal Batch Name");
        ServJnlBatch.FilterGroup := 2;
        ServJnlBatch.SetRange("Journal Template Name", ServJnlBatch."Journal Template Name");
        ServJnlBatch.FilterGroup := 0;
        if Page.RunModal(0, ServJnlBatch) = Action::LookupOK then begin
            CurrentJnlBatchName := ServJnlBatch.Name;
            SetName(CurrentJnlBatchName, ServJnlLine);
        end;
    end;


    procedure GetVeh(VehNo: Code[20]; var VehName: Text[30])
    var
        Veh: Record Vehicle;
    begin
        if VehNo <> OldVehNo then begin
            VehName := '';
            if VehNo <> '' then
                if Veh.Get(VehNo) then begin
                    Veh.CalcFields("Model Commercial Name");
                    VehName := Veh."Model Commercial Name";
                end;
            OldVehNo := VehNo;
        end;
    end;
}

