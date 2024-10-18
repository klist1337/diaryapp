import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/helpers/function.dart';
import 'package:diaryapp/screens/diaryapp/login_page.dart';
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

  late AssetImage image;
  @override
  void initState() {
    super.initState();
    image = const AssetImage('assets/images/pastel.jpg');
  }

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    title.dispose();
    text.dispose();
    super.dispose();
  }
  final db = FirebaseFirestore.instance;
  TextEditingController title = TextEditingController();
  TextEditingController text = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  List<Map<String, dynamic>> feelings = 
  [ {"feeling":"Happy", "icon": const Icon(Icons.sentiment_very_satisfied, color: Colors.yellow,)},
    {"feeling": "Bad" ,"icon": const Icon(Icons.sentiment_neutral, color: Colors.greenAccent,) },
    {"feeling":"Fearful","icon": const Icon(Icons.sentiment_neutral, color: Colors.orange)},
    {"feeling":"Angry", "icon":const Icon(Icons.sentiment_neutral, color: Colors.red)},
    {"feeling":"Disgusted","icon": const Icon(Icons.sentiment_neutral, color: Colors.grey)},
    {"feeling":"Suprised", "icon":const Icon(Icons.sentiment_neutral, color: Colors.purple)},
    {"feeling":"Sad","icon": const Icon(Icons.sentiment_very_dissatisfied, color: Colors.blueAccent)},
    {"feeling":"Sick", "icon":const Icon(Icons.sick, color: Colors.pink)},
    ];
    IconData icon = Icons.sentiment_neutral;
    bool isPicked  = false;
    List<Map<String, dynamic>> iconColors = [
      {"feeling": "Happy", "color": Colors.yellow},
      {"feeling": "Bad", "color": Colors.greenAccent},
      {"feeling": "Fearful", "color": Colors.orange},
      {"feeling": "Angry", "color": Colors.red},
      {"feeling": "Disgusted", "color": Colors.grey},
      {"feeling": "Suprised", "color": Colors.purple},
      {"feeling": "Sad", "color": Colors.blueAccent},
      {"feeling": "Sick", "color": Colors.pink}
    ];
    String feeling = "";
    List<String> notesId = [];
  // List<Widget> icons = 
  // [ const Icon(Icons.sentiment_very_satisfied, color: Colors.yellow),
  //   const Icon(Icons.sentiment_neutral, color: Colors.greenAccent,),
  //   const Icon(Icons.sentiment_neutral, color: Colors.orange),
  //   const Icon(Icons.sentiment_neutral, color: Colors.red),
  //   const Icon(Icons.sentiment_neutral, color: Colors.grey),
  //   const Icon(Icons.sentiment_neutral, color: Colors.purple),
  //   const Icon(Icons.sentiment_very_dissatisfied, color: Colors.blueAccent),
  //   const Icon(Icons.sick, color: Colors.pink),
  //   ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover)
          ),
          child: Column(
            children: [
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     widget.photoUrl == null ?
              //       const CircleAvatar(
              //         child: Icon(Icons.person),
              //       )
              //     :
              //       Stack(
              //       children: [
              //         const ClipRRect(
              //           borderRadius: BorderRadius.all(Radius.circular(99)),
              //           child:CircleAvatar(
              //             backgroundColor: Colors.green,
              //             radius: 64,
              //           )  ,
              //         ),
              //         Positioned(
              //           left: 3.8,
              //           top: 3.8,
              //           child: CircleAvatar(
              //             radius: 60,
              //             backgroundImage: NetworkImage(widget.photoUrl!),
              //           ),
              //         ),
              //       ],
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(top: 40),
              //       child: Text(widget.displayName!, 
              //         style: const TextStyle(
              //           fontSize: 19,
              //           fontWeight: FontWeight.w600,
              //           fontStyle: FontStyle.italic,
              //         ),),
              //     ),
              //       Padding(
              //         padding: const EdgeInsets.only(top: 28),
              //         child: IconButton(
              //           onPressed: () async {
              //             await AuthService().logout();
              //             await clearLoginInfo();
              //             if (!context.mounted) return ;
              //             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
              //             },
              //           icon: const Icon(
              //             Icons.logout ,
              //             color: Colors.black,),),
              //       ),
              //   ],
              // ),
              StreamBuilder<QuerySnapshot>(
                stream: db.collection('notes').snapshots(), 
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (snapshot.hasError) {
                    return const Center(child: Text("Error something happen"));
                  }
                  else {
                    final notes = snapshot.data!.docs;
                    if (notes.isEmpty) {
                       return const Padding(
                         padding:  EdgeInsets.all(25.0),
                         child:  SizedBox(
                          height: 40,
                          child: Text("Nothing added yet")),
                       );
                    }
                    return SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.4,
                      child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return Center(
                            child: Stack(
                              children: [
                                Container(
                                  height: 80,
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: const BoxDecoration(
                                    color:  Color.fromARGB(255, 232, 171, 221)
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width * 0.8,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      color: Colors.white
                                    ),
                                    child: Text('here'),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                    );
                  }
              
                }),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF8D7F2)
                ),
                onPressed: () {
                  showDialog(context: context, builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return SingleChildScrollView(
                          child: AlertDialog(
                            actions: [
                              TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  setState(() {
                                    feeling = "";
                                    isPicked = false;
                                  });
                                },
                                child: const Text("Fermer", 
                                  style: TextStyle(
                                    fontFamily: "roboto",
                                ),)),
                                TextButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate() && feeling.isNotEmpty) {
                                      createDiaryEntry(title.text, text.text, feeling);
                                      setState(() {
                                        feeling = "";
                                        isPicked = false;
                                      });
                                      title.clear();
                                      text.clear();
                                      Navigator.pop(context);
                                    }
                                    else {
                                      showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          shape: const LinearBorder(),
                                          content: SizedBox(
                                            height: MediaQuery.sizeOf(context).height * 0.05,
                                            width: MediaQuery.sizeOf(context).width * 0.03,
                                            child: const Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Error', 
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                    ) ,),
                                                    SizedBox(width: 8.0,),
                                                    Icon(Icons.error,size: 16,),
                                                  ],
                                                ),
                                                Text('Please add something'),
                                              ],
                                            ),
                                          )
                                          ,
                                        );
                                          
                                      });
                                    }
                                  }, 
                                  child: const Text("Add", 
                                  style: TextStyle(
                                    fontFamily: "roboto",
                                    fontSize: 14
                                  ),) )
                            ],
                            shape: const LinearBorder(),
                            content: Builder(builder: (context) => 
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.65 ,
                              height: MediaQuery.sizeOf(context).height * 0.70,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Add new entry",
                                     style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                     )),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      controller: title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Title",
                                        hintStyle: const TextStyle(
                                          fontSize: 14
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade700
                                          )
                                        ),
                                        focusedBorder:OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade700
                                          )
                                        ),
                                        errorBorder:OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade700
                                          )
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade700
                                          )
                                        ), 
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter the title";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10,),
                                    const Text("Pick your day's feeling",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                      ),),
                                    const SizedBox(height: 10,),
                                    SizedBox(
                                      height: 48,
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) => const SizedBox(width: 2,),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: feelings.length  ,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            hoverColor: Colors.transparent,
                                            onTap: () {
                                              setState(() {
                                              isPicked = true;
                                              feeling = getFeeling(index)!;
                                              icon = getIcon(index)!.icon!;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                getIcon(index)!,
                                                Text(getFeeling(index)!,
                                                  style:const TextStyle(
                                                    fontSize: 10,
                                                    fontFamily: "roboto"
                                                  ) ,)
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    isPicked == false ?
                                    Column(
                                      children: [
                                        Center(
                                          child: Icon(icon, size: 60,)
                                        ),
                                        const Text("Nothing selected", 
                                         style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold
                                         ),)
                                      ],
                                    )
                                    : 
                                    Column(
                                      children: [
                                        Center(
                                          child: Icon(icon, size: 60, color: getColor(feeling),)
                                        ),
                                        Text(feeling, 
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold 
                                          ) ,)
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      controller: text,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold
                                      ),
                                      maxLines: 8,
                                      decoration: const InputDecoration(
                                        hintText: "Text",
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black, 
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey
                                          )
                                        ) ,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey
                                          )
                                        ) ,
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey
                                          )
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey
                                          )
                                        ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "please enter something";
                                          }
                                          return null;
                                        },
                                    )
                                  ],
                                ),
                              ),
                            ))
                          ),
                        );
                      }
                    );
                  });
                }, 
                label: const Text('Add entry', 
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),),
                icon: const Icon(Icons.add, color: Colors.black,),)
            ],
          ),
        ),
      ),
    );
  }

  void createDiaryEntry (String title, String text, String feeling) {
    final note = <String, dynamic>{
      "email": widget.email,
      "date": DateTime.now().toString(),
      "title": title, 
      "feeling": feeling,
      "content": text
    };
    db.collection("notes").add(note);
  }

 

  Icon? getIcon(int index) {
    for (int i = 0; i < feelings.length; i++) {
      if (index == i) {
        return feelings[i]["icon"];
      }
    }
    return null;
  }

  Icon? getIconByFeeling(String feeling) {
     for (var feel in feelings) {
      if (feel["feeling"] == feeling) {
        return feel["icon"];
      }
     }
     return null;
  }

  String? getFeeling(int index) {
    for (int i = 0; i < feelings.length; i++) {
      if (index == i) {
        return feelings[i]["feeling"];
      }
    }
    return null;
  }
  Color? getColor(String feeling) {
    for (var iconColor in iconColors ) {
      if (iconColor["feeling"] == feeling) {
        return iconColor["color"];
      }
    }
    return null;
  }

}