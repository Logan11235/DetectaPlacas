import 'package:flutter/material.dart';

class DatosPlacaProvider with ChangeNotifier{
  String? _description;
  String? _registrationYear;
  String? _carMake;
  String? _carModel;
  String? _vin;
  String? _use;
  String? _imageUrl;

  bool _isLoading = false;


  get obtenerDescripcion=>_description;
  get obtenerFechaRegistro=>_registrationYear;
  get obtenerModelo=>_carModel;
  get obtenerMarca=>_carMake;
  get obtenerVin=>_vin;
  get obtenerModoUso=>_use;
  get obtenerImagenUrl=>_imageUrl;

  get estadoCarga=> _isLoading;

  void establecerDatosPlaca({required String description, required String registYear, 
  required String carMake, required String carModel, required String vin, required String use, required String imagenUrl}){

    _description=description;
    _registrationYear=registYear;
    _carMake=carMake;
    _carModel= carModel;
    _vin = vin;
    _use = use;
    _imageUrl = imagenUrl;

    notifyListeners();

  }

  
  void setLoading(bool estadoCarga){
    _isLoading = estadoCarga;
    notifyListeners();
  }
}