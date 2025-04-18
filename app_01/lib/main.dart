import 'package:flutter/material.dart';//cua Google
import 'package:app_01/My_Widget.dart';



void main() {
  runApp(const MyApp());
}
// StatelessWidget => Không có trạng thái, phu hợp với các thành phần giao diện tĩnh
// StatefulWidget => Có thể thay đổi trạng thái, phù hợp với các thành phần động.



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyStatefulWiget(),
    );
  }
}
