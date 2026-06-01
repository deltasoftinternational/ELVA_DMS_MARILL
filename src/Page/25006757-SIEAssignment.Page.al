/*
Page 25006757 "SIE Assignment"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'SIE Assignment';
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    SourceTable = "SIE Assignment";
    SourceTableView = sorting("Applies-to Type", "Applies-to Doc. Type", "Applies-to Doc. No.", "Line No.")
                      order(ascending);
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(AppliestoDocType; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoDocNo; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoDocLineNo; Rec."Applies-to Doc. Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(QtytoAssign; Rec."Qty. to Assign")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        UpdateQtyAssgnt;
                    end;
                }
                field(DocQtyAssigned; Rec."Doc. Qty. Assigned")
                {
                    ApplicationArea = Basic;
                }
                field(QtytoTransfer; Rec."Qty. to Transfer")
                {
                    ApplicationArea = Basic;
                }
                field(TransactionDate; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field(TransactionTime; Rec."Transaction Time")
                {
                    ApplicationArea = Basic;
                }
                field(Resource; Rec.Resource)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            group(Control1101901018)
            {
                fixed(Control1101901019)
                {
                    group(Assignable)
                    {
                        Caption = 'Assignable';
                        field(AssignableQty; AssignableQty)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total (Qty.)';
                        }
                        field(AssgntAmount; AssgntAmount)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total (Amount)';
                        }
                    }
                    group(ToAssign)
                    {
                        Caption = 'To Assign';
                        field(TotalQtyToAssign; TotalQtyToAssign)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total (Qty.)';
                        }
                        field(TotalAmountToAssign; TotalAmountToAssign)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total (Amount)';
                        }
                    }
                    group(RemtoAssign)
                    {
                        Caption = 'Rem. to Assign';
                        field(RemQtyToAssign; RemQtyToAssign)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total (Qty.)';
                        }
                        field(RemAmountToAssign; RemAmountToAssign)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total (Amount)';
                        }
                    }
                    group(ToTransfer)
                    {
                        Caption = 'To Transfer';
                        field(QtyToPutIn; QtyToPutIn)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total (Qty.)';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1101907050>")
            {
                Caption = 'Posting';
                action("<Action1101901001>")
                {
                    ApplicationArea = Basic;
                    Caption = '&Assign';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SIEAssignment.PostAssignment(FilterSIEAssgnt, 1)
                    end;
                }
                action(Unassign)
                {
                    ApplicationArea = Basic;
                    Caption = '&Unassign';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SIEAssignment.PostUnAssignment(Rec, false)
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action("<Action1101901003>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest S&IE Assignment';
                    Promoted = true;
                    PromotedCategory = New;

                    trigger OnAction()
                    var
                        SIEAssignment: Codeunit "SIE Assignment";
                    begin
                        SIEAssignment.SuggestAssgnt(FilterSIEAssgnt);
                    end;
                }
                action(AddUnassignedTransaction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Add Unassigned Transaction';
                    Promoted = true;
                    PromotedCategory = New;

                    trigger OnAction()
                    var
                        SIEAssignment: Codeunit "SIE Assignment";
                    begin
                        SIEAssignment.AddUnassignedTran(FilterSIEAssgnt);
                    end;
                }
                separator(Action1101901006)
                {
                }
                action(Transfer)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        SIEAssignment: Codeunit "SIE Assignment";
                    begin
                        if not Confirm(Text001, false) then
                            exit;
                        SIEAssignment.TransferAll(FilterSIEAssgnt);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateQtyAssgnt;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        AssignableQty := 0;
        TotalQtyToAssign := 0
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Applies-to Type", FilterSIEAssgnt."Applies-to Type");
        Rec.SetRange(Corrected, false);
        Rec.SetRange(Type, Rec.Type::Main);
        case "Appl. Type" of
            "appl. type"::Service:
                begin
                    Rec.SetRange("Applies-to Doc. Type", FilterSIEAssgnt."Applies-to Doc. Type");
                    Rec.SetRange("Applies-to Doc. No.", FilterSIEAssgnt."Applies-to Doc. No.");
                    if FilterSIEAssgnt."Applies-to Doc. Line No." <> 0 then
                        Rec.SetRange("Applies-to Doc. Line No.", FilterSIEAssgnt."Applies-to Doc. Line No.")
                    else
                        Rec.SetRange("Applies-to Doc. Line No.");
                end;
            "appl. type"::Sale:
                ;
        end;
        Rec.FilterGroup(0);
        SIEAssignment.DistributeTransfer(FilterSIEAssgnt);
    end;

    var
        Text001: label 'Do you want to transfer all items?';
        Text002: label 'Do you realy want to post put-on?';
        Text100: label 'You don''t have rights to modify this field!';
        FilterSIEAssgnt: Record "SIE Assignment";
        SIELedgEntry: Record "SIE Ledger Entry";
        ServHeader: Record "Service Header EDMS";
        SalesHeader: Record "Sales Header";
        SIEAssignment: Codeunit "SIE Assignment";
        "Appl. Type": Option Service,Sale;
        AssignableQty: Decimal;
        TotalQtyToAssign: Decimal;
        RemQtyToAssign: Decimal;
        AssgntAmount: Decimal;
        TotalAmountToAssign: Decimal;
        RemAmountToAssign: Decimal;
        UnitCost: Decimal;
        QtyToPutIn: Decimal;
        DataCaption: Text[250];
        AssignableQtyTxt: Text[10];
        TotalQtyToAssignTxt: Text[10];
        RemQtyToAssignTxt: Text[10];


    procedure UpdateQtyAssgnt()
    var
        SIEAssgnt: Record "SIE Assignment";
        ServLine: Record "Service Line EDMS";
    begin
        SIELedgEntry.Get(Rec."Entry No.");
        SIELedgEntry.CalcFields("Qty. to Assign", "Qty. Assigned");
        AssignableQty := SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned";
        //AssignableQtyTxt := STRSUBSTNO('%1(%2)',AssignableQty,SIELedgEntry.Quantity);

        //AssgntAmount := AssignableQty * UnitCost;

        SIEAssgnt.Reset;
        SIEAssgnt.SetCurrentkey("Applies-to Type", "Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
        SIEAssgnt.SetRange("Applies-to Type", FilterSIEAssgnt."Applies-to Type");
        SIEAssgnt.SetRange("Applies-to Doc. Type", Rec."Applies-to Doc. Type");
        SIEAssgnt.SetRange("Applies-to Doc. No.", Rec."Applies-to Doc. No.");

        SIEAssgnt.SetRange(Type, Rec.Type::Main);

        if "Appl. Type" = "appl. type"::Service then
            if ServLine.Get(Rec."Applies-to Doc. Type", Rec."Applies-to Doc. No.",
               Rec."Applies-to Doc. Line No.") then begin
                SIEAssgnt.SetRange("Applies-to Doc. Line No.", Rec."Applies-to Doc. Line No.");
                SIEAssgnt.CalcSums("Qty. to Assign");
                QtyToPutIn := SIEAssgnt."Qty. to Assign";
                SIEAssgnt.SetRange(Type, Rec.Type::Detail);
                SIEAssgnt.CalcSums("Qty. Assigned Det.");
                //ServLine.CALCFIELDS("Transfered Quantity");
                //QtyToPutIn += (SIEAssgnt."Qty. Assigned Det." - ServLine."Transfered Quantity");
                SIEAssgnt.SetRange("Applies-to Doc. Line No.");
                SIEAssgnt.SetRange(Type, Rec.Type::Main);
            end else
                QtyToPutIn := Rec."Qty. to Assign";


        SIEAssgnt.SetRange("Entry No.", Rec."Entry No.");

        SIEAssgnt.CalcSums("Qty. to Assign", "Amount to Assign");
        TotalQtyToAssign := SIEAssgnt."Qty. to Assign";
        //TotalQtyToAssignTxt := STRSUBSTNO('%1(%2)',TotalQtyToAssign,SIELedgEntry."Qty. to Assign");
        //TotalAmountToAssign := SIEAssgnt."Amount to Assign";

        RemQtyToAssign := AssignableQty - TotalQtyToAssign;
        //RemAmountToAssign := AssgntAmount - TotalAmountToAssign;
    end;

    local procedure UpdateQty()
    begin
    end;


    procedure Initialize(SIEAssgnt: Record "SIE Assignment")
    begin
        FilterSIEAssgnt := SIEAssgnt;
        DataCaption := SIEAssgnt."Applies-to Doc. No.";
        if SIEAssgnt."Applies-to Doc. Line No." <> 0 then
            DataCaption := DataCaption + ' ' + SIEAssgnt.Description;
    end;
}
*/