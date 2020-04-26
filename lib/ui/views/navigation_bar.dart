import 'package:Discover/themes/theme.dart';
import 'package:Discover/ui/views/home_page.dart';
import 'package:Discover/ui/views/tracks_page.dart';
import 'package:Discover/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class NavigationView extends StatefulWidget {
  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  final CustomTheme _customTheme = new CustomTheme();
  Widget _bodyWidget;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    this._bodyWidget = _homepageView();
  }

  Widget _homepageView() {
    return HomepageView();
  }

  Widget _tracksView() {
    return TracksView();
  }

  void _setScaffoldBody(index) {
    switch (index) {
      case 0:
        setState(() {
          this._bodyWidget = _homepageView();
        });
        break;
      case 1:
        setState(() {
          this._bodyWidget = _tracksView();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _customTheme.getStyleUI(
      ThemeProvider.optionsOf<SystemUI>(context).ui,
    );
    return Scaffold(
      extendBody: true,
      body: _bodyWidget,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 36,
          left: 24,
          right: 24,
        ),
        child: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          changeIndex: (_index) {
            setState(() {
              _selectedIndex = _index;
              _setScaffoldBody(_selectedIndex);
            });
          },
        ),
      ),
    );
  }
}
