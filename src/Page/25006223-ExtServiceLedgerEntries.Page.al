Page 25006223 "Ext. Service Ledger Entries"
{
    Caption = 'External Service Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = "External Serv. Ledger Entry";
    SourceTableView = sorting("External Serv. No.", "External Serv. Tracking No.", "Entry Type");

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(ExternalServNo; Rec."External Serv. No.")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalServTrackingNo; Rec."External Serv. Tracking No.")
                {
                    ApplicationArea = Basic;
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(JournalBatchName; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceNo; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }

                field("Service Order No."; Rec."Service Order No.")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Serial No."; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Registration No."; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = All;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = All;
                }
                field("Model Code"; Rec."Model Code")
                {
                    ApplicationArea = All;
                }
                field("Make Code"; Rec."Make Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimensions)
            {
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    Rec.ShowDimensions;
                    CurrPage.SaveRecord;
                end;
            }
        }
        area(processing)
        {
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
}

