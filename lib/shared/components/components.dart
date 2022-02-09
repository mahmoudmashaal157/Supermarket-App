import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void navigateTo(context,Widget screen){
  Navigator.push(context,MaterialPageRoute(builder: (context)=>screen));
}

void popScreen(context){
  Navigator.pop(context);
}

String dateNow(){
  final DateTime dateNow = DateTime.now();
  final DateFormat format =DateFormat('dd/MM/yyyy');
  final String formattedDate =  format.format(dateNow);
  return formattedDate;
}

showToast (String msg){
   Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}