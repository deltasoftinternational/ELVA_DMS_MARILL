Table 25006011 "Document Report"
{
    // 28.09.2007. EDMS P2
    //   * Added field Take From Lines

    Caption = 'Document Report';

    fields
    {
        field(5; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ',Spare Parts Trade,Vehicles Trade,Service,Rent';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service,Rent;
        }
        field(10; "Document Functional Type"; Option)
        {
            Caption = 'Document Functional Type';
            OptionCaption = ' ,Sale,Purchase,Service,Rent';
            OptionMembers = " ",Sale,Purchase,Service,Rent;
        }
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Shipment,Transfer,Posted Order,Posted Invoice,Posted Credit Memo,Posted Return Order,Posted Shipment,Contract,Process Checklist';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,Transfer,"Posted Order","Posted Invoice","Posted Credit Memo","Posted Return Order","Posted Shipment",Contract,"Process Checklist";
        }
        field(30; Sequence; Code[10])
        {
            Caption = 'Sequence';
            Numeric = true;
        }
        field(40; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));

            trigger OnLookup()
            var
                ReportID: Integer;
            begin
                ReportID := 0;
                LookUpMgt.LookUpReport(ReportID);
                if ReportID <> 0 then
                    Validate("Report ID", ReportID);
            end;

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
            begin
                //CALCFIELDS("Report Name");
                //>>Delta
                if AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Report, "Report ID") then
                    Rec."Custom Name" := AllObjWithCaption."Object Caption"
                else
                    Rec."Custom Name" := '';
                //<<Delta
            end;
        }
        field(50; "Custom Name"; Text[80])
        {
            Caption = 'Custom Name';
        }
        field(60; "Take From Lines"; Boolean)
        {
            Caption = 'Take From Lines';
        }
        field(70; "Customer Signature"; Boolean)
        {
            Caption = 'Customer Signature';
        }
        field(80; "Employee Signature"; Boolean)
        {
            Caption = 'Employee Signature';
        }
        field(90; "E-mail To"; Option)
        {
            Caption = 'E-mail To';
            OptionCaption = 'Customer/Vendor,Contact';
            OptionMembers = CustomerVendor,Contact;
        }
    }

    keys
    {
        key(Key1; "Document Profile", "Document Functional Type", "Document Type", Sequence)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ReportSelection2: Record "Document Report";
        LookUpMgt: Codeunit LookUpManagement;


    procedure NewRecord()
    begin
        ReportSelection2.SetRange("Document Profile", "Document Profile");
        ReportSelection2.SetRange("Document Functional Type", "Document Functional Type");
        ReportSelection2.SetRange("Document Type", "Document Type");
        if ReportSelection2.FindLast and (ReportSelection2.Sequence <> '') then
            Sequence := IncStr(ReportSelection2.Sequence)
        else
            Sequence := '1';
    end;


    procedure ShowReportName(): Text[80]
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        if "Custom Name" <> '' then
            exit("Custom Name");

        AllObjWithCaption.Reset;
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."object type"::Report);
        AllObjWithCaption.SetRange("Object ID", "Report ID");
        if AllObjWithCaption.FindFirst then
            exit(AllObjWithCaption."Object Caption");

        exit('');
    end;
}

