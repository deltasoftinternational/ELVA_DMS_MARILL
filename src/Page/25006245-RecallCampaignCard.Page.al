Page 25006245 "Recall Campaign Card"
{
    Caption = 'Recall Campaign Card';
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = "Recall Campaign";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic;
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalNo; Rec."External No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control3; Notes)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Campaign)
            {
                Caption = 'C&ampaign';
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = const("Recall Campaign"),
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
                action(ServicePackages)
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
}

