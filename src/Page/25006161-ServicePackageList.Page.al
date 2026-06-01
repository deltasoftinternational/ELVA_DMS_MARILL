Page 25006161 "Service Package List"
{
    ApplicationArea = Basic;
    Caption = 'Service Package List';
    CardPageID = "Service Package Card";
    Editable = false;
    PageType = List;
    SourceTable = "Service Package";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
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
                    Visible = false;
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                }
                field(GroupCode; Rec."Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SubgroupCode; Rec."Subgroup Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RecallCampaignNo; Rec."Recall Campaign No.")
                {
                    ApplicationArea = Basic;
                }
                field(CampaignNo; Rec."Campaign No.")
                {
                    ApplicationArea = Basic;
                }
                field(FreeofCharge; Rec."Free of Charge")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
    }


    procedure GetSelectionFilter(): Text
    var
        ServicePackage: Record "Service Package";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        "Item Sales Doc. Mgt. EDMS": codeunit "Item Sales Doc. Mgt. EDMS";
    begin
        CurrPage.SetSelectionFilter(ServicePackage);
        exit("Item Sales Doc. Mgt. EDMS".GetSelectionFilterForServicePackage(ServicePackage));
    end;
}

