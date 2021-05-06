import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();

  static final _db = FirebaseFirestore.instance;

  static void handleSnapshot(_snapshot, EventSink _sink) {
    List<Map> ret = List<Map>();
    _snapshot.docs.forEach((_document) {
      Map _map = _document.data();
      _map['id'] = _document.id;
      ret.add(_map);
    });
    _sink.add(ret);
  }

  static Stream<List<Map>> snapshots(String _table) {
    StreamTransformer<QuerySnapshot,List<Map>> snapshotTransformer =
    StreamTransformer.fromHandlers(handleData: handleSnapshot);
    return FirebaseFirestore.instance.collection(_table).snapshots()
      .transform(snapshotTransformer);
  }
 
  static Future<List<Map>> getAll(String _table) async {
    print("Database getAll");
    List<Map> ret;
    String _errorMsg = "";
    QuerySnapshot _query = await _db.collection(_table).get()
      .catchError((_error) {
        _errorMsg = "${_error}";
    });
    if (_query != null) {
      ret = List<Map>();
      List<DocumentSnapshot> _documents = _query.docs;
      for (int i = 0; i < _documents.length; i++) {
        Map _map = _documents[i].data();
        _map['id'] = _documents[i].id;
        ret.add(_map);
      }
    }
    if (ret != null)
      return ret;
    else
      return Future<List<Map>>.error(_errorMsg);
  }

  static Future<Map> getByID(String _table, String _id) async {
    print("Database getByID");
    Map ret;
    String _errorMsg = "";
    DocumentSnapshot _document = await _db.collection(_table).doc(_id)
      .get()
      .catchError((_error) {
        _errorMsg = "${_error}";
      });
    if (_document != null) {
      ret = _document.data();
      ret['id'] = _document.id;
    }
    if (ret != null)
      return ret;
    else
      return Future<Map>.error(_errorMsg);
  }

  static Future<int> insert(String _table, Map _map) async {
    print("Database insert");
    int ret;
    String _errorMsg = "";
    _map.remove('id');
    DocumentReference _documentReference = await _db.collection(
      _table
    ).add(_map)
     .catchError((_error) {
       _errorMsg = "${_error}";
    });
    if(_documentReference.id != null)
      ret = 1;
    if (ret != null)
      return ret;
    else
      return Future<int>.error(_errorMsg);
  }

  static Future<int> update(String _table, Map _map) async {
    print("Database update");
    int ret;
    String _errorMsg = "";
    String _id = _map['id'];
    _map.remove('id');
    await _db.collection(_table).doc(_id)
      .update(_map)
      .catchError((_error) {
        _errorMsg = "${_error}";
      });
    if (_errorMsg == "")
      ret = 1;
    if (ret != null)
      return ret;
    else
      return Future<int>.error(_errorMsg);
  }

  static Future<int> delete(String _table, String _id) async {
    print("Database delete");
    int ret;
    String _errorMsg = "";
    await _db.collection(_table).doc(_id).delete()
      .catchError((_error) {
        _errorMsg = "${_error}";
      });
    if (_errorMsg == "")
      ret = 1;
    if (ret != null)
      return ret;
    else
      return Future<int>.error(_errorMsg);
  }

  void close() {
    print("CloseDB");
  }
}
