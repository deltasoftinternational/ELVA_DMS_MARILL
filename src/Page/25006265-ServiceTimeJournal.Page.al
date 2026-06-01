Page 25006265 "Service Time Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Service Time Journal';
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Service Time Journal";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                }
                field(SourceLineNo; Rec."Source Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(StartTime; Rec."Start Time")
                {
                    ApplicationArea = Basic;
                }
                field(EndTime; Rec."End Time")
                {
                    ApplicationArea = Basic;
                }
                field(QuantityHours; Rec."Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                }
                field(Travel; Rec.Travel)
                {
                    ApplicationArea = Basic;
                }
                field(Day; Format(Rec.Date, 0, '<Weekday Text>'))
                {
                    ApplicationArea = Basic;
                    Caption = 'Day';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup25006023)
            {
                Caption = 'Register';
                action(Action25006024)
                {
                    ApplicationArea = Basic;
                    Caption = 'Register';
                    Image = Registered;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
                        UserSetup: Record "User Setup";
                    begin
                        UserSetup.Get(UserId);
                        if UserSetup."Allow Use Service Schedule" = UserSetup."allow use service schedule"::" " then
                            Error(Text102);

                        if UserSetup."Allow Use Service Schedule" = UserSetup."allow use service schedule"::"View Only" then
                            Error(Text101);

                        ResourceTimeRegMgt.RegisterServiceTimeJournal(Rec);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."User ID" := UserId;
        Rec."Source Type" := xRec."source type"::"Service Document";
        Rec."Source Subtype" := xRec."source subtype"::Order;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId);
    end;

    var
        Text101: label 'You have only permission to view service schedule!';
        Text102: label 'You have no permission to use service schedule!';
}

