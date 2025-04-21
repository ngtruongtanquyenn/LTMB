import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarouselLocalForm extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/anh1.jpg',
    'assets/images/anh2.jpg',
    'assets/images/anh3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Chạy Ảnh (Local)'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(
            height: 250,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            autoPlayInterval: Duration(seconds: 2),
          ),
          items: imagePaths.map((path) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
