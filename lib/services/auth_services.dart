// Singleton class
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthService {
  // Private Named Constructor
  AuthService._pc();

  // Static Final Object
  static final AuthService instance = AuthService._pc();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> anonymousLogin() async {
    UserCredential credential = await auth.signInAnonymously();

    return credential.user;
  }

  Future<User?> register({required String email, required String psw}) async {
    User? user;

    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: psw);
      user = credential.user;
    } catch (e) {
      Logger().e("EXCEPTION: ${e.toString()}");
    }
    return user;
  }

  Future<User?> signIn({required String email, required String psw}) async {
    User? user;

    try {
      UserCredential credential =
          await auth.signInWithEmailAndPassword(email: email, password: psw);
      user = credential.user;
    } catch (e) {
      Logger().e("EXCEPTION: ${e.toString()}");
    }
    return user;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }

  Future<void> logOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
  }
}
