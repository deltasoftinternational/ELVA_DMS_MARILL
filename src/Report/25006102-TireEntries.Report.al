Report 25006102 "Tire Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TireEntries.rdlc';

    dataset
    {
        dataitem("Tire Entry"; "Tire Entry")
        {
            DataItemTableView = sorting("Document No.", "Posting Date");
            RequestFilterFields = "Posting Date";
            column(ReportForNavId_1; 1)
            {
            }
            column(EntryNo_TireEntry; "Tire Entry"."Entry No.")
            {
                IncludeCaption = true;
            }
            column(VehicleSerialNo_TireEntry; "Tire Entry"."Vehicle Serial No.")
            {
                IncludeCaption = true;
            }
            column(VehicleAxleCode_TireEntry; "Tire Entry"."Vehicle Axle Code")
            {
                IncludeCaption = true;
            }
            column(TirePositionCode_TireEntry; "Tire Entry"."Tire Position Code")
            {
                IncludeCaption = true;
            }
            column(TireCode_TireEntry; "Tire Entry"."Tire Code")
            {
                IncludeCaption = true;
            }
            column(EntryType_TireEntry; "Tire Entry"."Entry Type")
            {
                IncludeCaption = true;
            }
            column(PostingDate_TireEntry; "Tire Entry"."Posting Date")
            {
            }
            column(PostingDateFormat_TireEntry; Format("Tire Entry"."Posting Date"))
            {
            }
            column(VariableFieldRun1_TireEntry; "Tire Entry"."Variable Field Run 1")
            {
                IncludeCaption = true;
            }
            column(DocumentNo_TireEntry; "Tire Entry"."Document No.")
            {
                IncludeCaption = true;
            }
            column(Open_TireEntry; Format("Tire Entry".Open))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Document No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        PostingDateLbl = 'Posting Date';
        ReportTitleLbl = 'Tire Entry';
        StatusLbl = 'Status\(in use)';
    }

    trigger OnPreReport()
    begin
        CompInfo.CalcFields(Picture);
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        CompInfo: Record "Company Information";
}

