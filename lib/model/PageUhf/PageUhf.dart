import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:uhf_c72_plugin/uhf_c72_plugin.dart';
import 'package:uhf_c72_plugin/tag_epc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uhf_scan/model/setting/globalvar.dart' as global;
import 'package:uhf_scan/model/PageTask/PageTask.dart';
import 'package:uhf_scan/main.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
class ScanUhf extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ScanUhf> {
  String? _platformVersion = 'Unknown';
  bool _isStarted = false;
  bool _isEmptyTags = false;
  bool _isConnected = false;
  TextEditingController powerLevelController =
  TextEditingController(text: '26');
  TextEditingController workAreaController = TextEditingController(text: '3');
  String poverAnt = global.poverAntena.toString();
  Color buttonColor = Colors.green;
  bool isFetching = false;
  String? resultTruck = ' ';
  String? resultTrailer = ' ';
  String truck2 = '';
  int countS = 0;
  late String? taskId;
  late String? httpType;
  late String? taskWaypoint;
  late String? taskWaypointName;
  late String? taskWaypointTruck;
  late String? taskWaypointTrailer;
  late String? taskDate;
  late String? taskDriverName;
  late String? taskName;
  final String assetName = 'assets/kernel-logo.svg';
  final Widget svg = SvgPicture.asset(
      'assets/kernel-logo.svg',
      semanticsLabel: 'Acme Logo'
  );

  @override
  void initState() {
    super.initState();
    //initPlatformState();
    //НомерТТН
    if (global.taskId == null) {
      taskId = '';
    }
    else {
      taskId = global.taskId;
    };

    if (global.httpType == true) {
      httpType = 'https://';
    }
    else {
      httpType = 'http://';
    };

    if (global.taskWaypointId == null) {
      taskWaypoint = '';
    }
    else {
      taskWaypoint = global.taskWaypointId;
    };

    if (global.taskWaypointName == null) {
      taskWaypointName = '';
    }
    else {
      taskWaypointName = global.taskWaypointName;
    };

    if (global.taskWaypointTruck == null) {
      taskWaypointTruck = '';
    }
    else {
      taskWaypointTruck = global.taskWaypointTruck;
    };

    if (global.taskWaypointTrailer == null) {
      taskWaypointTrailer = '';
    }
    else {
      taskWaypointTrailer = global.taskWaypointTrailer;
    };


    if (global.taskDriverName == null) {
      taskDriverName = '';
    }
    else {
      taskDriverName = global.taskDriverName;
    };


    if (global.taskName == null) {
      taskName = '';
    }
    else {
      taskName = global.taskName;
    };
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await UhfC72Plugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    UhfC72Plugin.connectedStatusStream
        .receiveBroadcastStream()
        .listen(updateIsConnected);
    UhfC72Plugin.tagsStatusStream.receiveBroadcastStream().listen(updateTags);

    await UhfC72Plugin.connect;
    await UhfC72Plugin.setWorkArea('3');
    await UhfC72Plugin.setPowerLevel(poverAnt);
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  List<String> _logs = [];

  void log(String msg) {
    setState(() {
      _logs.add(msg);
    });
  }

  List<TagEpc> _data = [];

  void updateTags(dynamic result) {
    setState(() {
      _data = TagEpc.parseTags(result);
      if (resultTruck == '') {
        resultTruck = _data[0].epc.substring(4);
      }
      if (resultTrailer == '') {
        resultTrailer = _data[0].epc.substring(4);
      }
      countS = _data.length;
      if (countS > 0) {
        UhfC72Plugin.stop;
        buttonColor = Colors.green;
      }
    });
  }

  void updateIsConnected(dynamic isConnected) {
    log('connected $isConnected');
    //setState(() {
    _isConnected = isConnected;
    //});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar( title: Text('Форма сканування РФІД мітки'),
            backgroundColor: Colors.blueGrey, centerTitle: true,),
          body: Scaffold(
              body: Container(
                  child: SingleChildScrollView(
                      child: Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: <Widget>[
                                      RaisedButton(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25

                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                18.0),
                                          ),
                                          color: buttonColor,
                                          child: Text(
                                            'Сканувати авто',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            await UhfC72Plugin.clearData;
                                            buttonColor = Colors.blueGrey;
                                            setState(() {
                                              _data = [];
                                              countS = 0;
                                              resultTruck = '';
                                            });
                                            bool? isStarted = await UhfC72Plugin
                                                .startContinuous;
                                          }),
                                      RaisedButton(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25),
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                18.0),
                                          ),
                                          color: buttonColor,
                                          child: Text(
                                            'Сканувати прицеп',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () async {
                                            await UhfC72Plugin.clearData;
                                            buttonColor = Colors.blueGrey;

                                            setState(() {
                                              _data = [];
                                              countS = 0;
                                              resultTrailer = '';
                                            });
                                            bool? isStarted = await UhfC72Plugin
                                                .startContinuous;
                                          }),

                                    ]
                                )

                            ),
                            Align(
                                child:
                                (buttonColor == Colors.blueGrey) ?
                                Align(child: Text(("Піднесіть сканер до мітки"),
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.blue)),
                                    alignment: Alignment.center) :
                                Align(child: Text((""),),
                                    alignment: Alignment.center)),
                            Divider(
                                color: Colors.blueGrey
                            ),
                            Container(
                              child: ListTile(
                                  leading: FaIcon(FontAwesomeIcons.tasks),
                                  title: Text('Назва завдання'),
                                  subtitle: Text(("" + '$taskName' ),
                                      style: TextStyle(
                                          fontSize: 15.0, fontWeight: FontWeight
                                          .bold, color: Colors.black))
                              ),
                            ),
                            Divider(
                                color: Colors.blueGrey
                            ),
                            Container(
                              child: ListTile(
                                  leading: FaIcon(FontAwesomeIcons.table),
                                  title: Text('Тип завдання'),
                                  subtitle: Text(("" + '$taskWaypoint'),
                                      style: TextStyle(
                                          fontSize: 15.0, fontWeight: FontWeight
                                          .bold, color: Colors.black))
                              ),
                            ),
                            Divider(
                                color: Colors.blueGrey
                            ),
                            Container(
                              child: ListTile(
                                  leading: FaIcon(FontAwesomeIcons.truck),
                                  title: Text('Автомобіль'),
                                  subtitle: Text(("" + '$taskWaypointTruck'),
                                      style: TextStyle(
                                          fontSize: 15.0, fontWeight: FontWeight
                                          .bold, color: Colors.black))

                              ),
                            ),
                            //resultTruck
                            Align(child: Text(("    " + '$resultTruck'),
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.blue)),
                              alignment: FractionalOffset.bottomLeft,),
                            Divider(
                                color: Colors.blueGrey
                            ),
                            Container(
                              child: ListTile(
                                  title: Text('Причіп'),
                                  leading: FaIcon(FontAwesomeIcons.trailer),
                                  subtitle: Text(("" + '$taskWaypointTrailer'),
                                      style: TextStyle(
                                          fontSize: 15.0, fontWeight: FontWeight
                                          .bold, color: Colors.black))

                              ),

                            ),
                            Align(child: Text(("    " + '$resultTrailer'),
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.blue)),
                              alignment: FractionalOffset.bottomLeft,),

                            Divider(
                                color: Colors.blueGrey
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),

                              child: (resultTruck != ' ') &&
                                  (buttonColor == Colors.green)   ? RaisedButton(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  color: Colors.pink,
                                  child: Text(
                                    'Присвоїти',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: setUhfData) : Container(
                              ),

                              margin: EdgeInsets.only(top: 0.0),
                            )


                          ]
                      )
                  )
              ))
      ),
    );
  }


  Future<void> setUhfData() async {
    if (!isFetching) {
      setState(() {
        isFetching = true;
      });

      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);


      String url = '$httpType' +  global.urlVar  + "/tasks";

      Map map = {
        "truck_rfid": resultTruck,
        "trailer_rfid": resultTrailer,
        "task_id": global.taskId,

      };

      HttpClientRequest request = await client.postUrl(Uri.parse(url));

      request.headers.set('content-type', 'application/json');

      request.add(utf8.encode(json.encode(map)));

      HttpClientResponse response = await request.close();

      if (200 == response.statusCode) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Main_Page())
        );
      } else {
        var responseBody = await response.transform(utf8.decoder).join();

        Map jsonResponse = json.decode(responseBody);

        global.InfoError  =  jsonResponse['error'];

            Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Error_post()),
        );
      }
      setState(() {
        isFetching = false;
      });
    }
  }


}


class Error_post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AlertDialog dialog = AlertDialog(
      title: Text('Помилка при спробі присвоїти мітку.Повторити спробу?'),
      content:
      Text(global.InfoError),
      actions: [
        FlatButton(
          textColor: Color(0xFF6200EE),
          onPressed: () =>  { Navigator.of(context).popUntil((route) => route.isFirst) },
          child: Text('Ні'),
        ),
        FlatButton(
          textColor: Color(0xFF6200EE),
          onPressed: () { Navigator.pop(
            context,MaterialPageRoute(builder: (context) => ScanUhf()),
          );
          },
          child: Text('Так'),
        ),
      ],
    );
    return Scaffold(
        body:dialog
    );
  }



}
