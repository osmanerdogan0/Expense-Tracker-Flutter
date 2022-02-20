import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTransaction extends StatelessWidget {
  MyTransaction({required this.transactionName, required this.money, required this.expenseOrIncome});

  final String transactionName;
  final String money;
  final String expenseOrIncome;


  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(10),
          color: (expenseOrIncome=='expense'? Colors.red[400] : Colors.green[400]),
          height: 50,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5.5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Center(
                    child: Icon(
                      Icons.attach_money_outlined,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
                Text(transactionName, style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400),),
                Text((expenseOrIncome=='expense' ? '-' : '+') + money + '₺',
                  style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
