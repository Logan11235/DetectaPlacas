import 'dart:io';

import 'package:flutter/material.dart';

class ImagenProvider with ChangeNotifier{
  File? _imagen;
  

  get obtenerImagen=> _imagen;

  void establecerImagen(File imagen){
    _imagen= imagen;
    notifyListeners();
  }
}