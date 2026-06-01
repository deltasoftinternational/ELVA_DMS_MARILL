Report 25006319 "Service WIP Reverse"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(ServiceWIPTotal; "Service WIP Total")
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ServWIPMgt);
                ServWIPMgt.PostReverseWIP("Document No.", ReverseDocumentNo, PostingDate);
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
                field(PostingDate; PostingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
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
        ServWIPMgt: Codeunit "Service WIP Management";
        DocumentNo: Code[20];
        ReverseDocumentNo: Code[20];
        PostingDate: Date;
}

