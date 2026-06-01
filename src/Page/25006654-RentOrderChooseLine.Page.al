Page 25006654 "Rent Order Choose Line"
{
    AutoSplitKey = true;
    Caption = 'Choose Rent Lines';
    PageType = List;
    SourceTable = "Rent Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = true;
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = False;
                    StyleExpr = StatusStyleExpression;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentItemNo; Rec."Rent Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(RentAssetQuantity; Rec."Rent Asset Quantity")
                {
                    ApplicationArea = Basic;
                    Editable = IsQuantityEditable;
                }
                field(RentPeriodType; Rec."Rent Period Type")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(RentStartDate; Rec."Rent Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(RentEndDate; Rec."Rent End Date")
                {
                    ApplicationArea = Basic;
                }
                field(DimensionSetID; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                }
                field(ActualShipmentDate; Rec."Actual Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(ActualReturnDate; Rec."Actual Return Date")
                {
                    ApplicationArea = Basic;
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                }
                field(QtytoInvoice; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Basic;
                }
                field(QuantityInvoiced; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                }
                field(PlannedShipmentDate; Rec."Planned Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(PlannedReturnDate; Rec."Planned Return Date")
                {
                    ApplicationArea = Basic;
                }
                field(AttachedtoLineNo; Rec."Attached to Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentAssetNo; Rec."Rent Asset No.")
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
                }
                field(SerialNo; Rec."Serial No.")
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
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
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
                field(LastDateInvoiced; Rec."Last Date Invoiced")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Quantity Returned"; Rec."Quantity Returned")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    trigger OnInit()
    begin
        Rec.MarkedOnly(true);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateRentAssetQtyEditable;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        StatusStyleExpression := GetStatusColor(Rec."Status");
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
        IsVFRun1Visible: Boolean;
        IsVFRun2Visible: Boolean;
        IsVFRun3Visible: Boolean;
        IsVFRun4Visible: Boolean;
        IsVFRun5Visible: Boolean;
        IsVFRun6Visible: Boolean;
        IsQuantityEditable: Boolean;
        RentAsset: Record "Rent Asset";
        ShortcutDimCode: array[8] of Code[20];
        StatusStyleExpression: Text[30];

    local procedure UpdateRentAssetQtyEditable()
    begin
        IsQuantityEditable := false;
        if Rec."Rent Asset No." <> '' then begin
            RentAsset.Get(Rec."Rent Asset No.");
            if RentAsset."Asset Type" = RentAsset."Asset Type"::Multiple then
                IsQuantityEditable := true;
        end;
    end;

    procedure GetStatusColor(Staus: Integer): Text[30]
    begin
        if Staus = 0 then
            exit('Stadard');
        if Staus = 1 then
            exit('StandardAccent');
        if Staus = 2 then
            exit('Ambiguous');
        if Staus = 3 then
            exit('Favorable');
    end;
}

