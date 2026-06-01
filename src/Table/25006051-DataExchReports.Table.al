Table 25006051 "Data Exch. Reports"
{
    // 22.10.2007. EDMS P2
    //   * Added field "Take From Lines"
    // 
    // 27.08.2007. EDMS P2
    //   * Created

    Caption = 'Data Exch. Reports';

    fields
    {
        field(5; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(10; "Document Functional Type"; Option)
        {
            Caption = 'Document Functional Type';
            OptionCaption = ',Sale,Purchase,Service';
            OptionMembers = ,Sale,Purchase,Service;
        }
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Shipment,Transfer,Posted Order,Posted Invoice,Posted Credit Memo,Posted Return Order,Posted Shipment';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,Transfer,"Posted Order","Posted Invoice","Posted Credit Memo","Posted Return Order","Posted Shipment";
        }
        field(30; Sequence; Code[10])
        {
            Caption = 'Sequence';
            Numeric = true;
        }
        field(40; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            //TableRelation = Object.ID where (Type=const(Report));
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
            begin
                //CALCFIELDS("Report Name");
            end;
        }
        field(50; "Report Name"; Text[80])
        {
            Caption = 'Report Name';
        }
        field(60; "Take From Lines"; Boolean)
        {
            Caption = 'Take From Lines';
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
        if "Report Name" <> '' then
            exit("Report Name");

        AllObjWithCaption.Reset;
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."object type"::Report);
        AllObjWithCaption.SetRange("Object ID", "Report ID");
        if AllObjWithCaption.FindFirst then
            exit(AllObjWithCaption."Object Caption");

        exit('');
    end;
}

