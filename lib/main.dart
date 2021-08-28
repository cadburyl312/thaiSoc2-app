import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_appscroller/networkingFuture.dart';
import 'package:http/http.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return MaterialApp(
      title: 'Thai Soc Ed',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Thai Soc Ed'),
        ),
        body:  Center(
          child: RandomWords()
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWords createState() => _RandomWords();
}
class _RandomWords extends State<RandomWords>{

  List<String> discountInfos = [""];
  List<String> postCodes = [""];
  late Future adsResults;
  @override
  void initState(){
    super.initState();
    adsResults = getFuture();
  }
  getFuture() async{
    return await  networkCode.sendHTTPreq(json.encode({"userid": "username", "useremail": "email"}), "viewAdds");
  }

  final _suggestions = <WordPair>[];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wordPair = WordPair.random();
    return  buildSuggestion();
  }
  Widget buildSuggestion() {
    return FutureBuilder(
        future: adsResults,
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text("active or waiting");
            case ConnectionState.done:
              if (snapshot.hasError){return Text (snapshot.error.toString());}
              return buildListView(retrieveData(snapshot.data.toString()));
          }
        }

    );
  }
  List<dynamic> retrieveData(String jsonStr){
    List<dynamic> list = json.decode(jsonStr);
    return list;
  }
  
  Widget buildListView(List<dynamic> inData){
      return ListView.builder(
          itemCount: inData.length * 2,
          itemBuilder: (BuildContext context,int index ){
            if (index.isOdd ){return const Divider();}
            else { return  rowBuilder(inData[index ~/ 2],index ~/2);}
        },
      );
  }

  Widget rowBuilder(dynamic listElem, int index){
    index += 1;
    String data = listElem.toString();
    discountInfos.add(listElem["info"]);
    postCodes.add(listElem["addr"]);
    print(listElem["name"]);
    return ListTile(
      onTap: (){Scaffold.of(context).hideCurrentSnackBar();snackBarUse(discountInfos[index], postCodes[index]);},
      title: Row(
        mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          imageDisplayer(listElem["imgName"]),
          Text(listElem["name"]),

        ],
      )
    );
  }


  void snackBarUse(String data, String postCode){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container( height: 150,child: ListView(
        padding: const EdgeInsets.all(8),

        children:  <Widget>[
          Container (alignment: Alignment.center, child:Text("info: "+data)),
          Divider(),
          FlatButton(onPressed: (){print("later");}, child: Text("postcode:" + postCode)),
          Divider(),
          FlatButton(onPressed: (){Scaffold.of(context).hideCurrentSnackBar();}, child: Text("CLOSE")),

        ],
      )),
      backgroundColor: Colors.blue,



      //FlatButton(child: Text("discount info: " + data), onPressed: (){Scaffold.of(context).hideCurrentSnackBar();},),
      duration:  Duration(minutes: 1),
    ));
  }


}

class imageDisplayer extends StatefulWidget {
  final String fileName;
  const imageDisplayer(this.fileName);
  @override

  imageState createState() => imageState();
}

class imageState extends State<imageDisplayer>{
  late Future<dynamic> imageRecover;
  getFuture() async{
    return await  networkCode.grabImage(widget.fileName);
  }
  @override
  void initState(){
    super.initState();
    imageRecover = getFuture();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<dynamic>(future: imageRecover,
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
              return Text("none");
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text("Loading");
            case ConnectionState.done:
              if (snapshot.hasError){return Text("iamge load error");}
              else {
                return Container(child:snapshot.data ,width: 100, height: 100, ) ;
              }
          }


        }
    );

  }
  
}

class dataStore {

  static List<String> getNames(){
    final List<String> names = <String>[
      'Manish',
      'Jitender',
      'Pankaj',
      'Aarti',
      'Nighat',
      'Mohit',
      'Ruchika',
    ];
    return names;
  }

}

  
