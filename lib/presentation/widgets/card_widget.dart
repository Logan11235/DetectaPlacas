import 'package:flutter/material.dart';

Widget cardWidget(String item, String content) {
  item= item.toUpperCase();
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 1),
    width: double.infinity,
    height: 60,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      gradient:const  LinearGradient(colors: [
        Color.fromARGB(255, 242, 237, 237),
        Color.fromARGB(255, 250, 255, 255),
      ])
    ),
    child: Center(
      child: Text("$item : $content", 
      style:const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold
      
      ) ,),
    ),

  );
}