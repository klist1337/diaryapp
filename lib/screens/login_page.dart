import 'package:diaryapp/firebase_options.dart';
import 'package:diaryapp/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           SizedBox(
              height: 50,
              child: SignInButton(
                Buttons.google,
                text: "Login with Google",
                onPressed: () async {
                  try {
                    showDialog(context: context, builder: (context) => 
                    const Center(child: CircularProgressIndicator(),));
                    final userCredential =  await signInWithGoogle();
                    if (!context.mounted) return ;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => const ProfilePage(),));
                  }
                  catch (e) {
                    if (!context.mounted) return ;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Column(
                        children: [
                          Text(e.toString())
                        ],
                      ),)
                    );
                    Navigator.pop(context);
                  }

                }))
          ],
        ),
      ),
    );
  }
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId: (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.android) ?
        DefaultFirebaseOptions.currentPlatform.androidClientId : DefaultFirebaseOptions.currentPlatform.iosClientId,  
    ).signIn() ;

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}