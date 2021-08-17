import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:places_app/models/afiliado_model.dart';
import 'package:places_app/models/categoria_model.dart';
import 'package:places_app/services/api.dart';
import 'package:uuid/uuid.dart';

class AfiliadosService {
  Api afiliadosDB = new Api('afiliados');
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference ref;
  //AfiliadosService() {}

  void crearAfiliado(Afiliado afiliado) async {
    afiliadosDB.addDocument(afiliado.toJson());
  }

  Future<List<Afiliado>> getByCategoria() async {
    //var result = await afiliadosDB.getDataCollection();
    ref = _db.collection("afiliados");
    var result = await ref.where("aprobado", isEqualTo: true).get();
    List<Afiliado> data = [];
    data =
        result.docs.map((doc) => Afiliado.fromMap(doc.data(), doc.id)).toList();
    return data;
  }

  //
  Future<List<Afiliado>> loadByRating() async {
    ref = _db.collection("afiliados");
    var result = await ref.where("aprobado", isEqualTo: true).get();
    List<Afiliado> data = [];
    data =
        result.docs.map((doc) => Afiliado.fromMap(doc.data(), doc.id)).toList();
    return data;
  }

  Future<List<Afiliado>> loadByCategoria(Categoria c) async {
    //var result = await afiliadosDB.getWhere('categoria', c.nombre);
    ref = _db.collection("afiliados");
    var result = await ref.where("categoria", isEqualTo: c.nombre).where("aprobado", isEqualTo: true).get();
    List<Afiliado> data = [];
    data =
        result.docs.map((doc) => Afiliado.fromMap(doc.data(), doc.id)).toList();
    return data;
  }

  Future<Afiliado> getByUser(String email) async {
    try {
      final resp = await afiliadosDB.getWhere('user', email);
      if (resp.docs.length > 0) {
        return Afiliado.fromMap(resp.docs.first.data(), resp.docs.first.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  Future<Afiliado> updateDocument(Afiliado afiliado) async {
    try {
       await afiliadosDB.updateDocument(afiliado.toJson(),afiliado.id);
      
      return null;
    } catch (e) {
      return null;
    }
  }
}
