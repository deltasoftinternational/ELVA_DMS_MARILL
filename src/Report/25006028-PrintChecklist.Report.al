Report 25006028 "Print Checklist"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PrintChecklist.rdlc';

    dataset
    {
        dataitem(ItemGHCheckListBuffer; "Checklist Buffer")
        {
            UseTemporary = true;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Item_LineNo; ItemGHCheckListBuffer."Line No.")
            {
            }
            column(Item_Type; ItemGHCheckListBuffer.Type)
            {
            }
            column(Item_Caption; ItemGHCheckListBuffer.Caption)
            {
            }
            dataitem(ControlGHCheckListBuffer; "Checklist Buffer")
            {
                DataItemLink = "Parent Line No." = field("Line No.");
                UseTemporary = true;
                column(ReportForNavId_1000000004; 1000000004)
                {
                }
                column(Control_ParentLineNo; ControlGHCheckListBuffer."Parent Line No.")
                {
                }
                column(Control_Value; ControlGHCheckListBuffer.Value)
                {
                }
                column(Control_Color; ControlGHCheckListBuffer.Color)
                {
                }
                column(Control_Caption; ControlGHCheckListBuffer.Caption)
                {
                }
                column(Control_SubType; ControlGHCheckListBuffer."Sub Type")
                {
                }
                column(Control_Selected; ControlGHCheckListBuffer.Selected)
                {
                }
                column(Control_AssistEdit; ControlGHCheckListBuffer."Assist Edit")
                {
                }
                column(Control_Filter; 'True')
                {
                }
            }
        }
        dataitem(ChecklistHeader; "Process Checklist Header")
        {
            UseTemporary = true;
            column(ReportForNavId_1000000006; 1000000006)
            {
            }
            column(CH_No; ChecklistHeader."No.")
            {
                IncludeCaption = true;
            }
            column(CH_TemplateCode; ChecklistHeader."Template Code")
            {
                IncludeCaption = true;
            }
            column(CH_VehicleRegNo; ChecklistHeader."Vehicle Registration No.")
            {
                IncludeCaption = true;
            }
            column(CH_LocationCode; ChecklistHeader."Location Code")
            {
                IncludeCaption = true;
            }
            column(CH_ProcessStatus; ChecklistHeader."Process Status")
            {
                IncludeCaption = true;
            }
            column(CH_ConfirmedByAdvisor; ChecklistHeader."Confirmed by Advisor")
            {
                IncludeCaption = true;
            }
            column(CH_Filter; 'True')
            {
            }
            column(CH_VehicleDescription; ChecklistHeader.VehicleDescription)
            {
            }
            column(CustomerSignatureImage; "Customer Signature Image")
            {
            }
            column(CustomerSignatureName; "Customer Signature Text")
            {
            }
            column(EmployeeSignatureImage; "Employee Signature Image")
            {
            }
            column(EmployeeSignatureName; "Employee Signature Text")
            {
            }
            column(ServicePersonNameCaption; ServicePesronNameLbl)
            {
            }
            column(ServicePersonSignatureCaption; ServicePersonSignatureLbl)
            {
            }
            column(CustomerNameCaption; CustomerNameLbl)
            {
            }
            column(CustomerSignatureCaption; CustomerSignatureLbl)
            {
            }
            dataitem(Picture; Picture)
            {
                DataItemLink = "Source ID" = field("No.");
                DataItemTableView = where("Source Type" = const(25006025), "Source Subtype" = const("0"), "Source Ref. No." = const(0));
                column(ReportForNavId_1000000028; 1000000028)
                {
                }
                column(Image; Picture.Blob)
                {
                }
                column(PIC_Filter; 'True')
                {
                }
            }
        }
        dataitem(CompanyInformation; "Company Information")
        {
            CalcFields = Picture, "Invoice Header Picture", "Invoice Footer Picture", "Invoice Disclaimer Picture";
            column(ReportForNavId_1000000022; 1000000022)
            {
            }
            column(CI_Picture; Picture)
            {
            }
            column(CI_InvoiceHeaderPicture; "Invoice Header Picture")
            {
            }
            column(CI_InvoiceFooterPicture; "Invoice Footer Picture")
            {
            }
            column(CI_InvoiceDisclaimerPicture; "Invoice Disclaimer Picture")
            {
            }
            column(CI_Filter; 'True')
            {
            }
            column(Setup_CheckBoxChecked; ProcessChecklistSetup."CheckBox Checked")
            {
            }
            column(Setup_CheckBoxUnchecked; ProcessChecklistSetup."CheckBox Unchecked")
            {
            }
            column(Setup_PrintPictures; PrintPictures)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ProcessChecklistSetup.Get;
                ProcessChecklistSetup.CalcFields("CheckBox Checked", "CheckBox Unchecked");
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
                    field(PrintPictures; PrintPictures)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Pictures';
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
    }

    var
        ProcessChecklistSetup: Record "Process Checklist Setup";
        PrintPictures: Boolean;
        ServicePesronNameLbl: label 'Service Person Name, Surname';
        ServicePersonSignatureLbl: label 'Service Person Signature';
        CustomerNameLbl: label 'Customer Name, Surname';
        CustomerSignatureLbl: label 'Customer Person Signature';


    procedure FillItemCheckList(var GHCheckList: Record "Checklist Buffer")
    begin
        GHCheckList.Reset;
        GHCheckList.SetFilter(Type, '%1|%2', GHCheckList.Type::Group, GHCheckList.Type::Item);
        if GHCheckList.FindFirst then
            repeat
                ItemGHCheckListBuffer.Init;
                ItemGHCheckListBuffer := GHCheckList;
                ItemGHCheckListBuffer.Insert;
            until GHCheckList.Next = 0;

        GHCheckList.Reset;
        GHCheckList.SetFilter(Type, '<>%1', GHCheckList.Type::Group);
        GHCheckList.SetFilter(Type, '<>%1', GHCheckList.Type::Item);
        if GHCheckList.FindFirst then
            repeat
                ControlGHCheckListBuffer.Init;
                ControlGHCheckListBuffer := GHCheckList;
                ControlGHCheckListBuffer.Insert;
            until GHCheckList.Next = 0;
    end;


    procedure SetCheckListHeader(ProcessChecklistHeaderToSet: Record "Process Checklist Header")
    begin
        ChecklistHeader.DeleteAll;
        ChecklistHeader.Init;
        ProcessChecklistHeaderToSet.CalcFields("Employee Signature Image", "Customer Signature Image");
        ChecklistHeader := ProcessChecklistHeaderToSet;
        ChecklistHeader.Insert;
    end;
}

