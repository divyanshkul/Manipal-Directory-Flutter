import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class SubpageTest extends StatefulWidget {
  final String subCat;
  SubpageTest({Key key, @required this.subCat}) : super(key: key);
  @override
  _SubpageTestState createState() => _SubpageTestState();


}

class _SubpageTestState extends State<SubpageTest> {

  Query ref;
  Map<dynamic, dynamic> values;
  bool wantToReport = false;
  _makingPhoneCall(String number) => launch('tel: $number');
  _makingMapCall(String link) => launch('$link');


  final textController = TextEditingController();
  int reported;
  int upvoted;



  @override
  void initState() {
    // TODO: implement initState
    ref = FirebaseDatabase.instance.reference().child('Categories').parent();
    super.initState();
  }

  // Widget buildCategories({Map categories}) {
  //   //print(categories['Departments']);
  //   return Container(
  //       child: SafeArea(
  //           child: ListTile(
  //             leading: Icon(Icons.import_contacts_sharp),
  //             title: Text(
  //               categories[widget.subCat][0]["contact"].toString(),
  //               style: TextStyle(
  //                 fontSize: 16,
  //               ),
  //             ),
  //             subtitle: Text("Hello"),
  //             trailing: Icon(Icons.keyboard_arrow_right),
  //           )
  //       )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: FutureBuilder(
            future: ref.once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                values = snapshot.data.value;
                return new ListView(
                    children: values["Categories"][widget.subCat].map<Widget>((document) {
                      return Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(2),
                        child: Column(
                          children: [
                            Card(
                              color: Colors.grey[900],
                              // child: new ListTile(
                              // title: new Text(document['name']),
                              // subtitle: new Text("Clsasss"),
                              // ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: IconButton(
                                      icon: Icon(
                                        Icons.call, size: 30,
                                        color: document['reported'] > 2 ? Colors.red: Colors.blue,),
                                      onPressed: (){
                                        print("PrintF");
                                        _makingPhoneCall(document['contact'].toString());
                                      },
                                    )                            ,
                                    title: Text(document['name'], style: TextStyle(color: Colors.white, fontSize: 22)),
                                    subtitle: Text(
                                      widget.subCat.toUpperCase(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.map, size: 30,
                                        color: Colors.green[300],
                                      ),
                                      onPressed: (){

                                        _makingMapCall(document['launch'].toString());
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
                                        child: Text(
                                          document['contact'].toString(),
                                          style: TextStyle
                                            (color: document['reported'] > 2 ? Colors.red : Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children:[
                                      Container(
                                        margin: EdgeInsets.fromLTRB(80, 5, 0, 0),
                                        child: Text(
                                          "Upvotes: ${document['upvoted']}",
                                          style: TextStyle(
                                            color: Colors.green[800],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children:[
                                      Container(
                                        margin: EdgeInsets.fromLTRB(80, 5, 0, 0),
                                        child: Text(
                                          "Reports: ${document['reported']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: document['reported'] > 2 ? Colors.red : Colors.white
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.start,
                                    children: [
                                      MaterialButton(
                                        textColor:  HexColor('#03DAC5'),
                                        onPressed: () {
                                          upvoted = document['upvoted'];
                                          upvoted += 1;
                                          print(widget.subCat);
                                          final getRef = FirebaseDatabase.instance.reference().child('Categories/${widget.subCat}/${document['index']}').update({
                                            'upvoted': upvoted,
                                          });
                                          // Perform some action
                                        },
                                        child: const Text('UPVOTE'),
                                      ),
                                      MaterialButton(
                                        textColor: HexColor('#03DAC5'),
                                        onPressed: () {
                                          _showBottomModal(context, document);
                                          // Perform some action
                                        },
                                        child: const Text('REPORT'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),
                      );
                    }).toList()
                );
                // values.forEach((key, value) {
                //   print(values["Categories"]["Departments"][0]["name"]);
                // });
              }
              else{
                return CircularProgressIndicator();
              }

              //return buildCategories(categories: values);

            }
        )
    );
  }


  _showBottomModal(context, dynamic document) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return new Container(
            // height: 800,
            color: Colors.transparent,
            child: new Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0, // has the effect of softening the shadow
                    spreadRadius: 0.0, // has the effect of extending the shadow
                  )
                ],
              ),
              alignment: Alignment.topLeft,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          "REPORT NUMBER",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 5, right: 5),
                          child: MaterialButton(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            onPressed: () {
                              Navigator.pop(context);
                              //print(textController.text);
                              reported = document['reported'];
                              reported += 1;
                              print(reported);
                              if (textController.text == '') {
                                final getRef = FirebaseDatabase.instance.reference().child('Categories/${widget.subCat}/${document['index']}')
                                    .update({
                                  'reported': reported,
                                });
                              }
                              else{
                                final getRef = FirebaseDatabase.instance.reference().child('Categories/${widget
                                    .subCat}/${document['index']}').update({
                                  'reportedResponses': textController.text,
                                });
                              }
                            },
                            child: Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: const Color(0xfff8f8f8),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        TextField(
                          controller: textController,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.call),

                            labelText: "Enter the number (Optional)",
                            border: OutlineInputBorder(),

                          ),
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],


                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}