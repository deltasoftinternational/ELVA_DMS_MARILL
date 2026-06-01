Page 25006160 "Service Package Card"
{
    Caption = 'Service Package Card';
    DataCaptionExpression = STRSUBSTNO('%1 Nr. %2', Rec.Type, Rec."No.");
    PageType = Card;
    SourceTable = "Service Package";

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
                        if Rec.AssistEdit then
                            CurrPage.Update;
                    end;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        MakeCodeOnAfterValidate;
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
                field(GroupCode; Rec."Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(SubgroupCode; Rec."Subgroup Code")
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
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                }
                field(CampaignNo; Rec."Campaign No.")
                {
                    ApplicationArea = Basic;
                }
                field(RecallCampaignNo; Rec."Recall Campaign No.")
                {
                    ApplicationArea = Basic;
                }
            }
            part(PackageVersionLines; "Service Package Versions")
            {
                ApplicationArea = All;
                Caption = 'Versions';
                SubPageLink = "Package No." = field("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field(FreeofCharge; Rec."Free of Charge")
                {
                    ApplicationArea = Basic;
                }
                field(FixedPricesandDiscounts; Rec."Fixed Prices and Discounts")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Package)
            {
                Caption = 'Package';
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = const("Service Package"),
                                  "No." = field("No.");
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(RecalculatePrices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recalculate Prices';
                    Image = Recalculate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.PackageVersionLines.Page.GetRecord(recServPackVersion);
                        recServPackVersion.SetRange("Package No.", recServPackVersion."Package No.");
                        recServPackVersion.SetRange("Version No.", recServPackVersion."Version No.");

                        Report.Run(Report::"Upd. Package Ver. Spec. Prices", true, true, recServPackVersion);
                    end;
                }
            }
        }
    }

    var
        recServPackVersion: Record "Service Package Version";

    local procedure MakeCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

