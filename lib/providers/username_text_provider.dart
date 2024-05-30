import 'package:flutter/material.dart';

class UserNameTextProvider with ChangeNotifier{
  String _username="SebastianJhonson";

  get obtenerUsername=> _username;

  void establecerUsername(String username){
    _username= username;
    notifyListeners();
  }


}