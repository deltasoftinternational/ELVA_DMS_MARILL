Table 25006143 "External Serv. Journal Line"
{
    Caption = 'External Serv. Journal Line';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Ext. Service Journal Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "External Serv. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Ext. Service No."; Code[20])
        {
            Caption = 'Ext. Service No.';
            TableRelation = "External Service";

            trigger OnValidate()
            begin
                if "Ext. Service No." = '' then begin
                    CreateDim(
                      Database::"External Service", "Ext. Service No.");
                    exit;
                end;

                ExtService.Get("Ext. Service No.");
                ExtService.TestField(Blocked, false);
                Description := ExtService.Description;

                CreateDim(
                  Database::"External Service", "Ext. Service No.");
            end;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(9; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(11; "Ext. Service Tracking No."; Code[20])
        {
            Caption = 'Ext. Service Tracking No.';
            TableRelation = "External Serv. Tracking No."."External Serv. Tracking No." where("External Service No." = field("Ext. Service No."));
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(18; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code"); 26.10.2012 EDMS
            end;
        }
        field(19; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");  26.10.2012 EDMS
            end;
        }
        field(21; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(24; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(31; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(32; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(33; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(34; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Customer)) Customer."No."
            else
            if ("Source Type" = const(Vendor)) Vendor."No.";
        }
        field(60; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(70; "Vehicle Serial No."; Code[20])
        {

        }
        field(80; "Vehicle Registration No."; Code[20])
        {

        }
        field(90; "VIN"; Code[20])
        {

        }
        field(100; "Make Code"; Code[20])
        {

        }
        field(110; "Model Code"; Code[20])
        {

        }
        field(120; "Service Order No."; Code[20])
        {

        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // 26.10.2012 EDMS >>
        /*
        DimMgt.DeleteJnlLineDim(
          DATABASE::"External Serv. Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0);
        */
        // 26.10.2012 EDMS <<

    end;

    trigger OnInsert()
    begin
        LockTable;
        ExtServiceJnlTemplate.Get("Journal Template Name");
        ExtServiceJnlBatch.Get("Journal Template Name", "Journal Batch Name");


        // 26.10.2012 EDMS >>
        /*
        ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
        
        DimMgt.InsertJnlLineDim(
          DATABASE::"External Serv. Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        */
        // 26.10.2012 EDMS <<

    end;

    var
        ExtServiceJnlTemplate: Record "Ext. Service Journal Template";
        ExtServiceJnlBatch: Record "External Serv. Journal Batch";
        ExtServiceJnlLine: Record "External Serv. Journal Line";
        ExtService: Record "External Service";
        DimMgt: Codeunit DimensionManagement;
        NoSeriesMgt: Codeunit "No. Series";


    procedure EmptyLine(): Boolean
    begin
        exit(("Ext. Service No." = '') and (Quantity = 0));
    end;


    procedure SetUpNewLine(LastExtServiceJnlLine: Record "External Serv. Journal Line")
    begin
        ExtServiceJnlTemplate.Get("Journal Template Name");
        ExtServiceJnlBatch.Get("Journal Template Name", "Journal Batch Name");
        ExtServiceJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        ExtServiceJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if ExtServiceJnlLine.FindFirst then begin
            "Posting Date" := LastExtServiceJnlLine."Posting Date";
            "Document No." := LastExtServiceJnlLine."Document No.";
        end else begin
            "Posting Date" := WorkDate;
            if ExtServiceJnlBatch."No. Series" <> '' then begin
                Clear(NoSeriesMgt);
                "Document No." := NoSeriesMgt.PeekNextNo(ExtServiceJnlBatch."No. Series", "Posting Date");
            end;
        end;
        "Source Code" := ExtServiceJnlTemplate."Source Code";
        "Reason Code" := ExtServiceJnlBatch."Reason Code";
        "Posting No. Series" := ExtServiceJnlBatch."Posting No. Series";
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        Dimsource: List of [Dictionary of [Integer, code[20]]];

    begin
        //TableID[1] := Type1;
        //No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, Type1, No1);
        DimMgt.GetDefaultDimID(
          Dimsource, "Source Code",
          "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1 %2 %3', "Journal Template Name", "Journal Batch Name", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;
}

