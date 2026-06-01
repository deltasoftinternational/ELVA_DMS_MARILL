Page 25006450 "Manufacturer Options"
{
    ApplicationArea = Basic;
    Caption = 'Manufacturer Options';
    PageType = List;
    SourceTable = "Manufacturer Option";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalCode; Rec."External Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Standard; Rec.Standard)
                {
                    ApplicationArea = Basic;
                }
                field(BillofMaterials; Rec."Bill of Materials")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ClassCode; Rec."Class Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
            action(SalesPrices)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Prices';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Option Sales Prices";
                RunPageLink = "Option Type" = const("Manufacturer Option"),
                              "Make Code" = field("Make Code"),
                              "Model Code" = field("Model Code"),
                              "Model Version No." = field("Model Version No."),
                              "Option Code" = field("Option Code"),
                              "Option Subtype" = field("Type");
            }
            action("<Action1101904016>")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Discounts';
                Image = SalesLineDisc;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Option Sales Discounts";
                RunPageLink = "Option Type" = const("Manufacturer Option"),
                              "Make Code" = field("Make Code"),
                              "Model Code" = field("Model Code"),
                              "Model Version No." = field("Model Version No."),
                              "Option Code" = field("Option Code");
            }
            action("<Page Option Purchase Prices>")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Prices';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Option Purchase Prices";
                RunPageLink = "Option Type" = const("Manufacturer Option"),
                              "Make Code" = field("Make Code"),
                              "Model Code" = field("Model Code"),
                              "Model Version No." = field("Model Version No."),
                              "Option Code" = field("Option Code");
            }
            action(PurchaseDiscounts)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Discounts';
                Image = SalesLineDisc;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Option Purchase Discounts";
                RunPageLink = "Option Type" = const("Manufacturer Option"),
                              "Make Code" = field("Make Code"),
                              "Model Code" = field("Model Code"),
                              "Model Version No." = field("Model Version No."),
                              "Option Code" = field("Option Code");
            }
            action("<Action1101904020>")
            {
                ApplicationArea = Basic;
                Caption = 'Conditions';
                Image = Worksheet;
                RunObject = Page "Manufacturer Option Conditions";
                RunPageLink = "Make Code" = field("Make Code"),
                              "Model Code" = field("Model Code"),
                              "Model Version No." = field("Model Version No."),
                              "Option Code" = field("Option Code");
            }
            action(Translations)
            {
                ApplicationArea = Basic;
                Caption = 'Translations';
                Image = Translations;
                RunObject = Page "Option Translations";
                RunPageLink = "Option Type" = const("Manufacturer Option"),
                              "Make Code" = field("Make Code"),
                              "Model Code" = field("Model Code"),
                              "Model Version No." = field("Model Version No."),
                              "Option Code" = field("Option Code");
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
                    Item.Get(Rec."Model Version No.");
                    CopyOptions.SetItem(Item);
                    CopyOptions.Run;
                    Clear(CopyOptions);
                end;
            }
            group("Assembly List")
            {
                Caption = 'Assembly List';
                action("<Action1101904024>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assembly List';
                    Image = List;
                    RunObject = Page "Manufacturer Option BOM Comp.";
                    RunPageLink = "Make Code" = field("Make Code"),
                                  "Model Code" = field("Model Code"),
                                  "Model Version No." = field("Model Version No."),
                                  "Parent Option Code" = field("Option Code");
                }
                action("<Action1101904025>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Where-Used List';
                    Image = List;
                    RunObject = Page "Manufacturer Option BOM Comp.";
                    RunPageLink = "Make Code" = field("Make Code"),
                                  "Model Code" = field("Model Code"),
                                  "Model Version No." = field("Model Version No."),
                                  "Option Code" = field("Option Code");
                }
            }
        }
    }

    var
        Item: Record Item;
        CopyOptions: Report "Copy Option";
        Text001: label 'Sales Price';


    procedure GetSelectionFilter(): Code[80]
    var
        recManOption: Record "Manufacturer Option";
        codFirstManOption: Code[30];
        codLastManOption: Code[30];
        SelectionFilter: Code[250];
        iManOptionCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(recManOption);
        iManOptionCount := recManOption.Count;
        if iManOptionCount > 0 then begin
            recManOption.FindSet;
            while iManOptionCount > 0 do begin
                iManOptionCount := iManOptionCount - 1;
                recManOption.MarkedOnly(false);
                codFirstManOption := recManOption."Option Code";
                codLastManOption := codFirstManOption;
                More := (iManOptionCount > 0);
                while More do
                    if recManOption.Next = 0 then
                        More := false
                    else
                        if not recManOption.Mark then
                            More := false
                        else begin
                            codLastManOption := recManOption."Option Code";
                            iManOptionCount := iManOptionCount - 1;
                            if iManOptionCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if codFirstManOption = codLastManOption then
                    SelectionFilter := SelectionFilter + codFirstManOption
                else
                    SelectionFilter := SelectionFilter + codFirstManOption + '..' + codLastManOption;
                if iManOptionCount > 0 then begin
                    recManOption.MarkedOnly(true);
                    recManOption.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;

    local procedure GetCaptionClassUnitPrice(): Text[80]
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPricesIncVar: Integer;
    begin
        SalesSetup.Get;
        if SalesSetup."Def. Sales Price Include VAT" then
            SalesPricesIncVar := 1
        else
            SalesPricesIncVar := 0;
        Clear(SalesSetup);
        exit('2,' + Format(SalesPricesIncVar) + ',' + Text001);
    end;
}

