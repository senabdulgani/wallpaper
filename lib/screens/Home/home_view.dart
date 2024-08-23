import 'package:flutter/material.dart';
import 'package:wallpaper_app/screens/Home/Slider/photo_slider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('wallpaper_app'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.96,
            child: Column(
              children: [
                sectionHeaderText(text: 'My Portfolio'),
                const PhotoSlider(),
                sectionHeaderText(text: 'Community'),
                const PhotoSlider(),
              ],
            ),
          ),
        ));
  }

  Padding sectionHeaderText({required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Text(
            text,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
