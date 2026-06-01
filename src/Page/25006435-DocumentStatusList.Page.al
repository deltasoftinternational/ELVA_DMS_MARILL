Page 25006435 "Document Status List"
{
    Caption = 'Document Status List';
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Document Status";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code used for the document status.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies description for the work status.';
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the document this work status will be used for.';
                }
                field(DocumentProfile; Rec."Document Profile")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document profile of the document this work status will be used for.';
                }
                field(NextStatusonWorkStarted; Rec."Next Status on Work Started")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of work status to which system should change document status once work is started on a service order.';
                }
                field(NextStatusonWorkFinished; Rec."Next Status on Work Finished")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of work status to which system should change document status once work is finished on a service order.';
                }
            }
        }
    }

    actions
    {
    }
}

