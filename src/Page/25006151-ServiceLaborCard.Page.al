Page 25006151 "Service Labor Card"
{
    // 19.01.2010 EDMS P2
    //   * Added menu item Labor -> Texts
    // 
    // 09.10.2007. EDMS P2
    //   * Made unvisible "Functions -> Restore VOLVO model and serie list"

    Caption = 'Service Labor Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Service Labor";
    PromotedActionCategories = 'New,Process,Report,New Document,Approve,Request Approval,Prices and Discounts,Navigate,Labor';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the labor.';

                    trigger OnAssistEdit()
                    var
                        SER001: label 'Make Code must be filled in. Please enter a value.';
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update;
                    end;
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
                    ToolTip = 'Specifies an additional description for the specified labor.';
                }
                field(LaborType; Rec."Labor Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the specified labor. Information on types are stored later in data and can be used for analysis.';
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
                    ToolTip = 'Specifies the base unit used to measure the labor, for example, an hour.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions.';
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a search description that you use to find the labor in lists.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a Global Dimension 1 code that should be applied when the labor code is used.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a Global Dimension 2 code that should be applied when the labor code is used.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies when the labor card was created.';
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies when the labor card was last modified.';
                }
                field(VariableField25006800; Rec."Variable Field 25006800")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006800Visibl;
                    ToolTip = 'Specifies the additional specification defined by variable fields.';
                }
                field(VariableField25006801; Rec."Variable Field 25006801")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006801Visibl;
                    ToolTip = 'Specifies the additional specification defined by variable fields.';
                }
                field(VariableField25006802; Rec."Variable Field 25006802")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006802Visibl;
                    ToolTip = 'Specifies the additional specification defined by variable fields.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                //field(FreeofCharge; "Free of Charge")
                //{
                //    ApplicationArea = Basic;
                //}
                field(PriceIncludesVAT; Rec."Price Includes VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if price defined in the labor card is including VAT.';
                }
                field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the VAT business posting group for customers for whom you want the sales price including VAT to apply.';
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the price of one unit of the labor.';
                }
                field(PriceProfitCalculation; Rec."Price/Profit Calculation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this labor.';
                }
                field(Profit; Rec."Profit %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the profit margin that you want to sell the labor at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost of one unit of the labor on the line.';
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the labor''s product type to link transactions made for this labor with the appropriate general ledger account according to the general posting setup.';
                }
                field(VATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the VAT specification of the involved labor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field(PriceGroupCode; Rec."Price Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the labor price group applied to this labor. You can use price groups to define pricing for labors based on groups instead of having to do it per each labor card separatelly';
                }
                field(LaborDiscountGroup; Rec."Labor Discount Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the labor discount group applied to this labor. You can use labro discount groups to define discounts for labors based on groups instead of having to do it per each labor card separatelly';
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
                Caption = '&Labor';
                action(ServiceLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger Entries';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedOnly = true;
                    ToolTip = 'View the history of transactions that have been posted for the selected labor in service ledger.';
                    RunObject = Page "Service Ledger Entries EDMS";
                    RunPageLink = "No." = field("No."),
                                  Type = const(Labor);
                    RunPageView = sorting("Entry Type", Type, "Payment Method Code", "No.", "Posting Date")
                                  order(ascending);
                    ShortCutKey = 'Ctrl+F5';
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = Comment;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'View or add comments for the selected labor code.';
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = const(Labor),
                                  "No." = field("No.");
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View or add default dimensions for the selected labor code.';
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(25006121),
                                  "No." = field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action(Translations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Translations';
                    Image = Translations;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'View or add default dimensions for the selected labor code.';
                    RunObject = Page "Service Labor Translations";
                    RunPageLink = "No." = field("No.");
                }
                action(Texts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Texts';
                    Image = Text;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'View or add additional texts for the selected labor code.';
                    RunObject = Page "Service Labor Texts";
                    RunPageLink = "Service Labor No." = field("No.");
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
                    ToolTip = 'View or add default dimensions for the selected labor code.';
                    RunObject = Page "Service Labor Standard Times";
                    RunPageLink = "Labor No." = field("No.");
                    ShortCutKey = 'Ctrl+S';
                }
                action("<Action1190012>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Prices';
                    Image = SalesPrices;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Set up different prices for the labor. A labor price is automatically granted on service lines when the specified criteria are met, such as customer, quantity, or ending date.';
                    RunObject = Page "Service Prices";
                    RunPageLink = Code = field("No."),
                                  Type = const(Labor);
                }
                action(Skills)
                {
                    ApplicationArea = Basic;
                    Caption = 'Skills';
                    Image = Skills;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    ToolTip = 'Set up skills required for this labor. Skills cab be assigned to resources and then system can control them.';
                    RunObject = Page "Service Labor Skills";
                    RunPageLink = "Labor Code" = field("No.");
                    RunPageView = sorting("Labor Code", "Skill Code");
                }
                action(SalesLineDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Line Discounts';
                    Image = LineDiscount;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Set up different discounts for the labor. A labor discount is automatically granted on service lines when the specified criteria are met, such as customer, quantity, or ending date.';
                    RunObject = Page "Labor Sales Line Discounts";
                    RunPageLink = Type = const(Labor),
                                  Code = field("No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetVariableFields;
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        DMSVariableField25006802Visibl := true;
        DMSVariableField25006801Visibl := true;
        DMSVariableField25006800Visibl := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetVariableFields;
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        SetVariableFields
    end;

    var
        [InDataSet]
        DMSVariableField25006800Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006801Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006802Visibl: Boolean;


    procedure SetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006800"));
        DMSVariableField25006801Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006801"));
        DMSVariableField25006802Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006802"));
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        Rec.SetRange("Make Code");
        Rec.SetRange("No.");
    end;
}

