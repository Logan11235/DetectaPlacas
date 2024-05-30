import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pruebas_pruebas/providers/imagen_provider.dart';

class FullScreenImagen extends StatelessWidget {


  const FullScreenImagen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(context.read<ImagenProvider>().obtenerImagen),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
}
}