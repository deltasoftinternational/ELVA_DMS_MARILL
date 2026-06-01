Page 25006452 "Manufacturer Option BOM Comp."
{
    AutoSplitKey = true;
    Caption = 'Manufacturer Option BOM Comp.';
    DataCaptionExpression = Rec."Parent Option Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Manufacturer Option BOM Comp.";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ParentOptionCode; Rec."Parent Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(BillofMaterials; Rec."Bill of Materials")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

