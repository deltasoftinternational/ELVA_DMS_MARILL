Page 25006026 "Vehicle Warranty Card"
{
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added fields new

    Caption = 'Vehicle Warranty Card';
    PageType = Document;
    SourceTable = "Vehicle Warranty";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(VehicleSerialNo; rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the the vehicle for which this warranty is.';

                }
                field(VIN; rec.VIN)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the VIN code for the vehicle for which this warranty is.';

                }
                field(No; rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number for the vehicle warranty entry.';


                    trigger OnAssistEdit()
                    begin
                        if rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(WarrantyTypeCode; rec."Warranty Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type for the vehicle warranty.';

                }
                field(StartingDate; rec."Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date for the vehicle warranty.';
                }
                field(TermDateFormula; rec."Term Date Formula")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the warranty limit as time duration.';
                }
                field(VariableFieldRun1; rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun1Visible;
                    ToolTip = 'Specifies the warranty limit based on vehicle counter information.';
                }
                field(VariableFieldRun2; rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun2Visible;
                    ToolTip = 'Specifies the warranty limit based on vehicle counter information.';
                }
                field(VariableFieldRun3; rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun3Visible;
                    ToolTip = 'Specifies the warranty limit based on vehicle counter information.';
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status for the vehicle warranty.';
                }
                field(VariableField25006800; rec."Variable Field 25006800")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006800Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields.';
                }
                field(VariableField25006801; rec."Variable Field 25006801")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006801Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields.';
                }
                field(VariableField25006802; rec."Variable Field 25006802")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006802Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields.';
                }
                field(VariableField25006803; rec."Variable Field 25006803")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006803Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields.';
                }
                field(VariableField25006804; rec."Variable Field 25006804")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006804Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields.';
                }
                field(VariableField25006805; rec."Variable Field 25006805")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006805Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields.';
                }
                field(VariableField25006806; rec."Variable Field 25006806")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006806Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields.';
                }
                field(VariableField25006807; rec."Variable Field 25006807")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006807Visible;
                    ToolTip = 'Specifies the vehicle additional specification defined by variable fields.';
                }
                field(EndingDate; rec."Ending Date")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the ending date for the vehicle warranty.';
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies a description for the vehicle warranty.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        [InDataSet]
        VF25006800Visible: Boolean;
        [InDataSet]
        VF25006801Visible: Boolean;
        [InDataSet]
        VF25006802Visible: Boolean;
        [InDataSet]
        VF25006803Visible: Boolean;
        [InDataSet]
        VF25006804Visible: Boolean;
        [InDataSet]
        VF25006805Visible: Boolean;
        [InDataSet]
        VF25006806Visible: Boolean;
        [InDataSet]
        VF25006807Visible: Boolean;
        [InDataSet]
        VFRun1Visible: Boolean;
        [InDataSet]
        VFRun2Visible: Boolean;
        [InDataSet]
        VFRun3Visible: Boolean;


    procedure SetVariableFields()
    begin
        //Variable Fields
        VF25006800Visible := rec.IsVFActive(rec.FieldNo("Variable Field 25006800"));
        VF25006801Visible := rec.IsVFActive(rec.FieldNo("Variable Field 25006801"));
        VF25006802Visible := rec.IsVFActive(rec.FieldNo("Variable Field 25006802"));
        VF25006803Visible := rec.IsVFActive(rec.FieldNo("Variable Field 25006803"));
        VF25006804Visible := rec.IsVFActive(rec.FieldNo("Variable Field 25006804"));
        VF25006805Visible := rec.IsVFActive(rec.FieldNo("Variable Field 25006805"));
        VF25006806Visible := rec.IsVFActive(rec.FieldNo("Variable Field 25006806"));
        VF25006807Visible := rec.IsVFActive(rec.FieldNo("Variable Field 25006807"));
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
    end;


    procedure SetRange(VehSerialNo: Code[20])
    begin
        rec.SetRange("Vehicle Serial No.", VehSerialNo);
    end;
}

