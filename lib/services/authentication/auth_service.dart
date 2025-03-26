import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Future<void> authWithGoogle() async {

    final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

    if (gUser == null) return;

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );

    await _auth.signInWithCredential(credentials);

  }

  Future <void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

}