tableextension 25006142 "Transfer Header" extends "Transfer Header" //5740
{
    // 21.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     "Receipt Dimension Set ID"
    //   Added functions:
    //     ShowDocReceiptDim
    //     UpdateAllLineReceiptDim
    //     CreateReceiptDim
    //   Modified trigger:
    //     Transfer-to Code - OnValidate()
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Receipt Dimension Set ID"; Integer)
        {
            Caption = 'receipt Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocReceiptDim;
            end;
        }
        field(25006010; "New Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1,' + Text107;
            Caption = 'New Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateNewShortcutDimCode(1, "New Shortcut Dimension 1 Code");
            end;
        }
        field(25006020; "New Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2,' + Text107;
            Caption = 'New Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateNewShortcutDimCode(2, "New Shortcut Dimension 2 Code");
            end;
        }
        field(25006100; "Transfer-to Customer No."; Code[20])
        {
            Caption = 'Transfer-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                if "Transfer-to Customer No." = '' then begin
                    "Transfer-to Customer Name" := '';
                    exit;
                end;
                if Cust.Get("Transfer-to Customer No.") then
                    "Transfer-to Customer Name" := Cust.Name;
            end;
        }
        field(25006110; "Transfer-to Customer Name"; Text[100])
        {
            Caption = 'Transfer-to Customer Name';
        }
        field(25006160; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            Editable = false;

            trigger OnValidate()
            var
                TransferLine: Record "Transfer Line";
            begin
                TransferLine.Reset;
                TransferLine.SetRange("Document No.", "No.");
                if TransferLine.FindFirst then
                    Error(Text101, FieldCaption("Source Type"), "No.");
            end;
        }
        field(25006166; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";

            trigger OnValidate()
            var
                TransferLine: Record "Transfer Line";
            begin
                TransferLine.Reset;
                TransferLine.SetRange("Document No.", "No.");
                if TransferLine.FindFirst then
                    Error(Text101, FieldCaption("Source Subtype"), "No.");

                Validate("Source No.", '');
            end;
        }
        field(25006200; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(25006145)) "Service Header EDMS"."No." where("Document Type" = field("Source Subtype"));

            trigger OnValidate()
            var
                TransferLine: Record "Transfer Line";
            begin
                TransferLine.Reset;
                TransferLine.SetRange("Document No.", "No.");
                if TransferLine.FindFirst then
                    Error(Text101, FieldCaption("Source No."), "No.");
            end;
        }
        field(25006201; "Transfer-to Vehicle Serial No."; Code[20])
        {
            Caption = 'Transfer-to Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
                if "Transfer-to Vehicle Serial No." = '' then begin
                    "Transfer-to Vehicle Make Code" := '';
                    "Transfer-to Vehicle Model Code" := '';
                    "Transfer-to Vehicle VIN" := '';
                    exit;
                end;
                if Vehicle.Get("Transfer-to Vehicle Serial No.") then begin
                    "Transfer-to Vehicle Make Code" := Vehicle."Make Code";
                    "Transfer-to Vehicle Model Code" := Vehicle."Model Code";
                    "Transfer-to Vehicle VIN" := Vehicle.VIN;
                end;
            end;
        }
        field(25006202; "Transfer-to Vehicle Make Code"; Code[20])
        {
            Caption = 'Transfer-to Vehicle Make Code';
            TableRelation = Vehicle;
        }
        field(25006203; "Transfer-to Vehicle Model Code"; Code[20])
        {
            Caption = 'Transfer-to Vehicle Model Code';
            TableRelation = Vehicle;
        }
        field(25006204; "Transfer-to Vehicle VIN"; Code[20])
        {
            Caption = 'Transfer-to Vehicle VIN';
            TableRelation = Vehicle;
        }
        field(25006210; "Combined Order"; Boolean)
        {
            Caption = 'Combined Order';
        }
        field(25007407; "Document Status"; Code[20])
        {
            Caption = 'Document Status';
            DataClassification = ToBeClassified;
            TableRelation = "Document Status".Code where("Document Type" = const("Transfer Order"),
                                                          "Document Profile" = const(Service));
        }

        modify("Transfer-to Code")
        {
            trigger OnAfterValidate()
            begin
                if xRec."Transfer-to Code" <> "Transfer-to Code" then begin
                    CreateReceiptDim(Database::Location, "Transfer-to Code");
                end;
            END;
        }

    }

    keys
    {
        key(Key2; "Document Profile")
        {
        }
        key(Key3; "Source Type", "Source Subtype", "Source No.", "Document Profile")
        {
        }
    }
    var
        TransLine: Record "Transfer Line";
        DimMgt: Codeunit DimensionManagement;
        Text101: label 'You cannot change %1 while there exist transfer lines for transfer order %2.';
        Text102: label 'Do you want to update the lines?';
        Text107: label 'New ';
        Text007: Label 'You may have changed a dimension.\\Do you want to update the lines?';


    procedure ValidateNewShortcutDimCode(FieldNumber: Integer; NewShortcutDimCode: Code[20])
    var
        TransferLine: Record "Transfer Line";
    begin
        TransferLine.Reset;
        TransferLine.SetRange("Document No.", "No.");
        if not TransferLine.FindFirst then
            exit;

        if not Confirm(Text102) then
            exit;

        case FieldNumber of
            1:
                TransferLine.ModifyAll("From Location Dimension 1 Code", NewShortcutDimCode);
            2:
                TransferLine.ModifyAll("From Location Dimension 2 Code", NewShortcutDimCode);
        end;
    end;


    procedure ShowDocReceiptDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Receipt Dimension Set ID";
        "Receipt Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Receipt Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Receipt Dimension Set ID" then begin
            Modify;
            if TransferLinesExist then
                UpdateAllLineReceiptDim("Receipt Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure UpdateAllLineReceiptDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
    begin
        if "Document Profile" <> "document profile"::"Vehicles Trade" then
            exit;

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not HideValidationDialog then
            if not Confirm(Text007) then
                exit;

        TransLine.Reset;
        TransLine.SetRange("Document No.", "No.");
        TransLine.LockTable;
        if TransLine.Find('-') then
            repeat
                if (TransLine.Quantity = TransLine."Quantity Shipped") and (TransLine.Quantity <> TransLine."Quantity Received") then begin
                    NewDimSetID := DimMgt.GetDeltaDimSetID(TransLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                    if TransLine."Dimension Set ID" <> NewDimSetID then begin
                        TransLine."Dimension Set ID" := NewDimSetID;
                        DimMgt.UpdateGlobalDimFromDimSetID(
                          TransLine."Dimension Set ID", TransLine."Shortcut Dimension 1 Code", TransLine."Shortcut Dimension 2 Code");
                        TransLine.Modify;
                    end;
                end;
            until TransLine.Next = 0;
    end;


    procedure CreateReceiptDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        DimMgt: Codeunit DimensionManagement;
        Dimsource: List of [Dictionary of [Integer, code[20]]];
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;


        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';

        /* "Receipt Dimension Set ID" :=
        DimMgt.GetDefaultDimID(
           TableID, No, SourceCodeSetup.Transfer,
           "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Receipt Dimension Set ID", Database::Location);*/
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, Type1, No1);
        "Receipt Dimension Set ID" := DimMgt.GetDefaultDimID(Dimsource, sourceCodeSetup.Transfer,
           "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Receipt Dimension Set ID", Database::Location);
    end;

}