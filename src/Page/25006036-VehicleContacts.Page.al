Page 25006036 "Vehicle Contacts"
{
    Caption = 'Vehicle Contact';
    DataCaptionFields = "Vehicle Serial No.";
    PageType = List;
    SourceTable = "Vehicle Contact";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RelationshipCode; Rec."Relationship Code")
                {
                    ApplicationArea = Basic;
                }
                field(ContactNo; Rec."Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(ContactName; Rec."Contact Name")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DoNotUseInService; Rec."Do Not Use In Service")
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
            group("<Action103>")
            {
                Caption = '&General';
                action(CustomerCard)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Card';
                    Image = Customer;

                    trigger OnAction()
                    var
                        Contact: Record Contact;
                        Customer: Record Customer;
                        ContBusinessRel: Record "Contact Business Relation";
                    begin
                        if Rec."Contact No." <> '' then
                            if ContBusinessRel.Get(Rec."Contact No.", 'CUST') then
                                if Customer.Get(ContBusinessRel."No.") then begin
                                    Page.Run(Page::"Customer Card", Customer);
                                    exit;
                                end;
                        Message(Text001);
                    end;
                }
                action(ContactCard)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contact Card';
                    Image = ContactPerson;
                    RunObject = Page "Contact Card";
                    RunPageLink = "No." = field("Contact No.");
                }
            }
        }
    }

    var
        Text001: label 'No Customer found.';
}

