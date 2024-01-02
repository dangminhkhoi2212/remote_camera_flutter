import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remote_camera/const/color_const.dart';
import 'package:remote_camera/pages/gellary.dart';
import 'package:remote_camera/pages/home.dart';
import 'package:remote_camera/pages/setting.dart';
import 'package:remote_camera/provider/index_bar.dart';
import 'package:remote_camera/widgets/appbar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => IndexBar())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MainPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: buildPages(),
          appBar: AppBar(
            backgroundColor: ColorConst.third,
            // elevation: 2,
            // shadowColor: Colors.black,
            title: Text(
              'Remote Camera',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
          ),
          bottomNavigationBar: buildBottomBar(),
        ),
      );

  Widget buildPages() {
    int index = context.watch<IndexBar>().indexBar;
    switch (index) {
      case 1:
        return HomePage();
      case 2:
        return GellaryPage();
      case 3:
        return SettingPage();
      default:
        return HomePage();
    }
  }

  Widget buildBottomBar() => AppbarCustom();
}
