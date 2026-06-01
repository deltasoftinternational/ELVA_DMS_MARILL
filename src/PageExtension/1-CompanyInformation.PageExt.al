pageextension 25006001 "Company Information" extends "Company Information" //1
{
    layout
    {
        addafter(Experience)
        {
            group(ReportDesignTemplates)
            {
                Caption = 'Report Design Templates';
                field(InvoiceHeaderPicture; Rec."Invoice Header Picture")
                {
                    ApplicationArea = Basic;
                }
                field(InvoiceFooterPicture; Rec."Invoice Footer Picture")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}