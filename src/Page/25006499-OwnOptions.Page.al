Page 25006499 "Own Options"
{
    // 27.08.2008. EDMS P2
    //   * Added Menu Item "Own Option" -> Copy Own Options
    //                     "Own Option" -> Paste Own Options

    ApplicationArea = Basic;
    Caption = 'Own Options';
    DataCaptionFields = "Make Code", "Model Code";
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Own Option";
    UsageCategory = Lists;

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
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field(PackageNo; Rec."Package No.")
                {
                    ApplicationArea = Basic;
                }
                field(SalesPrice; Rec.GetCurrentPrice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Price';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(OwnOption)
            {
                Caption = 'Own Option';
                action(Translations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Option Translations";
                    RunPageLink = "Option Type" = const("Own Option"),
                                  "Make Code" = field("Make Code"),
                                  "Model Code" = field("Model Code"),
                                  "Option Code" = field("Option Code");
                }
                action(Action1101907022)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Price';
                    Image = SalesPrices;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Option Sales Prices";
                    RunPageLink = "Make Code" = field("Make Code"),
                                  "Model Code" = field("Model Code"),
                                  "Option Code" = field("Option Code"),
                                  "Option Type" = const("Own Option"),
                                  "Sales Type" = const("All Customers");
                }
                action(SalesDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Discounts';
                    Image = SalesLineDisc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Option Sales Discounts";
                    RunPageLink = "Make Code" = field("Make Code"),
                                  "Model Code" = field("Model Code"),
                                  "Option Code" = field("Option Code"),
                                  "Option Type" = const("Own Option"),
                                  "Sales Type" = const("All Customers");
                }
                action(ActionCopyOptions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Options';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Model.Get(Rec."Make Code", Rec."Model Code");
                        CopyOptions.SetModel(Model);
                        CopyOptions.RunModal;
                        Clear(CopyOptions);
                    end;
                }
            }
        }
    }

    var
        CopyOptions: Report "Copy Option";
        Model: Record Model;


    procedure GetSelectionFilter(): Code[80]
    var
        recOwnOption: Record "Own Option";
        codFirstOwnOption: Code[30];
        codLastOwnOption: Code[30];
        SelectionFilter: Code[250];
        iOwnOptionCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(recOwnOption);
        iOwnOptionCount := recOwnOption.Count;
        if iOwnOptionCount > 0 then begin
            recOwnOption.FindSet;
            while iOwnOptionCount > 0 do begin
                iOwnOptionCount := iOwnOptionCount - 1;
                recOwnOption.MarkedOnly(false);
                codFirstOwnOption := recOwnOption."Option Code";
                codLastOwnOption := codFirstOwnOption;
                More := (iOwnOptionCount > 0);
                while More do
                    if recOwnOption.Next = 0 then
                        More := false
                    else
                        if not recOwnOption.Mark then
                            More := false
                        else begin
                            codLastOwnOption := recOwnOption."Option Code";
                            iOwnOptionCount := iOwnOptionCount - 1;
                            if iOwnOptionCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if codFirstOwnOption = codLastOwnOption then
                    SelectionFilter := SelectionFilter + codFirstOwnOption
                else
                    SelectionFilter := SelectionFilter + codFirstOwnOption + '..' + codLastOwnOption;
                if iOwnOptionCount > 0 then begin
                    recOwnOption.MarkedOnly(true);
                    recOwnOption.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;
}

