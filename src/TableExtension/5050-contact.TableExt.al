tableextension 25006069 "contact" extends "contact"  //5050
{
    // 03.07.2015 EB.P30
    //   Specified Table DrillDownPageID
    // 
    // 28.01.2008 EDMS P3
    //         * SalesPerson on interaction
    // 30-07-2007 EDMS P3 CRM
    //   * New procedures ShowQuickCust & MakeQuickCust, Const Text100 - for fast creation of customer
    // 07-08-2007 EDMS P3
    //   * New field 25006000 - birthday
    // 08-08-2007 EDMS P3
    //   * There was errorneous logic
    // 10-08-2007 EDMS P3
    //   * CheckObligatoryFields - for fields checking
    //   * MakeQuickCust - added return parameter
    fields
    {
        field(25006000; Birthday; Date)
        {
            Caption = 'Birthday';
        }
        field(25006010; "Last User Modified"; Code[50])
        {
            Caption = 'Last User Modified';
            Editable = false;
        }
    }

    procedure ShowQuickCust()
    var
        FormSelected: Boolean;
        Cust: Record Customer;
    begin
        FormSelected := true;

        ContBusRel.Reset;
        ContBusRel.SetRange("Contact No.", "Company No.");
        ContBusRel.SetFilter("No.", '<>''''');
        ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Customer);

        case ContBusRel.Count of
            0:
                FormSelected := MakeQuickCust();  //08-08-2007 EDMS P3
            1:
                ContBusRel.FindFirst;
            else
                FormSelected := Page.RunModal(Page::"Contact Business Relations", ContBusRel) = Action::LookupOK;
        end;

        if FormSelected then begin
            Cust.Get(ContBusRel."No.");
            Page.Run(Page::"Customer Card", Cust);
        end
    end;

    procedure MakeQuickCust(): Boolean
    var
        Selection: Integer;
    begin
        Selection := StrMenu(Text100, 1);

        case Selection of
            0:
                exit(false);  //08-08-2007 EDMS P3
            1:
                CreateCustomerLink;
            2:
                CreateCustomerFromTemplate(rec.ChooseNewCustomerTemplate);
        end;
        exit(true) //08-08-2007 EDMS P3
    end;

    var
        ContBusRel: Record "Contact Business Relation";
        Text100: label 'Link with existing Customer,Create as Customer';
}