import "package:flutter/material.dart";
import 'package:transparent_image/transparent_image.dart';

class CacheImageView extends StatelessWidget {
  final String url;
  final double height;

  const CacheImageView({
    Key key,
    @required this.url,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child :  Stack(
        children: [
          Center(child: CircularProgressIndicator()),
          // Center(
          //   child: FadeInImage.memoryNetwork(
          //     placeholder: kTransparentImage,
          //     image: url,
          //     fit: BoxFit.cover,
          //     height: height,
          //     width: double.infinity,
          //   ),
          // ),
          Center(
            child: Image.asset(
              "assets/images/post_1.jpg",
              fit: BoxFit.cover,
              height: height,
              width: double.infinity,
            ),
          ),
        ],
      )
    );  
  }
}
