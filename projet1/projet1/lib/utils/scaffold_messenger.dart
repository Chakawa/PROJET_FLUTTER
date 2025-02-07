
import 'package:flutter/material.dart';

class SacffoldMessenger{

  static succesMessage(BuildContext context,{required String title}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(title,style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
      )
    );
  }
  static faillureMessage(BuildContext context,{required String title}){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(title,style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        )
    );
  }
}