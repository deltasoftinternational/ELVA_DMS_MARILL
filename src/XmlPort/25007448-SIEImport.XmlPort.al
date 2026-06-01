/*
XmlPort 25007448 "SIE Import"
{
    Caption = 'SIE Import';
    DefaultFieldsValidation = false;
    Direction = Import;

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
                textelement(User)
                {
                    textelement("No.")
                    {
                    }
                    textelement(Name)
                    {
                    }
                }
            }
            textelement(Transactions)
            {
                MinOccurs = Zero;
                tableelement(journal;"SIE Journal Line")
                {
                    MinOccurs = Zero;
                    XmlName = 'Transaction';
                    fieldelement("No.";Journal."Int 1")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(SIEDate;Journal."Date 1")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(SIETime;Journal."Time 1")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(DocumentNo;Journal."Code20 1")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(User;Journal."Text50 1")
                    {
                    }
                    fieldelement(ControlPanel;Journal."Int 2")
                    {
                    }
                    fieldelement(Pistol;Journal."Int 3")
                    {
                    }
                    fieldelement(SIEBin;Journal."Int 4")
                    {
                        FieldValidate = yes;
                    }
                    fieldelement(DemandedQty;Journal."Decimal 1")
                    {
                    }
                    fieldelement(PurifiedQty;Journal."Decimal 2")
                    {
                    }
                    fieldelement(ShippedQty;Journal."Decimal 3")
                    {
                    }
                    fieldelement(RemainingQty;Journal."Decimal 4")
                    {
                    }
                    fieldelement("Suppl.No.";Journal."Int 5")
                    {
                    }
                    fieldelement(Group;Journal."Int 6")
                    {
                    }

                    trigger OnAfterInitRecord()
                    begin
                        Journal."SIE No." := SIECode;
                        NewTranLineNo :=  NewTranLineNo + 100;
                        Journal."Line No." := NewTranLineNo;
                    end;
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

    trigger OnPreXmlPort()
    begin
        Journal.Reset;
        if Journal.FindLast then
          NewTranLineNo := Journal."Line No.";
    end;

    var
        NewTranLineNo: Integer;
}
*/