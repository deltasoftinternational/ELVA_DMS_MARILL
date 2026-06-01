pageextension 25006009 "Item List" extends "Item List" //31
{

    layout
    {
        addafter("Default Deferral Template Code")
        {
            field("Market Recomended Sales Price"; Rec."Market Recomended Sales Price")
            {
                ToolTip = 'Specifies the Recomended Sales Price.';
                ApplicationArea = All;
                Visible = false;
            }
            field("MRSP Currency Code"; Rec."MRSP Currency Code")
            {
                ToolTip = 'Specifies the Recomended Sales Price currency.';
                ApplicationArea = All;
                Visible = false;
            }
            field("Reserved Qty. on Inventory"; Rec."Reserved Qty. on Inventory")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
    actions
    {
        modify(Action16)
        {
            Visible = false;
        }
        addafter(Action16)
        {
            action(EDMSAction16)
            {
                ApplicationArea = Suite;
                Caption = 'Statistics';
                Image = Statistics;
                ShortCutKey = 'F7';
                ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

                trigger OnAction()
                var
                    EDMSItemStatistics: Page "EDMS Item Statistics";
                begin
                    EDMSItemStatistics.SetItem(Rec);
                    EDMSItemStatistics.RunModal();
                end;
            }

        }
    }
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Item Type", Rec."Item Type"::Item);
        Rec.FilterGroup(0);
    end;
}