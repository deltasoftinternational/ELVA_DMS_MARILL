Page 25006489 "Posted Transf.Rcpt.Subf.(Veh.)"
{
    Caption = 'Vehicle Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Transfer Receipt Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(TransferToBinCode; Rec."Transfer-To Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShippingTime; Rec."Shipping Time")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Line)
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #5745. Unsupported part was commented. Please check it.
                        /*CurrPage.TransferReceiptLines.FORM.*/
                        _ShowDimensions;

                    end;
                }
            }
        }
    }


    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure _ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;


    procedure ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;
}

