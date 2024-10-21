import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/helpers/function.dart';
import 'package:diaryapp/screens/diaryapp/login_page.dart';
import 'package:diaryapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


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
          child: ListView(
            children: [
              Column(
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
                    stream: db.collection('notes').orderBy('date', descending: true).snapshots(), 
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      else if (snapshot.hasError) {
                        return const Center(child: Text("Error something happen"));
                      }
                      else {
                        final notes = snapshot.data!.docs;
                        double ratio = (notes.length / 10) + 0.1 ;
                        if (notes.isEmpty) {
                           return const Padding(
                             padding:  EdgeInsets.all(25.0),
                             child:  SizedBox(
                              height: 40,
                              child: Text("Nothing added yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                                ))),
                           );
                        }
                        return Column(
                          children: [
                            const SizedBox(height: 10,),
                            const Text("Your last diary entries",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                            const SizedBox(height: 10,),
                            SizedBox(
                              height: notes.length < 8 ? MediaQuery.sizeOf(context).height * ratio 
                                      : MediaQuery.sizeOf(context).height * 0.8,
                              child: ListView.builder(
                                itemCount: notes.length,
                                itemBuilder: (context, index) {
                                  final note = notes[index];
                                  return Center(
                                    child: Container(
                                      height: 100,
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: const BoxDecoration(
                                        color:  Color.fromARGB(255, 232, 171, 221)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context, 
                                            builder: (context)  {
                                              return AlertDialog(
                                                content: Builder(builder: (context) {
                                                  return SingleChildScrollView(
                                                    child: SizedBox(
                                                      width: MediaQuery.sizeOf(context).width * 0.8,
                                                      height: text.text.length < 100 ? MediaQuery.sizeOf(context).height * 0.3 :
                                                              MediaQuery.sizeOf(context).height * 0.6,
                                                      child: Column(
                                                        children: [
                                                          Text(DateFormat("EEEE, MMMM d, yyyy").format(DateTime.parse(note['date'])).toString(),
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18
                                                            ),),
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                          Container(
                                                            width: MediaQuery.sizeOf(context).width * 0.8,
                                                            height: 2,
                                                            decoration: const BoxDecoration(
                                                              color: Colors.black
                                                            ),                                                
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              const Text("My feeling:", style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold
                                                              ),),
                                                              const SizedBox(width: 10,),
                                                              getIconByFeeling(note['feeling'])!
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10,),
                                                           Container(
                                                            width: MediaQuery.sizeOf(context).width * 0.8,
                                                            height: 2,
                                                            decoration: const BoxDecoration(
                                                              color: Colors.black
                                                            ),                                                
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          Text(note['content'], 
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold
                                                          ),)
                                                        ],
                                                      )
                                                    ),
                                                  );
                                                }),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      db.collection('notes').doc(note.id).delete();
                                                      Navigator.pop(context);
                                                    }, 
                                                    child: const Text('Delete this entry', 
                                                      style: TextStyle(
                                                        color: Colors.red
                                                      ),))
                                                ],
                                              );  
                                            },
                                            );
                                          },
                                          child: Container(
                                          height: 60,
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(123, 238, 238, 238)
                                          ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0, left: 20),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(getDay(note['date']), 
                                                        style:const TextStyle(
                                                          fontStyle: FontStyle.italic,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600
                                                        ),),
                                                      Text(getMonth(note["date"]), 
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                          fontStyle: FontStyle.italic
                                                                        
                                                        ) ,),
                                                      Text(getYear(note['date']), 
                                                        style: const TextStyle(
                                                          fontSize: 12
                                                        ),)
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 20,),
                                                getIconByFeeling(note['feeling'])!,
                                                const SizedBox(width: 20,),
                                                Container(
                                                width: 2,
                                                height: 60,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black
                                                ), 
                                                ),
                                                const SizedBox(width: 30,),
                                                Text(note['title'], 
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold
                                                  ),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            ),
                          ],
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
                                      title.clear();
                                      text.clear();
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
                                                child: Column(
                                                  children: [
                                                    const Row(
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
                                                    feeling.isEmpty ? const Text('Please add feeling') 
                                                                    : const Text("Please add something"),
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
                    label: const Text('New diary entry', 
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),),
                    icon: const Icon(Icons.add, color: Colors.black,),)
                ],
              ),
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

  getDay(String date) {
    final String dateDays = date.split(' ')[0];
    return dateDays.split('-')[2];
  }
  getYear(String date) {
    final String dateDays = date.split(' ')[0];
    return dateDays.split('-')[0];
  }

  getMonth(String date) {
    List<String> month =  ["January", "February", "March", "April", "May", "June", "July",
                            "August", "September", "October", "November", "December"];
    final monthNumber = int.parse(date.split('-')[1]);
    return month[monthNumber - 1];
  }

}