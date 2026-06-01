tableextension 25006139 "Cost Element Buffer" extends "Cost Element Buffer" //5820
{
    // 30.08.2013 EDMS P8
    //   * fix to store data. It could situations when temporary line data filled but then need to save it - purpose not to loose amounts, some times because of movements lost amounts
    // 
    // 08.01.2009. EDMS P2
    //   * Added fields "Gen. Prod. Posting Group", "Gen. Bus. Posting Group" to group cost adjustments for vehicles by it
    //   * Added code AddActualCost2, AddExpectedCost2, AddRndgResidual2, Retreive2
    // 
    // 24-08-2007 EDMS P3
    //   * Added new field "Inventory Posting Group" to group cost adjustments for vehicles by it
    //   * To AddActualCost, AddExpectedCost, AddRndgResidual  added new parameter - to group by Invt. posting group
    //   * Created Retreive2 procedure to support new field "Inventory Posting Group"

    fields
    {
        field(25006000; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(25006010; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
        }
    }

    keys
    {

        //  Modify PK key !!!
        /*
        key(Key1; Type, "Variance Type", "Inventory Posting Group", "Gen. Prod. Posting Group")
        {
            Clustered = true;
        }
        key(Key3; "Inventory Posting Group", "Gen. Prod. Posting Group")
        {
            SumIndexFields = "Actual Cost", "Actual Cost (ACY)", "Expected Cost", "Expected Cost (ACY)";
        }
        */
    }

}
