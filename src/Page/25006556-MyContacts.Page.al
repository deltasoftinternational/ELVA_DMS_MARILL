Page 25006556 "My Contacts"
{
    PageType = ListPart;
    SourceTable = Contact;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Contact Details")
            {
                ApplicationArea = Basic;
                Image = CustomerContact;
                RunObject = Page "Contact Card";
                RunPageLink = "No." = field("No.");
            }
        }
    }

    trigger OnInit()
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Salespers./Purch. Code" <> '' then
                Rec.SetFilter("Salesperson Code", UserSetup."Salespers./Purch. Code");
    end;

    var
        UserSetup: Record "User Setup";
}

