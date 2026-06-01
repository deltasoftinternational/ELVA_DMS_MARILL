/* page 25006110 "Report Standard Text"
{
    ApplicationArea = All;
    Caption = 'Report Standard Text';
    PageType = List;
    SourceTable = "Report Standard Text";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Report ID"; Rec."Report ID")
                {
                    ToolTip = 'Specifies the Report that would have special texts.';
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the date of document from which this special text should be displayed.';
                    ApplicationArea = All;
                }
                field(Sequence; Rec.Sequence)
                {
                    ToolTip = 'Specifies the Sequence in which texts will be displayed, if there is more than one text specified.';
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the date of document to which this special text should be displayed.';
                    ApplicationArea = All;
                }
                field("Standard Text Code"; Rec."Standard Text Code")
                {
                    ToolTip = 'Specifies the Standard Text Code that defines the special text.';
                    ApplicationArea = All;
                }
                field("Show in Bold"; Rec."Show in Bold")
                {
                    ToolTip = 'Specifies if the text should be displayed in Bold.';
                    ApplicationArea = All;
                }
                field("Show in Italic"; Rec."Show in Italic")
                {
                    ToolTip = 'Specifies if the text should be displayed in Italic.';
                    ApplicationArea = All;
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    ToolTip = 'Shows the the Report Caption.';
                    ApplicationArea = All;
                }
            }
        }
    }
}*/
