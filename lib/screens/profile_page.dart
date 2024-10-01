import 'package:diaryapp/screens/login_page.dart';
import 'package:diaryapp/services/auth_service.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
   ProfilePage({
    super.key, 
   this.photoUrl,
    this.displayName,
    this.email
  });
  Uri? photoUrl;
  String? displayName;
 String? email;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 80,),
             ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout', 
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),),
              onTap: () async {
                await AuthService().logout();
                if (!context.mounted) return ;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
              },
            )
          ],
        ),
      ) ,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.photoUrl == null ?
              const CircleAvatar(
                child: Icon(Icons.person),
              )
            :
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(widget.photoUrl.toString()),
              ),
            Text(widget.displayName!, 
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),),
            const Text("connected", 
              style: TextStyle(
                fontSize: 40,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),),

          ],
        ) ,
      ),
    );
  }
}