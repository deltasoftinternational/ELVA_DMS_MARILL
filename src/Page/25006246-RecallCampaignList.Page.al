Page 25006246 "Recall Campaign List"
{
    ApplicationArea = Basic;
    Caption = 'Recall Campaign List';
    CardPageID = "Recall Campaign Card";
    PageType = List;
    SourceTable = "Recall Campaign";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ExternalNo; Rec."External No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field(Type; Rec.Type)
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
            group(Campaign)
            {
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name" = const("Recall Campaign"),
                                  "No." = field("No.");
                }
                action(Vehicles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicles';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Recall Campaign Vehicles";
                    RunPageLink = "Campaign No." = field("No.");
                }
                action("<Action1190015>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Packages';
                    Image = ServiceItemGroup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServPackage: Record "Service Package";
                    begin
                        ServPackage.Reset;
                        ServPackage.SetCurrentkey("Recall Campaign No.");
                        ServPackage.SetRange("Recall Campaign No.", Rec."No.");
                        if ServPackage.Count = 1 then
                            Page.RunModal(Page::"Service Package Card", ServPackage)
                        else
                            Page.RunModal(Page::"Service Package List", ServPackage);
                    end;
                }
            }
        }
    }


    procedure GetSelectionFilter(): Code[80]
    var
        Campaign: Record Campaign;
        FirstCampaign: Code[30];
        LastCampaign: Code[30];
        SelectionFilter: Code[250];
        CampaignCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(Campaign);
        CampaignCount := Campaign.Count;
        if CampaignCount > 0 then begin
            Campaign.FindSet;
            while CampaignCount > 0 do begin
                CampaignCount := CampaignCount - 1;
                Campaign.MarkedOnly(false);
                FirstCampaign := Campaign."No.";
                LastCampaign := FirstCampaign;
                More := (CampaignCount > 0);
                while More do
                    if Campaign.Next = 0 then
                        More := false
                    else
                        if not Campaign.Mark then
                            More := false
                        else begin
                            LastCampaign := Campaign."No.";
                            CampaignCount := CampaignCount - 1;
                            if CampaignCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstCampaign = LastCampaign then
                    SelectionFilter := SelectionFilter + FirstCampaign
                else
                    SelectionFilter := SelectionFilter + FirstCampaign + '..' + LastCampaign;
                if CampaignCount > 0 then begin
                    Campaign.MarkedOnly(true);
                    Campaign.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;
}

