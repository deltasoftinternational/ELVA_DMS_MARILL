Table 25006701 "SIE Setup"
{
    // 26.06.2013 EDMS P8
    //   * Added fields: 'Processing Log Path' and 'Processing Log Active'

    Caption = 'SIE Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "File Name"; Text[200])
        {
            Caption = 'Default Exchange File Name';
        }
        field(30; "Synch. Interval (sec)"; Integer)
        {
            Caption = 'Synch. Interval (sec.)';
        }
        field(40; "Default SIE Sys"; Integer)
        {
            Caption = 'Default SIE System Selection';
        }
        field(70; "Automatic SIE Journal Posting"; Boolean)
        {
            Caption = 'Automatic SIE Journal Posting';
        }
        field(80; "Automatic PutInTakeOut"; Boolean)
        {
            Caption = 'Automatic Transfer';
        }
        field(90; "Automatic Assign"; Boolean)
        {
            Caption = 'Automatic Assign';
        }
        field(100; "Processing Log Path"; Text[250])
        {
            Caption = 'Schedule Add-In Log Path';
        }
        field(110; "Processing Log Active"; Boolean)
        {
            Caption = 'Schedule Add-In Log Active';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

