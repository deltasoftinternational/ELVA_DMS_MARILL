Page 25006019 "Document Reports"
{
    ApplicationArea = Basic;
    Caption = 'Document Reports';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Document Report";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(DocumentProfile; rec."Document Profile")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentFunctionalType; rec."Document Functional Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentType; rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(Sequence; rec.Sequence)
                {
                    ApplicationArea = Basic;
                }
                field(ReportID; rec."Report ID")
                {
                    ApplicationArea = Basic;
                }
                field(CustomName; rec."Custom Name")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerSignature; rec."Customer Signature")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeSignature; rec."Employee Signature")
                {
                    ApplicationArea = Basic;
                }
                field("E-mail To"; Rec."E-mail To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies from where to take e-mail address.';
                }
            }
        }
    }

    actions
    {
    }
}

