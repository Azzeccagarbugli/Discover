import 'package:Discover/models/track.dart';
import 'package:Discover/themes/theme.dart';
import 'package:Discover/ui/views/intro.dart';
import 'package:Discover/ui/views/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
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
        _customTheme.getLight(),
        _customTheme.getDark(),
      ],
      // saveThemesOnChange: true,
      // loadThemeOnInit: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ThemeConsumer(
          // child: NavigationView(),
          child: IntroView(),
        ),
      ),
    );
  }
}
