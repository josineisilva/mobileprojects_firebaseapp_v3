import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  static final AuthHelper _instance = AuthHelper.internal();
  factory AuthHelper() => _instance;
  AuthHelper.internal();

  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> signInWithGoogle() async {
    print("signInWithGoogle");
    String _errorMsg = "";
    final GoogleSignInAccount _googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
    final _credential = GoogleAuthProvider.credential(
      accessToken: _googleAuth.accessToken,
      idToken: _googleAuth.idToken,
    );
    UserCredential _userCredential;
    _userCredential = await FirebaseAuth.instance.signInWithCredential(_credential)
      .catchError((_error) {
        _errorMsg = "${_error}";
      });
    if (_userCredential != null) {
      User _user = _userCredential.user;
      print("signed in " + _user.email);
      return true;
    }
    else
      return Future<bool>.error(_errorMsg);
  }

  static Future<bool> createUser(String _email, String _password) async {
    print("createUser");
    String _errorMsg = "";
    final _authResult = await _auth.createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    ).catchError((_error) {
      _errorMsg = "${_error}";
    });
    if ( _authResult != null ) {
      print("signed in ");
      return true;
    }
    else
      return Future<bool>.error(_errorMsg);
  }

  static Future<bool> signInWithEmail(String _email, String _password) async {
    print("signInWithEmail");
    String _errorMsg = "";
    final _authResult = await _auth.signInWithEmailAndPassword(
      email: _email,
      password: _password,
    ).catchError((_error) {
      _errorMsg = "${_error}";
    });
    if ( _authResult != null ) {
      print("signed in ");
      return true;
    }
    else
      return Future<bool>.error(_errorMsg);
  }
}
