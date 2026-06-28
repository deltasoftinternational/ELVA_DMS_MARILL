Codeunit 25006304 "VehicleOptionManagement"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified UseAssemblyFunctionality(), Usert Profile Setup to Branch Profile Setup
    // 
    // 31.05.2013 Elva Baltic P15
    //   * Added Function ModifVehColorUpholstByAssembly
    // 
    // 11.04.2013 EDMS P8
    //   * changes due to new field in T25006374
    // 
    // 02.12.2011. EDMS P8
    //   * Added functions
    //             CreatePDIdocFromAssemblyLine
    //             CreatePDIdocFromAssemblyServic
    // 
    // 27.08.2008. EDMS P2
    //   * Added functions
    //             PasteOwnOption
    //             PasteManufacturerOption


    trigger OnRun()
    begin
    end;

    var
        InventorySetup: Record "Inventory Setup";


    procedure FillVehAssembly(SerialNo: Code[20]; AssemblyID: Code[20]; MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionNo: Code[20])
    var
        VehicleAssemby: Record "Vehicle Assembly Line";
        LineNo: Integer;
        ManOptinon: Record "Manufacturer Option";
        VehOptLedger: Record "Vehicle Opt. Ledger Entry";
    begin
        VehicleAssemby.SetRange("Serial No.", SerialNo);
        VehicleAssemby.SetRange("Assembly ID", AssemblyID);
        if not VehicleAssemby.FindFirst then begin
            if VehicleOptionsExists(SerialNo) then begin
                VehicleAssemby.Init;
                VehicleAssemby."Serial No." := SerialNo;
                VehicleAssemby."Assembly ID" := AssemblyID;
                VehicleAssemby."Make Code" := MakeCode;
                VehicleAssemby."Model Code" := ModelCode;
                VehicleAssemby."Model Version No." := ModelVersionNo;
                SyncVehAssembly(VehicleAssemby);
            end else begin
                VehicleAssemby.Init;
                VehicleAssemby."Serial No." := SerialNo;
                VehicleAssemby."Assembly ID" := AssemblyID;
                LineNo += 10000;
                VehicleAssemby."Line No." := LineNo;
                VehicleAssemby."Make Code" := MakeCode;
                VehicleAssemby."Model Code" := ModelCode;
                VehicleAssemby."Model Version No." := ModelVersionNo;
                VehicleAssemby.Validate("Option Type", VehicleAssemby."option type"::"Vehicle Base");
                if VehicleAssemby.Insert(true) then;

                ManOptinon.SetRange("Make Code", MakeCode);
                ManOptinon.SetRange("Model Code", ModelCode);
                ManOptinon.SetRange("Model Version No.", ModelVersionNo);
                ManOptinon.SetRange(Standard, true);

                if ManOptinon.FindSet then
                    repeat
                        VehicleAssemby.Init;
                        VehicleAssemby."Serial No." := SerialNo;
                        VehicleAssemby."Assembly ID" := AssemblyID;
                        LineNo += 10000;
                        VehicleAssemby."Line No." := LineNo;
                        VehicleAssemby."Option Type" := VehicleAssemby."option type"::"Manufacturer Option";
                        VehicleAssemby."Make Code" := MakeCode;
                        VehicleAssemby."Model Code" := ModelCode;
                        VehicleAssemby."Model Version No." := ModelVersionNo;
                        VehicleAssemby.Validate("Option Subtype", ManOptinon.Type);
                        VehicleAssemby.Validate("Option Code", ManOptinon."Option Code");
                        VehicleAssemby.Validate("Sales Price", ManOptinon.GetCurrentPrice);//30.05.2019 EB.RC bug email
                        VehicleAssemby.Standard := true;
                        if VehicleAssemby.Insert(true) then;
                    until ManOptinon.Next = 0;
                Commit;
            end;
        end;
    end;


    procedure VehicleOptionsExists(SerialNo: Code[20]): Boolean
    var
        VehOptLedger: Record "Vehicle Opt. Ledger Entry";
    begin
        VehOptLedger.Reset;
        VehOptLedger.SetCurrentkey("Vehicle Serial No.");
        VehOptLedger.SetRange("Vehicle Serial No.", SerialNo);
        VehOptLedger.SetRange(Open, true);
        exit(VehOptLedger.FindSet)
    end;


    procedure PostVehOptPurchLine(var PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line")
    var
        VehOptLedger: Record "Vehicle Opt. Ledger Entry";
        VehOptJnlLine: Record "Vehicle Opt. Jnl. Line";
        VehOptJnlPostLine: Codeunit "Vehicle Opt. Jnl.-Post Line";
        CrMemo: Boolean;
        VehAssembly: Record "Vehicle Assembly Line";
    begin
        PurchLine.TestField("Vehicle Serial No.");
        PurchLine.TestField("Vehicle Assembly ID");

        CrMemo := PurchLine."Document Type" = PurchLine."document type"::"Credit Memo";

        if CrMemo then begin
            VehOptLedger.Reset;
            VehOptLedger.SetRange("Vehicle Serial No.", PurchLine."Vehicle Serial No.");
            VehOptLedger.SetRange("Entry Type", VehOptLedger."entry type"::"Put On");
            VehOptLedger.SetRange(Open, true);
            VehOptLedger.SetRange(Correction, false);
            VehOptLedger.SetFilter("Option Type", '%1|%2|%3', VehOptLedger."option type"::"Manufacturer Option",
              VehOptLedger."option type"::"Vehicle Base", VehOptLedger."option type"::"Own Option");
            if VehOptLedger.FindSet then
                repeat
                    VehOptJnlLine.Reset;
                    VehOptJnlLine.Init;
                    VehOptJnlLine.Validate("Posting Date", PurchHeader."Posting Date");
                    VehOptJnlLine.Validate("Document No.", PurchLine."Document No.");
                    VehOptJnlLine.Validate("Entry Type", VehOptJnlLine."entry type"::Assemble);
                    VehOptJnlLine.Validate(Correction, true);
                    VehOptJnlLine.Validate("Vehicle Serial No.", PurchLine."Vehicle Serial No.");
                    VehOptJnlLine.VIN := PurchLine.VIN;
                    VehOptJnlLine.Validate("Make Code", VehOptLedger."Make Code");
                    VehOptJnlLine.Validate("Model Code", VehOptLedger."Model Code");
                    VehOptJnlLine.Validate("Model Version No.", VehOptLedger."Model Version No.");
                    VehOptJnlLine.Validate("Option Type", VehOptLedger."Option Type");
                    VehOptJnlLine.Validate("Option Subtype", VehOptLedger."Option Subtype");
                    VehOptJnlLine.Validate("Option Code", VehOptLedger."Option Code");
                    VehOptJnlLine.Validate("Applies-to Entry", VehOptLedger."Entry No.");
                    VehOptJnlLine."Assembly ID" := PurchLine."Vehicle Assembly ID";
                    VehOptJnlPostLine.Run(VehOptJnlLine);
                until VehOptLedger.Next = 0;
        end else begin //Not CrMemo
            VehAssembly.Reset;
            VehAssembly.SetRange("Serial No.", PurchLine."Vehicle Serial No.");
            VehAssembly.SetRange("Assembly ID", PurchLine."Vehicle Assembly ID");
            if VehAssembly.FindSet then
                repeat
                    VehOptJnlLine.Reset;
                    VehOptJnlLine.Init;
                    VehOptJnlLine.Validate("Posting Date", PurchHeader."Posting Date");
                    VehOptJnlLine.Validate("Document No.", PurchLine."Document No.");
                    VehOptJnlLine.Validate("Entry Type", VehOptJnlLine."entry type"::Assemble);
                    VehOptJnlLine.Validate(Correction, false);
                    VehOptJnlLine.Validate("Vehicle Serial No.", PurchLine."Vehicle Serial No.");
                    VehOptJnlLine.VIN := PurchLine.VIN;
                    VehOptJnlLine.Validate("Make Code", VehAssembly."Make Code");
                    VehOptJnlLine.Validate("Model Code", VehAssembly."Model Code");
                    VehOptJnlLine.Validate("Model Version No.", VehAssembly."Model Version No.");
                    VehOptJnlLine.Validate("Option Type", VehAssembly."Option Type");
                    VehOptJnlLine.Validate("Option Subtype", VehAssembly."Option Subtype");
                    VehOptJnlLine.Validate("Option Code", VehAssembly."Option Code");
                    VehOptJnlLine."Assembly ID" := PurchLine."Vehicle Assembly ID";
                    VehOptJnlPostLine.Run(VehOptJnlLine);
                until VehAssembly.Next = 0;
        end;
    end;


    procedure SyncVehAssembly(var VehAssembly: Record "Vehicle Assembly Line")
    var
        VehAssembly1: Record "Vehicle Assembly Line";
        VehOptLedger: Record "Vehicle Opt. Ledger Entry";
        LineNo: Integer;
    begin
        //Sinhronizējam A/M komplektēšanas d/l ar esošo komplektāciju (grāmatā)

        VehAssembly.TestField("Serial No.");
        VehAssembly.TestField("Assembly ID");

        VehAssembly1.LockTable;
        VehAssembly1.Reset;
        VehAssembly1.SetRange("Serial No.", VehAssembly."Serial No.");
        VehAssembly1.SetRange("Assembly ID", VehAssembly."Assembly ID");

        //Iegūstam pēdējās rindas Nr.
        LineNo := 0;
        if VehAssembly1.FindLast then
            LineNo := VehAssembly1."Line No.";

        //Saliekam visiem ierakstiem atzīmes
        if VehAssembly1.FindSet then
            repeat
                VehAssembly1.Mark := true;
            until VehAssembly1.Next = 0;

        VehOptLedger.LockTable;
        VehOptLedger.Reset;
        VehOptLedger.SetCurrentkey("Vehicle Serial No.");
        VehOptLedger.SetRange("Vehicle Serial No.", VehAssembly."Serial No.");
        VehOptLedger.SetRange("Entry Type", VehOptLedger."entry type"::"Put On");
        VehOptLedger.SetRange(Open, true);
        VehOptLedger.SetRange(Correction, false);
        if VehOptLedger.FindSet then
            repeat
                VehAssembly1.SetRange("Option Subtype", VehOptLedger."Option Subtype");
                VehAssembly1.SetRange("Option Type", VehOptLedger."Option Type");
                VehAssembly1.SetRange("Option Code");
                if VehOptLedger."Option Code" <> '' then
                    VehAssembly1.SetRange("Option Code", VehOptLedger."Option Code");
                if VehAssembly1.FindFirst then begin
                    VehAssembly1.Posted := true;
                    VehAssembly1."Cost Amount" := VehOptLedger."Cost Amount (LCY)";
                    VehAssembly1.Modify;
                    VehAssembly1.Mark := false;
                end
                else begin
                    LineNo := LineNo + 10000;
                    VehAssembly1.Init;
                    VehAssembly1."Serial No." := VehOptLedger."Vehicle Serial No.";
                    VehAssembly1."Make Code" := VehOptLedger."Make Code";
                    VehAssembly1."Model Code" := VehOptLedger."Model Code";
                    VehAssembly1."Model Version No." := VehOptLedger."Model Version No.";
                    VehAssembly1."Assembly ID" := VehAssembly."Assembly ID";
                    VehAssembly1."Line No." := LineNo;
                    VehAssembly1.Validate("Option Type", VehOptLedger."Option Type");
                    VehAssembly1.Validate("Option Subtype", VehOptLedger."Option Subtype");
                    if VehOptLedger."Option Code" <> '' then
                        VehAssembly1.Validate("Option Code", VehOptLedger."Option Code");
                    VehAssembly1."Cost Amount" := VehOptLedger."Cost Amount (LCY)";
                    VehAssembly1.Posted := true;
                    OnBeforeInsertVehAssembly(VehAssembly1, VehOptLedger);
                    if VehAssembly1.Insert then;
                end;
            until VehOptLedger.Next = 0;

        //Visiem atzīmētajiem ierakstiem saliekam pazīme -> Posted=False
        VehAssembly1.SetRange("Option Type");
        VehAssembly1.SetRange("Option Subtype");
        VehAssembly1.SetRange("Option Code");
        VehAssembly1.MarkedOnly(true);
        if VehAssembly1.FindSet then
            repeat
                VehAssembly1.Posted := false;
                VehAssembly1.Modify;
            until VehAssembly1.Next = 0;

        //Noņemam visas atzīmes
        VehAssembly1.ClearMarks;
    end;


    procedure PutOnOption(VehAssembly: Record "Vehicle Assembly Line")
    var
        VehOptJnlLine: Record "Vehicle Opt. Jnl. Line";
        VehOptJnlPostLine: Codeunit "Vehicle Opt. Jnl.-Post Line";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        InventorySetup.Get;
        InventorySetup.TestField("Vehicle Assembly Document Nos.");

        VehAssembly.TestField("Serial No.");
        VehAssembly.TestField("Assembly ID");

        VehOptJnlLine.Reset;
        VehOptJnlLine.Init;
        VehOptJnlLine.Validate("Posting Date", WorkDate);
        Clear(NoSeriesMgt);
        VehOptJnlLine.Validate("Document No.", NoSeriesMgt.PeekNextNo(InventorySetup."Vehicle Assembly Document Nos.",
                               VehOptJnlLine."Posting Date"));
        VehOptJnlLine.Validate("Entry Type", VehOptJnlLine."entry type"::Assemble);
        VehOptJnlLine.Validate(Correction, false);
        VehOptJnlLine.Validate("Vehicle Serial No.", VehAssembly."Serial No.");
        VehOptJnlLine.Validate("Make Code", VehAssembly."Make Code");
        VehOptJnlLine.Validate("Model Code", VehAssembly."Model Code");
        VehOptJnlLine.Validate("Model Version No.", VehAssembly."Model Version No.");
        VehOptJnlLine.Validate("Option Type", VehAssembly."Option Type");
        VehOptJnlLine.Validate("Option Subtype", VehAssembly."Option Subtype");
        VehOptJnlLine.Validate("Option Code", VehAssembly."Option Code");
        VehOptJnlLine.Validate("Cost Amount (LCY)", VehAssembly."Cost Amount");
        VehOptJnlLine."Assembly ID" := VehAssembly."Assembly ID";
        VehOptJnlPostLine.Run(VehOptJnlLine);

        VehAssembly.Posted := true;
        VehAssembly.Modify;
    end;


    procedure DeleteVehAssembly(SerialNo: Code[20]; AssemblyID: Code[20])
    var
        VehAssembly: Record "Vehicle Assembly Line";
    begin
        VehAssembly.Reset;
        VehAssembly.SetRange("Serial No.", SerialNo);
        VehAssembly.SetRange("Assembly ID", AssemblyID);
        VehAssembly.DeleteAll;
    end;


    procedure IsCompletelyAssembly(SerialNo: Code[20]; AssemblyID: Code[20])
    var
        VehAssembly: Record "Vehicle Assembly Line";
    begin
        VehAssembly.Reset;
        VehAssembly.SetRange("Serial No.", SerialNo);
        VehAssembly.SetRange("Assembly ID", AssemblyID);
    end;


    procedure UseAssemblyFunctionality(): Boolean
    var
        VehOptSetup: Record "Vehicle Opt. Setup";
        Workplace: Record "Branch Profile Setup";
        UserProfileMgt: Codeunit UserProfileManagement;
    begin
        if UserProfileMgt.CurrProfileID = '' then
            exit(false);
        if not VehOptSetup.Get then
            exit(false);

        if Workplace.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
            if Workplace."Don't Use Vehicle Assembly" then
                exit(false)
            else begin
                exit(VehOptSetup."Functionality Activated");
            end;
        end else
            exit(VehOptSetup."Functionality Activated");
    end;


    procedure GetOptionText(VehicleAssembly: Record "Vehicle Assembly Line"; LanguageCode: Code[10]): Text[250]
    var
        OptionTransl: Record "Option Translation";
    begin
        if LanguageCode = '' then
            exit(VehicleAssembly.Description);
        OptionTransl.Reset;
        OptionTransl.SetRange("Make Code", VehicleAssembly."Make Code");
        OptionTransl.SetRange("Model Code", VehicleAssembly."Model Code");
        OptionTransl.SetRange("Model Version No.", VehicleAssembly."Model Version No.");
        OptionTransl.SetRange("Option Type", VehicleAssembly."Option Type");
        OptionTransl.SetRange("Option Subtype", VehicleAssembly."Option Subtype");
        OptionTransl.SetRange("Option Code", VehicleAssembly."Option Code");
        OptionTransl.SetRange("Language Code", LanguageCode);
        if OptionTransl.FindFirst then
            exit(OptionTransl.Description)
        else
            exit(VehicleAssembly.Description)
    end;


    procedure PasteOwnOption(var OwnOption: Record "Own Option"; MakeCode: Code[20]; ModelCode: Code[20])
    var
        OwnOptionNew: Record "Own Option";
        OptionSalesPrice: Record "Option Sales Price";
        OptionSaleDiscount: Record "Option Sales Discount";
        OptionSalesPriceNew: Record "Option Sales Price";
        OptionSaleDiscountNew: Record "Option Sales Discount";
    begin
        if OwnOption.FindFirst then
            repeat
                if not OwnOptionNew.Get(MakeCode, ModelCode, OwnOption."Option Code") then begin
                    OwnOptionNew.Init;
                    OwnOptionNew := OwnOption;
                    OwnOptionNew."Make Code" := MakeCode;
                    OwnOptionNew."Model Code" := ModelCode;
                    OwnOptionNew.Insert;

                    OptionSalesPrice.Reset;
                    OptionSalesPrice.SetRange("Make Code", OwnOption."Make Code");
                    OptionSalesPrice.SetRange("Model Code", OwnOption."Model Code");
                    OptionSalesPrice.SetRange("Option Type", OptionSalesPrice."option type"::"Own Option");
                    OptionSalesPrice.SetRange("Option Code", OwnOption."Option Code");
                    if OptionSalesPrice.FindFirst then
                        repeat
                            OptionSalesPriceNew.Init;
                            OptionSalesPriceNew := OptionSalesPrice;
                            OptionSalesPriceNew."Make Code" := MakeCode;
                            OptionSalesPriceNew."Model Code" := ModelCode;
                            OptionSalesPriceNew."Model Version No." := '';
                            OptionSalesPriceNew.Insert;
                        until OptionSalesPrice.Next = 0;

                    OptionSaleDiscount.Reset;
                    OptionSaleDiscount.SetRange("Make Code", OwnOption."Make Code");
                    OptionSaleDiscount.SetRange("Model Code", OwnOption."Model Code");
                    OptionSaleDiscount.SetRange("Option Type", OptionSaleDiscount."option type"::"Own Option");
                    OptionSaleDiscount.SetRange("Option Code", OwnOption."Option Code");
                    if OptionSaleDiscount.FindFirst then
                        repeat
                            OptionSaleDiscountNew.Init;
                            OptionSaleDiscountNew := OptionSaleDiscount;
                            OptionSaleDiscountNew."Make Code" := MakeCode;
                            OptionSaleDiscountNew."Model Code" := ModelCode;
                            OptionSaleDiscountNew."Model Version No." := '';
                            OptionSaleDiscountNew.Insert;
                        until OptionSaleDiscount.Next = 0;
                end;
            until OwnOption.Next = 0;
    end;


    procedure PasteManufacturerOption(var ManufacturerOption: Record "Manufacturer Option"; MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionNo: Code[20])
    var
        ManufacturerOptionNew: Record "Manufacturer Option";
        OptionSalesPrice: Record "Option Sales Price";
        OptionSaleDiscount: Record "Option Sales Discount";
        OptionSalesPriceNew: Record "Option Sales Price";
        OptionSaleDiscountNew: Record "Option Sales Discount";
    begin
        if ManufacturerOption.FindFirst then
            repeat
                if not ManufacturerOptionNew.Get(MakeCode, ModelCode, ModelVersionNo, ManufacturerOption.Type, ManufacturerOption."Option Code") then begin
                    ManufacturerOptionNew.Init;
                    ManufacturerOptionNew := ManufacturerOption;
                    ManufacturerOptionNew."Make Code" := MakeCode;
                    ManufacturerOptionNew."Model Code" := ModelCode;
                    ManufacturerOptionNew."Model Version No." := ModelVersionNo;
                    ManufacturerOptionNew.Insert;

                    OptionSalesPrice.Reset;
                    OptionSalesPrice.SetRange("Make Code", ManufacturerOption."Make Code");
                    OptionSalesPrice.SetRange("Model Code", ManufacturerOption."Model Code");
                    OptionSalesPrice.SetRange("Model Version No.", ManufacturerOption."Model Version No.");
                    OptionSalesPrice.SetRange("Option Type", OptionSalesPrice."option type"::"Manufacturer Option");
                    OptionSalesPrice.SetRange("Option Subtype", ManufacturerOption.Type);
                    OptionSalesPrice.SetRange("Option Code", ManufacturerOption."Option Code");
                    if OptionSalesPrice.FindFirst then
                        repeat
                            OptionSalesPriceNew.Init;
                            OptionSalesPriceNew := OptionSalesPrice;
                            OptionSalesPriceNew."Make Code" := MakeCode;
                            OptionSalesPriceNew."Model Code" := ModelCode;
                            OptionSalesPriceNew."Model Version No." := ModelVersionNo;
                            OptionSalesPriceNew.Insert;
                        until OptionSalesPrice.Next = 0;

                    OptionSaleDiscount.Reset;
                    OptionSaleDiscount.SetRange("Make Code", ManufacturerOption."Make Code");
                    OptionSaleDiscount.SetRange("Model Code", ManufacturerOption."Model Code");
                    OptionSaleDiscount.SetRange("Model Version No.", ManufacturerOption."Model Version No.");
                    OptionSaleDiscount.SetRange("Option Type", OptionSaleDiscount."option type"::"Manufacturer Option");
                    OptionSaleDiscount.SetRange("Option Subtype", ManufacturerOption.Type);
                    OptionSaleDiscount.SetRange("Option Code", ManufacturerOption."Option Code");
                    if OptionSaleDiscount.FindFirst then
                        repeat
                            OptionSaleDiscountNew.Init;
                            OptionSaleDiscountNew := OptionSaleDiscount;
                            OptionSaleDiscountNew."Make Code" := MakeCode;
                            OptionSaleDiscountNew."Model Code" := ModelCode;
                            OptionSaleDiscountNew."Model Version No." := ModelVersionNo;
                            OptionSaleDiscountNew.Insert;
                        until OptionSaleDiscount.Next = 0;
                end;
            until ManufacturerOption.Next = 0;
    end;


    procedure CreatePDIdocFromAssemblyLine(var VehicleAssembly: Record "Vehicle Assembly Line")
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        VehicleAssemblyHeader: Record "Vehicle Assembly Header";
        VehicleAssemblyLineTmp: Record "Vehicle Assembly Line" temporary;
        ManOption: Record "Manufacturer Option";
        InvSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        CurrencyDate: Date;
        VehPriceMgt: Codeunit VehicleSalesPriceDiscountMgt;
        ServiceHeaderTmp: Record "Service Header EDMS" temporary;
        Customer: Record Customer;
        OwnOption: Record "Own Option";
        ServicePackage: Record "Service Package";
        ServicePackageVersion: Record "Service Package Version";
        Text1001: label 'PDI service document is not created - was not selected Own Option line';
        Text1002: label 'Is created %2 in %1.';
        Text1003: label 'Is auto-created by function from %1.';
        Text1004: label 'Is not able to find %1 with %2.';
        PDIcreateConfirmPage: Page "PDI create from Assem. Confirm";
        VehSerNo: Code[20];
        VehAssemID: Code[20];
        Text1005: label 'In selected range there are no %3 lines.';
        Text1006: label 'In selected range there are only %1 records with %2.';
        FormRetResult: action;
        SerialFilterStr: Text[100];
        AssemblyIDFilterStr: Text[100];
        LineNoFilterStr: Text[100];
        CreatePDIDocByAssembly: Report "Create PDI Doc. by Assembly";
    begin
        if not VehicleAssembly.FindFirst then
            Error(Text1001);

        VehSerNo := VehicleAssembly."Serial No.";
        VehAssemID := VehicleAssembly."Assembly ID";
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
        SalesLine.SetRange("Line Type", SalesLine."line type"::Vehicle);
        SalesLine.SetRange("Vehicle Serial No.", VehSerNo);
        SalesLine.SetRange("Vehicle Assembly ID", VehAssemID);
        if SalesLine.FindFirst then
            SalesHeader.Get(SalesLine."document type"::Order, SalesLine."Document No.");
        VehicleAssembly.SetRange("Serial No.", VehSerNo);
        VehicleAssembly.SetRange("Assembly ID", VehAssemID);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type");
        SalesHeader.SetRange("No.", SalesHeader."No.");
        CreatePDIDocByAssembly.SetTableview(SalesHeader);
        CreatePDIDocByAssembly.SetTableview(VehicleAssembly);
        CreatePDIDocByAssembly.Run;
    end;


    procedure CreatePDIdocFromAssemblyL_old(var VehicleAssembly: Record "Vehicle Assembly Line")
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        VehicleAssemblyHeader: Record "Vehicle Assembly Header";
        VehicleAssemblyLineTmp: Record "Vehicle Assembly Line" temporary;
        ManOption: Record "Manufacturer Option";
        InvSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        CurrencyDate: Date;
        VehPriceMgt: Codeunit VehicleSalesPriceDiscountMgt;
        ServiceHeaderTmp: Record "Service Header EDMS" temporary;
        Customer: Record Customer;
        OwnOption: Record "Own Option";
        ServicePackage: Record "Service Package";
        ServicePackageVersion: Record "Service Package Version";
        Text1001: label 'PDI service document is not created - was not selected Own Option line';
        Text1002: label 'Is created %2 in %1.';
        Text1003: label 'Is auto-created by function from %1.';
        Text1004: label 'Is not able to find %1 with %2.';
        PDIcreateConfirmPage: Page "PDI create from Assem. Confirm";
        VehSerNo: Code[20];
        VehAssemID: Code[20];
        Text1005: label 'In selected range there are no %3 lines.';
        Text1006: label 'In selected range there are only %1 records with %2.';
        FormRetResult: action;
        SerialFilterStr: Text[100];
        AssemblyIDFilterStr: Text[100];
        LineNoFilterStr: Text[100];
    begin
        // it supposed to be called with CurrPage.SETSELECTIONFILTER(VehicleAssembly) execute before
        if not VehicleAssembly.FindFirst then
            Error(Text1001);
        // HERE WE fill TEMP table to have stored situation with marked records
        VehicleAssemblyLineTmp.Reset;
        VehicleAssemblyLineTmp.DeleteAll;
        repeat
            VehicleAssemblyLineTmp := VehicleAssembly;
            VehicleAssemblyLineTmp.Insert;
        until VehicleAssembly.Next = 0;

        VehicleAssemblyLineTmp.SetRange("Option Type", VehicleAssembly."option type"::"Own Option");
        if not VehicleAssemblyLineTmp.FindFirst then
            Error(Text1005, VehicleAssembly.TableCaption, VehicleAssembly.FieldCaption("Option Type"),
              GetOptionCaption);
        VehicleAssemblyLineTmp.SetRange("PDI Created", false);
        if not VehicleAssemblyLineTmp.FindFirst then
            Error(Text1006, VehicleAssembly.TableCaption, VehicleAssembly.FieldCaption("PDI Created"));
        //it removes 'marked only'
        VehicleAssembly.SetRange("Option Type", VehicleAssembly."option type"::"Own Option");
        //set new marks to normal table
        //Serial No.,Assembly ID,Line No.
        SerialFilterStr := '';
        AssemblyIDFilterStr := '';
        LineNoFilterStr := '';
        repeat
            if SerialFilterStr <> '' then
                SerialFilterStr += '|';
            SerialFilterStr += '''' + VehicleAssemblyLineTmp."Serial No." + '''';
            if AssemblyIDFilterStr <> '' then
                AssemblyIDFilterStr += '|';
            AssemblyIDFilterStr += '''' + VehicleAssemblyLineTmp."Assembly ID" + '''';
            if LineNoFilterStr <> '' then
                LineNoFilterStr += '|';
            LineNoFilterStr += Format(VehicleAssemblyLineTmp."Line No.");
        until VehicleAssemblyLineTmp.Next = 0;
        VehicleAssembly.SetFilter("Serial No.", SerialFilterStr);
        VehicleAssembly.SetFilter("Assembly ID", AssemblyIDFilterStr);
        VehicleAssembly.SetFilter("Line No.", LineNoFilterStr);

        VehSerNo := VehicleAssembly."Serial No.";
        VehAssemID := VehicleAssembly."Assembly ID";
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
        SalesLine.SetRange("Line Type", SalesLine."line type"::Vehicle);
        SalesLine.SetRange("Vehicle Serial No.", VehSerNo);
        SalesLine.SetRange("Vehicle Assembly ID", VehAssemID);
        if not SalesLine.FindFirst then begin
            Message(Text1001);
            exit;
        end;
        //it works only for first line of range, so means that supposed that order is one for certain vehicle
        Customer.Reset;
        Customer.SetRange(Internal, true);
        if not Customer.FindFirst then begin
            Error(Text1004, Customer.TableCaption, Customer.FieldCaption(Internal));
        end else begin
            if Customer.Count > 1 then begin
                if not (Page.RunModal(Page::"Customer List", Customer) = Action::LookupOK) then
                    exit;
            end;
        end;
        if VehicleAssembly.FindFirst then begin
            with ServiceHeaderTmp do begin
                ServiceHeaderTmp.Init;
                ServiceHeaderTmp.SetHideValidationDialog(true);
                ServiceHeaderTmp.SetNotFindVehicle;
                ServiceHeaderTmp.Validate("Document Type", ServiceHeaderTmp."document type"::Order);
                ServiceHeaderTmp.Insert(true);
                ServiceHeaderTmp.Validate(Description, StrSubstNo(Text1003, SalesLine."Document No."));
                ServiceHeaderTmp.Validate("Order Date", WorkDate);
                ServiceHeaderTmp.Validate("Planned Service Date", WorkDate);
                ServiceHeaderTmp.SetSkipVehicleChoose(true);
                if SalesHeader.Get(SalesHeader."document type"::Order, SalesLine."Document No.") then
                    ServiceHeaderTmp.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.")
                else
                    ServiceHeaderTmp.Validate("Sell-to Customer No.", Customer."No.");
                ServiceHeaderTmp.Validate("Bill-to Customer No.", Customer."No.");
                ServiceHeaderTmp.Validate("Vehicle Serial No.", VehicleAssembly."Serial No.");
                ServiceHeaderTmp.Validate("Variable Field Run 1", SalesLine."Variable Field Run 1");
                ServiceHeaderTmp.Modify(true);
            end;
            Commit;
            with PDIcreateConfirmPage do begin
                PDIcreateConfirmPage.SetServiceHeaderTmp(ServiceHeaderTmp);
                PDIcreateConfirmPage.SetVehicleAssembly(VehicleAssembly);
                PDIcreateConfirmPage.SetRecord(ServiceHeaderTmp);
                FormRetResult := PDIcreateConfirmPage.RunModal;
                if (FormRetResult = Action::LookupOK) or (FormRetResult = Action::OK) then begin
                    PDIcreateConfirmPage.GetServiceHeaderTmp(ServiceHeaderTmp);
                    CreatePDIdocFromAssemblyServic(VehicleAssembly, ServiceHeaderTmp);
                end;
            end;
        end else begin
            Message(Text1005, VehicleAssembly.TableCaption, VehicleAssembly.FieldCaption("Option Type"),
              GetOptionCaption);
        end;
    end;


    procedure CreatePDIdocFromAssemblyServic(var VehicleAssembly: Record "Vehicle Assembly Line"; ServiceHeaderTmp: Record "Service Header EDMS" temporary)
    var
        SalesLine: Record "Sales Line";
        VehicleAssemblyHeader: Record "Vehicle Assembly Header";
        ManOption: Record "Manufacturer Option";
        InvSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        CurrencyDate: Date;
        VehPriceMgt: Codeunit VehicleSalesPriceDiscountMgt;
        ServiceHeader: Record "Service Header EDMS";
        Customer: Record Customer;
        OwnOption: Record "Own Option";
        ServicePackage: Record "Service Package";
        ServicePackageVersion: Record "Service Package Version";
        Text1001: label 'PDI service document is not created - not found PDI options.';
        Text1002: label '%1 %2 is created.';
        Text1003: label 'Is auto-created by function from %1.';
        Text1004: label 'Is not able to find %1 with %2.';
        DocDate: Date;
        DocNo: Code[20];
    begin
        // it supposed to be called with CurrPage.SETSELECTIONFILTER(VehicleAssembly) execute before
        if VehicleAssembly.FindFirst then begin
            // create service header
            ServiceHeader.Init;
            ServiceHeader.Validate("Document Type", ServiceHeader."document type"::Order);
            ServiceHeader.Insert(true);
            DocNo := ServiceHeader."No.";
            ServiceHeader.TransferFields(ServiceHeaderTmp);
            ServiceHeader."No." := DocNo;
            ServiceHeader.Modify(true);
            Commit;
            // fill by service lines
            ServicePackageVersion.Reset;
            repeat
                AddPDItoServDoc(VehicleAssembly, ServiceHeader);
            until VehicleAssembly.Next = 0;
            Message(Text1002, ServiceHeader.TableCaption + ' ' + Format(ServiceHeader."Document Type"), ServiceHeader."No.");
        end else
            Message(Text1001);
    end;


    procedure GetOptionCaption(): Text[30]
    var
        VehicleAssemblyL: Record "Vehicle Assembly Line";
        FieldRef: FieldRef;
        RecordRef: RecordRef;
        OptionCaption: Text[30];
        OptionCaptionList: Text[250];
        Position: Integer;
    begin
        VehicleAssemblyL."Option Type" := VehicleAssemblyL."option type"::"Own Option";
        RecordRef.Open(Database::"Vehicle Assembly Line");
        RecordRef.GetTable(VehicleAssemblyL);
        FieldRef := RecordRef.Field(VehicleAssemblyL.FieldNo("Option Type"));
        OptionCaptionList := FieldRef.OptionCaption;
        if VehicleAssemblyL."Option Type" > 0 then
            repeat
                Position := StrPos(OptionCaptionList, ',');
                if Position > 0 then
                    OptionCaptionList := CopyStr(OptionCaptionList, Position + 1, StrLen(OptionCaptionList) - Position);
                VehicleAssemblyL."Option Type" -= 1;
            until VehicleAssemblyL."Option Type" = 0;
        Position := StrPos(OptionCaptionList, ',');
        if Position = 0 then
            Position := StrLen(OptionCaptionList);
        OptionCaption := CopyStr(OptionCaptionList, 1, Position - 1);
        exit(OptionCaption);
    end;


    procedure AddPDItoServDoc(VehicleAssembly: Record "Vehicle Assembly Line"; var ServiceHeaderPar: Record "Service Header EDMS")
    var
        OwnOption: Record "Own Option";
        ServicePackage: Record "Service Package";
        ServicePackageVersion: Record "Service Package Version";
    begin
        ServicePackageVersion.Reset;
        if VehicleAssembly."Option Code" <> '' then
            if OwnOption.Get(VehicleAssembly."Make Code", VehicleAssembly."Model Code", VehicleAssembly."Option Code") then
                if OwnOption."Package No." <> '' then
                    if ServicePackage.Get(OwnOption."Package No.") then begin
                        ServicePackageVersion.SetRange("Package No.", OwnOption."Package No.");
                        ServiceHeaderPar.InsertLookupSPVersion(ServicePackageVersion);
                        VehicleAssembly."PDI Created" := true;
                        VehicleAssembly.Modify;
                    end;
    end;


    procedure CreateServDocFromVehTrade(var ServiceHeaderPar: Record "Service Header EDMS"; SalesLinePar: Record "Sales Line"; StartingDate: Date; FinishingDate: Date; CustomerNoSellTo: Code[20]; CustomerNoBillTo: Code[20]): Code[20]
    var
        SalesLine: Record "Sales Line";
        VehicleAssemblyHeader: Record "Vehicle Assembly Header";
        ManOption: Record "Manufacturer Option";
        InvSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        CurrencyDate: Date;
        VehPriceMgt: Codeunit VehicleSalesPriceDiscountMgt;
        ServiceHeader: Record "Service Header EDMS";
        Customer: Record Customer;
        OwnOption: Record "Own Option";
        ServicePackage: Record "Service Package";
        ServicePackageVersion: Record "Service Package Version";
        Text1001: label 'PDI service document is not created - not found PDI options.';
        Text1002: label '%1 %2 is created.';
        Text1003: label 'Is auto-created by function from %1.';
        Text1004: label 'Is not able to find %1 with %2.';
        DocDate: Date;
        DocNo: Code[20];
    begin
        ServiceHeaderPar.Init;
        ServiceHeaderPar.SetHideValidationDialog(true);
        ServiceHeaderPar.SetNotFindVehicle;
        ServiceHeaderPar.Validate("Document Type", ServiceHeaderPar."document type"::Order);
        ServiceHeaderPar.Insert(true);
        ServiceHeaderPar.Validate(Description, StrSubstNo(Text1003, SalesLinePar."Document No."));
        ServiceHeaderPar.Validate("Requested Starting Date", StartingDate);
        ServiceHeaderPar.Validate("Requested Finishing Date", FinishingDate);
        ServiceHeaderPar.SetSkipVehicleChoose(true);
        ServiceHeaderPar.Validate("Sell-to Customer No.", CustomerNoSellTo);
        ServiceHeaderPar.Validate("Bill-to Customer No.", CustomerNoBillTo);
        ServiceHeaderPar.Validate("Vehicle Serial No.", SalesLinePar."Vehicle Serial No.");
        ServiceHeaderPar.Validate("Variable Field Run 1", SalesLinePar."Variable Field Run 1");
        ServiceHeaderPar.Modify(true);
        exit(ServiceHeaderPar."No.");
    end;


    procedure GetVehColorUpholstFromAssemblyLine(VehSerialNoPar: Code[20]; VehAssemblyIDPar: Code[20]; var ColorAssmbl: Code[20]; var UpholsteryAssmbl: Code[20])
    var
        VehAssemblyLine: Record "Vehicle Assembly Line";
    begin
        VehAssemblyLine.Reset;
        VehAssemblyLine.SetRange("Serial No.", VehSerialNoPar);
        VehAssemblyLine.SetRange("Assembly ID", VehAssemblyIDPar);
        VehAssemblyLine.SetRange("Option Type", VehAssemblyLine."option type"::"Manufacturer Option");
        // Color
        VehAssemblyLine.SetRange("Option Subtype", VehAssemblyLine."option subtype"::Color);
        if VehAssemblyLine.FindFirst then
            ColorAssmbl := VehAssemblyLine."Option Code";
        VehAssemblyLine.SetRange("Option Subtype");

        // Upholstery
        VehAssemblyLine.SetRange("Option Subtype", VehAssemblyLine."option subtype"::Upholstery);
        if VehAssemblyLine.FindFirst then
            UpholsteryAssmbl := VehAssemblyLine."Option Code";
    end;


    procedure CopyVehAssemblyToPosted(SourceID: Integer; SourceNo: Code[20]; AssemblyID: Code[20])
    var
        VehicleAssemblyHeader: Record "Vehicle Assembly Header";
        VehicleAssemblyLine: Record "Vehicle Assembly Line";
        PostedVehicleAssemblyHeader: Record "Posted Veh. Assembly Header";
        PostedVehicleAssemblyLine: Record "Posted Veh. Assembly Line";
    begin
        if VehicleAssemblyHeader.Get(AssemblyID) then begin
            PostedVehicleAssemblyHeader.Init;
            PostedVehicleAssemblyHeader.TransferFields(VehicleAssemblyHeader);
            PostedVehicleAssemblyHeader."Source ID" := SourceID;
            PostedVehicleAssemblyHeader."Source No." := SourceNo;
            PostedVehicleAssemblyHeader.Insert;
        end;
        VehicleAssemblyLine.Reset;
        VehicleAssemblyLine.SetRange("Assembly ID", AssemblyID);
        if VehicleAssemblyLine.FindFirst then
            repeat
                PostedVehicleAssemblyLine.Init;
                PostedVehicleAssemblyLine.TransferFields(VehicleAssemblyLine);
                PostedVehicleAssemblyLine."Source ID" := SourceID;
                PostedVehicleAssemblyLine."Source No." := SourceNo;
                PostedVehicleAssemblyLine.Insert;
            until VehicleAssemblyLine.Next = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertVehAssembly(var VehAssembly1: Record "Vehicle Assembly Line"; var VehOptLedger: Record "Vehicle Opt. Ledger Entry")
    begin
    end;
}

