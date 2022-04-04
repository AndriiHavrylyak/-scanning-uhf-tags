import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import  'package:uhf_scan/model/setting/globalvar.dart' as global;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uhf_scan/model/PageUhf/PageUhf.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
 class TaskList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('Завдання'), backgroundColor: Colors.blueGrey,
        centerTitle: true,),
      body: TaskListParse(),

    );
  }

}
class TaskListParse extends StatefulWidget {


  TaskListParse() : super();

  @override
  _JsonParseObjectsTask createState() => _JsonParseObjectsTask();
}

class _JsonParseObjectsTask extends State <StatefulWidget> {
  String limit = global.limit.toString();
  int updTime = global.upadateTime.toInt();
  List<TaskDetails> _searchResult = [];
  List<TaskDetails> _taskDetails = [];
  List<TaskDetails> _taskBarcode = [];
  TextEditingController controller = new TextEditingController();
  late String? httpType;

  String? _mySeals;





  Future<Null> getTaskDetails() async {

    final String url = '$httpType' +  global.urlVar + '/tasks';

    HttpClient client = new HttpClient();

    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);


    final request = await client
        .getUrl(Uri.parse(url))
        .timeout(Duration(seconds: 5));

    HttpClientResponse response = await request.close();


    var responseBody = await response.transform(utf8.decoder).join();


    final responseJson = json.decode(responseBody);
    List<TaskDetails> _temp=[];

    if (200 == response.statusCode) {
      setState(() {
        for (Map<String,dynamic> user in responseJson) {
          _temp.add(TaskDetails.fromJson(user));
        };
        _taskDetails=_temp;
      }
      );
    }   else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Error_connect()),
      );
    }


  }
  late Timer _timer;
  @override
  void initState() {
    if (global.httpType == true) {
      httpType = 'https://';
    }
    else {
      httpType = 'http://';
    };
    _timer = Timer.periodic(Duration(seconds: updTime),(_) => getTaskDetails());
    super.initState();
    getTaskDetails();
  }

  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }


  Widget _buildUsersList() {
    return new ListView.builder(
      itemCount: _taskDetails.length,
      itemBuilder: (context, index) {
        return new Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white38,
          margin: EdgeInsets.symmetric(vertical: 7),
          child: ListTile(
              title: Text(
                _taskDetails[index].name,
                style: TextStyle(fontSize: 15,
                  color: Colors.black)
              ),
              subtitle: Text("Водій:${_taskDetails[index].driver_name}; Дата:${ DateFormat('y-MM-dd HH:mm:ss').format(DateTime.parse(_taskDetails[index].task_date)) }"),
              leading: FaIcon(FontAwesomeIcons.truck),
              onTap: () =>
              {
                  global.taskId =  _taskDetails[index].id,
                  global.taskName =  _taskDetails[index].name,
                  global.taskDate = DateTime.parse(_taskDetails[index].task_date),
                  global.taskWaypointId =  _taskDetails[index].waypoint_id,
                  global.taskWaypointName =  _taskDetails[index].waypoint_name,
                  global.taskWaypointTruck =  _taskDetails[index].waybill_truck,
                  global.taskWaypointTrailer =  _taskDetails[index].waybill_trailer,
                  global.taskDriverName=  _taskDetails[index].driver_name,

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanUhf()),
                )
              }
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return new ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, i) {
        return new Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white38,
          margin: EdgeInsets.symmetric(vertical: 7),
          child: ListTile(
              title: Text(
                _searchResult[i].name,
                style: TextStyle(fontSize: 15),
              ),
              subtitle: Text("Водій:${_searchResult[i].driver_name}; Дата:${ DateFormat('y-MM-dd HH:mm:ss').format(DateTime.parse(_searchResult[i].task_date))  } "),
              leading: FaIcon(FontAwesomeIcons.truck),
              onTap: () =>
              {
                global.taskId =  _searchResult[i].id,
                global.taskName =  _searchResult[i].name,
                global.taskWaypointId =  _searchResult[i].waypoint_id,
                global.taskDate = DateTime.parse(_searchResult[i].task_date),
                global.taskWaypointName =  _searchResult[i].waypoint_name,
                global.taskWaypointTruck =  _searchResult[i].waybill_truck,
                global.taskWaypointTrailer =  _searchResult[i].waybill_trailer,
                global.taskDriverName=  _searchResult[i].driver_name,

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanUhf()),
                )
              }
          ),
        );
      },
    );
  }



  Widget _buildSearchBox() {

    return new Container(
      color: Colors.blueGrey,
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        margin: EdgeInsets.symmetric(vertical: 7),
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: controller,
            decoration: new InputDecoration(
                hintText: 'Пошук', border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {

    return new Scaffold(
      body:Container(
        child:Column(
          children: <Widget>[
            new Container(
                color: Theme.of(context).primaryColor, child: _buildSearchBox()),
            new Expanded(
                child: _searchResult.length != 0 || controller.text.isNotEmpty
                    ? _buildSearchResults()
                    : _buildUsersList()),
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _scanQR();
          });
        },
        child: const Icon(Icons.qr_code_scanner_sharp),
        backgroundColor: Colors.pink,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: _buildBody()
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _taskDetails.forEach((userDetail) {
      if (userDetail.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }

  Future _scanQR () async {
    try {
     String? cameraScanResult = await scanner.scan();
      setState(() {
       _mySeals = cameraScanResult; // setting string result with cameraScanResult
        getInfoTask(_mySeals);
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }


  Future<Null>    getInfoTask(
      String? task_id
      ) async {

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);

    final String url = '$httpType' +  global.urlVar +"/tasks" + "?barcode="+  '$task_id';

    final request = await client
        .getUrl(Uri.parse(url))
        .timeout(Duration(seconds: 5));


    HttpClientResponse response = await request.close();

    var responseBody = await response.transform(utf8.decoder).join();

    final responseJson = json.decode(responseBody);



    setState(() {
      for (Map<String,dynamic> user in responseJson) {
        _taskBarcode.add(TaskDetails.fromJson(user));
      }
    });

    global.taskId =  await _taskBarcode[0].id;
    global.taskName = await _taskBarcode[0].name;
    global.taskWaypointId = await _taskBarcode[0].waypoint_id;
    global.taskWaypointName = await _taskBarcode[0].waypoint_name;
    global.taskWaypointTruck = await   _taskBarcode[0].waybill_truck;
    global.taskWaypointTrailer = await   _taskBarcode[0].waybill_trailer;
    global.taskDriverName=  await _taskBarcode[0].driver_name;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanUhf()),
    );

  }
}




class TaskDetails {

  final String  id, name,waypoint_id,waypoint_name,waybill_truck,waybill_trailer,driver_name,task_date;



  TaskDetails({required this.id,required this.name,required this.waypoint_id,required this.waypoint_name,required this.waybill_truck,
    required this.waybill_trailer,required this.driver_name,required this.task_date});

  factory TaskDetails.fromJson(Map<String, dynamic> json) {
    return new TaskDetails(
      id: json['id'],
      name: json['name'],
      waypoint_id: json['waypoint_id'],
      waypoint_name: json['waypoint_name'],
      waybill_truck: json['waybill_truck'],
      waybill_trailer: json['waybill_trailer'],
      driver_name: json['driver_name'],
      task_date: json['task_date'],
    );
  }


}




class Error_connect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AlertDialog dialog = AlertDialog(
      title: Text('Не вдається з\u0027єднатись із сервером'),
      content:
      Text('Повторити спробу'),
      actions: [
        FlatButton(
          textColor: Color(0xFF6200EE),
          onPressed: () => SystemNavigator.pop(),
          child: Text('Ні'),
        ),
        FlatButton(
          textColor: Color(0xFF6200EE),
          onPressed: () { Navigator.push(
            context,MaterialPageRoute(builder: (context) => TaskList()),
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


