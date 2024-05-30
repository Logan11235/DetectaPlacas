import 'package:flutter/material.dart';

class TextPlacaProvider with ChangeNotifier {
  String? _textoPlaca;
  String? _textoPlacaAnterior;
  String? _fallas;
  bool _mismaPlaca=false;

  get obtenerTexto => _textoPlaca;
  get obtenerTextoAnterior => _textoPlacaAnterior;
  get obtenerFallas => _fallas;

  // void establecerTexto(String text){
  //   _texto= text;
  //   notifyListeners();
  // }

  void establecerTexto(String textoReconocido) {
    if (textoReconocido == "No se pudo identificar el texto") {
      //SIGNIFICA QUE EL TEXTO NO FUE RECONOCIDO entonces por defecto está viniendo este texto
      _fallas = textoReconocido;
      _textoPlaca=null;
      _textoPlacaAnterior=null;
      notifyListeners();
    } else {
      _mismaPlaca=false;

      List<String> lineas = textoReconocido.split(RegExp(r'\n'));
      if(_textoPlaca!=null){
        _textoPlacaAnterior=_textoPlaca;
      }

      for (String linea in lineas) {
        if (linea.length == 7) {
          // Patrónes: AB-JFI2, JFE-JFI, JFEE-FE
          if (linea[2] == '-' || linea[3] =='-' || linea[4]=='-') {
            if (_textoPlaca != null) {
              if(_textoPlaca != linea){
                _textoPlacaAnterior= _textoPlaca;
                _textoPlaca = linea;
              }else{
                _mismaPlaca=true;
              }
              
              break;

            }else {
              _textoPlaca=linea;
            }

            break;
          }
        }
      }
      if(_textoPlaca==null){
        _fallas ="No se encontró la placa";
      }
      if(_textoPlaca==_textoPlacaAnterior){
        if(_mismaPlaca==false){
          _textoPlaca= null;
          _fallas="No se encontró la placa";
        }
        
      }
      

      notifyListeners();
    }
  }
}
