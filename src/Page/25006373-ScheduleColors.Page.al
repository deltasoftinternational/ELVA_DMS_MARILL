Page 25006373 "Schedule Colors"
{
    ApplicationArea = Basic;
    Caption = 'Schedule Colors';
    PageType = List;
    SourceTable = "Schedule Color Config.";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of allocation this color will be defined for.';
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the subtype of document this color will be defined for.';
                }
                field(RentOrderSubtype; Rec."Rent Order Subtype")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the rent line status to which this color line will be defined for.';
                }
                field(WorkStatus; Rec."Work Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service work status to which this color line will be defined for.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service work status to which this color line will be defined for.';
                }
                field(FontColor; Rec."Font Color")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the color for text.';
                }
                field(FontBold; Rec."Font Bold")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if a text in the allocation should be in bold.';
                }
                field(BackgroundColor; Rec."Background Color")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the color for the allocation.';
                }
                field(AllocationDelayColor; Rec."Allocation Delay Color")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the color for the allocation that is delayed.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ForeColorOnFormat;
    end;

    var
        [InDataSet]
        ForeColorEmphasize: Boolean;

    local procedure ForeColorOnFormat()
    begin
        ForeColorEmphasize := Rec."Font Bold";
    end;
}

