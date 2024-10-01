import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:diaryapp/screens/profile_page.dart';
import 'package:diaryapp/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //UserProfile? userProfile;

  @override
  Widget build(BuildContext context) {
    Future login() async {
      final profile = await AuthService().login();
      if (!context.mounted) return ;
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => ProfilePage(
        photoUrl: profile?.pictureUrl,
        displayName: profile?.nickname,
        email: profile?.nickname,
      )));
    }
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_image.jpg'),
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
            fontSize: 50,
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
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),)),
           ) 
          ],
        ),
      ),
    );
  }
}