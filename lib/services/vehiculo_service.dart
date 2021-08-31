import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:places_app/models/vehiculo_model.dart';
import 'package:places_app/services/api.dart';

class VehiculoService{
  Api api = new Api('vehiculo');
  
  Future<bool> crearVehiculo(VehiculoModel vehiculo) async {
    bool bandera = false;
    await api.addDocument(vehiculo.toJson())
      .then((value) => bandera = true)
      .catchError((onError) => bandera = false);
    return bandera;
  }

  Future<QuerySnapshot> getVehiculo(String email,String placa) async {
    final resp = api.getWhereWhere('correo',email,'placa',placa);
    return resp;
  }

  Future<List<QueryDocumentSnapshot>> getVehiculosPorEmail(String email) async {
    List<QueryDocumentSnapshot> listaTemp = [];
    final resp = await api.getWhere('correo',email);
    resp.docs.forEach((element) {
      listaTemp.add(element);
    });
    return listaTemp;
  }

  Future<bool> updateVehiculo(VehiculoModel vehiculo, String id) async {
    bool bandera = false;
    final resp = await api
        .addDocumentWithId(id, vehiculo.toJson())
        .then((value) => bandera = true)
        .catchError((onError) => bandera = false);
    return bandera;
  }

  Future<bool> deleteVehiculo(String id) async {
    bool bandera = false;
    await api
      .removeDocument(id)
      .then((value) => bandera = true)
      .catchError((onError) => bandera = false);
    return bandera;
  }
}