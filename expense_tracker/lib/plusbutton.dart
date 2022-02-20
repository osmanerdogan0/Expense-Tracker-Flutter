import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final fuction;

  PlusButton({this.fuction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fuction,
      child: Container(

        width: 150,
        height: 75,
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: Text(
          'İşlem Ekle', style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.w400),),),
      ),
    );
  }


}