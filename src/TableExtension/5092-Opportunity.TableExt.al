tableextension 25006130 "Opportunity" extends Opportunity //5092
{
    // 02.10.2019 EB.P7 B3030DMS-14
    //   Added field Type
    //   Added functions AssignServiceQuoteEDMS,AssignRentQuote
    //   Modified function CreateQuote
    // 
    // 11.11.2015 EB.P7 #T066
    //   Bugfix Oportunity Assign Quote
    // 
    // 19.03.2014 Elva Baltic P15 #F002 MMG7.00
    //   Functions: *Prompt*
    // 
    // //10-08-2007 EDMS P3
    //   * Mandatory fields control
    fields
    {
        modify("Sales Document No.")
        {
            TableRelation = if ("Sales Document Type" = const(Quote),
                                Type = const(Sales)) "Sales Header"."No." where("Document Type" = const(Quote),
                                                                                                "Sell-to Contact No." = field("Contact No."))
            else
            if ("Sales Document Type" = const(Order)) "Sales Header"."No." where("Document Type" = const(Order),
                                                                                                                                                                         "Sell-to Contact No." = field("Contact No."))
            else
            if ("Sales Document Type" = const("Posted Invoice")) "Sales Invoice Header"."No." where("Sell-to Contact No." = field("Contact No."))
            else
            if ("Sales Document Type" = const(Quote),
                                                                                                                                                         Type = const(Service)) "Service Header EDMS"."No." where("Document Type" = const(Quote),
                                                                                                                                                                                                                 "Sell-to Contact No." = field("Contact No."))
            else
            if ("Sales Document Type" = const(Order),
                                                                                                                                                                                                                          Type = const(Service)) "Service Header EDMS"."No." where("Document Type" = const(Order),
                                                                                                                                                                                                                                                                                  "Sell-to Contact No." = field("Contact No."))
            else
            if ("Sales Document Type" = const("Posted Invoice"),
                                                                                                                                                                                                                                                                                           Type = const(Service)) "Posted Serv. Order Header"."No." where("Sell-to Contact No." = field("Contact No."))
            else
            if ("Sales Document Type" = const(Quote),
                                                                                                                                                                                                                                                                                                    Type = const(Rent)) "Rent Header"."No." where("Document Type" = const(Quote),
                                                                                                                                                                                                                                                                                                                                                 "Sell-to Contact No." = field("Contact No."))
            else
            if ("Sales Document Type" = const(Order),
                                                                                                                                                                                                                                                                                                                                                          Type = const(Rent)) "Rent Header"."No." where("Document Type" = const(Order),
                                                                                                                                                                                                                                                                                                                                                                                                       "Sell-to Contact No." = field("Contact No."));
        }
        field(25006000; "Wizard Estimated Value"; Decimal)
        {
            Caption = 'Wizard Estimated Value';

            trigger OnValidate()
            begin
                //20.03.2013 EDMS >>
                if "Wizard Currency Code" <> '' then begin
                    UpdateCurrencyFactor;
                    Currency.Get("Wizard Currency Code");
                    "Wizard Estimated Value (LCY)" := ROUND("Wizard Estimated Value" / CurrencyFactor, Currency."Amount Rounding Precision")
                end else
                    "Wizard Estimated Value (LCY)" := "Wizard Estimated Value";
                //20.03.2013 EDMS <<
            end;
        }
        field(25006020; "Wizard Currency Code"; Code[10])
        {
            Caption = 'Wizard Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                UpdateCurrencyFactor;
                Validate("Wizard Estimated Value (LCY)");
            end;
        }
        field(25006021; Type; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Sales,Service,Rent';
            OptionMembers = Sales,Service,Rent;
        }
    }
    var
        Currency: Record Currency;
        SalesHeaderDef: Record "Sales Header";
        TextDlg001: label 'Default,Spare Parts Trade,Vehicles Trade,Service,Rent';
        CurrencyFactor: Decimal;
        Text50000: label 'You cannot assign a service quote to the %2 record of the %1 while the %2 record of the %1 has no contact company assigned.';
        Text50001: label 'A service quote has already been assigned to this opportunity.';
        Text50002: label 'You cannot assign a rent quote to the %2 record of the %1 while the %2 record of the %1 has no contact company assigned.';
        Text50003: label 'A rent quote has already been assigned to this opportunity.';
        Text50004: label '';

    local procedure UpdateCurrencyFactor()
    var
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyDate: Date;
    begin
        if "Wizard Currency Code" <> '' then begin
            CurrencyDate := WorkDate;
            CurrencyFactor := CurrExchRate.ExchangeRate(CurrencyDate, "Wizard Currency Code");
        end else
            CurrencyFactor := 0;
    end;

    procedure GetPromptProfile(): Boolean
    begin
        exit(SalesHeaderDef.GetPromptProfile);
    end;

    procedure SetPromptProfile(BoolValueToSet: Boolean)
    begin
        SalesHeaderDef.SetPromptProfile(BoolValueToSet);
    end;



    procedure ChooseProfile(): Integer
    var
        Selected: Integer;
    begin
        Selected := StrMenu(TextDlg001, 0);
        exit(Selected);
    end;

    procedure AssignServiceQuoteEDMS()
    var
        Cont: Record Contact;
        ServiceHeader: Record "Service Header EDMS";
    begin
        Cont.Get("Contact No.");

        if (Cont.Type = Cont.Type::Person) and (Cont."Company No." = '') then
            Error(
              Text50000,
              Cont.TableCaption, Cont."No.");

        TestField(Status, Status::"In Progress");

        if not ServiceHeader.Get(ServiceHeader."document type"::Quote, "Sales Document No.") then begin
            ServiceHeader.SetRange("Sell-to Contact No.", Cont."No.");
            ServiceHeader.Init;
            ServiceHeader."Document Type" := ServiceHeader."document type"::Quote;
            ServiceHeader.AssistEdit(ServiceHeader);                                   // EB.P30 D209MSM3-10
            ServiceHeader.Insert(true);
            ServiceHeader.Validate("Service Advisor", "Salesperson Code");
            ServiceHeader.Validate("Campaign No.", "Campaign No.");
            ServiceHeader."Opportunity No." := "No.";
            ServiceHeader."Order Date" := GetEstimatedClosingDate;
            ServiceHeader.Modify;
            Type := Type::Service;
            "Sales Document Type" := "sales document type"::Quote;
            "Sales Document No." := ServiceHeader."No.";
            Modify;
        end else
            Error(Text50001);
        Page.Run(Page::"Service Quote EDMS", ServiceHeader);
    end;

    procedure AssignRentQuote()
    var
        Cont: Record Contact;
        RentHeader: Record "Rent Header";
        ContBusinessRelation: Record "Contact Business Relation";
    begin
        Cont.Get("Contact No.");

        if (Cont.Type = Cont.Type::Person) and (Cont."Company No." = '') then
            Error(
              Text50002,
              Cont.TableCaption, Cont."No.");

        TestField(Status, Status::"In Progress");

        ContBusinessRelation.Reset;
        ContBusinessRelation.SetCurrentkey("Link to Table", "No.");
        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
        ContBusinessRelation.SetRange("Contact No.", Cont."Company No.");
        if not ContBusinessRelation.FindFirst then
            Error(
              Text50002,
              Cont.TableCaption, Cont."No.");

        if not RentHeader.Get(RentHeader."document type"::Quote, "Sales Document No.") then begin
            RentHeader.Init;
            RentHeader."Document Type" := RentHeader."document type"::Quote;
            RentHeader.Insert(true);
            RentHeader.Validate("Sell-to Customer No.", ContBusinessRelation."No.");
            RentHeader.Validate("Salesperson Code", "Salesperson Code");
            RentHeader."Opportunity No." := "No.";
            RentHeader."Order Date" := GetEstimatedClosingDate;
            RentHeader.Modify;
            Type := Type::Rent;
            "Sales Document Type" := "sales document type"::Quote;
            "Sales Document No." := RentHeader."No.";
            Modify;
        end else
            Error(Text50003);
        Page.Run(Page::"Rent Quote", RentHeader);
    end;

    local procedure GetEstimatedClosingDate(): Date
    var
        OppEntry: Record "Opportunity Entry";
    begin
        OppEntry.SetCurrentKey(Active, "Opportunity No.");
        OppEntry.SetRange(Active, true);
        OppEntry.SetRange("Opportunity No.", "No.");
        if OppEntry.FindFirst then
            exit(OppEntry."Estimated Close Date");
    end;

    procedure EDMSShowSalesQuoteWithCheck()
    var
        SalesHeader: Record "Sales Header";
        ServiceHeaderEDMS: Record "Service Header EDMS";
        RentHeader: Record "Rent Header";
    begin
        if ("Sales Document Type" <> "Sales Document Type"::Quote) or
           ("Sales Document No." = '')
        then
            Error(Text003);


        case Type of
            Type::Sales:
                if SalesHeader.Get(SalesHeader."document type"::Quote, "Sales Document No.") then
                    Page.Run(Page::"Sales Quote", SalesHeader)
                else
                    Error(Text002, "Sales Document No.");
            Type::Service:
                if ServiceHeaderEDMS.Get(ServiceHeaderEDMS."document type"::Quote, "Sales Document No.") then
                    Page.Run(Page::"Service Quote EDMS", ServiceHeaderEDMS)
                else
                    Error(Text002, "Sales Document No.");
            Type::Rent:
                if RentHeader.Get(RentHeader."document type"::Quote, "Sales Document No.") then
                    Page.Run(Page::"Rent Quote", RentHeader)
                else
                    Error(Text002, "Sales Document No.");
        end;

        //IF NOT SalesHeader.GET(SalesHeader."Document Type"::Quote,"Sales Document No.") THEN
        //  ERROR(Text004,"Sales Document No.");
        //PAGE.RUN(PAGE::"Sales Quote",SalesHeader);
    end;



    var
        Text002: Label 'Do you want to create an opportunity for all contacts in the %1 segment?';
        Text003: Label 'There is no sales quote that is assigned to this opportunity.';








}
