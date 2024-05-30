import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:pruebas_pruebas/presentation/screens/screen_body.dart';
import 'package:pruebas_pruebas/providers/imagen_provider.dart';
import 'package:pruebas_pruebas/providers/username_text_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variable para detectar que imagePicker está activo o no
  bool _isImagePickerActive = false;

  @override
  Widget build(BuildContext context) {
    //variables

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detector de Placas"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade200,
        actions: [
          IconButton(
              onPressed: () {
                establecerUsername();
              },
              icon: const Icon(Icons.social_distance_outlined)),
        ],
      ),
      body: const ScreenBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //Botón de la cámara
          FloatingActionButton(
              child: const Icon(Icons.camera),
              onPressed: () {
                capturarImagen(context);
              }),
          const SizedBox(
            height: 12,
          ),
          // Botón de la galería
          FloatingActionButton(
              child: const Icon(Icons.open_in_browser),
              onPressed: () {
                seleccionarImagen(context);
              }),
        ],
      ),
    );
  }

  //MÉTODO PARA SELECCIONAR LA IMAGEN DESDE LA GALERÍA
  Future seleccionarImagen(BuildContext context) async {
    if (_isImagePickerActive) {
      return;
    } else {
      setState(() {
      _isImagePickerActive= true;
      });

      final ImagePicker imagePicker = ImagePicker();

      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      if (context.mounted) {
        context.read<ImagenProvider>().establecerImagen(File(image.path));
      }

      setState(() {
      _isImagePickerActive= false;
      });
    }
  }

  //MÉTODO PARA SELECCIONAR LA IMAGEN DESDE LA CÁMARA
  Future capturarImagen(BuildContext context) async {
    if (_isImagePickerActive) {
      return;
    } else {
      setState(() {
      _isImagePickerActive= true;
      });
      final ImagePicker imagePicker = ImagePicker();

      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.camera);
      if (image == null) return;

      if (context.mounted) {
        context.read<ImagenProvider>().establecerImagen(File(image.path));
      }
      setState(() {
      _isImagePickerActive= false;
      });
      
    }
  }

  //MÉTODO PARA ESTABLECER EL NUEVO USERNAME QUE SE USARÁ EN EL MÉTODO GET O POST A LA API
  //Aquí se actualiza el estado provider de username

  void establecerUsername() {
    TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text('Establecer Username'),
              Text("Actual: ${context.read<UserNameTextProvider>().obtenerUsername}", style: const TextStyle(fontSize: 12),)
            ],
          ),
          content: TextField(
            controller: usernameController,
            decoration:
                const InputDecoration(hintText: "Ingrese nuevo username"),
                autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                if (usernameController.text.isEmpty) {
                  Navigator.of(context).pop();
                  return;
                }
                if (context.mounted) {
                  context
                      .read<UserNameTextProvider>()
                      .establecerUsername(usernameController.text);
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
