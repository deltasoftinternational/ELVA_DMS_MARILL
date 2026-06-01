page 25006656 "Rent Order Components Subpage"
{
    AutoSplitKey = true;
    Caption = 'Rent Order Components Subpage';
    PageType = List;
    Editable = false;
    SourceTable = "Rent line";
    //PopulateAllFields = true;
    SourceTableView = sorting("Document Type", "Document No.", "Line No.")
                      where("Component Line" = const(TRUE));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = not Rec.Locked;
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
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(RentAssetNo; Rec."Rent Asset No.")
                {
                    ApplicationArea = Basic;
                }
                field("Rent Asset Description"; Rec."Rent Asset Description")
                {
                    ApplicationArea = All;
                }
                field(RentAssetQuantity; Rec."Rent Asset Quantity")
                {
                    ApplicationArea = Basic;
                    Editable = IsQuantityEditable;
                }
                field(ActualShipmentDate; Rec."Actual Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field(ActualReturnDate; Rec."Actual Return Date")
                {
                    ApplicationArea = Basic;
                }
                field(PlannedShipmentDate; Rec."Planned Shipment Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlannedReturnDate; Rec."Planned Return Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AttachedtoLineNo; Rec."Attached to Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(SerialNo; Rec."Serial No.")
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

    actions
    {
        area(processing)
        {
            action(CreateTransferOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Create Transfer Order';
                Image = CreateMovement;

                trigger OnAction()
                var
                    RentHeader: Record "Rent Header";
                    RentTransferPost: Codeunit "RentTransfer-Post";
                begin
                    RentHeader.Reset;
                    RentHeader.Get(Rec."Document Type", Rec."Document No.");
                    RentTransferPost.CreateRentTransferOrder(RentHeader, Rec."Line No.", true);
                end;
            }
            action(AddComponentLine)
            {
                ApplicationArea = Basic;
                Caption = 'Add Component Line';
                trigger OnAction()
                var
                    RentComponents: Record "Rent Asset Component";
                    RentComponents2: Record "Rent Asset Component";
                    RelationLine: Integer;
                    RentLine: Record "Rent Line";
                    RentLineFrom: Record "Rent Line";
                    RentComponentPage: Page "Rent Asset Components";
                    DocumentNo: Code[20];
                    NewLineNo: Integer;
                begin
                    Evaluate(RelationLine, Rec.GetFilter("Attached to Line No."));
                    Evaluate(DocumentNo, Rec.GetFilter("Document No."));
                    RentLineFrom.Reset;
                    RentLineFrom.SetFilter("Document No.", DocumentNo);
                    RentLineFrom.SetFilter("Line No.", Rec.GetFilter("Attached to Line No."));
                    If RentLineFrom.FindFirst then begin
                        RentComponents.Reset;
                        RentComponents.SetRange("Main Asset No.", RentLineFrom."Rent Asset No.");
                        if RentComponents.FindFirst then begin
                            RentComponents2.SetRange("Main Asset No.", RentLineFrom."Rent Asset No.");
                            if PAGE.RunModal(PAGE::"Rent Asset Components", RentComponents2) = ACTION::LookupOK then begin
                                RentLine.Reset;
                                RentLine.Setrange("Document Type", RentLine."Document Type"::Order);
                                RentLine.Setrange("Document No.", DocumentNo);
                                If RentLine.FindLast then
                                    NewLineNo := RentLine."Line No." + 10000;
                                RentLine.Init;
                                RentLine."Document Type" := RentLine."Document Type"::Order;
                                RentLine."Document No." := DocumentNo;
                                RentLine."Line No." := NewLineNo;
                                RentLine."Component Line" := true;
                                If Evaluate(RelationLine, Rec.GetFilter("Attached to Line No.")) then
                                    RentLine."Attached to Line No." := RelationLine;
                                RentLine.Validate("Rent Item No.", RentLineFrom."Rent Item No.");
                                RentLine.Validate("Rent Asset No.", RentComponents2."Rent Asset No.");
                                RentLine.Insert(true);
                                CurrPage.Update();
                            end;

                        end;
                    end;
                end;
            }
            Action(DeleteComponentLine)
            {
                ApplicationArea = Basic;
                Caption = 'Delete Component Line';
                trigger OnAction()
                var
                begin
                    Rec.Delete(true);
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateRentAssetQtyEditable;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
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
}

