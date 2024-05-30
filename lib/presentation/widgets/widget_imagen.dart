

import 'package:flutter/material.dart';
Widget imagen(String imagen){
  return Container(

    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(23),)
    ),
    child: Column(
      children: [
        const Text("IMAGEN DEL VEHÍCULO", style: TextStyle(fontWeight: FontWeight.bold),),
        Image.network(imagen),
      ],
    ),
  );
}