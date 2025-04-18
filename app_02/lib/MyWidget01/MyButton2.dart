import "package:flutter/material.dart";

class MyButton2 extends StatelessWidget {
  const MyButton2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App 02"),
        backgroundColor: Colors.yellow,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
          children: [
            SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                print("ElevatedButton");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text("ElevatedButton", style: TextStyle(fontSize: 24)),
            ),

            SizedBox(height: 20),

            InkWell(
              onTap: () {
                print("Đã Nhấn");
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                ),
                child: Text("Button tùy chỉnh với Inkwell"),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                print("New Button");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Màu nền xanh dương
                foregroundColor: Colors.white, // Màu chữ trắng
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Bo góc tròn hơn
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20), // Padding lớn hơn
                elevation: 8, // Hiệu ứng đổ bóng
                shadowColor: Colors.black54, // Màu của bóng
              ),
              child: Text(
                "New Button",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), // Font lớn hơn, đậm hơn
              ),
            ),

            SizedBox(height: 20),

            TextButton(
              onPressed: () {
                print("TextButton");
              },
              child: Text("TextButton", style: TextStyle(fontSize: 24)),
            ),

            SizedBox(height: 20),

            OutlinedButton(
              onPressed: () {
                print("OutlinedButton");
              },
              child: Text("OutlinedButton", style: TextStyle(fontSize: 24)),
            ),

            SizedBox(height: 20),

            IconButton(
              onPressed: () {
                print("IconButton");
              },
              icon: Icon(Icons.favorite),
            ),

            SizedBox(height: 20),

            FloatingActionButton(
              onPressed: () {
                print("FloatingActionButton");
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
        },
        child: const Icon(Icons.add_ic_call),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
        ],
      ),
    );
  }
}
