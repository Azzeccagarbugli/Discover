import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function changeIndex;

  const CustomBottomNavigationBar({
    @required this.selectedIndex,
    @required this.changeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.circular(62),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4.0, -4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 10,
        ),
        child: GNav(
          gap: 8,
          textStyle: TextStyle(
            color: ThemeProvider.themeOf(context).data.primaryColor,
            fontWeight: FontWeight.w700,
          ),
          color: Colors.grey[800],
          activeColor: ThemeProvider.themeOf(context).data.primaryColor,
          iconSize: 24,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          duration: Duration(
            milliseconds: 800,
          ),
          tabs: [
            GButton(
              active: true,
              icon: Icons.hearing,
              text: 'Listen',
              backgroundColor: Colors.blue[50],
            ),
            GButton(
              icon: Icons.library_books,
              text: 'Tracks',
              backgroundColor: Colors.blue[50],
            ),
            GButton(
              icon: Icons.favorite,
              text: 'Saved',
              backgroundColor: Colors.blue[50],
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
              backgroundColor: Colors.blue[50],
            ),
          ],
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            changeIndex(index);
          },
        ),
      ),
    );
  }
}
