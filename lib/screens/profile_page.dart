import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/helpers/function.dart';
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
  String? photoUrl;
  String? displayName;
  String? email;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/background1.jpg'),
            fit: BoxFit.cover)
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.photoUrl == null ?
                      const CircleAvatar(
                        child: Icon(Icons.person),
                      )
                    :
                      Stack(
                      children: [
                        const ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(99)),
                          child:CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 64,
                          )  ,
                        ),
                        Positioned(
                          left: 3.8,
                          top: 3.8,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(widget.photoUrl!),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(widget.displayName!, 
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),),
                    ),
                      Padding(
                        padding: const EdgeInsets.only(top: 38),
                        child: IconButton(
                          onPressed: () async {
                            await AuthService().logout();
                            await clearLoginInfo();
                            if (!context.mounted) return ;
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                            },
                          icon: const Icon(
                            Icons.logout ,
                            color: Colors.black,),),
                      ),
                  ],
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        shape: const LinearBorder(),
                        content: Builder(builder: (context) => 
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.6 ,
                          height: MediaQuery.sizeOf(context).height * 0.65,
                        ))
                      );
                    });
                    //createDiaryEntry();
                  }, 
                  label: const Text('Add entry', 
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),),
                  icon: const Icon(Icons.add, color: Colors.black,),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createDiaryEntry () {
    final note = <String, dynamic>{
      "email": "meneur2017@gmail.com",
      "date": DateTime.now().toString(),
      "title": "hii",
      "feeling": "satisfied",
      "content": "lorem ipsum trpmmp rtpmm rtpmmtpr mrtpmrptmptmrm"
    };
    db.collection("notes").add(note).then((DocumentReference doc) => print('DocumentSnapshot added with ID : ${doc.id}'));
  }
}