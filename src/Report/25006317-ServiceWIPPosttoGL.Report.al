Report 25006317 "Service WIP Post to G/L"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(WIPServiceOrderHeader; "Service Order WIP Header")
        {
            column(ReportForNavId_2; 2)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ServWIPMngt);
                ServWIPMngt.PostWIP(WIPServiceOrderHeader, PostingDate, Consolidated, ReverseDocumentNo, ReversePostingDate);
            end;

            trigger OnPreDataItem()
            begin
                //SETRANGE("Document Type",WIPServiceOrderHeader."Document Type"::Order);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("Posting Date"; PostingDate)
                {
                    ApplicationArea = Basic;
                }
                field(ReversePostingDate; ReversePostingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reverse Previos with Posting Date';
                }
                field(Consolidated; Consolidated)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Consolidated';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ServWIPMngt: Codeunit "Service WIP Management";
        PostingDate: Date;
        ReversePostingDate: Date;
        ReverseDocumentNo: Code[20];
        Consolidated: Boolean;
}

