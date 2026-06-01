Codeunit 25006605 "RentJnlManagement"
{
    Permissions = TableData "Res. Journal Template" = imd,
                  TableData "Res. Journal Batch" = imd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'RENTITEM';
        Text001: label 'Rent Item Journals';
        Text002: label 'RECURRING';
        Text003: label 'Recurring Rent Item Journal';
        Text004: label 'DEFAULT';
        Text005: label 'Default Journal';
        OldRentNo: Code[20];


    procedure TemplateSelection(PageID: Integer; RecurringJnl: Boolean; var RentJnlLine: Record "Rent Journal Line"; var JnlSelected: Boolean)
    var
        RentJnlTemplate: Record "Rent Journal Template";
    begin
        JnlSelected := true;

        RentJnlTemplate.Reset;
        RentJnlTemplate.SetRange("Page ID", PageID);
        RentJnlTemplate.SetRange(Recurring, RecurringJnl);

        case RentJnlTemplate.Count of
            0:
                begin
                    RentJnlTemplate.Init;
                    RentJnlTemplate.Recurring := RecurringJnl;
                    if not RecurringJnl then begin
                        RentJnlTemplate.Name := Text000;
                        RentJnlTemplate.Description := Text001;
                    end else begin
                        RentJnlTemplate.Name := Text002;
                        RentJnlTemplate.Description := Text003;
                    end;
                    RentJnlTemplate.Validate("Page ID");
                    RentJnlTemplate.Insert;
                    Commit;
                end;
            1:
                RentJnlTemplate.Find('-');
            else
                JnlSelected := Page.RunModal(0, RentJnlTemplate) = Action::LookupOK;
        end;
        if JnlSelected then begin
            RentJnlLine.FilterGroup := 2;
            RentJnlLine.SetRange("Journal Template Name", RentJnlTemplate.Name);
            RentJnlLine.FilterGroup := 0;
        end;
    end;


    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var RentJnlLine: Record "Rent Journal Line")
    begin
        CheckTemplateName(RentJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
        RentJnlLine.FilterGroup := 2;
        RentJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        RentJnlLine.FilterGroup := 0;
    end;


    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        RentJnlBatch: Record "Rent Journal Batch";
    begin
        RentJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
        if not RentJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if not RentJnlBatch.Find('-') then begin
                RentJnlBatch.Init;
                RentJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                RentJnlBatch.SetupNewBatch;
                RentJnlBatch.Name := Text004;
                RentJnlBatch.Description := Text005;
                RentJnlBatch.Insert(true);
                Commit;
            end;
            CurrentJnlBatchName := RentJnlBatch.Name;
        end;
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10]; var RentJnlLine: Record "Rent Journal Line")
    var
        RentJnlBatch: Record "Rent Journal Batch";
    begin
        RentJnlBatch.Get(RentJnlLine.GetRangemax("Journal Template Name"), CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10]; var RentJnlLine: Record "Rent Journal Line")
    begin
        RentJnlLine.FilterGroup := 2;
        RentJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        RentJnlLine.FilterGroup := 0;
        if RentJnlLine.Find('-') then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10]; var RentJnlLine: Record "Rent Journal Line"): Boolean
    var
        RentJnlBatch: Record "Rent Journal Batch";
    begin
        Commit;
        RentJnlBatch."Journal Template Name" := RentJnlLine.GetRangemax("Journal Template Name");
        RentJnlBatch.Name := RentJnlLine.GetRangemax("Journal Batch Name");
        RentJnlBatch.FilterGroup := 2;
        RentJnlBatch.SetRange("Journal Template Name", RentJnlBatch."Journal Template Name");
        RentJnlBatch.FilterGroup := 0;
        if Page.RunModal(0, RentJnlBatch) = Action::LookupOK then begin
            CurrentJnlBatchName := RentJnlBatch.Name;
            SetName(CurrentJnlBatchName, RentJnlLine);
        end;
    end;


    procedure GetRes(RentItemNo: Code[20]; var RentDesc: Text[50])
    var
        RentItem: Record "Rent Item";
    begin
        if RentItemNo <> OldRentNo then begin
            RentDesc := '';
            if RentItemNo <> '' then
                if RentItem.Get(RentItemNo) then
                    RentDesc := RentItem.Description;
            OldRentNo := RentItemNo;
        end;
    end;
}

