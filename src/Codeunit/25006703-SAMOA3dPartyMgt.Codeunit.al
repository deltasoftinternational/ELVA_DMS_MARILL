Codeunit 25006703 "SAMOA 3d Party Mgt."
{
    /* FIXME
      // 12.11.2007 P3
      //   * Added new procedure CheckSIEBin - checks if bin is used by SIE System

      TableNo = "SIE Run-Time Params";

      trigger OnRun()
      var
          XMLFile: File;
          XMLOut: OutStream;
          adoConn: Automation ;
          adoRs: Automation ;
          flds: Automation ;
          fld: Automation ;
          XMLBuffer: Record "SIE XML Buf";
          SIESetup: Record "SIE Setup";
          SIEXMLPort: XmlPort "SIE Export";
          SQL: Text[500];
      begin
          SIESetup.Get;

          SIENo := "SIE No.";

          if "Run Mode" = "run mode"::Post then begin
            AutoPostJnl("Posting Unit");
            exit
          end;

          if "Max Date"=0D then begin
            "Max Date" := 20990101D;
            "Max Time" := 000000T;
          end;

          //IF NOT VARIABLEACTIVE(adoConn) THEN
          Create(adoConn,false,true);//30.10.2012 EDMS
          adoConn.Open("DSN Name");

          case Direction of
            Direction::Export:
              begin
                XMLBuffer.DeleteAll;
                case "Run Mode" of
                  "run mode"::Flow:
                    begin
                     SQL:='Select *,l.num as supl_num from Transactions t, Livraisons l,claviers c where ' +
                          't.num = l.num_trans And l.clavier_exe=c.num And l.num_pistolet <> 0 And '+
                          'datediff(''n'',t.moment_fin,'''+Format(CreateDatetime("Max Date","Max Time"))+''')<0';
                     adoRs:=adoConn.Execute(SQL);
                     while not adoRs.EOF do begin
                       XMLBuffer.Init;
                       XMLBuffer.Type := XMLBuffer.Type::Transaction;

                       flds:=adoRs.Fields;

                       fld:=flds.Item('num_trans');
                       XMLBuffer."SIE Entry No." := fld.Value;

                       fld:=flds.Item('supl_num');
                       XMLBuffer.Int4 := fld.Value;

                       fld:=flds.Item('moment_fin');
                       XMLBuffer.Date1 := fld.Value;
                       XMLBuffer.Time1 := VARIANT2TIME(fld.Value);

                       fld:=flds.Item('O_R');
                       XMLBuffer."10Txt1" := fld.Value;

                       fld:=flds.Item('Operateur');
                       XMLBuffer."30Txt1" := fld.Value;

                       fld:=flds.Item('clavier_lancement');
                       XMLBuffer.Int1 := fld.Value;

                       fld:=flds.Item('num_pistolet');
                       XMLBuffer.Int2 := fld.Value;

                       fld:=flds.Item('num_cuve');
                       XMLBuffer.Int3 := fld.Value;

                       fld:=flds.Item('qte_demandee');
                       XMLBuffer.Decimal1 := fld.Value;
                       XMLBuffer.Decimal1 := XMLBuffer.Decimal1 / 100;

                       fld:=flds.Item('qte_raclee');
                       XMLBuffer.Decimal2 := fld.Value;
                       XMLBuffer.Decimal2 := XMLBuffer.Decimal2 / 100;

                       fld:=flds.Item('qte_livree');
                       XMLBuffer.Decimal3 := fld.Value;
                       XMLBuffer.Decimal3 := XMLBuffer.Decimal3 / 100;

                       fld:=flds.Item('reste_en_cuve');
                       XMLBuffer.Decimal4 := fld.Value;

                       fld:=flds.Item('groupe');
                       XMLBuffer.Int5 := fld.Value;

                       XMLBuffer.Insert;
                       adoRs.MoveNext;
                     end;
                     SQL:='Select max(t.moment_fin) from Transactions t, Livraisons l,claviers c where ' +
                         't.num = l.num_trans And l.clavier_exe=c.num';
                     adoRs:=adoConn.Execute(SQL);
                     flds:=adoRs.Fields;
                     fld:=flds.Item(0);
                     "Max Date" := fld.Value;
                     "Max Time" := VARIANT2TIME(fld.Value);
                   end;
                 "run mode"::Synchronize:
                   begin
                     adoRs:=adoConn.Execute('select * from Utilisateurs');
                     while not adoRs.EOF do begin
                       XMLBuffer.Init;
                       XMLBuffer.Type := XMLBuffer.Type::User;
                       flds:=adoRs.Fields;
                       fld:=flds.Item(2);

                       //XMLBuffer.INSERT;
                       adoRs.MoveNext;
                     end;
                   end;
                end;
                if XMLBuffer.Count>0 then begin
                  if Exists(SIESetup."File Name") then Erase(SIESetup."File Name");
                  XMLFile.Create(SIESetup."File Name");
                  XMLFile.CreateOutstream(XMLOut);
                  SIEXMLPort.SetData("SIE No.");
                  SIEXMLPort.SetDestination(XMLOut);
                  SIEXMLPort.SetTableview(XMLBuffer);
                  SIEXMLPort.Export;
                end;
              end;
            Direction::Import:;
          end;
          Clear(adoRs) ;
          Clear(adoConn)
      end;

      var
          SIENo: Code[10];
          SIE: Record "Special Inventory Equipment";

     
      procedure AutoPostJnl(PostingUnit: Integer)
      var
          JnlLine: Record "SIE Journal Line";
          SAMOAJnlPost: Codeunit "SAMOA SIE Jnl.-Post";
      begin
          Clear(JnlLine);
          if not JnlLine.FindFirst then exit;
          Codeunit.Run(PostingUnit,JnlLine)
      end;

     
      procedure CheckSIEBin(Loc: Code[10];Bin: Code[20]): Boolean
      var
          SIEObjCat: Record "SIE Object Category";
          SIEObj: Record "SIE Object";
      begin
          SIE.Reset;
          SIE.SetRange(SystemCode,SIE.Systemcode::SAMOA);
          SIE.SetRange(Active,true);
          if SIE.FindFirst then begin
            SIEObjCat.SetRange("SIE No.",SIE."No.");
            SIEObjCat.SetRange(SYSType,SIEObjCat.Systype::Bin);
            if SIEObjCat.FindFirst then begin
              SIEObj.SetRange("SIE No.",SIE."No.");
              SIEObj.SetRange(Category,SIEObjCat."No.");
              SIEObj.SetRange("NAV No.",Loc);
              SIEObj.SetRange("NAV No. 2",Bin);
              exit(SIEObj.FindFirst)
            end
          end
      end;
      */
}

