import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText({super.key});

  @override
  Widget build(BuildContext context) {
    // Tra ve Scaffold - widget cung cap bo cuc Material Design co ban
    //Man hinh
    return Scaffold(
      //Tieu de cua Ung Dung
      appBar: AppBar(
        title: Text("App_02"),
        backgroundColor: Colors.blue,
        elevation: 4,
        actions: [
          IconButton(
            onPressed: () {
              print("b1");
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              print("b2");
            },
            icon: Icon(Icons.abc),
          ),
          IconButton(
            onPressed: () {
              print("b3");
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),

      body: Center(child: Column(
        children: [
          const SizedBox(height: 50,),
          const Text("Nguyen Truong Tan Quyen"),
          const SizedBox(height: 20,),

          const Text("Hello ",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30
               ,fontWeight:  FontWeight.bold,
            color: Colors.blue,
              letterSpacing:1.5,
          ),
          ),

          const SizedBox(height: 20,),
          const Text("Flutter là một framework mã nguồn mở được phát triển và hỗ trợ bởi Google. Nó cho phép người dùng phát triển ứng dụng di động cho các nền tảng khác nhau bao gồm iOS, Android và cả web ",
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 20
              ,
              color: Colors.black,
              letterSpacing:1.5,
            ),
          ),
        ]
      )),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
        },
        child: const Icon(Icons.add_ic_call),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang Chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm Kiếm"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá Nhân"),
        ],
      ),
    );
  }
}
