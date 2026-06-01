Page 25006152 "Service Labor List"
{
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     "Description in LVI"

    ApplicationArea = Basic;
    Caption = 'Service Labor List';
    CardPageID = "Service Labor Card";
    Editable = false;
    PageType = List;
    SourceTable = "Service Labor";
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Process,Report,New Document,Approve,Request Approval,Prices and Discounts,Navigate,Labor';

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the labor.';
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the make code for the labor. If make code is specified, then this labor can be used only for vehicles of that make.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description for the specified labor.';
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies an additional description for the specified labor.';
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a search description that you use to find the labor in lists.';
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the labor''s product type to link transactions made for this labor with the appropriate general ledger account according to the general posting setup.';
                }
                field(VATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the VAT specification of the involved labor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies a Global Dimension 1 code that should be applied when the labor code is used.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies a Global Dimension 2 code that should be applied when the labor code is used.';
                }
                field(GroupCode; Rec."Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the group that the labor belongs to.';
                }
                field(SubgroupCode; Rec."Subgroup Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the subgroup that the labor belongs to.';
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the base unit used to measure the labor, for example, an hour.';
                }
                //field(FreeofCharge; "Free of Charge")
                //{
                //    ApplicationArea = Basic;
                //    Visible = false;
                //}
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies when the labor card was last modified.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Labor)
            {
                Caption = 'Labor';
                action(Translations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Translations';
                    Image = Translations;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Service Labor Translations";
                    RunPageLink = "No." = field("No.");
                }
                action(StandardTimes)
                {
                    ApplicationArea = Basic;
                    Caption = '&Standard Times';
                    Image = Timeline;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Service Labor Standard Times";
                    RunPageLink = "Labor No." = field("No.");
                }
                action("<Action1190000>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Prices';
                    Image = SalesPrices;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Service Prices";
                    RunPageLink = Code = field("No."),
                                  Type = const(Labor);
                }
            }
        }
    }


    procedure GetSelectionFilter(): Code[80]
    var
        Labor: Record "Service Labor";
        FirstItem: Code[30];
        LastItem: Code[30];
        SelectionFilter: Code[250];
        ItemCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(Labor);
        ItemCount := Labor.Count;
        if ItemCount > 0 then begin
            Labor.FindSet;
            while ItemCount > 0 do begin
                ItemCount := ItemCount - 1;
                Labor.MarkedOnly(false);
                FirstItem := Labor."No.";
                LastItem := FirstItem;
                More := (ItemCount > 0);
                while More do
                    if Labor.Next = 0 then
                        More := false
                    else
                        if not Labor.Mark then
                            More := false
                        else begin
                            LastItem := Labor."No.";
                            ItemCount := ItemCount - 1;
                            if ItemCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstItem = LastItem then
                    SelectionFilter := SelectionFilter + FirstItem
                else
                    SelectionFilter := SelectionFilter + FirstItem + '..' + LastItem;
                if ItemCount > 0 then begin
                    Labor.MarkedOnly(true);
                    Labor.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;
}

