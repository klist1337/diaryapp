
import 'package:diaryapp/screens/advanced_diary_app/calendar.dart';
import 'package:diaryapp/screens/advanced_diary_app/profile_page.dart';
import 'package:flutter/material.dart';

class AdvancedDiaryApp extends StatefulWidget {
  const AdvancedDiaryApp({
  super.key, 
  this.photoUrl,
  this.displayName,
  this.email
  });
  final String? photoUrl;
  final String? displayName;
  final String? email;

  @override
  State<AdvancedDiaryApp> createState() => _AdvancedDiaryAppState();
}

class _AdvancedDiaryAppState extends State<AdvancedDiaryApp> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
  List<Widget> pages = [ProfilePage(photoUrl: widget.photoUrl, displayName: widget.displayName, email: widget.email,), const Calendar() ];
    return Scaffold(
      body: pages[currentIndex] ,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 232, 171, 221),
        selectedItemColor: Colors.black,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        currentIndex: currentIndex,
        items:const [
          BottomNavigationBarItem(
            icon:  Icon(Icons.person),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "")
        ] )
    );
  }
}