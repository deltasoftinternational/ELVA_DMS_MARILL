pageextension 25006023 "Campaign Card" extends "Campaign Card"//5086
{
    layout
    {
        addlast(General)
        {
            field(CampaignAppliestoAll; Rec."Campaign Applies to All")
            {
                ApplicationArea = Basic;
            }
            field(ActivatedSales; Rec."Activated (Sales)")
            {
                ApplicationArea = Basic;
            }
        }
    }
}