Page 25006624 "Rent Quote List"
{
    ApplicationArea = Basic;
    Caption = 'Rent Quotes';
    CardPageID = "Rent Quote";
    Editable = false;
    PageType = List;
    SourceTable = "Rent Header";
    SourceTableView = sorting("Document Type", "No.")
                      where("Document Type" = const(Quote),
                            Closed = const(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(OrderDate; Rec."Order Date")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }

        area(factboxes)
        {
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(25006618),
                              "No." = FIELD("No."),
                              "Document Type" = FIELD("Document Type");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
    }
}

