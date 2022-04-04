import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhf_scan/model/setting/globalvar.dart' as global;
import 'package:syncfusion_flutter_sliders/sliders.dart';

class Setting extends StatelessWidget {
  // This widget is the root of your application.

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('Налаштування'),
        backgroundColor: Colors.blueGrey, centerTitle: true,),
      body: EditProfilePage(),

    );
  }

}


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Color button1Color = Colors.green;
  bool disableDemoItems = false;
  late bool _httpType = global.httpType;
  final TextEditingController userController   = new TextEditingController();
  final TextEditingController apiController   = new TextEditingController();
  final TextEditingController passController    = new TextEditingController();
 double timeUpd =   global.upadateTime;
 double poverAntena =   global.poverAntena;
 double limit =   global.limit;
  @override
  void initState()  {

    super.initState();

    if ( global.urlVar == null) {
      apiController.text  == '';}
    else {
       apiController.text = global.urlVar;};

    if ( global.nameUser == null) {
      userController.text  == '';}
    else {
       userController.text =  global.nameUser;};


    if ( global.passUser == null) {
      passController.text  == '';}
    else {
      passController.text =  global.passUser;};

  }
  bool showPassword = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [

              TextFormField(
                controller: userController,
                cursorColor: Colors.white,

                style: TextStyle(color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                ),
                decoration: InputDecoration(
                  icon: Icon(Icons.person, color: Colors.black),
                  hintText: "Користувач",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: const Color(
                      0xFF6A6969)),
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                controller: apiController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 16.0,

                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  icon: Icon(Icons.insert_link, color: Colors.black),
                  hintText: "Адреса сервера",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: TextStyle(color: const Color(
                      0xFF6A6969)),
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.language, color: Colors.black)
                    ),
                    Align(
                        alignment: Alignment.center ,
                        child:Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[

                            Text('     http' ,style: TextStyle(color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                            )),
                            Switch(
                                activeColor: Theme.of(context).accentColor,
                                value: _httpType,
                                onChanged: (newVal) {
                                  _httpType = newVal;
                                  setState(() {});
                                }),
                            Text('https' ,style: TextStyle(color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                            )),
                          ],))
                  ]

              ),
              SizedBox(height: 30.0),
              Row (
              children: <Widget>[

                Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.settings_input_antenna, color: Colors.black)
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "    Потужність РФІД антенни",
                      textAlign: TextAlign.center,
    style:TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold,color: const Color(
              0xFF6A6969)
                    )
                )
                )
              ],

              ),
              SfSlider(
                min: 0,
                max: 30,
                value: poverAntena,
                  interval: 15,
                  showTicks: true,
                  showLabels: true,
                  enableTooltip: true,
                  tooltipTextFormatterCallback:
                      (dynamic actualValue, String formattedText) {
                    return actualValue.toStringAsFixed(0);
                  },
                  minorTicksPerInterval: 1,
                  onChanged: (dynamic value){
                    setState(() {
                      poverAntena= value;
                    });
                  },
                ),

              Row (
                children: <Widget>[

                  Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.library_books_rounded, color: Colors.black)
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "    Ліміт завдань",
                          textAlign: TextAlign.center,
                          style:TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold,color: const Color(
                              0xFF6A6969)
                          )
                      )
                  )
                ],

              ),
              SfSlider(
                min: 0,
                max: 50,
                value: limit,
                interval: 10,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                tooltipTextFormatterCallback:
                    (dynamic actualValue, String formattedText) {
                  return actualValue.toStringAsFixed(0);
                },
                minorTicksPerInterval: 1,
                onChanged: (dynamic value){
                  setState(() {
                    limit = value;
                  });
                },
              ),
              Row (
                children: <Widget>[

                  Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.timelapse, color: Colors.black)
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "    Час оновлення завдань(с)",
                          textAlign: TextAlign.center,
                          style:TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold,color: const Color(
                              0xFF6A6969)
                          )
                      )
                  )
                ],

              ),
              SfSlider(
                min: 10,
                max: 60,
                value: timeUpd,
                interval: 10,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                tooltipTextFormatterCallback:
                    (dynamic actualValue, String formattedText) {
                  return actualValue.toStringAsFixed(0);
                },
                minorTicksPerInterval: 1,
                onChanged: (dynamic value){
                  setState(() {
                    timeUpd = value;
                  });
                },
              ),


              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(

                    onPressed: () async{

                      SharedPreferences prefs = await SharedPreferences.getInstance();

                      prefs.setString('apiUrl',  apiController.text);
                      prefs.setDouble('PoverAntena', poverAntena);
                      prefs.setString('userId', userController.text);
                      prefs.setString('userPass', passController.text);
                      prefs.setDouble('limit', limit);
                      prefs.setDouble('upadateTime', timeUpd);
                      prefs.setBool('httpType', _httpType);
                      global.urlVar =  apiController.text;
                      global.nameUser =   userController.text;
                      global.passUser =   passController.text;
                      global.poverAntena = poverAntena;
                      global.httpType = _httpType;
                      global.limit = limit;
                      global.upadateTime = timeUpd;
                    },
                    color: button1Color,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Зберегти",
                      style: TextStyle(

                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}

