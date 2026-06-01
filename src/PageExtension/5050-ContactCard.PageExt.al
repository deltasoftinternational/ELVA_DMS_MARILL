pageextension 25006021 "Contact Card" extends "Contact Card"//5050
{

    actions
    {
        addfirst("C&ontact")
        {
            action("<Action1101904000>")
            {
                ApplicationArea = Basic;
                Caption = 'Vehicles';
                Image = Delivery;
                RunObject = Page "Contact Vehicles";
                RunPageLink = "Contact No." = field("No.");
                RunPageView = sorting("Contact No.");
            }
        }
        addafter("Segmen&ts")
        {
            action("<Action1101914001>")
            {
                ApplicationArea = Basic;
                Caption = 'Service Quotes';
                Image = Quote;
                RunObject = Page "Service Quotes EDMS";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageView = sorting("Document Type", "Sell-to Contact No.");
            }
        }
        addfirst("F&unctions")
        {
            action(SendSMS)
            {
                ApplicationArea = Basic;
                Caption = 'Send SMS';
                Image = SendTo;

                trigger OnAction()
                var
                    SendSMS: Page "Send SMS Message";
                    UserSetup: Record "User Setup";
                    SalespersonCode: Code[10];
                begin
                    if UserSetup.Get(UserId) then;
                    if UserSetup."Salespers./Purch. Code" <> '' then
                        SalespersonCode := UserSetup."Salespers./Purch. Code"
                    else
                        SalespersonCode := Rec."Salesperson Code";

                    SendSMS.SetSalespersonCode(SalespersonCode);
                    SendSMS.SetContactNo(Rec."No.");
                    SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                    SendSMS.Run;
                end;
            }
        }
    }
}