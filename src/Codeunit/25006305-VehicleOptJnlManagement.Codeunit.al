Codeunit 25006305 "VehicleOptJnlManagement"
{
    Permissions = TableData "Item Journal Template" = imd,
                  TableData "Item Journal Batch" = imd;

    trigger OnRun()
    begin
    end;

    var
        Text003: label 'DEFAULT';
        Text004: label 'Default Journal';
        codOldItemNo: Code[20];
        codOldNewItemNo: Code[20];


    procedure fTemplateSelection(var recVehoptJnlLine: Record "Vehicle Opt. Jnl. Line")
    var
        recVehOptJnlTemplate: Record "Vehicle Opt. Jnl. Template";
        bJnlSelected: Boolean;
    begin
        bJnlSelected := true;

        recVehOptJnlTemplate.Reset;

        case recVehOptJnlTemplate.Count of
            0:
                begin
                    recVehOptJnlTemplate.Init;
                    recVehOptJnlTemplate.Validate("Form ID");
                    begin
                        begin
                            recVehOptJnlTemplate.Name := '';
                        end;
                    end;
                    recVehOptJnlTemplate.Insert;
                    Commit;
                end;
            1:
                begin
                    recVehOptJnlTemplate.FindFirst;
                end;
            else
                bJnlSelected := Page.RunModal(0, recVehOptJnlTemplate) = Action::LookupOK;
        end;
        if bJnlSelected then begin
            recVehoptJnlLine.FilterGroup := 2;
            recVehoptJnlLine.SetRange("Journal Template Name", recVehOptJnlTemplate.Name);
            recVehoptJnlLine.FilterGroup := 0;
            //PAGE.RUN(recVehOptJnlTemplate."Form ID",recVehOptJnlLine);
        end;
    end;


    procedure fOpenJnl(var codCurrentJnlBatchName: Code[10]; var recVehoptJnlLine: Record "Vehicle Opt. Jnl. Line")
    begin
        fCheckTemplateName(recVehoptJnlLine.GetRangemax("Journal Template Name"), codCurrentJnlBatchName);
        recVehoptJnlLine.FilterGroup := 2;
        recVehoptJnlLine.SetRange("Journal Batch Name", codCurrentJnlBatchName);
        recVehoptJnlLine.FilterGroup := 0;
    end;


    procedure fCheckTemplateName(codCurrentJnlTemplateName: Code[10]; var codCurrentJnlBatchName: Code[10])
    var
        recvehoptJnlBatch: Record "Vehicle Opt. Jnl. Batch";
    begin
        recvehoptJnlBatch.SetRange("Journal Template Name", codCurrentJnlTemplateName);
        if not recvehoptJnlBatch.Get(codCurrentJnlTemplateName, codCurrentJnlBatchName) then begin
            if recvehoptJnlBatch.IsEmpty then begin
                recvehoptJnlBatch.Init;
                recvehoptJnlBatch."Journal Template Name" := codCurrentJnlTemplateName;
                recvehoptJnlBatch.fSetupNewBatch;
                recvehoptJnlBatch.Name := Text003;
                recvehoptJnlBatch.Description := Text004;
                recvehoptJnlBatch.Insert(true);
                Commit;
            end;
            codCurrentJnlBatchName := recvehoptJnlBatch.Name
        end;
    end;


    procedure fCheckName(codCurrentJnlBatchName: Code[10]; var recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line")
    var
        recVehOptJnlBatch: Record "Vehicle Opt. Jnl. Batch";
    begin
        recVehOptJnlBatch.Get(recVehOptJnlLine.GetRangemax("Journal Template Name"), codCurrentJnlBatchName);
    end;


    procedure fSetName(codCurrentJnlBatchName: Code[10]; var recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line")
    begin
        recVehOptJnlLine.FilterGroup := 2;
        recVehOptJnlLine.SetRange("Journal Batch Name", codCurrentJnlBatchName);
        recVehOptJnlLine.FilterGroup := 0;
        if recVehOptJnlLine.FindSet then;
    end;


    procedure fLookupName(var codCurrentJnlBatchName: Code[10]; var recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line"): Boolean
    var
        recVehOptJnlBatch: Record "Vehicle Opt. Jnl. Batch";
    begin
        Commit;
        recVehOptJnlBatch."Journal Template Name" := recVehOptJnlLine.GetRangemax("Journal Template Name");
        recVehOptJnlBatch.Name := recVehOptJnlLine.GetRangemax("Journal Batch Name");
        recVehOptJnlBatch.FilterGroup := 2;
        recVehOptJnlBatch.SetRange("Journal Template Name", recVehOptJnlBatch."Journal Template Name");
        recVehOptJnlBatch.FilterGroup := 0;
        if Page.RunModal(0, recVehOptJnlBatch) = Action::LookupOK then begin
            codCurrentJnlBatchName := recVehOptJnlBatch.Name;
            fSetName(codCurrentJnlBatchName, recVehOptJnlLine);
        end;
    end;


    procedure fOnAfterInputItemNo(var txtText: Text[1024]): Text[1024]
    var
        recItem: Record Item;
        iNumber: Integer;
    begin
        if txtText = '' then
            exit;

        if Evaluate(iNumber, txtText) then
            exit;

        recItem."No." := txtText;
        if recItem.FindFirst then
            if CopyStr(recItem."No.", 1, StrLen(txtText)) = UpperCase(txtText) then begin
                txtText := recItem."No.";
                exit;
            end;

        recItem.SetCurrentkey("Search Description");
        recItem."Search Description" := txtText;
        recItem."No." := '';
        if recItem.FindFirst then
            if CopyStr(recItem."Search Description", 1, StrLen(txtText)) = UpperCase(txtText) then
                txtText := recItem."No.";
    end;


    procedure fGetNonstockItem(codItemNo: Code[20]; var txtItemDescription: Text[50]; codNewItemNo: Code[20]; var txtNewItemDescription: Text[50])
    var
        recNonstockItem: Record "Nonstock Item";
        recNonstockItem1: Record "Nonstock Item";
    begin
        if codItemNo <> codOldItemNo then begin
            txtItemDescription := '';
            if codItemNo <> '' then
                if recNonstockItem.Get(codItemNo) then
                    txtItemDescription := recNonstockItem.Description;
            codOldItemNo := codItemNo;
        end;

        if codNewItemNo <> codOldNewItemNo then begin
            txtNewItemDescription := '';
            if codNewItemNo <> '' then
                if recNonstockItem1.Get(codNewItemNo) then
                    txtNewItemDescription := recNonstockItem1.Description;
            codOldNewItemNo := codNewItemNo;
        end;
    end;
}

