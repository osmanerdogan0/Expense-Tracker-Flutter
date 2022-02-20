import 'dart:async';

import 'package:expense_tracker/google_sheets_api.dart';
import 'package:expense_tracker/plusbutton.dart';
import 'package:expense_tracker/top_cart.dart';
import 'package:expense_tracker/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loading_circle.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState()=>_HomePageState();

}

class _HomePageState extends State<HomePage> {
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
    );
    setState(() {});
  }

  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('Y E N İ  H A R C A M A'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Gider'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          Text('Gelir'),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Tutar?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Tutarı giriniz';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Harcama detayı',
                              ),
                              controller: _textcontrollerITEM,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child:
                    Text('İptal', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: Text('Ekle', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }


  bool timerHasStarted=false;
  void startLoading(){
    timerHasStarted=true;
    Timer.periodic(Duration(seconds: 1),(timer){
      if(GoogleSheetsApi.loading==false){
        setState((){});
        timer.cancel();
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {

    if(GoogleSheetsApi.loading==true&&timerHasStarted==false){
      startLoading();
    }

    return Scaffold(
      backgroundColor: Colors.white12,

      body: Padding(
        padding: const EdgeInsets.all(40.0),


        child: Column(


          children: [
            SizedBox(height: 20,),

            Text('Expense Tracker',style: TextStyle(fontSize: 42,color: Colors.white, fontWeight: FontWeight.w300),),

            SizedBox(height: 30,),

            TopNeuCard(
              balance: (GoogleSheetsApi.calculateIncome() -
                  GoogleSheetsApi.calculateExpense())
                  .toString(),
              income: GoogleSheetsApi.calculateIncome().toString(),
              expense: GoogleSheetsApi.calculateExpense().toString(),
            ),


            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),

                      Expanded(
                        child: GoogleSheetsApi.loading==true?LoadingCircle(): ListView.builder(
                          itemCount: GoogleSheetsApi.currentTransaction.length,
                            itemBuilder: (context , index){
                          return MyTransaction(
                              transactionName: GoogleSheetsApi.currentTransaction[index][0],
                              money: GoogleSheetsApi.currentTransaction[index][1],
                              expenseOrIncome: GoogleSheetsApi.currentTransaction[index][2]
                          );
                        }),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: PlusButton(
                fuction: _newTransaction,
              ),
            ),
          ],
        ),
      ),

    );
  }
}


