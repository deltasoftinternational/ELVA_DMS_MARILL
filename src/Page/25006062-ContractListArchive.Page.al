Page 25006062 "Contract List Archive"
{
    ApplicationArea = Basic;
    Caption = 'Contract List Archive';
    CardPageID = "Contract Archive";
    Editable = false;
    PageType = List;
    SourceTable = "Contract Archive";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocNoOccurrence; Rec."Doc. No. Occurrence")
                {
                    ApplicationArea = Basic;
                }
                field(VersionNo; Rec."Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoName; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Contract)
            {
                Caption = '&Contract';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    RunObject = Page "Contract Archive";
                    RunPageLink = "Contract No." = field("Contract No."),
                                  "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                  "Version No." = field("Version No.");
                    RunPageView = sorting("Contract No.", "Doc. No. Occurrence", "Version No.");
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }
}

