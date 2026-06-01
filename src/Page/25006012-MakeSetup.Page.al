Page 25006012 "Make Setup"
{
    // #Include EDMS.Integration
    // 
    // 22.08.2018 EB.ASM EDMS.Integration
    //   Added fast tab:
    //     Integration
    // 
    // 16.05.2014 Elva Baltic P8 #S016 MMG7.00
    //   * added fields:
    //     Common
    // 
    // 03.03.2014 Elva Baltic P7 #R114 MMG7.00
    //   * Added Field "Service Warranty (years)"

    Caption = 'Make Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Make Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DefaultCMVATProdPostGrp; rec."Default CM VAT Prod. Post. Grp")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a different VAT Product Posting group if system should automatically change it in service lines for credit memos.';
                }
                field(UseVehicleAssemblies; rec."Vehicle Assembly Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if it is mandatory to have vehicle assembly for sales or purchase documents for vehicle of this brand.';
                }
                //field(ProcessICInboxDocuments; "Process IC Inbox Documents")
                //{
                //    ApplicationArea = Basic;
                //}
                field(PDIServicePackageNo; rec."PDI Service Package No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service package, that should be automatically applied in PDI service documents created for vehicles of this make.';
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field(StandardOptionNos; rec."Standard Option Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to vehicle option codes.';
                }
            }
            group(Integration)
            {
                Caption = 'Integration';
                field(IntegrationConnectorCode; rec."Integration Connector Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the integration connector that is used in integrations related to this make.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        TargetMakeCode: Code[20];
    begin
        TargetMakeCode := rec.GetRangeMin("Make Code");

        rec.Reset;
        if not rec.Get(TargetMakeCode) then begin
            rec.Init;
            rec."Make Code" := TargetMakeCode;
            rec.Insert;
        end;
    end;
}

