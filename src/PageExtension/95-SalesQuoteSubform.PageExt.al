pageextension 25006054 "Sales Quote Subform" extends "Sales Quote Subform"//95
{
    actions
    {
        addafter("Select Nonstoc&k Items")
        {
            action(RegisterLostSale)
            {
                ApplicationArea = All;
                Caption = 'Register Lost Sale';
                Image = Register;
                trigger OnAction()
                begin
                    rec.RegLostSales();
                end;
            }
        }
    }
}