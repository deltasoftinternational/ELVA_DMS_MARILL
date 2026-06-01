Page 25006404 "Send SMS Message"
{
    DataCaptionExpression = '';
    PageType = Worksheet;
    SourceTable = "Integer";

    layout
    {
        area(content)
        {
            field("Phone No."; PhoneNo)
            {
                ApplicationArea = Basic;
                Caption = 'Phone No.';
            }
            field("SMS Message"; MessageText)
            {
                ApplicationArea = Basic;
                Caption = 'Message Body';
                MultiLine = true;
            }
            field("Salesperson Code"; SalespersonCode)
            {
                ApplicationArea = Basic;
                Caption = 'Salesperson Code';
                Editable = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send SMS")
            {
                ApplicationArea = Basic;
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if PhoneNo = '' then
                        Error(FillPhoneNoErr);

                    if MessageText = '' then
                        Error(FillMessageErr);

                    if SalespersonCode = '' then
                        Error(NoSalespersonCode);

                    SMSManagement.SetContactNo(ContactNo);
                    SMSManagement.SetSalespersonCode(SalespersonCode);
                    SMSManagement.SetDocumentNo := DocumentNo;
                    SMSManagement.SetDocumentType := DocumentType;
                    SMSManagement.AddSMSToQueue(PhoneNo, MessageText);
                    Message(SmsQueuedMsg);
                end;
            }
        }
    }

    var
        PhoneNo: Text[50];
        MessageText: Text[160];
        ContactNo: Code[20];
        SalespersonCode: Code[10];
        SMSManagement: Codeunit "SMS Management";
        SmsQueuedMsg: label 'SMS Message sent.';
        FillPhoneNoErr: label 'Please fill in recipient Phone No.';
        FillMessageErr: label 'Message body is empty.';
        NoSalespersonCode: label 'Please set up Salesperson code.';
        DocumentType: Option;
        DocumentNo: Code[20];


    procedure SetPhoneNo(PhoneNoToSet: Text[50])
    begin
        PhoneNo := PhoneNoToSet;
    end;


    procedure SetMessageBody(MessageBodyToSet: Text[160])
    begin
        MessageText := MessageBodyToSet;
    end;


    procedure SetContactNo(ContactNoToSet: Code[20])
    begin
        ContactNo := ContactNoToSet;
    end;


    procedure SetSalespersonCode(SalespersonCodeToSet: Code[10])
    begin
        SalespersonCode := SalespersonCodeToSet;
    end;


    procedure SetDocumentNo(DocumentNoToSet: Code[20])
    begin
        DocumentNo := DocumentNoToSet;
    end;


    procedure SetDocumentType(DocumentTypeToSet: Option)
    begin
        DocumentType := DocumentTypeToSet;
    end;
}

