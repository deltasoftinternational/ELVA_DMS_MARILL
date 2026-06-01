Report 25006004 "Process Checklist"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ProcessChecklist.rdlc';
    Caption = 'Process Checklist';

    dataset
    {
        dataitem("Process Checklist Header"; "Process Checklist Header")
        {
            column(ReportForNavId_9863; 9863)
            {
            }
            column(No_ProcessChecklistHeader; "Process Checklist Header"."No.")
            {
                IncludeCaption = true;
            }
            column(VIN_ProcessChecklistHeader; "Process Checklist Header".VIN)
            {
                IncludeCaption = true;
            }
            column(TemplateCode_ProcessChecklistHeader; "Process Checklist Header"."Template Code")
            {
                IncludeCaption = true;
            }
            column(SourceID_ProcessChecklistHeader; "Process Checklist Header"."Source ID")
            {
                IncludeCaption = true;
            }
            column(GetFiltersExpr; GetFiltersExpr)
            {
            }
            column(ForInput; ForInput)
            {
            }
            dataitem("Process Checklist Line"; "Process Checklist Line")
            {
                DataItemLink = "Process Checklist No." = field("No.");
                DataItemTableView = sorting("Process Checklist No.", "Line No.");
                column(ReportForNavId_6432; 6432)
                {
                }
                column(TypeDescription_ProcessChecklistLine; "Process Checklist Line"."Type Description")
                {
                    IncludeCaption = true;
                }
                column(ValueDescription_ProcessChecklistLine; "Process Checklist Line"."Value Description")
                {
                }
                column(ProcessChecklistNo_ProcessChecklistLine; "Process Checklist Line"."Process Checklist No.")
                {
                }
                column(LineNo_ProcessChecklistLine; "Process Checklist Line"."Line No.")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                GetFiltersExpr := GetFilters;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ForInput; ForInput)
                    {
                        ApplicationArea = Basic;
                        Caption = 'For Input';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitleLbl = 'Process Checklist';
        TypeLbl = 'Type';
        ValueLbl = 'Value';
    }

    var
        ForInput: Boolean;
        Process_ChecklistCaptionLbl: label 'Process Checklist';
        Process_Checklist_Line__Type_Description__Control1190003CaptionLbl: label 'Type';
        Process_Checklist_Line__Value_Description_CaptionLbl: label 'Value';
        GetFiltersExpr: Text[250];
}

