Page 25006637 "Rent Sales Order Subpage"
{
    AutoSplitKey = true;
    Caption = 'Rent Sales Lines';
    PageType = ListPart;
    SourceTable = "Rent Sales Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Rent Asset Quantity"; Rec."Rent Asset Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(Periods; Rec.Periods)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = QuantityEditable;
                }
                field(UnitCostLCY; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                }
                field(AttachedtoRentLineNo; Rec."Attached to Rent Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(ToInvoice; Rec."To Invoice")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(DimensionSetID; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RentLedgerEntryNo; Rec."Rent Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SalesDocumentType; SalesDocumentType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Document Type';
                    OptionCaption = ' ,Invoice,Credit Memo,Posted Invoice,Posted Credit Memo';
                }
                field(GetSalesDocumentNo; Rec.GetSalesDocumentNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Document No.';

                    trigger OnDrillDown()
                    begin
                        case SalesDocumentType of
                            Salesdocumenttype::Invoice, Salesdocumenttype::"Credit Memo":
                                begin
                                    SalesHeader.Reset;
                                    SalesHeader.SetRange("No.", Rec.GetSalesDocumentNo);
                                    if SalesDocumentType = Salesdocumenttype::Invoice then
                                        Page.Run(Page::"Sales Invoice", SalesHeader)
                                    else
                                        Page.Run(Page::"Sales Credit Memo", SalesHeader);
                                end;
                            Salesdocumenttype::"Posted Invoice":
                                begin
                                    SalesInvHeader.Reset;
                                    SalesInvHeader.SetRange("No.", Rec.GetSalesDocumentNo);
                                    Page.Run(Page::"Posted Sales Invoice", SalesInvHeader);
                                end;
                            Salesdocumenttype::"Posted Credit Memo":
                                begin
                                    SalesCreditMemo.Reset;
                                    SalesCreditMemo.SetRange("No.", Rec.GetSalesDocumentNo);
                                    Page.Run(Page::"Posted Sales Credit Memo", SalesCreditMemo);
                                end;
                        end;
                    end;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field(VFRun1From; Rec."VF Run 1 From")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                }
                field(VFRun1To; Rec."VF Run 1 To")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun2Visible;
                }
                field(VFRun2From; Rec."VF Run 2 From")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun3Visible;
                }
                field(VFRun2To; Rec."VF Run 2 To")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun4Visible;
                }
                field(VFRun3From; Rec."VF Run 3 From")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun5Visible;
                }
                field(VFRun3To; Rec."VF Run 3 To")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun6Visible;
                }
                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Extra Charge Line"; Rec."Extra Charge Line")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(BinCode; Rec."Bin Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Dimensions)
            {
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;

                trigger OnAction()
                begin
                    Rec.ShowDocDim;
                end;
            }
            action(CreateExtraChargeLines)
            {
                ApplicationArea = Basic;
                Caption = 'Create Extra Charge Sales Lines';

                trigger OnAction()
                begin
                    Rec.CreateExtraChargeLines;
                end;
            }
            action(CancelRentSalesLine)
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Rent Sales Line';

                trigger OnAction()
                begin
                    Rec.CancelRentSalesLine(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SalesDocumentType := Rec.GetSalesDocumentType;
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        if Rec."Attached to Rent Line No." <> 0 then
            QuantityEditable := false
        else
            QuantityEditable := true;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Attached to Rent Line No." <> 0 then
            QuantityEditable := false
        else
            QuantityEditable := true;
    end;

    trigger OnOpenPage()
    begin
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 1 From"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 1 To"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 2 From"));
        IsVFRun4Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 2 To"));
        IsVFRun5Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 3 From"));
        IsVFRun6Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 3 To"));
    end;

    var
        SalesDocumentType: Option " ",Invoice,"Credit Memo","Posted Invoice","Posted Credit Memo";
        SalesDocumentNo: Code[20];
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCreditMemo: Record "Sales Cr.Memo Header";
        IsVFRun1Visible: Boolean;
        IsVFRun2Visible: Boolean;
        IsVFRun3Visible: Boolean;
        IsVFRun4Visible: Boolean;
        IsVFRun5Visible: Boolean;
        IsVFRun6Visible: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        QuantityEditable: Boolean;
}

