import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t3_pais/database/model/pais_model.dart';

class PaisService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'paises',
  );

  Future<void> createPais(Pais pais) async {
    await _collection.add(pais.toMap());
  }

  Future<List<Pais>> getPaises() async {
    QuerySnapshot querySnapshot = await _collection.get();

    return querySnapshot.docs.map((doc) {
      return Pais.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> updatePais(Pais pais) async {
    if (pais.id != null) {
      await _collection.doc(pais.id).update(pais.toMap());
    }
  }

  Future<void> deletePais(String id) async {
    await _collection.doc(id).delete();
  }
}
