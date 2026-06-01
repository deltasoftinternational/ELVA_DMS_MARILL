Page 25006688 "Vehicle Health Check Lines"
{
    // 28/03/2018 GH P30
    //   Created

    Caption = 'Vehicle Health Check Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Related Information';
    SourceTable = "Service Line EDMS";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sell-to Customer Name';
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,,Item,Labor,External Service';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Width = 20;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VHCServiceOrderNo; Rec."VHC Service Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(ReminderDate; Rec."Reminder Date")
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
            action(VehicleCheckCard)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Health Check Card';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Vehicle Health Check Card";
                RunPageLink = "Document Type" = field("Document Type"),
                              "No." = field("Document No.");
            }
        }
    }
}

