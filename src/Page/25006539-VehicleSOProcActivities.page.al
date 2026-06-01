page 25006539 "Vehicle SO Proc. Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Sales Cue";

    layout
    {
        area(content)
        {
            cuegroup("For Release")
            {
                Caption = 'For Release';
                CueGroupLayout = Wide;
                field(OpenSalesQuotesCnt; OpenSalesQuotesCnt)
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Quotes";
                    ToolTip = 'Specifies the number of sales quotes that are not yet converted to invoices or orders.';
                }
                field(OpenSalesOrdersCnt; OpenSalesOrdersCnt)
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales orders that are not fully posted.';
                }

                actions
                {
                    action("New Sales Quote")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Sales Quote';
                        RunObject = Page "Sales Quote";
                        RunPageMode = Create;
                        ToolTip = 'Offer items or services to a customer.';
                    }
                    action("New Sales Order")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Sales Order';
                        RunObject = Page "Sales Order";
                        RunPageMode = Create;
                        ToolTip = 'Create a new sales order for items or services that require partial posting.';
                    }
                }
            }
            cuegroup("Sales Orders Released Not Shipped")
            {
                Caption = 'Sales Orders Released Not Shipped';
                field(ReadyToShip; Rec."Ready to Ship")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ready To Ship';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales documents that are ready to ship.';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowOrders(Rec.FieldNo("Ready to Ship"));
                    end;
                }
                field(PartiallyShipped; Rec."Partially Shipped")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Partially Shipped';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales documents that are partially shipped.';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowOrders(Rec.FieldNo("Partially Shipped"));
                    end;
                }
                field(DelayedOrders; Rec.Delayed)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Delayed';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales documents where your delivery is delayed.';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowOrders(Rec.FieldNo(Delayed));
                    end;
                }
                field("Average Days Delayed"; Rec."Average Days Delayed")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 1;
                    Image = Calendar;
                    ToolTip = 'Specifies the number of days that your order deliveries are delayed on average.';
                }

                actions
                {
                    action(Navigate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Navigate';
                        RunObject = Page Navigate;
                        ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                    }
                }
            }
            cuegroup(Returns)
            {
                Caption = 'Returns';
                field(OpenReturnOrdersCnt; OpenReturnOrdersCnt)
                {
                    ApplicationArea = SalesReturnOrder;
                    DrillDownPageID = "Sales Return Order List";
                    ToolTip = 'Specifies the number of sales return orders documents that are displayed in the Sales Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field(OpenCreditMemosCnt; OpenCreditMemosCnt)
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Credit Memos";
                    ToolTip = 'Specifies the number of sales credit memos that are not yet posted.';
                }

                actions
                {
                    action("New Sales Return Order")
                    {
                        ApplicationArea = SalesReturnOrder;
                        Caption = 'New Sales Return Order';
                        RunObject = Page "Sales Return Order";
                        RunPageMode = Create;
                        ToolTip = 'Process a return or refund that requires inventory handling by creating a new sales return order.';
                    }
                    action("New Sales Credit Memo")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Sales Credit Memo';
                        RunObject = Page "Sales Credit Memo";
                        RunPageMode = Create;
                        ToolTip = 'Process a return or refund by creating a new sales credit memo.';
                    }
                }
            }
            cuegroup("Document Exchange Service")
            {
                Caption = 'Document Exchange Service';
                Visible = ShowDocumentsPendingDodExchService;
                field("Sales Inv. - Pending Doc.Exch."; Rec."Sales Inv. - Pending Doc.Exch.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies sales invoices that await sending to the customer through the document exchange service.';
                    Visible = ShowDocumentsPendingDodExchService;
                }
                field("Sales CrM. - Pending Doc.Exch."; Rec."Sales CrM. - Pending Doc.Exch.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies sales credit memos that await sending to the customer through the document exchange service.';
                    Visible = ShowDocumentsPendingDodExchService;
                }
            }
            cuegroup("My User Tasks")
            {
                Caption = 'My User Tasks';
                field("UserTaskManagement.GetMyPendingUserTasksCount"; UserTaskManagement.GetMyPendingUserTasksCount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pending User Tasks';
                    Image = Checklist;
                    ToolTip = 'Specifies the number of pending tasks that are assigned to you or to a group that you are a member of.';

                    trigger OnDrillDown()
                    var
                        UserTaskList: Page "User Task List";
                    begin
                        UserTaskList.SetPageToShowMyPendingUserTasks;
                        UserTaskList.Run;
                    end;
                }
            }
            usercontrol(SATAsyncLoader; SatisfactionSurveyAsync)
            {
                ApplicationArea = Basic, Suite;
                trigger ResponseReceived(Status: Integer; Response: Text)
                var
                    SatisfactionSurveyMgt: Codeunit "Satisfaction Survey Mgt.";
                begin
                    //SatisfactionSurveyMgt.TryShowSurvey(Status, Response);//FIXME
                end;

                /*   trigger ControlAddInReady();
                  begin
                      IsAddInReady := true;
                      CheckIfSurveyEnabled();
                  end; */
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CuesAndKpis.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
    begin
        //RoleCenterNotificationMgt.HideEvaluationNotificationAfterStartingTrial;
    end;

    trigger OnAfterGetRecord()
    var
        DocExchServiceSetup: Record "Doc. Exch. Service Setup";
    begin
        CalculateCueFieldValues;
        ShowDocumentsPendingDodExchService := false;
        if DocExchServiceSetup.Get then
            ShowDocumentsPendingDodExchService := DocExchServiceSetup.Enabled;
    end;

    trigger OnOpenPage()
    var
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Rec.SetRespCenterFilter;
        Rec.SetRange("Date Filter", 0D, WorkDate - 1);
        Rec.SetFilter("Date Filter2", '>=%1', WorkDate);
        Rec.SetFilter("User ID Filter", UserId);

        RoleCenterNotificationMgt.ShowNotifications;
        ConfPersonalizationMgt.RaiseOnOpenRoleCenterEvent;

        /*if PageNotifier.IsAvailable then begin
            PageNotifier := PageNotifier.Create;
            PageNotifier.NotifyPageReady;
        end;*///FIXME
    end;

    var
        CuesAndKpis: Codeunit "Cues And KPIs";
        UserTaskManagement: Codeunit "User Task Management";
        // [RunOnClient]
        // [WithEvents]
        // PageNotifier: DotNet PageNotifier;//FIXME
        ShowDocumentsPendingDodExchService: Boolean;
        IsAddInReady: Boolean;
        IsPageReady: Boolean;
        OpenSalesOrdersCnt: Integer;
        OpenSalesQuotesCnt: Integer;
        OpenReturnOrdersCnt: Integer;
        OpenCreditMemosCnt: Integer;


    local procedure CalculateCueFieldValues()
    var
        SalesHeader: Record "Sales Header";
        DocProfMgt: Codeunit "Document Profile Mgt. EDMS";
        DocProfFilter: Text;

    begin
        if Rec.FieldActive("Average Days Delayed") then
            Rec."Average Days Delayed" := Rec.CalculateAverageDaysDelayed;

        if Rec.FieldActive("Ready to Ship") then
            Rec."Ready to Ship" := Rec.CountOrdersEDMS(Rec.FieldNo("Ready to Ship"));

        if Rec.FieldActive("Partially Shipped") then
            Rec."Partially Shipped" := Rec.CountOrdersEDMS(Rec.FieldNo("Partially Shipped"));

        if Rec.FieldActive(Delayed) then
            Rec.Delayed := Rec.CountOrdersEDMS(Rec.FieldNo(Delayed));

        DocProfFilter := DocProfMgt.GetDocProfileFilter();
        SalesHeader.Reset();
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        SalesHeader.SetFilter("Document Profile", DocProfFilter);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        OpenSalesOrdersCnt := SalesHeader.Count;
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        OpenSalesQuotesCnt := SalesHeader.Count;
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Return Order");
        OpenReturnOrdersCnt := SalesHeader.Count;
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        OpenCreditMemosCnt := SalesHeader.Count;
    end;

    /*trigger PageNotifier::PageReady()
    begin
        IsPageReady := true;
        CheckIfSurveyEnabled();
    end;*///FIXME

    local procedure CheckIfSurveyEnabled()
    var
        SatisfactionSurveyMgt: Codeunit "Satisfaction Survey Mgt.";
        CheckUrl: Text;
    begin
        if not IsAddInReady then
            exit;
        if not IsPageReady then
            exit;
        /*if not SatisfactionSurveyMgt.DeactivateSurvey() then
            exit;
        if not SatisfactionSurveyMgt.TryGetCheckUrl(CheckUrl) then
            exit;
        CurrPage.SATAsyncLoader.SendRequest(CheckUrl, SatisfactionSurveyMgt.GetRequestTimeoutAsync());*///FIXME
    end;
}

