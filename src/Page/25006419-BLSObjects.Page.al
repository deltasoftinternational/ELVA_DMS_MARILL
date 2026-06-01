Page 25006419 "BLS Objects"
{
    ApplicationArea = Basic;
    Caption = 'Objects';
    PageType = List;
    SaveValues = true;
    SourceTable = "BLS Object";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(ObjectType; Rec."Object Type")
                {
                    ApplicationArea = Basic;
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        BLSObject: Record "BLS Object";
                        BLSObjectList: Page "BLS Object List";
                    begin
                        BLSObject := Rec;
                        BLSObjectList.SetTableview(BLSObject);
                        BLSObjectList.LookupMode := true;
                        if BLSObjectList.RunModal = Action::LookupOK then begin
                            BLSObjectList.GetRecord(BLSObject);
                            Text := BLSObject.Code;
                            exit(true);
                        end;
                        exit(false);
                    end;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                }
                field(Address2; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = Basic;
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(IndentObjects)
                {
                    ApplicationArea = Basic;
                    Caption = 'Indent Objects';
                    Image = Indent;
                    RunObject = Codeunit "BLS Object-Indent";
                    RunPageOnRec = true;
                }
            }
        }
        area(navigation)
        {
            group("Object")
            {
                Caption = '&Object';
                Image = Resource;
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action(DimensionsSingle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = const(25006214),
                                      "No." = field(Code);
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action(DimensionsMultiple)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;

                        trigger OnAction()
                        var
                            BLSObject: Record "BLS Object";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(BLSObject);
                            DefaultDimMultiple.SetMultiBLSObject(BLSObject);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = Contract;
                action(Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = JobPrice;
                    Promoted = true;
                    RunObject = Page "BLS Service Prices";
                    RunPageLink = "Object Code" = field(Code);
                }
                action(Discounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Discounts';
                    Image = Discount;
                    Promoted = true;
                    RunObject = Page "BLS Service Discounts";
                    RunPageLink = "Object Code" = field(Code);
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("<Page BLS Ledger Entries>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger Entries';
                    Image = ServiceLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "BLS Ledger Entries";
                    RunPageLink = "Object Code" = field(Code),
                                  "Object Code" = field(filter(Totaling));
                }
                action(CalculationLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculation Ledger Entries';
                    Image = CalculateLines;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "BLS Calculation Ledger Entries";
                    RunPageLink = "Object Code" = field(Code),
                                  "Object Code" = field(filter(Totaling));
                }
                action(InvoicingLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoicing Ledger Entries';
                    Image = CustomerLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "BLS Invoicing Ledger Entries";
                    RunPageLink = "Object Code" = field(Code),
                                  "Object Code" = field(filter(Totaling));
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        FormatLine;
    end;

    var
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    local procedure FormatLine()
    begin
        Emphasize := Rec."Object Type" <> Rec."object type"::Standard;
        NameIndent := Rec.Indentation;
    end;
}

