Codeunit 25006210 "WarrantyJnlManagement"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'WARRANTY';
        Text001: label 'Warranty Journals';
        Text002: label 'RECURRING';
        Text003: label 'Recurring Warranty Journal';
        Text004: label 'DEFAULT';
        Text005: label 'Default Journal';
        OldVehNo: Code[20];


    procedure TemplateSelection(FormID: Integer; RecurringJnl: Boolean; var WarrantyJnlLine: Record "Warranty Journal Line"; var JnlSelected: Boolean)
    var
        WarrantyJnlTemplate: Record "Warranty Journal Template";
    begin
        JnlSelected := true;

        WarrantyJnlTemplate.Reset;
        WarrantyJnlTemplate.SetRange("Form ID", FormID);
        WarrantyJnlTemplate.SetRange(Recurring, RecurringJnl);

        case WarrantyJnlTemplate.Count of
            0:
                begin
                    WarrantyJnlTemplate.Init;
                    WarrantyJnlTemplate.Recurring := RecurringJnl;
                    if not RecurringJnl then begin
                        WarrantyJnlTemplate.Name := Text000;
                        WarrantyJnlTemplate.Description := Text001;
                    end else begin
                        WarrantyJnlTemplate.Name := Text002;
                        WarrantyJnlTemplate.Description := Text003;
                    end;
                    WarrantyJnlTemplate.Validate("Form ID");
                    WarrantyJnlTemplate.Insert;
                    Commit;
                end;
            1:
                WarrantyJnlTemplate.FindFirst;
            else
                JnlSelected := Page.RunModal(0, WarrantyJnlTemplate) = Action::LookupOK;
        end;
        if JnlSelected then begin
            WarrantyJnlLine.FilterGroup := 2;
            WarrantyJnlLine.SetRange("Journal Template Name", WarrantyJnlTemplate.Name);
            WarrantyJnlLine.FilterGroup := 0;
        end;
    end;


    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var WarrantyJnlLine: Record "Warranty Journal Line")
    begin
        CheckTemplateName(WarrantyJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
        WarrantyJnlLine.FilterGroup := 2;
        WarrantyJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        WarrantyJnlLine.FilterGroup := 0;
    end;


    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        WarrantyJnlBatch: Record "Warranty Journal Batch";
    begin
        WarrantyJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
        if not WarrantyJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if not WarrantyJnlBatch.FindFirst then begin
                WarrantyJnlBatch.Init;
                WarrantyJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                WarrantyJnlBatch.SetupNewBatch;
                WarrantyJnlBatch.Name := Text004;
                WarrantyJnlBatch.Description := Text005;
                WarrantyJnlBatch.Insert(true);
                Commit;
            end;
            CurrentJnlBatchName := WarrantyJnlBatch.Name;
        end;
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10]; var WarrantyJnlLine: Record "Warranty Journal Line")
    var
        WarrantyJnlBatch: Record "Warranty Journal Batch";
    begin
        WarrantyJnlBatch.Get(WarrantyJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10]; var WarrantyJnlLine: Record "Warranty Journal Line")
    begin
        WarrantyJnlLine.FilterGroup := 2;
        WarrantyJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        WarrantyJnlLine.FilterGroup := 0;
        if WarrantyJnlLine.FindSet then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10]; var WarrantyJnlLine: Record "Warranty Journal Line"): Boolean
    var
        WarrantyJnlBatch: Record "Warranty Journal Batch";
    begin
        Commit;
        WarrantyJnlBatch."Journal Template Name" := WarrantyJnlLine.GetRangemax("Journal Template Name");
        WarrantyJnlBatch.Name := WarrantyJnlLine.GetRangemax("Journal Batch Name");
        WarrantyJnlBatch.FilterGroup := 2;
        WarrantyJnlBatch.SetRange("Journal Template Name", WarrantyJnlBatch."Journal Template Name");
        WarrantyJnlBatch.FilterGroup := 0;
        if Page.RunModal(0, WarrantyJnlBatch) = Action::LookupOK then begin
            CurrentJnlBatchName := WarrantyJnlBatch.Name;
            SetName(CurrentJnlBatchName, WarrantyJnlLine);
        end;
    end;


    procedure GetVeh(VehNo: Code[20]; var VehName: Text[50])
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

