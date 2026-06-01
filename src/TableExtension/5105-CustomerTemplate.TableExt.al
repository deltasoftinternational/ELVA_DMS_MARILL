tableextension 25006135 "Customer Templ." extends "Customer Templ."  //1381
{
    fields
    {
        field(25006000; "Prices Including VAT DMS"; Boolean)
        {
            Caption = 'Prices Including VAT DMS';
            InitValue = true;
        }
        /* ADDED IN BASE APP
        field(25006001; Reserve; Option)
        {
            Caption = 'Reserve';
            InitValue = Optional;
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }*/
    }
}