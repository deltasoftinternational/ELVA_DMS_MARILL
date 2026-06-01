Report 25006320 "Salesperson Interactions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SalespersonInteractions.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Salesperson/Purchaser"; "Salesperson/Purchaser")
        {
            column(ReportForNavId_25006000; 25006000)
            {
            }
            dataitem("Interaction Log Entry"; "Interaction Log Entry")
            {
                DataItemLink = "Salesperson Code" = field(Code);
                column(ReportForNavId_25006003; 25006003)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    InteractionSummary.Reset;
                    InteractionSummary.SetRange("Code Field 1", "Salesperson/Purchaser".Code);
                    InteractionSummary.SetRange("Code Field 2", "Interaction Template Code");
                    InteractionSummary.SetRange("Code Field 3", "Contact No.");
                    if not InteractionSummary.FindFirst then begin
                        EntryNo += 1;
                        InteractionSummary.Init;
                        InteractionSummary."Entry No." := EntryNo;
                        InteractionSummary."Code Field 1" := "Salesperson/Purchaser".Code;
                        InteractionSummary."Code Field 2" := "Interaction Template Code";
                        InteractionSummary."Code Field 3" := "Contact No.";
                        InteractionSummary."Text Field 1" := "Salesperson/Purchaser".Name;
                        InteractionSummary."Integer Field 1" := 1;
                        InteractionSummary.Insert;
                    end else begin
                        InteractionSummary."Integer Field 1" += 1;
                        InteractionSummary.Modify;
                    end;
                end;
            }
            dataitem(InteractionSummary; "Data Buffer")
            {
                DataItemLink = "Code Field 1" = field(Code);
                UseTemporary = true;
                column(ReportForNavId_25006008; 25006008)
                {
                }
                column(TmplateCode_InteractionLogEntry; "Code Field 2")
                {
                }
                column(ContactNo_InteractionLogEntry; "Code Field 3")
                {
                }
                column(Count_InteractionLogEntry; "Integer Field 1")
                {
                }
                column(Code_SalesPerson; "Code Field 1")
                {
                }
                column(Name_SalesPerson; "Text Field 1")
                {
                }
                column(Name_CompanyInfo; CompanyInfo.Name)
                {
                }
                column(SalesPersFilter; SalesPersFilter)
                {
                }
                column(InteractionLogEntryFilter; InteractionLogEntryFilter)
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        ReportName = 'Salesperson interaction entries statistic';
        InteractionTemplateCodeLbl = 'Interaction Template Code';
        InteractionCountLbl = 'Interaction Count';
        UniqueContactLbl = 'Unique Contact';
        TotalLbl = 'Total:';
        PageLbl = 'Page';
        CodeLbl = 'Code';
        NameLbl = 'Name';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        EntryNo := 0;
        if "Salesperson/Purchaser".GetFilters <> '' then
            SalesPersFilter := "Salesperson/Purchaser".TableCaption + ': ' + "Salesperson/Purchaser".GetFilters;

        if "Interaction Log Entry".GetFilters <> '' then
            InteractionLogEntryFilter := "Interaction Log Entry".TableCaption + ': ' + "Interaction Log Entry".GetFilters;

        InteractionSummary.DeleteAll;
    end;

    var
        CompanyInfo: Record "Company Information";
        SalesPersFilter: Text;
        InteractionLogEntryFilter: Text;
        EntryNo: Integer;
}

