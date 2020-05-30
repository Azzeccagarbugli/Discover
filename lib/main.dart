import 'package:Discover/models/track.dart';
import 'package:Discover/themes/theme.dart';
import 'package:Discover/ui/views/intro.dart';
import 'package:Discover/ui/views/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(TrackAdapter());
  await Hive.openBox<Track>(Discover.trackBoxName);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(Discover());
}

class Discover extends StatelessWidget {
  final CustomTheme _customTheme = new CustomTheme();

  static String trackBoxName = "track";

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: [
        _customTheme.getDark(),
        _customTheme.getLight(),
      ],
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ThemeConsumer(
          child: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (BuildContext context,
                AsyncSnapshot<SharedPreferences> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return LoadingScreen();
                default:
                  return snapshot.data.getBool("welcome") != null
                      ? NavigationView()
                      : IntroView();
              }
            },
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ThemeProvider.themeOf(context).data.scaffoldBackgroundColor,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            ThemeProvider.themeOf(context).data.textSelectionColor,
          ),
        ),
      ),
    );
  }
}
