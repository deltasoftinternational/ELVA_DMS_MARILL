XmlPort 25007449 "SIE Export"
{
    Caption = 'Special Inventory Equipment Export Data';
    Direction = Export;
    Format = VariableText;
    FieldDelimiter = '"';

    schema
    {
        textelement(SIE)
        {
            textattribute(siecode)
            {
                XmlName = 'No.';
            }
            textelement(Users)
            {
                MinOccurs = Zero;
                tableelement(user; "SIE XML Buf")
                {
                    XmlName = 'User';
                    SourceTableView = sorting(Type, "SIE Entry No.", Int4) where(Type = const(User));
                    fieldelement("No."; User.Int1)
                    {
                    }
                    fieldelement(Name; User."30Txt1")
                    {
                    }
                }
            }
            textelement(Transactions)
            {
                MinOccurs = Zero;
                tableelement(transaction; "SIE XML Buf")
                {
                    MinOccurs = Zero;
                    XmlName = 'Transaction';
                    SourceTableView = sorting(Type, "SIE Entry No.", Int4) where(Type = const(Transaction));
                    fieldelement("No."; Transaction."SIE Entry No.")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(SIEDate; Transaction.Date1)
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(SIETime; Transaction.Time1)
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(DocumentNo; Transaction."10Txt1")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(User; Transaction."30Txt1")
                    {
                    }
                    fieldelement(ControlPanel; Transaction.Int1)
                    {
                    }
                    fieldelement(Pistol; Transaction.Int2)
                    {
                    }
                    fieldelement(SIEBin; Transaction.Int3)
                    {
                    }
                    fieldelement(DemandedQty; Transaction.Decimal1)
                    {
                    }
                    fieldelement(PurifiedQty; Transaction.Decimal2)
                    {
                    }
                    fieldelement(ShippedQty; Transaction.Decimal3)
                    {
                    }
                    fieldelement(RemainingQty; Transaction.Decimal4)
                    {
                    }
                    fieldelement("Suppl.No."; Transaction.Int4)
                    {
                    }
                    fieldelement(Group; Transaction.Int5)
                    {
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        ServLines: Record "Service Line EDMS";


    procedure SetData(SIE: Text[10])
    begin
        SIECode := SIE
    end;
}

