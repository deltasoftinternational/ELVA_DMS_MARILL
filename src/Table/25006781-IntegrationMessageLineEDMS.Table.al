Table 25006781 "Integration Message Line EDMS"
{
    Caption = 'DMS Integration Message Line';

    fields
    {
        field(10; "Message ID"; Integer)
        {
            Caption = 'Message ID';
            TableRelation = "Integration Message EDMS";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(100; "Parent Line No."; Integer)
        {
            Caption = 'Parent Line No.';
            TableRelation = "Integration Message Line EDMS"."Line No." where("Message ID" = field("Message ID"));
        }
        field(200; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
        }
        field(210; "Date, Time Stamp"; DateTime)
        {
            Caption = 'Date, Time Stamp';
            DataClassification = ToBeClassified;
        }
        field(1000; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            DataClassification = ToBeClassified;
            Description = '1000..1999   NAV side info';
        }
        field(1010; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            DataClassification = ToBeClassified;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(1020; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
            DataClassification = ToBeClassified;
        }
        field(1021; "Source ID1"; Code[20])
        {
            Caption = 'Source ID1';
            DataClassification = ToBeClassified;
        }
        field(1022; "Source ID2"; Code[20])
        {
            Caption = 'Source ID2';
            DataClassification = ToBeClassified;
        }
        field(1030; "Source Batch Name"; Code[10])
        {
            Caption = 'Source Batch Name';
            DataClassification = ToBeClassified;
        }
        field(1040; "Source Prod. Order Line"; Integer)
        {
            Caption = 'Source Prod. Order Line';
            DataClassification = ToBeClassified;
        }
        field(1050; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
            DataClassification = ToBeClassified;
        }
        field(1070; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Item Ledger Entry";
        }
        field(9010; Code1; Code[20])
        {
            Description = '9000..9999   Free usage fields';
        }
        field(9020; Code2; Code[20])
        {
        }
        field(9030; Code3; Code[20])
        {
        }
        field(9040; Code4; Code[20])
        {
        }
        field(9050; Code5; Code[20])
        {
        }
        field(9060; Code6; Code[20])
        {
        }
        field(9070; Code7; Code[20])
        {
        }
        field(9080; Code8; Code[20])
        {
        }
        field(9090; Code9; Code[20])
        {
        }
        field(9100; Code10; Code[20])
        {
        }
        field(9110; Date1; Date)
        {
        }
        field(9120; Date2; Date)
        {
        }
        field(9130; Date3; Date)
        {
        }
        field(9140; Date4; Date)
        {
        }
        field(9150; Date5; Date)
        {
        }
        field(9160; Date6; Date)
        {
        }
        field(9170; Date7; Date)
        {
        }
        field(9180; Date8; Date)
        {
        }
        field(9190; Date9; Date)
        {
        }
        field(9200; Date10; Date)
        {
        }
        field(9210; Int1; Integer)
        {
        }
        field(9220; Int2; Integer)
        {
        }
        field(9230; Int3; Integer)
        {
        }
        field(9240; Int4; Integer)
        {
        }
        field(9250; Int5; Integer)
        {
        }
        field(9310; Dec1; Decimal)
        {
        }
        field(9311; Dec11; Decimal)
        {
        }
        field(9320; Dec2; Decimal)
        {
        }
        field(9321; Dec12; Decimal)
        {
        }
        field(9330; Dec3; Decimal)
        {
        }
        field(9331; Dec13; Decimal)
        {
        }
        field(9340; Dec4; Decimal)
        {
        }
        field(9341; Dec14; Decimal)
        {
        }
        field(9350; Dec5; Decimal)
        {
        }
        field(9351; Dec15; Decimal)
        {
        }
        field(9360; Dec6; Decimal)
        {
        }
        field(9370; Dec7; Decimal)
        {
        }
        field(9380; Dec8; Decimal)
        {
        }
        field(9390; Dec9; Decimal)
        {
        }
        field(9400; Dec10; Decimal)
        {
        }
        field(9410; Text1; Text[250])
        {
        }
        field(9420; Text2; Text[250])
        {
        }
        field(9430; Text3; Text[250])
        {
        }
        field(9440; Text4; Text[250])
        {
        }
        field(9450; Text5; Text[250])
        {
        }
        field(9510; Bool1; Boolean)
        {
        }
        field(9520; Bool2; Boolean)
        {
        }
        field(9530; Bool3; Boolean)
        {
        }
        field(9540; Bool4; Boolean)
        {
        }
        field(9550; Bool5; Boolean)
        {
        }
        field(9560; Bool6; Boolean)
        {
        }
        field(9570; Bool7; Boolean)
        {
        }
        field(9580; Bool8; Boolean)
        {
        }
        field(9590; Bool9; Boolean)
        {
        }
        field(9600; Bool10; Boolean)
        {
        }
        field(9610; ShortText1; Text[50])
        {
        }
        field(9620; ShortText2; Text[50])
        {
        }
        field(9630; ShortText3; Text[50])
        {
        }
        field(9640; ShortText4; Text[50])
        {
        }
        field(9650; ShortText5; Text[50])
        {
        }
        field(9660; ShortText6; Text[50])
        {
        }
        field(9670; ShortText7; Text[50])
        {
        }
        field(9680; ShortText8; Text[50])
        {
        }
        field(9690; ShortText9; Text[50])
        {
        }
        field(9700; ShortText10; Text[50])
        {
        }
        field(9710; DateTime1; DateTime)
        {
        }
        field(9720; DateTime2; DateTime)
        {
        }
        field(9730; DateTime3; DateTime)
        {
        }
        field(9740; DateTime4; DateTime)
        {
        }
        field(9750; DateTime5; DateTime)
        {
        }
        field(10000; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            Description = '10000..19999 Item info';
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                if "Item No." = '' then begin
                    "Unit Of Measure Code" := '';
                    Validate("Item Category Code", '');
                end else begin
                    Item.Get("Item No.");
                    "Unit Of Measure Code" := Item."Base Unit of Measure";
                    Validate("Item Category Code", Item."Item Category Code");
                end;
            end;
        }
        field(10010; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Variant".Code;
        }
        field(10020; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";

            trigger OnValidate()
            var
                ProductSubgrp: Record "Product Subgroup";
            begin
            end;
        }
        field(10030; "Unit Of Measure Code"; Code[10])
        {
            Caption = 'Unit Of Measure Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(10100; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(10110; "Bin Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10120; "Location Code Original"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(10300; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10310; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            DataClassification = ToBeClassified;
            TableRelation = "Ordering Price Type";

            trigger OnValidate()
            var
                OrderingPriceType: Record "Ordering Price Type";
            begin
            end;
        }
        field(10400; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20000; "Vehicle No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '20000..29999 Vehicle info';
        }
        field(20010; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Make;

            trigger OnValidate()
            begin
                if "Make Code" <> xRec."Make Code" then
                    Validate("Model Code", '');
            end;
        }
        field(20020; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            DataClassification = ToBeClassified;
            TableRelation = Model.Code where("Make Code" = field("Make Code"));

            trigger OnValidate()
            begin
                if "Model Code" <> xRec."Model Code" then
                    Validate("Model Version No.", '');
            end;
        }
        field(20030; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            DataClassification = ToBeClassified;
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
            end;
        }
        field(20040; "Model Commercial Name"; Text[50])
        {
            CalcFormula = lookup(Model."Commercial Name" where("Make Code" = field("Make Code"),
                                                                Code = field("Model Code")));
            Caption = 'Model Commercial Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20050; "Prod. Serial No."; Code[20])
        {
            Caption = 'Prod. Serial No.';
            DataClassification = ToBeClassified;
        }
        field(20060; VIN; Code[20])
        {
            Caption = 'VIN';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(20070; "Make Vehicle ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20080; "Vehicle Registration No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30000; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '30000..39999 Customer info';
            TableRelation = Customer;
        }
        field(30010; "Customer ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30020; "Customer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30030; "Customer Reg. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30040; "Customer Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30050; "Customer Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30060; "Customer City"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30070; "Customer Post Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(30080; "Customer Country Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(30090; "Customer County"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30100; "Customer Phone No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30110; "Customer Fax No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30120; "Customer E-Mail"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(30130; "Customer Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30140; "Customer Language Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(40000; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '40000..49999 Vendor info';
            TableRelation = Vendor;
        }
        field(40020; "Vendor ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(40030; "Make ID"; Code[20])
        {
            Caption = 'Make ID';
            DataClassification = ToBeClassified;
        }
        field(50000; "Dealer ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '50000..59999 Dealer info';
        }
        field(60000; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '60000..69999 Document Info';
        }
        field(60005; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(60010; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60020; "Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60025; "External Order No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(61000; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(61010; "Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(61020; "Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(61030; "Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(70000; "Country Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '70000..70999 Location Info';
        }
        field(71000; "Recall Campaign Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(71010; "Recall Campaign Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(71020; "Recall Campaign Defect Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90000; "Response Status"; Option)
        {
            Caption = 'Response Status';
            DataClassification = ToBeClassified;
            Description = '90000..99999 Other';
            OptionCaption = ' ,OK,Error,Warning';
            OptionMembers = " ",OK,Error,Warning;
        }
    }

    keys
    {
        key(Key1; "Message ID", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField("Message ID");
        if "Line No." = 0 then begin
            Rec2.Reset;
            Rec2.SetRange("Message ID", "Message ID");
            if Rec2.FindLast then
                "Line No." := Rec2."Line No." + 1
            else
                "Line No." := 1;
        end;

        "User ID" := UserId;
        "Date, Time Stamp" := CurrentDatetime;
    end;

    var
        MessageHeader: Record "Integration Message EDMS";
        Rec2: Record "Integration Message Line EDMS";
        Item: Record Item;

    local procedure GetHeader()
    begin
        TestField("Message ID");
        MessageHeader.Get("Message ID");
    end;


    procedure SetSource(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdLineNo: Integer; SourceRefNo: Integer; ItemLedgEntryNo: Integer)
    begin
        "Source Type" := SourceType;
        "Source Subtype" := SourceSubtype;
        "Source ID" := SourceID;
        "Source Batch Name" := SourceBatchName;
        "Source Prod. Order Line" := SourceProdLineNo;
        "Source Ref. No." := SourceRefNo;
        "Item Ledger Entry No." := ItemLedgEntryNo;
    end;


    procedure SetSourceFromHeader()
    begin
        GetHeader;
        "Source Type" := MessageHeader."Source Type";
        "Source Subtype" := MessageHeader."Source Subtype";
        "Source ID" := MessageHeader."Source ID";
        "Source Batch Name" := MessageHeader."Source Batch Name";
        "Source Prod. Order Line" := MessageHeader."Source Prod. Order Line";
        "Source Ref. No." := MessageHeader."Source Ref. No.";
        "Item Ledger Entry No." := MessageHeader."Item Ledger Entry No.";
    end;


    procedure InitSameLevelLine(var NewMessageLine: Record "Integration Message Line EDMS")
    begin
        TestField("Message ID");

        Clear(NewMessageLine);
        NewMessageLine."Message ID" := "Message ID";
        NewMessageLine."Parent Line No." := "Parent Line No.";
    end;


    procedure AddSameLevelLine(var NewMessageLine: Record "Integration Message Line EDMS")
    begin
        InitSameLevelLine(NewMessageLine);
        NewMessageLine.Insert(true);
    end;


    procedure InitChildLine(var NewMessageLine: Record "Integration Message Line EDMS")
    begin
        TestField("Message ID");
        TestField("Line No.");

        Clear(NewMessageLine);
        NewMessageLine."Message ID" := "Message ID";
        NewMessageLine."Parent Line No." := "Line No.";
    end;


    procedure AddChildLine(var NewMessageLine: Record "Integration Message Line EDMS")
    begin
        InitChildLine(NewMessageLine);
        NewMessageLine.Insert(true);
    end;


    procedure PrepareLines(MessageID: Integer; MessageLineNo: Integer): Boolean
    begin
        Reset;
        SetRange("Message ID", MessageID);
        SetRange("Parent Line No.", MessageLineNo);
        exit(FindFirst);
    end;


    procedure PrepareLinesOnMessage(var SourceMessageHeader: Record "Integration Message EDMS"): Boolean
    begin
        Reset;
        if (SourceMessageHeader.ID = 0) then
            SetFilter("Message ID", '0&1')
        else begin
            SetRange("Message ID", SourceMessageHeader.ID);
            SetRange("Parent Line No.", 0);
        end;

        exit(FindFirst);
    end;


    procedure PrepareLinesOnLine(var SourceMessageLine: Record "Integration Message Line EDMS"): Boolean
    begin
        Reset;
        if (SourceMessageLine."Message ID" = 0) or
           (SourceMessageLine."Line No." = 0)
        then
            SetFilter("Message ID", '0&1')
        else begin
            SetRange("Message ID", SourceMessageLine."Message ID");
            SetRange("Parent Line No.", SourceMessageLine."Line No.");
        end;

        exit(FindFirst);
    end;
}

