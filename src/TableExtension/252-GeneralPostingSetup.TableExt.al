tableextension 25006042 "General Posting Setup" extends "General Posting Setup" //252
{
    // 29.08.2018 EB.P30 EDMS
    //   Added fields:
    //     25006060"Labor Cost Account"
    //     25006070"Labor Cost Adjustment Account"
    // 
    // 11.04.2008 EDMS P3
    //  * Added new field Veh. Add. Expenses Account for Vehicle Additional Expenses functionality
    fields
    {
        field(25006000; "Service Prepayments Account"; Code[20])
        {
            Caption = 'Service Prepayments Account';
            TableRelation = "G/L Account";
        }
        field(25006010; "Veh. Add. Expenses Account"; Code[20])
        {
            Caption = 'Veh. Add. Expenses Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Veh. Add. Expenses Account");
            end;
        }
        field(25006020; "WIP Accured Cost Acc."; Code[10])
        {
            Caption = 'WIP Accured Cost Acc.';
            TableRelation = "G/L Account";
        }
        field(25006030; "WIP Accured Sales Acc."; Code[10])
        {
            Caption = 'WIP Accured Sales Acc.';
            TableRelation = "G/L Account";
        }
        field(25006040; "WIP Cost Adjustment Acc."; Code[10])
        {
            Caption = 'WIP Cost Adjustment Acc.';
            TableRelation = "G/L Account";
        }
        field(25006050; "WIP Sales Adjusment Acc."; Code[10])
        {
            Caption = 'WIP Sales Adjusment Acc.';
            TableRelation = "G/L Account";
        }
        field(25006060; "Labor Cost Account"; Code[20])
        {
            Caption = 'Labor Cost Account';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(25006070; "Labor Cost Adjustment Account"; Code[20])
        {
            Caption = 'Labor Cost Adjustment Account';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
    }
}