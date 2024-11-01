import 'package:diaryapp/helpers/function.dart';
import 'package:diaryapp/screens/advanced_diary_app/advanced_diary_app.dart';
import 'package:diaryapp/screens/advanced_diary_app/login_page2.dart';
import 'package:diaryapp/screens/diaryapp/diary_app.dart';
import 'package:diaryapp/screens/diaryapp/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  final bool loggedIn = await isLoggin();
  final String? pictureUrl = await getPictureUrl();
  final String? displayName = await getDisplayName();
  final String? email = await getEmail();

  runApp (MyApp(
    isLoggin: loggedIn, 
    picture: pictureUrl, 
    displayName: displayName,
    email: email));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, 
  required this.isLoggin,
  required this.picture,
  required this.displayName, 
  required this.email
  });
  final bool isLoggin;
  final String? picture;
  final String? displayName;
  final String? email;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true
        ),
        useMaterial3: true,
        fontFamily: "cereal"
      ),
      home: isLoggin == true
        ? AdvancedDiaryApp(photoUrl: picture, displayName: displayName, email: email,)
        : const LoginPage2()
    );
  }
}
