Page 25006601 "Rent Item Card"
{
    Caption = 'Rent Item Card New';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Item,History,Prices & Discounts';
    SourceTable = "Rent Item";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the rent item, according to the specified number series.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the rent item.';
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional description of the rent item.';
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the make of this rent item.';
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the model of this rent item.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for Global Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for Global Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field(RentItemCategoryCode; Rec."Rent Item Category Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the category that the rent item belongs to.';
                }
                field(RentProductGroupCode; Rec."Rent Product Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the product group that the rent item belongs to.';
                }
                field(DefaultRentPackageNo; Rec."Default Rent Package No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the rent package number that should be applied with this rent item.';
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a search description that you use to find the rent item in lists.';
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resource code that will be used to invoice revenue related to this rent item.';
                }
                field("Extra Charge Resource No."; Rec."Extra Charge Resource No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resource code that will be used to invoice revenue for extra charges related to this rent item.';
                }
                field(VariableField1; Rec."Variable Field 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVF1Visible;
                    ToolTip = 'Specifies the additional specification defined by variable fields.';
                }
                field(VariableField2; Rec."Variable Field 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVF2Visible;
                    ToolTip = 'Specifies the additional specification defined by variable fields.';
                }
                field(VariableField3; Rec."Variable Field 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVF3Visible;
                    ToolTip = 'Specifies the additional specification defined by variable fields.';
                }
            }
            group("Specification 1")
            {
            }
        }
        area(factboxes)
        {
            part(RentItemAttributesFactbox; "Rent Item Attributes Factbox")
            {
                ApplicationArea = Basic, Suite;
            }

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
            action(RentItemRelation)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Item Relation';
                Image = ItemSubstitution;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Rent Item Relations";
                RunPageLink = "Rent Item No." = field("No.");
            }
            action(Availability)
            {
                ApplicationArea = Basic;
                Caption = 'Availability';
                Image = AvailableToPromise;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RentItemCapacity: Page "Rent Item Capacity";
                begin
                    RentItemCapacity.SetRentItems(Rec);
                    RentItemCapacity.SetItemOrAsset(0);//Set Item
                    RentItemCapacity.Run;
                end;
            }
            action(ServiceLedgerEntries)
            {
                ApplicationArea = Basic;
                Caption = 'Service Ledger Entries';
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(RentMgt);
                    RentMgt.ShowRentItemServiceEntries(Rec."No.");
                end;
            }
            action(Prices)
            {
                ApplicationArea = Basic;
                Caption = 'Prices';
                Image = Price;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page "Rent Item Price List";
                RunPageLink = "Rent Item No." = field("No.");
            }
            action(Discounts)
            {
                ApplicationArea = Basic;
                Caption = 'Discounts';
                Image = Discount;
                Promoted = true;
                PromotedCategory = Category6;
                RunObject = Page "Rent Item Sales Discounts";
                RunPageLink = Code = field("No."), Type = Const("Rent Item");
            }
            action(Attributes)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = All;
                Caption = 'Attributes';
                Image = Category;
                Promoted = true;
                PromotedCategory = Category4;
                Scope = Repeater;
                ToolTip = 'View or edit the item''s attributes, such as color, size, or other characteristics that help to describe the item.';

                trigger OnAction()
                begin
                    Page.RunModal(Page::"Ren Item Attribute Val. Editor", Rec);
                    CurrPage.SaveRecord;
                    CurrPage.RentItemAttributesFactbox.Page.LoadItemAttributesData(Rec."No.");
                end;
            }
            action(RentLedgerEntries)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Ledger Entries';
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page "Rent Ledger Entries";
                RunPageLink = "Rent Item No." = field("No.");
            }
            action("Page Default Dimensions")
            {
                ApplicationArea = Suite;
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = const(25006601),
                              "No." = field("No.");
                ShortCutKey = 'Shift+Ctrl+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
            }
            action(RentAssetsByLocation)
            {
                ApplicationArea = Basic;
                Caption = 'Availability by Location';
                Image = LedgerEntries;
                trigger OnAction()
                var
                    RentItemsByLocation: Page "Rent Assets by Location";
                begin
                    RentItemsByLocation.SetRentItemNo(Rec."No.");
                    RentItemsByLocation.Run();
                end;
            }
            action(RentItemOpenDoc)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Item in Open Documents';
                Image = LedgerEntries;
                RunObject = Page "Rent Lines";
                RunPageLink = "Rent Item No." = field("No."),
                                Closed = CONST(false);
            }
            action(RentItemClosedDoc)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Item in Closed Documents';
                Image = LedgerEntries;
                RunObject = Page "Rent Lines";
                RunPageLink = "Rent Item No." = field("No."),
                                Closed = CONST(true);
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.RentItemAttributesFactbox.Page.LoadItemAttributesData(Rec."No.");
    end;

    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnOpenPage()
    begin
        IsVF1Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field 1"));
        IsVF2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field 2"));
        IsVF3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field 3"));
    end;

    var

        RentMgt: Codeunit "Rent Management";
        RentItemRelation: Record "Rent Item Relation";
        LastMotorhours: Decimal;
        IsVF1Visible: Boolean;
        IsVF2Visible: Boolean;
        IsVF3Visible: Boolean;

}

