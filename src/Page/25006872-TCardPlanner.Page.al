Page 25006872 "TCard Planner"
{
    DataCaptionExpression = PageCaptionText;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'Test1,Test2,Test3,Planner';
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(Control25006001)
            {
                usercontrol(TCard; TCardAddIn)
                {
                    ApplicationArea = Basic;

                    trigger ControlAddInReady()
                    var
                        AddInData: Text;
                    begin
                        TCardMgt.SetLocationCode(LocationCode);
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveInitTCardData(AddInData);
                    end;

                    trigger RequestPositionChange(ContainerEntryNo: Integer; PosX: Integer; PosY: Integer)
                    var
                        TCardContainer: Record "TCard Container";
                    begin
                        if TCardContainer.Get(ContainerEntryNo) then begin
                            TCardContainer.PositionX := PosX;
                            TCardContainer.PositionY := PosY;
                            TCardContainer.Modify;
                        end;
                    end;

                    trigger RequestSizeChange(ContainerEntryNo: Integer; Size: Integer)
                    var
                        TCardContainer: Record "TCard Container";
                    begin
                        if TCardContainer.Get(ContainerEntryNo) then begin
                            TCardContainer."Configured Size" := Size;
                            TCardContainer."Container Size" := TCardContainer."container size"::Custom;
                            TCardContainer.Modify;
                        end;
                    end;

                    trigger RequestItemToContainerChange(ContainerEntryNo: Integer; ItemEntryNo: Code[20]; ItemEntryType: Option; ItemSortIndex: Integer)
                    var
                        TCardMgt: Codeunit "TCard Management";
                        AddInData: Text;
                    begin
                        TCardMgt.ItemToContainerChange(ContainerEntryNo, ItemEntryNo, ItemEntryType, ItemSortIndex);
                        TCardMgt.SetLocationCode(LocationCode);
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
                    end;

                    trigger RequestRefreshData()
                    var
                        AddInData: Text;
                    begin
                        TCardMgt.SetLocationCode(LocationCode);
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
                    end;

                    trigger OpenItemEditCard(ItemEntryNo: Code[20]; ItemEntryType: Option Quote,"Order","Return Order",Booking)
                    var
                        AddInData: Text;
                        ServiceDocument: Record "Service Header EDMS";
                        ServiceBookingCard: Page "Service Booking";
                        ServiceOrderCard: Page "Service Order EDMS";
                    begin
                        case ItemEntryType of
                            Itementrytype::Booking:
                                begin
                                    if ServiceDocument.Get(ItemEntryType, ItemEntryNo) then begin
                                        ServiceBookingCard.SetRecord(ServiceDocument);
                                        ServiceBookingCard.RunModal;
                                    end;
                                end;
                            Itementrytype::Order:
                                begin
                                    if ServiceDocument.Get(ItemEntryType, ItemEntryNo) then begin
                                        ServiceOrderCard.SetRecord(ServiceDocument);
                                        ServiceOrderCard.RunModal;
                                    end;
                                end;
                        end;

                        TCardMgt.SetLocationCode(LocationCode);
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
                    end;

                    trigger RequestContainerSettings(ContainerEntryNo: Integer)
                    var
                        TCardContainer: Record "TCard Container";
                        ContainerCard: Page "TCard Container Card";
                        AddInData: Text;
                    begin
                        if TCardContainer.Get(ContainerEntryNo) then begin
                            ContainerCard.SetRecord(TCardContainer);
                            ContainerCard.RunModal;
                        end;

                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveInitTCardData(AddInData);
                    end;

                    trigger RequestContainerDelete(ContainerEntryNo: Integer)
                    var
                        TCardContainer: Record "TCard Container";
                        AddInData: Text;
                    begin
                        if Dialog.Confirm(AreYouSureTxt, false) then begin
                            if TCardContainer.Get(ContainerEntryNo) then begin
                                TCardContainer.Delete;
                            end;
                        end;

                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveInitTCardData(AddInData);
                    end;

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Planner)
            {
                Caption = 'Planner';
                action("Operation Mode")
                {
                    ApplicationArea = Basic;
                    Image = Log;

                    trigger OnAction()
                    var
                        AddInData: Text;
                    begin
                        TCardMgt.SetEditMode(false);
                        EditMode := false;
                        SetPageCaption;
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveInitTCardData(AddInData);
                    end;
                }
                action("Configuration Mode")
                {
                    ApplicationArea = Basic;
                    Image = LogSetup;

                    trigger OnAction()
                    var
                        AddInData: Text;
                    begin
                        TCardMgt.SetEditMode(true);
                        EditMode := true;
                        SetPageCaption;
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveInitTCardData(AddInData);
                    end;
                }
                action(Refresh)
                {
                    ApplicationArea = Basic;
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        AddInData: Text;
                    begin
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
                    end;
                }
                action("Switch Location")
                {
                    ApplicationArea = Basic;
                    Image = SwitchCompanies;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SelectedLocation: Record Location;
                        AddInData: Text;
                    begin
                        SelectedLocation.SetRange("Use As Service Location", true);
                        if LocationCode <> '' then
                            SelectedLocation.Get(LocationCode);

                        if Page.RunModal(Page::"Location List", SelectedLocation) = Action::LookupOK then
                            LocationCode := SelectedLocation.Code;

                        SetPageCaption;

                        TCardMgt.SetLocationCode(LocationCode);
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveInitTCardData(AddInData);
                    end;
                }
                action("Create New Container")
                {
                    ApplicationArea = Basic;
                    Image = NewItem;

                    trigger OnAction()
                    var
                        AddInData: Text;
                    begin
                        if not EditMode then
                            Error(GoToEditModeTxt);

                        TCardMgt.CreateNewContainer;
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
                    end;
                }
                action("Reindex Sorting")
                {
                    ApplicationArea = Basic;
                    Image = Refresh;

                    trigger OnAction()
                    var
                        AddInData: Text;
                        Container: Record "TCard Container";
                    begin
                        Container.Reset();
                        Container.SetRange(Enabled, True);
                        if Container.FindFirst() then
                            repeat
                                TCardMgt.ReindexContainerSortIndex(Container."No.");
                            until Container.Next() = 0;
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
                    end;
                }
                action("Reset Sorting")
                {
                    ApplicationArea = Basic;
                    Image = Refresh;

                    trigger OnAction()
                    var
                        AddInData: Text;
                        Container: Record "TCard Container";
                    begin
                        Container.Reset();
                        Container.SetRange(Enabled, True);
                        if Container.FindFirst() then
                            repeat
                                TCardMgt.ResetContainerSortIndex(Container."No.");
                            until Container.Next() = 0;
                        TCardMgt.FillAddInData(AddInData);
                        CurrPage.TCard.RecieveRefreshTCardData(AddInData);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        AddInData: Text;
    begin
        //ServiceNavigationMgt.FillAddInData(AddInData);
        //CurrPage.Navigation.RecieveInitNavigationData(AddInData);
    end;

    trigger OnInit()
    begin
        LocationCode := TCardMgt.GetDefaultLocationCode;
        SetPageCaption;
    end;

    var
        TCardMgt: Codeunit "TCard Management";
        CurrentResourceNo: Code[20];
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        LocationCode: Code[20];
        PageCaptionText: Text[255];
        TCardPageLbl: label 'TCard Planner';
        PageCaptionSep: Text[3];
        EditModeLbl: label 'EDIT';
        EditMode: Boolean;
        GoToEditModeTxt: label 'Please switch to configuration mode first.';
        AreYouSureTxt: label 'Are You sure, You want to delete container box?';



    local procedure SetPageCaption()
    var
        EditModeCaption: Text[20];
        Location: Record Location;
    begin
        if LocationCode <> '' then
            PageCaptionSep := ' - '
        else
            PageCaptionSep := '';

        if EditMode then
            EditModeCaption := ' - ' + EditModeLbl
        else
            EditModeCaption := '';

        if Location.Get(LocationCode) then
            PageCaptionText := TCardPageLbl + PageCaptionSep + Location.Name + EditModeCaption
        else
            PageCaptionText := TCardPageLbl + PageCaptionSep + LocationCode + EditModeCaption;
    end;
}

