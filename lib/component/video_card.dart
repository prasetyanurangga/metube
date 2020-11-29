import "package:flutter/material.dart";
import 'package:transparent_image/transparent_image.dart';
import 'package:metube/component/cache_image_view.dart';

class VideoCard extends StatelessWidget {
  final String url;
  final Function press;

  const VideoCard({
    Key key,
    @required this.url,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
              children : [
                Stack(
                    children: [
                      CacheImageView(url : url, height: 250),
                      Positioned(
                        bottom: 10,
                        right:10,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius : BorderRadius.circular(4),
                            color: Colors.black,

                            ),
                              child :Text("10.20", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white)),
                          )
                      )
                    ]
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children:[
                      SizedBox(
                          width : 40,
                          height:40,
                          child : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage("https://avatars1.githubusercontent.com/u/35420062?s=460&u=9c2836499e7b0cca2da4c8788938f555989ad570&v=4")
                          ),
                      ),
                      SizedBox(width : 20),
                      Expanded(
                          child : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Video Pertama", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                              Text("Angga Nur Prsetya 9,0 jt x tonton 9 tahun yang lalu", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey[600])),
                            ]
                        )
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child:IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.more_vert, color: Colors.black)
                          )
                      )
                    ]
                  )
                )
              ]
          )
        )
    );  
  }
}
