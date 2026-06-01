Codeunit 25006005 "ActivateContract"
{
    // 16.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed Constant:
    //     Text000
    //   Modified procedure:
    //     ActivateContract


    trigger OnRun()
    begin
    end;

    var
        Text000: label 'It is not possible to set Status to Active because some Contract Sales Line Discount lines have zero %1.';


    procedure ActivateContract(FromServContractHeader: Record Contract)
    var
        ServContractHeader: Record Contract;
        ServContractLine: Record "Contract Sales Line Discount";
    begin
        ServContractHeader := FromServContractHeader;
        if ServContractHeader.Status = ServContractHeader.Status::Active then
            exit;

        ServContractHeader.LockTable;

        ServContractLine.Reset;
        ServContractLine.SetRange("Contract No.", ServContractHeader."Contract No.");
        ServContractLine.SetRange("Line Discount %", 0);
        if not ServContractLine.IsEmpty then
            // ERROR(Text000,Status,ServContractLine.FIELDCAPTION("Line Discount %"));                                     // 16.04.2014 Elva Baltic P21
            Error(Text000, ServContractLine.FieldCaption("Line Discount %"));                                              // 16.04.2014 Elva Baltic P21

        ServContractHeader.Get(FromServContractHeader."Contract No.");
        ServContractHeader.Status := ServContractHeader.Status::Active;
        ServContractHeader.Modify;
    end;


    procedure InactivateContract(ServContractHeader: Record Contract)
    begin
        if ServContractHeader.Status = ServContractHeader.Status::Inactive then
            exit;
        ServContractHeader.LockTable;
        ServContractHeader.Status := ServContractHeader.Status::Inactive;
        ServContractHeader.Modify;
    end;
}

