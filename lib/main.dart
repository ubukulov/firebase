import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(FirebaseApp());
}

class FirebaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Авторизация...'),
        ),
        body: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: Text('Login with Google'),
                      onPressed: _signIn,
                    ),
                    ElevatedButton(
                      child: Text('Login with Facebook'),
                      onPressed: signInWithFacebook,
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('Успешно авторизовались!'),
              );
            }
          },
        ),
      ),
    );
  }

  void _signIn() {
    if(kIsWeb) {
      signInWithGoogleWeb();
    } else {
      signInWithGoogle();
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  Future<UserCredential> signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint' : 'ubukulov2@gmail.com'});
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

        return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      }
    } catch (e) {
      print('Error signing in with Facebook: $e');
    }
  }
}