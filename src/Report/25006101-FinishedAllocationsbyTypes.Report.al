Report 25006101 "Finished Allocations by Types"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FinishedAllocationsbyTypes.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Serv. Labor Allocation Entry"; "Serv. Labor Allocation Entry")
        {
            RequestFilterFields = "Source Type", "Source ID", "Reason Code";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            var
                ServiceHdr: Record "Service Header EDMS";
                PostedServiceHdr: Record "Posted Serv. Order Header";
            begin

                if ("Source Type" = "source type"::"Service Document") and (Status <> Status::Finished) then
                    CurrReport.Skip;

                if ("Source Type" = "source type"::"Service Document") then begin
                    if PostedServiceHdr.Get("Source ID") then begin
                        CreateEntry(Format("Source Type"), PostedServiceHdr."Deal Type Code", "Quantity (Hours)", 1);
                    end else begin
                        if ServiceHdr.Get("Source Subtype", "Source ID") then begin
                            CreateEntry(Format("Source Type"), ServiceHdr."Deal Type", "Quantity (Hours)", 1);
                        end;
                    end;
                end;

                if ("Source Type" = "source type"::"Standard Event") then begin
                    CreateEntry(Format("Source Type"), "Source ID", "Quantity (Hours)", 2);
                end;
            end;

            trigger OnPreDataItem()
            begin

                FilterStr := "Serv. Labor Allocation Entry".GetFilters;
                if FilterStr <> '' then
                    FilterStr += '; ';
                FilterStr += TextDateFrom + ' ' + Format(StartDate);
                FilterStr += '; ' + TextDateTo + ' ' + Format(EndDate);
                if StartDate <> 0D then
                    SetFilter("Start Date-Time", '%1..', DateTimeMgt.Datetime(StartDate, 000000T));
                if EndDate <> 0D then
                    SetFilter("End Date-Time", '..%1', DateTimeMgt.Datetime(EndDate, 235959T));

                DataFilterExpr := FilterStr;
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_2; 2)
            {
            }
            column(Type_Databuffer; DataBuffer."Text Field 1")
            {
            }
            column(Code_Databuffer; DataBuffer."Code Field 1")
            {
            }
            column(Description_Databuffer; DataBuffer."Text Field 2")
            {
            }
            column(Quantity_Databuffer; DataBuffer."Decimal Field 1")
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(DataFilterExpr; DataFilterExpr)
            {
            }

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then
                    DataBuffer.FindFirst
                else
                    DataBuffer.Next;

                if (DataBuffer."Integer Field 1" = 1) and DealType.Get(DataBuffer."Code Field 1") then
                    DataBuffer."Text Field 2" := DealType.Description;

                if (DataBuffer."Integer Field 1" = 2) and StandardEvent.Get(DataBuffer."Code Field 1") then
                    DataBuffer."Text Field 2" := StandardEvent.Description;

                GroupQty += DataBuffer."Decimal Field 1";
                TotalQty += DataBuffer."Decimal Field 1";
            end;

            trigger OnPreDataItem()
            begin

                DataBuffer.Reset;
                DataBuffer.SetCurrentkey("Integer Field 1");

                DataBuffer.SetRange("Integer Field 1", 1);
                ServEntry := DataBuffer.Count;
                DataBuffer.SetRange("Integer Field 1", 2);
                EventEntry := DataBuffer.Count;
                DataBuffer.SetRange("Integer Field 1");

                SetRange(Number, 1, DataBuffer.Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitleLbl = 'Finished Allocation by Types';
        TotalLbl = 'Total';
        TotalByLbl = 'Total By';
        DateFromLbl = 'Date From:';
        DateToLbl = 'Date To:';
        CodeLbl = 'Code';
        DescriptionLbL = 'Description';
        QuantityLbl = 'Quantity';
    }

    var
        DataBuffer: Record "Data Buffer" temporary;
        DealType: Record "Deal Type";
        StandardEvent: Record "Serv. Standard Event";
        DateTimeMgt: Codeunit "Datetime Mgt.";
        StartDate: Date;
        EndDate: Date;
        GroupQty: Decimal;
        TotalQty: Decimal;
        EntryNo: Integer;
        ServEntry: Integer;
        EventEntry: Integer;
        FilterStr: Text[250];
        Text001: label 'Total by %1';
        Text002: label 'Total';
        TextDateFrom: label 'Date From:';
        TextDateTo: label 'Date To:';
        DataFilterExpr: Text[250];


    procedure CreateEntry(SourceType: Text[30]; SourceID: Code[20]; Quantity: Decimal; SourceTypeID: Integer)
    begin
        DataBuffer.Reset;
        DataBuffer.SetRange("Text Field 1", SourceType);
        DataBuffer.SetRange("Code Field 1", SourceID);

        if not DataBuffer.FindFirst then begin
            EntryNo += 1;
            DataBuffer.Init;
            DataBuffer."Entry No." := EntryNo;
            DataBuffer."Text Field 1" := SourceType;
            DataBuffer."Code Field 1" := SourceID;
            DataBuffer."Integer Field 1" := SourceTypeID;
            DataBuffer.Insert;
        end;

        DataBuffer."Decimal Field 1" += Quantity;
        DataBuffer.Modify;
    end;
}

