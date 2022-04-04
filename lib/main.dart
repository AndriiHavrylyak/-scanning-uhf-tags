import 'package:flutter/material.dart';
import 'package:uhf_scan/model/PageTask/PageTask.dart';
import 'package:uhf_scan/model/Setting_page/setting_glob.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhf_scan/model/setting/globalvar.dart' as global;

void main() async {



  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  global.urlVar =  prefs.getString('apiUrl');
  global.passUser =  prefs.getString('userPass');
  global.nameUser =  prefs.getString('userId');
  global.poverAntena =  prefs.getDouble('PoverAntena') ?? 11.0;
  global.httpType =  prefs.getBool('httpType') ?? false;
  global.upadateTime =  prefs.getDouble('upadateTime') ?? 10.0;
  global.limit =  prefs.getDouble('limit') ?? 20.0;
  runApp(Main_Page());


}

class Main_Page extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MainMenu> {
  int _currentIndex=0;
  List _screens=[TaskList(),Setting() ];

  void _updateIndex(int value) {
    setState(() {
      _currentIndex = value;

    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child:Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _updateIndex,
        selectedItemColor: Colors.blue[700],
        selectedFontSize: 13,
        unselectedFontSize: 13,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            label: "Завдання",
            icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: "Налаштування",
            icon: Icon(Icons.settings),
          ),

        ],
      ),)
    );
  }
  Future<bool> _onBackPressed() async {
    return await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Ви хочете вийти з додатку?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () =>  {Navigator.of(context).popUntil((route) => route.isFirst) },
            child:
            Text("Ні",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(height: 40),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("Так",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }


}
