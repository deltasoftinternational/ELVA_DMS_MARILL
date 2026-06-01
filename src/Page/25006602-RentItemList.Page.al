Page 25006602 "Rent Item List"
{
    ApplicationArea = Basic;
    Caption = 'Rent Item List';
    CardPageID = "Rent Item Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Attributes';
    SourceTable = "Rent Item";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the rent item, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the rent item.';
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a search description that you use to find the rent item in lists.';
                }
                field(Description2; Rec."Description 2")
                {
                    ToolTip = 'Specifies an additional description of the rent item.';
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
                field(DefaultRentPackageNo; Rec."Default Rent Package No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the rent package number that should be applied with this rent item.';
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
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the model of this rent item.';
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the make of this rent item.';
                }
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
            action(Attributes)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = Advanced;
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
                    //CurrPage.ItemAttributesFactBox.PAGE.LoadItemAttributesData("No.");
                end;
            }
            action(FilterByAttributes)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Filter by Attributes';
                Image = EditFilter;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Find items that match specific attributes. To make sure you include recent changes made by other users, clear the filter and then reset it.';

                trigger OnAction()
                var
                    RentManagement: Codeunit "Rent Management";
                    TypeHelper: Codeunit "Type Helper";
                    CloseAction: action;
                    FilterText: Text;
                    FilterPageID: Integer;
                    ParameterCount: Integer;
                begin
                    FilterPageID := Page::"Filter Items by Attribute";
                    if CurrentClientType() = Clienttype::Phone then
                        FilterPageID := Page::"Filter Items by Att. Phone";

                    CloseAction := Page.RunModal(FilterPageID, TempFilterItemAttributesBuffer);
                    if (CurrentClientType() <> Clienttype::Phone) and (CloseAction <> Action::LookupOK) then
                        exit;

                    if TempFilterItemAttributesBuffer.IsEmpty then begin
                        ClearAttributesFilter;
                        exit;
                    end;

                    RentManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer, TempFilteredRentItem);
                    FilterText := RentManagement.GetItemNoFilterText(TempFilteredRentItem, ParameterCount);


                    if ParameterCount < TypeHelper.GetMaxNumberOfParametersInSQLQuery - 100 then begin
                        Rec.FilterGroup(0);
                        Rec.MarkedOnly(false);
                        Rec.SetFilter("No.", FilterText);
                    end else begin
                        RunOnTempRec := true;
                        Rec.ClearMarks;
                        Rec.Reset;
                    end;
                end;
            }
            action(ClearAttributes)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Clear Attributes Filter';
                Image = RemoveFilterLines;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Remove the filter for specific item attributes.';

                trigger OnAction()
                begin
                    ClearAttributesFilter;
                    TempFilteredRentItem.Reset;
                    TempFilteredRentItem.DeleteAll;
                    RunOnTempRec := false;
                end;
            }
            action(RentLedgerEntries)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Ledger Entries';
                Image = LedgerEntries;
                RunObject = Page "Rent Ledger Entries";
                RunPageLink = "Rent Item No." = field("No.");
            }
            action(Prices)
            {
                ApplicationArea = Basic;
                Caption = 'Prices';
                Image = Price;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Rent Item Price List";
                RunPageLink = "Rent Item No." = field("No.");
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.RentItemAttributesFactbox.Page.LoadItemAttributesData(Rec."No.");
    end;

    var
        TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
        TempFilteredRentItem: Record "Rent Item" temporary;
        RunOnTempRec: Boolean;

    local procedure ClearAttributesFilter()
    begin
        Rec.ClearMarks;
        Rec.MarkedOnly(false);
        TempFilterItemAttributesBuffer.Reset;
        TempFilterItemAttributesBuffer.DeleteAll;
        Rec.FilterGroup(0);
        Rec.SetRange("No.");
    end;
}

