Page 25006256 "Service Quote Archives EDMS"
{
    ApplicationArea = Basic;
    Caption = 'Service Quote Archives';
    CardPageID = "Service Quote Archive EDMS";
    Editable = false;
    PageType = List;
    SourceTable = "Service Header Archive EDMS";
    SourceTableView = where("Document Type" = const(Quote));
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(VersionNo; Rec."Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(DateArchived; Rec."Date Archived")
                {
                    ApplicationArea = Basic;
                }
                field(TimeArchived; Rec."Time Archived")
                {
                    ApplicationArea = Basic;
                }
                field(ArchivedBy; Rec."Archived By")
                {
                    ApplicationArea = Basic;
                }
                field(InteractionExist; Rec."Interaction Exist")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoContact; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                }
                field(SelltoPostCode; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCountryRegionCode; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoContactNo; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoPostCode; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCountryRegionCode; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RequestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PaymentDiscount; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::"Service Header Archive"),
                              "No." = FIELD("No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Version)
            {
                Caption = 'Ver&sion';
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Serv. Arch. Comment Sheet";
                    RunPageLink = Type = const("Service Return Order"),
                                  "No." = field("No."),
                                  "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                  "Version No." = field("Version No.");
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UserMgtEDMS.GetServiceFilterEDMS <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgtEDMS.GetServiceFilterEDMS);
            Rec.FilterGroup(0);
        end;
    end;

    var
        UserMgt: Codeunit "User Setup Management";
        UserMgtEDMS: Codeunit "UserProfileManagement";
}

