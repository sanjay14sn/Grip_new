import 'package:flutter/material.dart';

class BottomAppBarMenu extends StatefulWidget {
  @override
  _BottomAppBarMenuState createState() => _BottomAppBarMenuState();
}

class _BottomAppBarMenuState extends State<BottomAppBarMenu> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Floating menu buttons
          if (isMenuOpen)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _menuItem(Icons.group, "Referrals"),
                  _menuItem(Icons.handshake, "Thank U Notes"),
                  _menuItem(Icons.chat, "Testimonials"),
                  _menuItem(Icons.group_work, "One-To-Ones"),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: CircleBorder(side: BorderSide(color: Colors.red, width: 2)),
        child: Icon(
          isMenuOpen ? Icons.close : Icons.add,
          color: Colors.red,
        ),
        onPressed: () {
          setState(() {
            isMenuOpen = !isMenuOpen;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height:60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.red),
                onPressed: () {},
              ),
              SizedBox(width:40), // space for FAB
              IconButton(
                icon: Icon(Icons.person, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
