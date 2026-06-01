tableextension 25006025 "Sales Price" extends "Sales Price" //7002
{
    // 25.11.2015 EB.P7 #T017
    //   Trigger code moved to events
    // 
    // 14.05.2014 Elva Baltic P8 #S0038 MMG7.00
    //   * PERFORMANCE ISSUE resolve. Added key.
    // 
    // 30.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Make Code added to the primary key


    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006002; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Make;
        }
        field(25006007; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006010; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Description = 'Only for Vehicle Trade';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));
        }
        field(25006120; "Source Type"; Option)
        {
            Caption = 'Source Type';
            Editable = false;
            OptionCaption = 'User,Contract';
            OptionMembers = User,Contract;
        }
        field(25006130; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
        }
        field(25006140; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(25006373; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Only for Vehicle Trade';
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006770; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,7002,25006800';
        }
    }
    /*
      keys
      {
          key(Key1; "Item No.", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code", "Location Code", "Document Profile", "Vehicle Serial No.", "Variable Field 25006800", "Make Code")
          {
              Clustered = true;
          }
          key(Key4; "Item No.", "Make Code", "Model Code", "Model Version No.", "Vehicle Serial No.", "Document Profile")
          {
          }
      }
      */
}
