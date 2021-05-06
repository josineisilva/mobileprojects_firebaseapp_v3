import 'dart:async';
import '../models/student.dart';
import '../database/database.dart';

class StudentDao {
  String _errorMsg = "";

  String get errorMsg => _errorMsg;

  void handleSnapshot(_snapshot, EventSink _sink) {
    List<Student> ret = List<Student>();
    _snapshot.forEach((_map) {
      Student _student = Student.fromJson(_map);
      ret.add(_student);
    });
    _sink.add(ret);
  }

  Stream<List<Student>> snapshots() {
    StreamTransformer<List<Map>,List<Student>> snapshotTransformer =
    StreamTransformer.fromHandlers(handleData: handleSnapshot);
    return DatabaseHelper.snapshots('student')
      .transform(snapshotTransformer);
  }

  Future<List<Student>> getAll() async {
    print("DAO getAll");
    _errorMsg = "";
    List<Map> _maps = await DatabaseHelper.getAll(
      'student'
    ).catchError((_error) {
        _errorMsg = _error;
    });
    if (_maps != null) {
      List<Student> _students = [];
      if (_maps.length > 0) {
        for (int i = 0; i < _maps.length; i++) {
          _students.add(Student.fromJson(_maps[i]));
        }
      }
      return _students;
    } else
      return null;
  }

  Future<Student> getByID(String _id) async {
    print("DAO getByID");
    Student ret;
    _errorMsg = "";
    var response = await DatabaseHelper.getByID(
      "student",
      _id
    ).catchError((_error) {
      _errorMsg = _error;
    });
    if ( _errorMsg == "" ) {
      if (response.isNotEmpty)
        ret = Student.fromJson(response);
      else
        ret = Student.empty();
    }
    return ret;
  }

  Future<int> insert(Student _student) async {
    print("DAO insert");
    int ret;
    _errorMsg = "";
    ret = await DatabaseHelper.insert(
      'student',
      _student.toJson()
    ).catchError((_error) {
      _errorMsg = _error;
    });
    return ret;
  }

  Future<int> update(Student _student) async {
    print("DAO update");
    int ret;
    _errorMsg = "";
    ret = await DatabaseHelper.update(
      'student',
      _student.toJson(),
    ).catchError((_error) {
      _errorMsg = _error;
    });
    return ret;
  }

  Future<int> delete(String _id) async {
    print("DAO delete");
    int ret;
    _errorMsg = "";
    ret = await DatabaseHelper.delete(
      'student',
      _id,
    ).catchError((_error) {
      _errorMsg = _error;
    });
    return ret;
  }
}
