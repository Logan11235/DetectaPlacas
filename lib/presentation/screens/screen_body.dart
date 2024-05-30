import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:pruebas_pruebas/infraestructure/models/vehicles.dart';
import 'package:pruebas_pruebas/presentation/screens/full_screen_image.dart';
import 'package:pruebas_pruebas/presentation/widgets/card_widget.dart';
import 'package:pruebas_pruebas/presentation/widgets/widget_imagen.dart';

import 'package:pruebas_pruebas/providers/datos_placa_provider.dart';
import 'package:pruebas_pruebas/providers/username_text_provider.dart';
import 'package:xml/xml.dart';

import 'package:pruebas_pruebas/providers/imagen_provider.dart';
import 'package:pruebas_pruebas/providers/text_placa_provider.dart';

class ScreenBody extends StatefulWidget {
  const ScreenBody({super.key});

  @override
  State<ScreenBody> createState() => _ScreenBodyState();
}

class _ScreenBodyState extends State<ScreenBody> {
  @override
  Widget build(BuildContext context) {
    //Variables para escuchar el estado de los providers
    final imagenProvider = context.watch<ImagenProvider>();
    final textPlacaProvider = context.watch<TextPlacaProvider>();
    final userNameTextProvider = context.watch<UserNameTextProvider>();
    final datosPlacaProvider = context.watch<DatosPlacaProvider>();

    bool isButtonDisabled =
        false; //Para controlar el estado del botón de convertir a texto -activo -inactivo

    void mostrarAlertaApi() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('ERROR AL TRAER DATOS'),
            content: const Text(
                "Posiblemente excedió la cantidad de créditos de consulta en la API"),
            actions: <Widget>[
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    //MÉTODO PARA CONVERTIR LA IMAGEN A TEXTO, Aquí se actualiza el estado del texto
    Future<void> convertImage() async {
      if (imagenProvider.obtenerImagen == null) {
        return;
      }
      final inputImage = InputImage.fromFile(imagenProvider.obtenerImagen);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);

      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;

      if (text.isEmpty) {
        if (context.mounted) {
          textPlacaProvider.establecerTexto("No se pudo identificar el texto");
        }
        return;
      }

      if (context.mounted) {
        textPlacaProvider.establecerTexto(text);
      }
      textRecognizer.close();
    }

    //MÉTODO PARA ELIMINAR EL GUIÓN DE LA PLACA Y PASARLO A LA API, este método se ejecuta dentro de conseguirDatos consulta a la API
    String formatearPlaca(String numeroPlaca) {
      return numeroPlaca.replaceAll('-', '');
    }

    //MÉTODO PARA TRAER DATOS DE UNA API USANDO DIO ...
    final dio = Dio();

    Future<void> conseguirDatos(String username, String placa) async {
      if (textPlacaProvider.obtenerTexto == null) {
        // print("la placa pasada está en NULO");

        return;
      } else if (textPlacaProvider.obtenerTexto == "No existe la placa") {
        // print("Entró en no existe la placa");

        return;
      } else if (textPlacaProvider.obtenerTexto ==
          textPlacaProvider.obtenerTextoAnterior) {
        // print("Entró en que las placas son iguales ");
        return;
      }

      String placaFormateada = formatearPlaca(placa);

      try {
        // print("Entró al try");
        datosPlacaProvider.setLoading(true);
        final response = await dio.get(
            "https://www.regcheck.org.uk/api/reg.asmx/CheckPeru?RegistrationNumber=$placaFormateada&username=$username");

        if (response.statusCode == 200) {
          // Analiza la respuesta XML
          final document = XmlDocument.parse(response.data);

          // Extrae el contenido del nodo vehicleJson
          final vehicleJsonString =
              document.findAllElements('vehicleJson').single.innerText;
          // Convierte la cadena JSON a un mapa
          final vehicleJson = jsonDecode(vehicleJsonString);

          Vehicle vehicle = Vehicle.fromJson(vehicleJson);
          //Establecemos el estado del provider de datos placa
          if (context.mounted) {
            context.read<DatosPlacaProvider>().establecerDatosPlaca(
                description: vehicle.description,
                registYear: vehicle.registrationYear,
                carMake: vehicle.carMake,
                carModel: vehicle.carModel,
                vin: vehicle.vin,
                use: vehicle.use,
                imagenUrl: vehicle.imageUrl);
          }
        } else if (response.statusCode == 500) {
          // mostrarAlertaApi();
          // print("CÓDIGO 500 API FALLANDO");
          throw Exception('Failed to load vehicle');
        }

        datosPlacaProvider.setLoading(false);
      } on DioException catch (e) {
        if (e.response != null) {
          // El servidor respondió con un código de estado que no es 200
          // print(
          //     'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
          // print('Datos de error: ${e.response?.data}');

          if (e.response?.statusCode == 500) {
            // print('Error del servidor 500: ${e.response?.statusMessage}');
            mostrarAlertaApi();
            // Aquí puedes manejar el caso específico de código 500
          } else {
            // Manejar otros códigos de estado no exitosos
            // print('Código de estado: ${e.response?.statusCode}');
          }
        } else {
          // Error de conexión, tiempo de espera, o cualquier otro error
          // print('Error de conexión: ${e.message}');
        }

        datosPlacaProvider.setLoading(false);
      } catch (e) {
        // Otros errores no relacionados con Dio
        // print('Error inesperado: $e');
        datosPlacaProvider.setLoading(false);
      }
    }

    final double alto = MediaQuery.of(context).size.height;
    final double ancho = MediaQuery.of(context).size.width;

    return Center(
      child: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),

          GestureDetector(
              onTap: () {
                
                if (context.read<ImagenProvider>().obtenerImagen != null) {
                  showDialog(
                      context: context,
                      builder: (context) => const FullScreenImagen());
                }
              },
              child: imagenProvider.obtenerImagen != null
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      height: alto * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                            style: BorderStyle.solid,
                            color:const  Color.fromARGB(179, 216, 204, 204)),
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(8, 5)),
                        image: DecorationImage(
                            image: FileImage(imagenProvider.obtenerImagen),
                            fit: BoxFit.cover),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      height: alto * 0.4,
                      decoration: BoxDecoration(
                          border: Border.all(
                              style: BorderStyle.solid,
                              color:const Color.fromARGB(179, 10, 10, 10)),
                          borderRadius:
                              const BorderRadius.all(Radius.elliptical(8, 5)),
                          shape: BoxShape.rectangle),
                      child: const Center(child: Text("Cargue una imagen")),
                    )),

          const SizedBox(height: 15),

          //Botón de convertir a texto
          Center(
            child: SizedBox(
              width: ancho*0.5,
              child: ElevatedButton(
                
                  style: ElevatedButton.styleFrom(
                    backgroundColor:const Color.fromARGB(121, 33, 149, 243) ,
                    disabledBackgroundColor:const Color.fromARGB(255, 90, 91, 91),
                    padding: const EdgeInsets.symmetric(horizontal: 1,vertical: 3),
                    elevation: 5,
                    shadowColor:const Color.fromARGB(255, 242, 242, 242),
                    alignment: Alignment.center,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  onPressed: () async {
                    if (isButtonDisabled) {
                      null;
                    } else {
                        setState(() {
                          isButtonDisabled =
                              true; //Establecemos como desactivado al botón
                        });
                        await convertImage(); //Método que convierte imagen a texto y actualiza el estado de placa
                        //Traemos los datos de la API, y actualizamos el estado de los datos de la placa
                        if (context.mounted) {
                          await conseguirDatos(userNameTextProvider.obtenerUsername,
                              textPlacaProvider.obtenerTexto ?? "No existe la placa");
                        }
                        setState(() {
                          isButtonDisabled =
                              false; //Establecemos como activado al botón para que pueda ser presionado
                        });
                     }
                  },
                  child: const Center(
                      child: Text(
                    "BUSCAR PLACA",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ))),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // BLOQUE DONDE SE MUESTRAN LO DATOS, DEBAJO DEL BOTÓN
          textPlacaProvider.obtenerTexto != null
              ? // Si el texto provider tiene un valor , no es nulo
              datosPlacaProvider.estadoCarga == true
                  ? // Si la obtención de datos está cargando
                  const Center(child: CircularProgressIndicator())
                  : // Si la obtención de datos ya no está cargando
                  datosPlacaProvider.obtenerDescripcion == null
                      ? // Si no hay datos ne el providerDatos
                      Center(
                          child: Text(
                              "No se ha encontrado datos para Placa: ${textPlacaProvider.obtenerTexto}"))
                      : // Si se encontró datos en el providerDatos
                      Column(
                          children: [
                            cardWidget("Placa", textPlacaProvider.obtenerTexto),
                            cardWidget("Descrip",
                                datosPlacaProvider.obtenerDescripcion),
                            cardWidget(
                                "Marca", datosPlacaProvider.obtenerMarca),
                            cardWidget(
                                "Modelo", datosPlacaProvider.obtenerModelo),
                            cardWidget("Vin", datosPlacaProvider.obtenerVin),
                            cardWidget(
                                "Uso", datosPlacaProvider.obtenerModoUso),
                            cardWidget("Registrado en",
                                datosPlacaProvider.obtenerFechaRegistro),
                            imagen(datosPlacaProvider.obtenerImagenUrl),
                          ],
                        )
              : //si el texto provider de la placa es nulo entonces
              textPlacaProvider.obtenerFallas == null
                  ? //Preguntar si aún no se han obtenido fallas, es 1ra vez que se carga la app y tiene null por defecto
                  const Center(
                      child: Text("Presione el botón de Convertir Texto"))
                  : // Si las fallas tienen valores significa que ya se deben mostrar
                  Center(child: Text(textPlacaProvider.obtenerFallas)),

          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
