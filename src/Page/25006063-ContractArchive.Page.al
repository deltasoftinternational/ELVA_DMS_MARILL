Page 25006063 "Contract Archive"
{
    Caption = 'Contract Archive';
    Editable = false;
    PageType = List;
    SourceTable = "Contract Archive";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentProfille; Rec."Document Profille")
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
                field(BilltoAddress; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic;
                }
                field(PostCodeCity; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code/City';
                }
                field(BilltoCity; Rec."Bill-to City")
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(ExpirationDate; Rec."Expiration Date")
                {
                    ApplicationArea = Basic;
                }
                field(SalespersonCode; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control1904291901)
            {
                Caption = 'Version';
                field(VersionNo; Rec."Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(ArchivedBy; Rec."Archived By")
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
                field(InteractionExist; Rec."Interaction Exist")
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
            group(Version)
            {
                Caption = '&Version';
                action(Signers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Signers';
                    Image = Signature;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Contract Signers Archive";
                    RunPageLink = "Contract Type" = const(Contract),
                                  "Contract No." = field("Contract No."),
                                  "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                  "Version No." = field("Version No.");
                }
            }
            group(Sale)
            {
                Caption = 'Sale';
                action(Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = Price;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Contract Sales Prices Archive";
                    RunPageLink = "Contract No." = field("Contract No."),
                                  "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                  "Version No." = field("Version No.");
                }
                action(LineDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Contract Sales Line Disc.Arch.";
                    RunPageLink = "Contract No." = field("Contract No."),
                                  "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                  "Version No." = field("Version No.");
                }
            }
        }
        area(processing)
        {
            action(Restore)
            {
                ApplicationArea = Basic;
                Caption = '&Restore';
                Ellipsis = true;
                Image = Restore;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ArchiveManagement: Codeunit ArchiveManagement;
                    VehicleProposalMgtEDMS: Codeunit "Vehicle Proposal Mgt. EDMS";
                begin
                    VehicleProposalMgtEDMS.RestoreContract(Rec);
                end;
            }
        }
    }
}

