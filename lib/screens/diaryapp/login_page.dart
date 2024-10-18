import 'package:diaryapp/helpers/function.dart';
import 'package:diaryapp/screens/diaryapp/diary_app.dart';
import 'package:diaryapp/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

late AssetImage backgroundImage;

@override
  void initState() {
    super.initState();
    backgroundImage = const AssetImage('assets/images/bg_image.jpg');
  }

  @override
  void didChangeDependencies() {
    precacheImage(backgroundImage, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future login() async {
      final profile = await AuthService().login();
      saveLoginStatus(profile!.pictureUrl.toString(), profile.nickname!, profile.email!);
      if (!context.mounted) return ;
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => DiaryApp(
        photoUrl: profile.pictureUrl.toString(),
        displayName: profile.nickname,
        email: profile.email,
      )));
    }
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backgroundImage ,
            fit: BoxFit.cover
          )
        ) ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.38,),
          const Text('Welcome to your diary',
          style: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold
          ),),
          SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.06,),
           SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.3,
             child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape:const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                )
              ),
              onPressed: (){
                login();
              }, 
              child: const Text('Login', 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black
              ),)),
           ) 
          ],
        ),
      ),
    );
  }
}