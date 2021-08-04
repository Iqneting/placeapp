import 'package:flutter/material.dart';
import 'package:places_app/models/terminosModelo.dart';
import 'package:places_app/services/terminosCondionesService.dart';

class TerminosCondiciones extends StatefulWidget {

  @override
  _TerminosCondicionesState createState() => _TerminosCondicionesState();
}

class _TerminosCondicionesState extends State<TerminosCondiciones> {
  TerminosCondicionesService terminos = new TerminosCondicionesService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Términos y Condiciones'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<TerminosModel>>(
          future: terminos.getTerminos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
              margin:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Column(
                children: [
                  Text(snapshot.data[0].texto)
                ],
              ),
            );
            } else {
              return CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }
}