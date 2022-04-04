import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:uhf_scan/model/setting/globalvar.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';


class ScanQr extends StatelessWidget {
  // This widget is the root of your application.

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('Сканування штрих коду'),
        backgroundColor: Colors.blueGrey, centerTitle: true,),
      body: AddSealsPage(),

    );
  }

}

class AddSealsPage extends StatefulWidget {


  @override
  _SealsPageState createState() => _SealsPageState();
}

class _SealsPageState extends State<AddSealsPage> {

  List? SealsList;
  String? _mySeals_1 ;
  String? _mySeals_2 ;
  String url = global.urlVar;
  bool _isButtonDisabledSeals1 = false;
  bool _isButtonDisabledSeals2 = false;
  bool isFetching = false;



  @override

  Widget build(BuildContext context) {

    return Scaffold(
      body:Container(

        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),

            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                        "$_mySeals_1",
                        style: TextStyle(color: Colors.black, fontSize: 15)
                    ),

                  ),
                  Expanded(

                    child: ButtonTheme(
                        alignedDropdown: true,
                        child: new RaisedButton.icon(
                          icon : Icon(Icons.qr_code),
                          onPressed: () {
                            setState(() {
                              _scanQR_1 () ;
                            });
                          }
                          ,
                          label: new Text(''),
                        )
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.all(10.0),

              child:(global.urlVar != '') ? ButtonTheme(
                minWidth: 10.0,
                height: 40.0,
                child: RaisedButton.icon(
                  label: Text("Поклеить метку",
                    style: TextStyle(
                        color: Colors.white, fontSize: 15.0),

                  ),
                  icon: Icon(Icons.send_to_mobile),
                  onPressed: isFetching == false &&  _isButtonDisabledSeals1 == true
                      &&  _isButtonDisabledSeals2 == true
                      ? makeRequest : null,
                  color: Colors.blue,
                  padding: EdgeInsets.all(20.0),
                ),
              ):
              Container(
              ),

              margin: EdgeInsets.only(top: 0.0),
            )
          ],
        ),
      ),



    );

  }

  //=============================================================================== Api Calling here





  //Post seals_main/unseals


  Future<void> makeRequest() async {
    if(!isFetching){
      setState(() {
        isFetching = true;
      });

      HttpClient client = new HttpClient();
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);


      String url = global.urlVar + "/transfer_seals";

      Map map = {
        "first_seals":_mySeals_1,
        "last_seals": _mySeals_2,
      };

      HttpClientRequest request = await client.postUrl(Uri.parse(url));

      request.headers.set('content-type', 'application/json');

      request.add(utf8.encode(json.encode(map)));

      HttpClientResponse response = await request.close();



      if (200 == response.statusCode )  {

      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Error_Auth()),
        );
      }
      setState((){
        isFetching=false;
      });
    }
  }

  Future _scanQR_1 () async {
    try {
      String? cameraScanResult = await scanner.scan();
      setState(() {
        _mySeals_1 =
            cameraScanResult; // setting string result with cameraScanResult

        _isButtonDisabledSeals1 = true;


      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future _scanQR_2 () async {
    try {
      String? cameraScanResult = await scanner.scan();
      setState(() {
        _mySeals_2 =
            cameraScanResult; // setting string result with cameraScanResult
        _isButtonDisabledSeals2 = true;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }


}



class Error_Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AlertDialog dialog = AlertDialog(
      title: Text('Помилка при створенні акту прийому пломб'),
      content:
      Text('Повторити спробу прийому пломб'),
      actions: [
        FlatButton(
          textColor: Color(0xFF6200EE),
          onPressed: () => SystemNavigator.pop(),
          child: Text('Ні'),
        ),
        FlatButton(
          textColor: Color(0xFF6200EE),
          onPressed: () {  Navigator.push(
            context,MaterialPageRoute(builder: (context) => ScanQr()),
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