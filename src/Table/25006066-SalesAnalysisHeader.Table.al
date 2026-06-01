Table 25006066 "Sales Analysis Header"
{

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Service Quote,Service Order';
            OptionMembers = Quote,"Order","Service Quote","Service Order";
        }
        field(30; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(40; "Total Cost"; Decimal)
        {
            CalcFormula = sum("Sales Analysis Line"."Total Cost" where("Document No." = field("No."),
                                                                        "Document Type" = field("Document Type")));
            Caption = 'Total Cost';
            FieldClass = FlowField;
        }
        field(50; "Margin Retail %"; Decimal)
        {
            Caption = 'Margin Retail %';
        }
        field(80; "Total Retail Price"; Decimal)
        {
            CalcFormula = sum("Sales Analysis Line"."Retail Total Price" where("Document No." = field("No."),
                                                                                "Document Type" = field("Document Type")));
            Caption = 'Total Retail Price';
            FieldClass = FlowField;
        }
        field(90; "Total Offer Price"; Decimal)
        {
            CalcFormula = sum("Sales Analysis Line"."Total Offer Price" where("Document No." = field("No."),
                                                                               "Document Type" = field("Document Type")));
            Caption = 'Total Offer Price';
            FieldClass = FlowField;
        }
        field(100; "Margin %"; Decimal)
        {
            Caption = 'Margin %';

            trigger OnValidate()
            begin
                SalesAnalysisLine.Reset;
                SalesAnalysisLine.SetRange("Document No.", "No.");
                SalesAnalysisLine.SetRange("Document Type", "Document Type");
                if SalesAnalysisLine.FindFirst then
                    repeat
                        SalesAnalysisLine.SetParams(true);
                        SalesAnalysisLine.Validate("Margin %", "Margin %");
                        SalesAnalysisLine.CalcPricesAndMargins(170);
                        SalesAnalysisLine.Modify;
                    until SalesAnalysisLine.Next = 0;
            end;
        }
        field(110; "Currency Factor"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "No.", "Document Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        SalesAnalysisLine.Reset;
        SalesAnalysisLine.SetRange("Document No.", "No.");
        SalesAnalysisLine.SetRange("Document Type", "Document Type");
        SalesAnalysisLine.DeleteAll;
    end;

    var
        SalesLine: Record "Sales Line";
        SalesAnalysisHeader: Record "Sales Analysis Header";
        SalesAnalysisLine: Record "Sales Analysis Line";
        ServiceLineEDMS: Record "Service Line EDMS";


    procedure FillFromSalesDocument(SalesHeader: Record "Sales Header")
    begin
        SalesAnalysisLine.Reset;
        SalesAnalysisLine.SetRange("Document No.", SalesHeader."No.");
        SalesAnalysisLine.SetRange("Document Type", SalesHeader."document type"::Quote);
        SalesAnalysisLine.DeleteAll;

        case SalesHeader."Document Type" of
            SalesHeader."document type"::Quote:
                begin
                    if not SalesAnalysisHeader.Get(SalesHeader."No.", SalesAnalysisHeader."document type"::Quote) then begin
                        Init;
                        "Document Type" := "document type"::Quote;
                        "No." := SalesHeader."No.";
                        "Currency Code" := SalesHeader."Currency Code";
                        Insert;
                    end;
                end;
        end;

        SalesLine.Reset;
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        if SalesLine.FindFirst then
            repeat
                SalesAnalysisLine.Init;
                SalesAnalysisLine."Document No." := "No.";
                SalesAnalysisLine."Document Type" := "Document Type";
                SalesAnalysisLine."Line No." := SalesLine."Line No.";
                case SalesLine.Type of
                    SalesLine.Type::Item:
                        SalesAnalysisLine.Type := SalesAnalysisLine.Type::Item;
                    SalesLine.Type::"External Service":
                        SalesAnalysisLine.Type := SalesAnalysisLine.Type::"External Service";
                    SalesLine.Type::"G/L Account":
                        SalesAnalysisLine.Type := SalesAnalysisLine.Type::"G/L Account";
                    SalesLine.Type::Resource:
                        SalesAnalysisLine.Type := SalesAnalysisLine.Type::Resource;
                end;
                SalesAnalysisLine."Currency Code" := SalesLine."Currency Code";
                SalesAnalysisLine."Currency Factor" := SalesHeader."Currency Factor";
                SalesAnalysisLine.Validate("No.", SalesLine."No.");
                SalesAnalysisLine.Description := SalesLine.Description;
                SalesAnalysisLine.Quantity := SalesLine.Quantity;
                SalesAnalysisLine."Line Discount %" := SalesLine."Line Discount %";
                if SalesLine.Quantity <> 0 then begin
                    SalesAnalysisLine."Retail Price" := SalesLine."Unit Price";
                    SalesAnalysisLine.Validate("Retail Unit Price", SalesLine."Unit Price" * (100 - SalesLine."Line Discount %") / 100);
                end;
                SalesAnalysisLine.Insert;
            until SalesLine.Next = 0;

        CalcFields("Total Cost", "Total Retail Price");
        if "Total Retail Price" <> 0 then
            "Margin Retail %" := ROUND(("Total Retail Price" - "Total Cost") / "Total Retail Price", 0.0001) * 100;

        "Margin %" := "Margin Retail %";
        Modify;
    end;


    procedure FillFromServiceDocument(ServiceHeaderEDMS: Record "Service Header EDMS")
    begin
        SalesAnalysisLine.Reset;
        SalesAnalysisLine.SetRange("Document No.", "No.");
        SalesAnalysisLine.SetRange("Document Type", SalesAnalysisLine."document type"::"Service Quote");
        SalesAnalysisLine.DeleteAll;

        case ServiceHeaderEDMS."Document Type" of
            ServiceHeaderEDMS."document type"::Quote:
                begin
                    if not SalesAnalysisHeader.Get(ServiceHeaderEDMS."No.", SalesAnalysisHeader."document type"::"Service Quote") then begin
                        Init;
                        "No." := ServiceHeaderEDMS."No.";
                        "Document Type" := "document type"::"Service Quote";
                        "Currency Code" := ServiceHeaderEDMS."Currency Code";
                        Insert;
                    end;
                end;
        end;

        ServiceLineEDMS.Reset;
        ServiceLineEDMS.SetRange("Document No.", ServiceHeaderEDMS."No.");
        ServiceLineEDMS.SetRange("Document Type", ServiceHeaderEDMS."Document Type");
        ServiceLineEDMS.SetFilter(Type, '<>%1', ServiceLineEDMS.Type::Comment);
        if ServiceLineEDMS.FindFirst then
            repeat
                SalesAnalysisLine.Init;
                SalesAnalysisLine."Document No." := "No.";
                SalesAnalysisLine."Document Type" := "Document Type";
                SalesAnalysisLine."Line No." := ServiceLineEDMS."Line No.";
                case ServiceLineEDMS.Type of
                    ServiceLineEDMS.Type::Item:
                        SalesAnalysisLine.Type := SalesAnalysisLine.Type::Item;
                    ServiceLineEDMS.Type::"External Service":
                        SalesAnalysisLine.Type := SalesAnalysisLine.Type::"External Service";
                    ServiceLineEDMS.Type::Labor:
                        SalesAnalysisLine.Type := SalesAnalysisLine.Type::Labor;
                end;
                SalesAnalysisLine."Currency Code" := ServiceLineEDMS."Currency Code";
                SalesAnalysisLine."Currency Factor" := ServiceHeaderEDMS."Currency Factor";
                SalesAnalysisLine.Validate("No.", ServiceLineEDMS."No.");
                SalesAnalysisLine.Description := ServiceLineEDMS.Description;
                SalesAnalysisLine.Quantity := ServiceLineEDMS.Quantity;
                SalesAnalysisLine."Line Discount %" := ServiceLineEDMS."Line Discount Amount";
                if ServiceLineEDMS.Quantity <> 0 then begin
                    SalesAnalysisLine."Retail Price" := ServiceLineEDMS."Unit Price";
                    SalesAnalysisLine.Validate("Retail Unit Price", ServiceLineEDMS."Unit Price" * (100 - ServiceLineEDMS."Line Discount %") / 100);
                end;
                SalesAnalysisLine.Insert;
            until ServiceLineEDMS.Next = 0;

        CalcFields("Total Cost", "Total Retail Price");
        if "Total Retail Price" <> 0 then
            "Margin Retail %" := ROUND(("Total Retail Price" - "Total Cost") / "Total Retail Price", 0.0001) * 100;

        "Margin %" := "Margin Retail %";
        Modify;
    end;


    procedure UpdateSourceDocument()
    begin
        case "Document Type" of
            "document type"::Quote:
                begin
                    SalesAnalysisLine.Reset;
                    SalesAnalysisLine.SetRange("Document No.", "No.");
                    SalesAnalysisLine.SetRange("Document Type", "Document Type");
                    if SalesAnalysisLine.FindFirst then
                        repeat
                            if SalesLine.Get(SalesLine."document type"::Quote, "No.", SalesAnalysisLine."Line No.") then begin
                                if (SalesLine."Unit Price" > SalesAnalysisLine."Offer Unit Price") and (SalesLine."Unit Price" > 0) then
                                    SalesLine.Validate("Line Discount %", SalesAnalysisLine."Offer Line Discount %")
                                else
                                    if SalesLine."Unit Price" < SalesAnalysisLine."Offer Unit Price" then
                                        SalesLine.Validate(SalesLine."Unit Price", SalesAnalysisLine."Offer Unit Price");
                                SalesLine.Modify;
                            end;
                        until SalesAnalysisLine.Next = 0;
                end;
            "document type"::"Service Quote":
                begin
                    SalesAnalysisLine.Reset;
                    SalesAnalysisLine.SetRange("Document No.", "No.");
                    SalesAnalysisLine.SetRange("Document Type", "Document Type");
                    if SalesAnalysisLine.FindFirst then
                        repeat
                            if ServiceLineEDMS.Get(ServiceLineEDMS."document type"::Quote, "No.", SalesAnalysisLine."Line No.") then begin
                                if (ServiceLineEDMS."Unit Price" > SalesAnalysisLine."Offer Unit Price") and (ServiceLineEDMS."Unit Price" > 0) then
                                    ServiceLineEDMS.Validate("Line Discount %", SalesAnalysisLine."Offer Line Discount %")
                                else
                                    if ServiceLineEDMS."Unit Price" < SalesAnalysisLine."Offer Unit Price" then
                                        ServiceLineEDMS.Validate(ServiceLineEDMS."Unit Price", SalesAnalysisLine."Offer Unit Price");
                                ServiceLineEDMS.Modify;
                            end;
                        until SalesAnalysisLine.Next = 0;
                end;
        end;
    end;


    procedure GetTotalRevenue(): Decimal
    begin
        exit("Total Offer Price" - "Total Cost");
    end;


    procedure GetTotalPriceDiff(): Decimal
    begin
        if "Total Retail Price" <> 0 then
            exit((1 - "Total Offer Price" / "Total Retail Price") * 100)
        else
            exit(0);
    end;


    procedure UpdateAnalysis()
    begin
        case "Document Type" of
            "document type"::Quote, "document type"::Order:
                UpdateFromSalesDocument;
            "document type"::"Service Quote", "document type"::"Service Order":
                UpdateFromServiceDocument;
        end;
    end;

    local procedure UpdateFromSalesDocument()
    var
        DocTypeSales: Integer;
        SalesAnalysisLineToDelete: Record "Sales Analysis Line";
        SalesHeader: Record "Sales Header";
    begin
        case "Document Type" of
            "document type"::Quote:
                DocTypeSales := SalesLine."document type"::Quote;
            "document type"::Order:
                DocTypeSales := SalesLine."document type"::Order;
        end;
        SalesHeader.Get(DocTypeSales, "No.");
        SalesAnalysisLine.Reset;
        SalesAnalysisLine.SetRange("Document Type", "Document Type");
        SalesAnalysisLine.SetRange("Document No.", "No.");
        if SalesAnalysisLine.FindFirst then
            repeat
                SalesLine.Reset;
                SalesLine.SetRange("Document Type", DocTypeSales);
                SalesLine.SetRange("Document No.", SalesAnalysisLine."Document No.");
                SalesLine.SetRange("Line No.", SalesAnalysisLine."Line No.");
                SalesLine.SetRange(Type, SalesAnalysisLine.Type);
                SalesLine.SetRange("No.", SalesAnalysisLine."No.");
                if not SalesLine.FindFirst then begin
                    SalesAnalysisLineToDelete.Get("No.", "Document Type", SalesAnalysisLine."Line No.");
                    SalesAnalysisLineToDelete.Delete;
                end else begin
                    if SalesAnalysisLine.Quantity <> SalesLine.Quantity then begin
                        SalesAnalysisLine.Quantity := SalesLine.Quantity;
                        SalesAnalysisLine.CalcLine(true);
                        SalesAnalysisLine."Total Offer Price" := SalesAnalysisLine.Quantity * SalesAnalysisLine."Offer Unit Price";
                        SalesAnalysisLine."Margin Amount" := SalesAnalysisLine."Offer Unit Price" - SalesAnalysisLine."Total Unit Cost";
                        SalesAnalysisLine.Modify;
                    end;
                end;
            until SalesAnalysisLine.Next = 0;

        SalesLine.Reset;
        SalesLine.SetRange("Document Type", DocTypeSales);
        SalesLine.SetRange("Document No.", SalesAnalysisLine."Document No.");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        if SalesLine.FindFirst then
            repeat
                if not SalesAnalysisLine.Get("No.", "Document Type", SalesLine."Line No.") then begin
                    SalesAnalysisLine.Init;
                    SalesAnalysisLine."Document No." := "No.";
                    SalesAnalysisLine."Document Type" := "Document Type";
                    SalesAnalysisLine."Line No." := SalesLine."Line No.";
                    case SalesLine.Type of
                        SalesLine.Type::Item:
                            SalesAnalysisLine.Type := SalesAnalysisLine.Type::Item;
                        SalesLine.Type::"External Service":
                            SalesAnalysisLine.Type := SalesAnalysisLine.Type::"External Service";
                        SalesLine.Type::"G/L Account":
                            SalesAnalysisLine.Type := SalesAnalysisLine.Type::"G/L Account";
                        SalesLine.Type::Resource:
                            SalesAnalysisLine.Type := SalesAnalysisLine.Type::Resource;
                    end;
                    SalesAnalysisLine."Currency Code" := SalesLine."Currency Code";
                    SalesAnalysisLine."Currency Factor" := SalesHeader."Currency Factor";
                    SalesAnalysisLine.Validate("No.", SalesLine."No.");
                    SalesAnalysisLine.Description := SalesLine.Description;
                    SalesAnalysisLine.Quantity := SalesLine.Quantity;
                    SalesAnalysisLine."Line Discount %" := SalesLine."Line Discount %";
                    if SalesLine.Quantity <> 0 then begin
                        SalesAnalysisLine."Retail Price" := SalesLine."Unit Price";
                        SalesAnalysisLine.Validate("Retail Unit Price", SalesLine."Unit Price" * (100 - SalesLine."Line Discount %") / 100);
                    end;
                    SalesAnalysisLine.Insert;
                end;
            until SalesLine.Next = 0;
        SalesAnalysisLine.CalcHeaderMarginPr;
    end;

    local procedure UpdateFromServiceDocument()
    var
        DocTypeService: Integer;
        SalesAnalysisLineToDelete: Record "Sales Analysis Line";
        ServiceHeaderEDMS: Record "Service Header EDMS";
    begin
        case "Document Type" of
            "document type"::"Service Quote":
                DocTypeService := ServiceLineEDMS."document type"::Quote;
            "document type"::"Service Order":
                DocTypeService := ServiceLineEDMS."document type"::Order;
        end;
        ServiceHeaderEDMS.Get(DocTypeService, "No.");

        SalesAnalysisLine.Reset;
        SalesAnalysisLine.SetRange("Document Type", "Document Type");
        SalesAnalysisLine.SetRange("Document No.", "No.");
        if SalesAnalysisLine.FindFirst then
            repeat
                ServiceLineEDMS.Reset;
                ServiceLineEDMS.SetRange("Document Type", DocTypeService);
                ServiceLineEDMS.SetRange("Document No.", SalesAnalysisLine."Document No.");
                ServiceLineEDMS.SetRange("Line No.", SalesAnalysisLine."Line No.");
                ServiceLineEDMS.SetRange(Type, SalesAnalysisLine.Type);
                ServiceLineEDMS.SetRange("No.", SalesAnalysisLine."No.");
                if not ServiceLineEDMS.FindFirst then begin
                    SalesAnalysisLineToDelete.Get("No.", "Document Type", SalesAnalysisLine."Line No.");
                    SalesAnalysisLineToDelete.Delete;
                end else begin
                    if SalesAnalysisLine.Quantity <> ServiceLineEDMS.Quantity then begin
                        SalesAnalysisLine.Quantity := ServiceLineEDMS.Quantity;
                        SalesAnalysisLine.CalcLine(true);
                        SalesAnalysisLine."Total Offer Price" := SalesAnalysisLine.Quantity * SalesAnalysisLine."Offer Unit Price";
                        SalesAnalysisLine."Margin Amount" := SalesAnalysisLine."Offer Unit Price" - SalesAnalysisLine."Total Unit Cost";
                        SalesAnalysisLine.Modify;
                    end;
                end;
            until SalesAnalysisLine.Next = 0;

        ServiceLineEDMS.Reset;
        ServiceLineEDMS.SetRange("Document Type", DocTypeService);
        ServiceLineEDMS.SetRange("Document No.", SalesAnalysisLine."Document No.");
        ServiceLineEDMS.SetFilter(Type, '<>%1', ServiceLineEDMS.Type::Comment);
        if ServiceLineEDMS.FindFirst then
            repeat
                if not SalesAnalysisLine.Get("No.", "Document Type", ServiceLineEDMS."Line No.") then begin
                    SalesAnalysisLine.Init;
                    SalesAnalysisLine."Document No." := "No.";
                    SalesAnalysisLine."Document Type" := "Document Type";
                    SalesAnalysisLine."Line No." := ServiceLineEDMS."Line No.";
                    case ServiceLineEDMS.Type of
                        ServiceLineEDMS.Type::Item:
                            SalesAnalysisLine.Type := SalesAnalysisLine.Type::Item;
                        ServiceLineEDMS.Type::"External Service":
                            SalesAnalysisLine.Type := SalesAnalysisLine.Type::"External Service";
                        ServiceLineEDMS.Type::Labor:
                            SalesAnalysisLine.Type := SalesAnalysisLine.Type::Labor;
                    end;
                    SalesAnalysisLine."Currency Code" := ServiceLineEDMS."Currency Code";
                    SalesAnalysisLine."Currency Factor" := ServiceHeaderEDMS."Currency Factor";
                    SalesAnalysisLine.Validate("No.", ServiceLineEDMS."No.");
                    SalesAnalysisLine.Description := ServiceLineEDMS.Description;
                    SalesAnalysisLine.Quantity := ServiceLineEDMS.Quantity;
                    SalesAnalysisLine."Line Discount %" := ServiceLineEDMS."Line Discount Amount";
                    if ServiceLineEDMS.Quantity <> 0 then begin
                        SalesAnalysisLine."Retail Price" := ServiceLineEDMS."Unit Price";
                        SalesAnalysisLine.Validate("Retail Unit Price", ServiceLineEDMS."Unit Price" * (100 - ServiceLineEDMS."Line Discount %") / 100);
                    end;
                    SalesAnalysisLine.Insert;
                end;
            until SalesLine.Next = 0;
        SalesAnalysisLine.CalcHeaderMarginPr;
    end;
}

