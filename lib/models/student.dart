//
// Modelo para dados do estudante
//
class Student {
  String id;
  String name;
  int age;
  String email;

  // Construtor padrao
  Student({this.id, this.name, this.age, this.email});

  // Construtor de um estudante vazio
  Student.empty() {
    id = "";
    name = "";
    age = 0;
    email = "";
  }

  // Construtor baseando em JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      email: json['email']
    );
  }

  // Converte um estudante para JSON
  Map<String, dynamic> toJson() {
    var map = {
      'id': id,
      'name': name,
      'age': age,
      'email': email
    };
    return map;
  }
}
