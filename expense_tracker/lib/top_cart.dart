import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class TopNeuCard extends StatelessWidget {
  final String balance;
  final String income;
  final String expense;

  TopNeuCard(
      {required this.balance, required this.expense, required this.income});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text('Mevcut Varlık',
                  style: TextStyle(color: Colors.white, fontSize: 42),),
                Text(balance+'₺',
                  style: TextStyle(color: Colors.green, fontSize: 36,fontWeight: FontWeight.bold),),

                SizedBox(height: 24,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_upward,color: Colors.green[400],size: 36,),
                        Column(
                          children: [
                            Text('Gelir',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white),),
                            Text(income+'₺',style: TextStyle(fontSize: 16,color: Colors.green, ),),
                          ],
                        ),
                      ],
                    ),


                    Row(
                      children: [
                        Icon(Icons.arrow_downward,color: Colors.red[400],size: 36,),
                        Column(
                          children: [
                            Text('Gider',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),),
                            Text(expense+'₺',style: TextStyle(fontSize: 16,color: Colors.red),),
                          ],
                        ),
                      ],
                    ),
                  ],

                ),


              ],
            ),
          ),
        ),

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(15),
          color: Colors.white12,
          boxShadow: [

            BoxShadow(
              color: Colors.white10,
              offset: Offset(4.0, 4.0),
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),




          ],

        ),
      ),
    );
  }
}




