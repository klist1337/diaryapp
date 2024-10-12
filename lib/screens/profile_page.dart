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
                    backgroundColor: Colors.white
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
                                  ),))
                              ],
                              shape: const LinearBorder(),
                              content: Builder(builder: (context) => 
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.65 ,
                                height: MediaQuery.sizeOf(context).height * 0.70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Add new entry",
                                     style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                     )),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "Title",
                                        hintStyle: const TextStyle(
                                          fontSize: 22,
                                          color: Colors.black
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
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    const Text("Pick your day feeling",
                                      style: TextStyle(
                                        fontSize: 21,
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
                                          fontSize: 28,
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
                                        Text("You choose $feeling", 
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold 
                                          ) ,)
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      maxLines: 10,
                                      decoration: const InputDecoration(
                                        hintText: "Text",
                                        hintStyle: TextStyle(
                                          fontSize: 21,
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
                                        ),
                                    )
                                  ],
                                ),
                              ))
                            ),
                          );
                        }
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

  Icon? getIcon(int index) {
    for (int i = 0; i < feelings.length; i++) {
      if (index == i) {
        return feelings[i]["icon"];
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