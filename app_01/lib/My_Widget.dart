import 'package:flutter/material.dart';

//Khong thay doi

class MyStatelessWidget extends StatelessWidget{
  final String title;

  MyStatelessWidget({required this.title});


  @override
  Widget build(BuildContext context) {
      return Text(title);
  }

}

class MyStatefulWiget extends StatefulWidget{

  @override  State<StatefulWidget> createState() => _MystatefulWiget();}
class _MystatefulWiget extends State<MyStatefulWiget>{
  String title ='Hello, Flutter!';
  void _updateTitle(){
    setState(() {
      title = 'Title Updated';
    });
  }
  @override  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title),
        ElevatedButton(onPressed: _updateTitle, child: Text('Update Title')),
      ],
    );
  }
}