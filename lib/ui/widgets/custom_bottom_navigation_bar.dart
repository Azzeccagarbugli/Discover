import 'package:Discover/ui/widgets/effects/neumorphism.dart';
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
        color: ThemeProvider.themeOf(context).id == "light_theme"
            ? Colors.white
            : Colors.grey[900],
        borderRadius: new BorderRadius.circular(62),
        boxShadow: Neumorphism.boxShadow(context),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 10,
        ),
        child: GNav(
          gap: 8,
          activeColor: ThemeProvider.themeOf(context).data.primaryColor,
          textStyle: TextStyle(
            color: ThemeProvider.themeOf(context).data.textSelectionColor,
            fontWeight: FontWeight.w700,
          ),
          color: Colors.grey[800],
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
              iconActiveColor:
                  ThemeProvider.themeOf(context).data.textSelectionColor,
              backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
            ),
            GButton(
              icon: Icons.library_books,
              text: 'Tracks',
              iconActiveColor:
                  ThemeProvider.themeOf(context).data.textSelectionColor,
              backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
            ),
            GButton(
              icon: Icons.favorite,
              text: 'Saved',
              iconActiveColor:
                  ThemeProvider.themeOf(context).data.textSelectionColor,
              backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
              iconActiveColor:
                  ThemeProvider.themeOf(context).data.textSelectionColor,
              backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
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
