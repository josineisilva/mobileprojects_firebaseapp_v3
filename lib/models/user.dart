//
// Modelo para dados do usuario
//
class User {
  String email;
  String password;

  // Construtor padrao
  User({this.email, this.password});

  // Construtor de uma sessao vazia
  User.empty() {
    email = "";
    password = "";
  }

  // Construtor baseando em JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password']
    );
  }

  // Converte um usuario para JSON
  Map<String, dynamic> toJson() {
    var map = {
      'email': email,
      'password': password
    };
    return map;
  }
}