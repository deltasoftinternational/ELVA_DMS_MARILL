Page 25006503 "Vehicle Reservation Entries"
{
    Caption = 'Vehicle Reservation Entries';
    DataCaptionExpression = Rec.TextCaption;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Vehicle Reservation Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(ChangedBy; Rec."Changed By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(ReservedFor; ReservEngineMgt.CreateForText(Rec))
                {
                    ApplicationArea = Basic;
                    Caption = 'Reserved For';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        LookupReservedFor;
                    end;
                }
                field(ReservedFrom; ReservEngineMgt.CreateFromText(Rec))
                {
                    ApplicationArea = Basic;
                    Caption = 'Reserved From';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        LookupReservedFrom;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(SourceBatchName; Rec."Source Batch Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(SourceRefNo; Rec."Source Ref. No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(CreationDate; Rec."Creation Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                action(CancelReservation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Reservation';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(ReservEntry);
                        if ReservEntry.FindSet then
                            repeat
                                if Confirm(
                                     Text003 +
                                     Text004 +
                                     Text005, false, ReservEntry.Quantity,
                                     ReservEntry."Model Version No.", ReservEngineMgt.CreateForText(Rec),
                                     ReservEngineMgt.CreateFromText(Rec))
                                then begin
                                    ReservEngineMgt.CloseReservEntry2(ReservEntry);
                                    Commit;
                                end;
                            until ReservEntry.Next = 0;
                    end;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        ReservEngineMgt.ModifyReservEntry(xRec, Rec.Quantity, Rec.Description, true);
        exit(false);
    end;

    var
        Text003: label 'Cancel reservation of %1 of item number %2,\';
        Text004: label 'reserved for %3\';
        Text005: label 'from %4?';
        SalesLine: Record "Sales Line";
        ReqLine: Record "Requisition Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        TransLine: Record "Transfer Line";
        ReservEntry: Record "Vehicle Reservation Entry";
        ReservEngineMgt: Codeunit "Veh. Reservation Engine Mgt.";


    procedure LookupReservedFor()
    var
        ReservEntry: Record "Vehicle Reservation Entry";
    begin
        ReservEntry.Get(Rec."Entry No.", false);
        LookupReserved(ReservEntry);
    end;


    procedure LookupReservedFrom()
    var
        ReservEntry: Record "Vehicle Reservation Entry";
    begin
        ReservEntry.Get(Rec."Entry No.", true);
        LookupReserved(ReservEntry);
    end;


    procedure LookupReserved(ReservEntry: Record "Vehicle Reservation Entry")
    begin
        case ReservEntry."Source Type" of
            Database::"Sales Line":
                begin
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", ReservEntry."Source Subtype");
                    SalesLine.SetRange("Document No.", ReservEntry."Source ID");
                    SalesLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(Page::"Sales Lines", SalesLine);
                end;
            Database::"Requisition Line":
                begin
                    ReqLine.Reset;
                    ReqLine.SetRange("Worksheet Template Name", ReservEntry."Source ID");
                    ReqLine.SetRange("Journal Batch Name", ReservEntry."Source Batch Name");
                    ReqLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(Page::"Requisition Lines", ReqLine);
                end;
            Database::"Purchase Line":
                begin
                    PurchLine.Reset;
                    PurchLine.SetRange("Document Type", ReservEntry."Source Subtype");
                    PurchLine.SetRange("Document No.", ReservEntry."Source ID");
                    PurchLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(Page::"Purchase Lines", PurchLine);
                end;
            Database::"Item Journal Line":
                begin
                    ItemJnlLine.Reset;
                    ItemJnlLine.SetRange("Journal Template Name", ReservEntry."Source ID");
                    ItemJnlLine.SetRange("Journal Batch Name", ReservEntry."Source Batch Name");
                    ItemJnlLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    ItemJnlLine.SetRange("Entry Type", ReservEntry."Source Subtype");
                    Page.RunModal(Page::"Item Journal Lines", ItemJnlLine);
                end;
            Database::"Item Ledger Entry":
                begin
                    ItemLedgEntry.Reset;
                    ItemLedgEntry.SetRange("Entry No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(0, ItemLedgEntry);
                end;
            Database::"Transfer Line":
                begin
                    TransLine.Reset;
                    TransLine.SetRange("Document No.", ReservEntry."Source ID");
                    TransLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
                    Page.RunModal(0, TransLine);
                end;
        end;
    end;
}

