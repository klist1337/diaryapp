
import 'package:diaryapp/screens/calendar.dart';
import 'package:diaryapp/screens/profile_page.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({
  super.key, 
  this.photoUrl,
  this.displayName,
  this.email
  });
  final String? photoUrl;
  final String? displayName;
  final String? email;

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
  List<Widget> pages = [ProfilePage(photoUrl: widget.photoUrl, displayName: widget.displayName, email: widget.email,), const Calendar() ];
    return Scaffold(
      body: pages[currentIndex] ,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green.shade100,
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