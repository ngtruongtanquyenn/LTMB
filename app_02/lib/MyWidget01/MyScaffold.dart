import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget{
  const MyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    // Tra ve Scaffold - widget cung cap bo cuc Material Design co ban
    //Man hinh
    return Scaffold(
      //Tieu de cua Ung Dung
      appBar: AppBar(
        title: Text("App_02"),
      ),
      backgroundColor: Colors.deepPurple,
      
      body:Center(child: Text("Nội dung chính"),) ,
      
      floatingActionButton: FloatingActionButton(
          onPressed: (){print("pressed");},
          child: const Icon(Icons.add_ic_call),

      ),
      bottomNavigationBar: BottomNavigationBar(items:[
      BottomNavigationBarItem(icon: Icon(Icons.home), label :"Trang Chủ"),
      BottomNavigationBarItem(icon: Icon(Icons.search), label :"Tìm Kiếm"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label :"Cá Nhân"),
    ]),
    );
  }
}