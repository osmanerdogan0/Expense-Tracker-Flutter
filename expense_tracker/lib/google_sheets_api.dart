import 'package:expense_tracker/google_sheets_api.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi{
  static const _credentials=r'''
  {
  "type": "service_account",
  "project_id": "flutternewexpense",
  "private_key_id": "e45dc7810951e68dfc204462aad8306c3c425a1e",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCjBj09HpqswwGy\n07GJo1iChmwsNySNKLmp2TQ/Nt2jlB4S5JXu4NZW1zotTMA4NfdCNqWPHPQsBBBI\nzQu6oYdKa9/ciwmikGtJIyb/NQo33xNWlfiOh8i+pUXKbW7nQZhsjMGwSXI6vz7R\nGtOxr3SyxKBUJEaWagaILl6Z99E4DFENrECneqTrKTWOraVfge9NxboAi/PxXQrH\n2Xi98wsnpogmDRxhpOCrbTdCN9lOUN/9OvZcpSjRoG/LmSRhKfsfzG7xzhdRgPry\nBZV5B8OEIXFhWjaNL7Dp+dJqA9iFeCY28s7qEPQfHK5+zhljlDjYQUrWN/SFAJm+\n5D+SWb2FAgMBAAECggEAAdtaZxQl9ap14mz0UKiOGxAXKiD2ZQRou6GGk/Ql1CBH\n961jhN2fZpDiNkl6HBR2FAzK5MI1M16cer0iFarX3VDObxTYM/u/qNFEaoKJ8soq\niie8E3655xbMSyug242XpiAR56MgqCcK9rlLkS41sgCjeHYkx/K+JLQlK9XIK/Fw\noPenf7QzPyOl6lSTX0ZVZwXEapMvonlYQNwZ6OM6sD5BGG4nuufr2milNgHwOrmB\njy4T29eChaoUabmpPYjX8sUqDo9McyzbChbmFsZwHlYOEG9PwJIBiadTeZGfC9GW\npigUl7Qm7itdfiPf4Lpl5uXlhUXi8A4iLtR1Rkv7JQKBgQDg4ctdBkRhWuLyw732\nv0x2mJxQDUmbFNfEd3r0WXdoXBLtLITOk4Ibph7OITp4VaviXoZ73Lm/tBJwcdnc\nryxh384L79gCye9QvVBwx7yyUxxUlF/UmG6Nvl+MoPiGOJSBtx78fhDXKAcCHFR2\nuFlrYQe8KnvEKYhhFY9+85YZzwKBgQC5lTQz/E+dBoN+LQ6alI7dAEFQxlUAEA+8\nlYX3fXKc9o5p4ZPFoizMOUlUB+FhqI3BdcRgyIVuEBCQ36HGfxdQctlFOFKPDSVP\nkmZLmnR8c7LIIU5dJkpk7XA6jL5hppfCTxtsnf+fD6z2D0l0072AaAtMbGye/WK9\nWXp8mDTMawKBgDMVN2PXM5tF0P3CVxmA1PavrfpFOm4e6vB3D5gH5qbvG2GC1lwy\nh8COGLtMMwL4uwW94SCrwAn69qFSS2Hk7NkCxMRTZCcmBdW6W1ZzGLsNRAc2eRpK\n0foiv4OrYSjkG1/n4AMNA/hL4GOrWchqEe3haadlox2pLZCYHDODU5pjAoGALstV\nb2pGdNSooU8hKI8e+tDOp1xrIGnsXePh9Ma3+KYewMn1Zdb/rrsfJ0YZaXOD0u0s\nCC9nnZoFY1JQS2nOaiWbbV3HS3TIHKlQi+21Q5A020uyo8A87/gC3XCRrLPB/mfO\nBXRNeUENnrm6DvA5D0Cs4KdSOECx/gaq4PHMFmMCgYAbTg1qP/tsVnQMmpzgznNf\ny2OpktSh8ywmjXMl9wpGshDuKD6tF7ml2euJgiD02byf2YGyF8Gh13fdWD6rSRoV\nOuZKL0QchoLyXJKj4G7gJ1AwZv3aqLapnyAmG1P07rpaB3DwDnuhfu4rpCNi2zWE\nYbeiBeb8OqcK9iBaPOSQVA==\n-----END PRIVATE KEY-----\n",
  "client_email": "flutternewexpense@flutternewexpense.iam.gserviceaccount.com",
  "client_id": "115578138948800629842",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutternewexpense%40flutternewexpense.iam.gserviceaccount.com"
}
''';
  static final _spreadsheetId='1sYz74iKx91MLB-qWlaF_YxWgkZxRPsvCFpAEyB2NCCA';
  static final _gsheet= GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransaction=0;
  static List<List<dynamic>> currentTransaction=[];
  static bool loading=true;

  Future init() async{
    final ss= await _gsheet.spreadsheet(_spreadsheetId);
    _worksheet=ss.worksheetByTitle('Sayfa1');
    countRows();
  }


  static Future countRows() async{
    while((await _worksheet!.values.value(column: 1, row: numberOfTransaction+1))!=''){
      numberOfTransaction++;
    }

    loadTransaction();
  }

  static Future loadTransaction() async {
    if(_worksheet==null) return;
    for(int i=1;i<numberOfTransaction;i++){
      final String transactionName=await _worksheet!.values.value(column: 1, row: i+1);
      final String transactionAmount=await _worksheet!.values.value(column: 2, row: i+1);
      final String transactionType=await _worksheet!.values.value(column: 3, row: i+1);
      if(currentTransaction.length<numberOfTransaction){
        currentTransaction.add([transactionName,transactionAmount,transactionType]);
      }
    }

    loading=false;
  }



  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransaction++;
    currentTransaction.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }




  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransaction.length; i++) {
      if (currentTransaction[i][2] == 'income') {
        totalIncome += double.parse(currentTransaction[i][1]);
      }
    }
    return totalIncome;
  }

  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransaction.length; i++) {
      if (currentTransaction[i][2] == 'expense') {
        totalExpense += double.parse(currentTransaction[i][1]);
      }
    }
    return totalExpense;
  }



}