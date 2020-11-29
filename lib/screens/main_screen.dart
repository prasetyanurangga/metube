import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:metube/component/cache_image_view.dart';
import 'package:metube/component/video_card.dart';
import 'package:metube/component/custom_navbar.dart';
import 'package:metube/component/control_overlay.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{
  var snappingSheetController = SnappingSheetController();
  double currentWidth = 120;
  double heightBase = 0.0;
  double height = 0;
  var firstLoad = false;
  double headSheet = 0;
  double currentPixel = 0.0;
  int animatedTime = 0;
  VideoPlayerController videoController;
  bool isChoose = false;
  AnimationController _animationController;
  int indexBottom;
  PersistentTabController _tapController;
  bool isExpand = false;
  bool showController = true;
  Future<void> initializeVideo;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
        indexBottom = 0;
  _tapController = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Row(
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child : SvgPicture.asset("assets/icons/youtube.svg")
          ),
          SizedBox(width: 5),
          Text("MeTube", style: GoogleFonts.oswald(textStyle: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black, fontWeight: FontWeight.bold)))
        ]
      ),
      actions:[
        IconButton(
          icon:Icon(Icons.notifications, color: Colors.black),
          onPressed: (){}
        ),
        IconButton(
          icon:Icon(Icons.search, color: Colors.black),
          onPressed: (){}
        ),
        SizedBox(
          width : 40,
          height:40,
          child : CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://avatars1.githubusercontent.com/u/35420062?s=460&u=9c2836499e7b0cca2da4c8788938f555989ad570&v=4")
          ),
        ),
        SizedBox(width: 5),
      ],
      backgroundColor: Colors.white
    );

    var heightBody = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - MediaQuery.of(context).padding.top;
    
    @override
    void dispose(){
      videoController?.dispose();
      super.dispose();
    }

    void initializePlay(String videoPath){
      videoController = null;
      videoController?.dispose();
      videoController = VideoPlayerController.network(
        videoPath,
      )
      ..initialize()
      ..setLooping(true);
    }

    return PersistentTabView(
      controller: _tapController,
      itemCount: 5,
      screens: [
        SafeArea(
          child:SnappingSheet(
            snappingSheetController: snappingSheetController,
            grabbingHeight : heightBase,
            grabbing: Container(
              color: Colors.white,
              child : GestureDetector(
                onTap: (){
                  setState((){
                      showController = true;
                      animatedTime = 0;
                      heightBase = 250;
                      currentWidth = MediaQuery.of(context).size.width;
                      if(snappingSheetController.currentSnapPosition == snappingSheetController.snapPositions[1]){
                        snappingSheetController.snapToPosition(snappingSheetController.snapPositions.last);
                      }
                  });
                },
                child : Row(
                  children : [
                    Container(
                      width : currentWidth,
                      height: heightBase,
                      child: (videoController != null) ? AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: 
                        GestureDetector(
                          onTap:(){
                              setState((){
                                if((currentPixel.round() - 70 )  == (heightBody- 306).round()){
                                    showController =! showController;
                                }
                              });
                          },
                          child :  Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              VideoPlayer(videoController),
                              AnimatedSwitcher(
                                duration : Duration(milliseconds: 300),   
                                child : showController ? ControlsOverlay(
                                  controller: videoController, 
                                  animationController:_animationController, 
                                  isExpand : isExpand,
                                  onBackPress : (){
                                    setState((){
                                      isExpand = false;
                                      showController= false;
                                    });
                                    snappingSheetController.snapToPosition(snappingSheetController.snapPositions[1]);
                                  },
                                  onPlayPause:(){
                                    if(isExpand){
                                      if(videoController.value.isPlaying) {
                                        videoController.pause();
                                        _animationController.reverse();

                                      }else{
                                        videoController.play();
                                        _animationController.forward();
                                      }
                                    }

                                    setState((){
                                      showController = false;
                                    })  ;
                                  }
                                ) : Container()
                              )
                            ],
                          ),
                        ),
                      ) : Container(),
                      // child : CacheImageView(url : "https://instagram.fcgk9-1.fna.fbcdn.net/v/t51.2885-15/e35/123136813_725212508077121_7155286665660634922_n.jpg?_nc_ht=instagram.fcgk9-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=d0gBYFReYwUAX-Da3Pz&tp=1&oh=aa5dbfb2a70da260c16d6eb1d2db24d8&oe=5FE325E5", height: heightBase),
                    ),
                    Expanded(
                      child : Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white,
                        height: heightBase,
                        child : Row(
                          children: [
                            Expanded(
                              flex:3,
                              child: AnimatedOpacity(
                                opacity: (currentWidth > (MediaQuery.of(context).size.width / 2)) ? 0.0 : 1.0,
                                duration: Duration(milliseconds: 70),
                                child : Text("${"malam minggu miko".substring(0,15)}...\nRaditya Dika"),
                              )
                            ),
                            Expanded(
                              flex:1,
                                child: IconButton(
                              onPressed : (){
                                  if(videoController.value.isPlaying) {
                                    videoController.pause();
                                    _animationController.reverse();
                                  }else{
                                    videoController.play();
                                    _animationController.forward();
                                  }
                              },
                              icon : AnimatedIcon(
                                 icon: AnimatedIcons.play_pause,
                                 progress: _animationController,
                               )
                            ),),

                            Expanded(
                              flex:1,
                                child: IconButton(
                                onPressed : (){
                                  videoController.pause();
                                  setState((){
                                      videoController = null;
                                  });
                                  snappingSheetController.snapToPosition(snappingSheetController.snapPositions.first);
                                  
                                },
                              icon : Icon(Icons.clear)
                            ),),
                          ]
                        )
                        
                      )
                    )
                  ]
                )
              ),
            ),
            sheetBelow: SnappingSheetContent(
              margin : EdgeInsets.zero,
                  child:Container(
                    color:Colors.white, 
                    child : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                        children : [
                          (videoController != null) ? SizedBox(height: 3,    child : VideoProgressIndicator( videoController, padding: EdgeInsets.zero,allowScrubbing : true)) : Container(),
                          Container(
                            padding: EdgeInsets.all(20),
                            child :  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Video Pertama", style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                                SizedBox(height: 10),
                                Text("9,0 jt x tonton 9 tahun yang lalu", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey[600])),
                                SizedBox(
                                  height: 70,
                                  child : ListView(
                                    scrollDirection: Axis.horizontal,
                                    children:[
                                      FlatButton(
                                        onPressed: (){},
                                        child : Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: Column(
                                            children:[
                                              Icon(Icons.thumb_up, color: Colors.grey[600]),
                                              SizedBox(height: 5),
                                              Text("Like", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey[600])),
                                            ]
                                          )
                                        )
                                      ),
                                      FlatButton(
                                        onPressed: (){},
                                        child : Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: Column(
                                            children:[
                                              Icon(Icons.thumb_up, color: Colors.grey[600]),
                                              SizedBox(height: 5),
                                              Text("Like", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey[600])),
                                            ]
                                          )
                                        )
                                      ),
                                      FlatButton(
                                        onPressed: (){},
                                        child : Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: Column(
                                            children:[
                                              Icon(Icons.thumb_up, color: Colors.grey[600]),
                                              SizedBox(height: 5),
                                              Text("Like", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey[600])),
                                            ]
                                          )
                                        )
                                      ),
                                      FlatButton(
                                        onPressed: (){},
                                        child : Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: Column(
                                            children:[
                                              Icon(Icons.thumb_up, color: Colors.grey[600]),
                                              SizedBox(height: 5),
                                              Text("Like", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey[600])),
                                            ]
                                          )
                                        )
                                      ),
                                      FlatButton(
                                        onPressed: (){},
                                        child : Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: Column(
                                            children:[
                                              Icon(Icons.thumb_up, color: Colors.grey[600]),
                                              SizedBox(height: 5),
                                              Text("Like", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey[600])),
                                            ]
                                          )
                                        )
                                      ),
                                    ]
                                  )
                                )
                              ]
                            )
                          )
                        ]
                    )
                  ),
                  heightBehavior: SnappingSheetHeight.manuel(minHeight : 3, maxHeight: heightBody - 306)),
            onMove: (d){
                var current = (d / heightBody);
                d += 70;

                setState((){
                    if((currentPixel.round() - 70 )  == (heightBody- 306).round()){
                      isExpand = true;
                      // showController= true;
                    }else{
                      isExpand = false;
                      // showController= false;
                    }
                    currentPixel = d;
                });

                if(isChoose){
                  if(d <=  70.0){
                    setState((){
                      currentWidth = 160;
                      heightBase = 70;
                    });
                  }else{
                    if(d < 250){
                      setState((){
                        heightBase = d; 
                      });
                    }else{
                      setState((){
                        heightBase = 250;
                      });
                    }
                    setState((){
                      var calculate = (d / 70) * 160;
                      currentWidth = calculate > (MediaQuery.of(context).size.width) ? (MediaQuery.of(context).size.width) : calculate;
                    });
                  }
                }

                
            },
            child: Scaffold(
              appBar: appBar,
              body: SingleChildScrollView(
                  child: Column(
                    children : [
                      VideoCard(
                        url : "https://instagram.fcgk9-1.fna.fbcdn.net/v/t51.2885-15/e35/123136813_725212508077121_7155286665660634922_n.jpg?_nc_ht=instagram.fcgk9-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=d0gBYFReYwUAX-Da3Pz&tp=1&oh=aa5dbfb2a70da260c16d6eb1d2db24d8&oe=5FE325E5", 
                        press : (){ 
                          initializePlay("http://techslides.com/demos/sample-videos/small.mp4");
                          print(heightBase);
                          setState((){
                            isChoose = true; 
                            animatedTime = 0;
                            heightBase = 250;
                            currentWidth = MediaQuery.of(context).size.width;
                            showController : true;
                          });
                          snappingSheetController.snapToPosition(snappingSheetController.snapPositions.last);
                        }
                      ),
                      VideoCard(
                        url : "https://instagram.fcgk9-1.fna.fbcdn.net/v/t51.2885-15/e35/123136813_725212508077121_7155286665660634922_n.jpg?_nc_ht=instagram.fcgk9-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=d0gBYFReYwUAX-Da3Pz&tp=1&oh=aa5dbfb2a70da260c16d6eb1d2db24d8&oe=5FE325E5", 
                        press : (){ 
                          initializePlay("http://techslides.com/demos/sample-videos/small.mp4");
                          print(heightBase);
                          setState((){
                            isChoose = true; 
                            animatedTime = 50;
                            heightBase = 250;
                            currentWidth = MediaQuery.of(context).size.width;
                          });
                          snappingSheetController.snapToPosition(snappingSheetController.snapPositions.last);
                        }
                      ),
                      VideoCard(
                        url : "https://instagram.fcgk9-1.fna.fbcdn.net/v/t51.2885-15/e35/123136813_725212508077121_7155286665660634922_n.jpg?_nc_ht=instagram.fcgk9-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=d0gBYFReYwUAX-Da3Pz&tp=1&oh=aa5dbfb2a70da260c16d6eb1d2db24d8&oe=5FE325E5", 
                        press : (){ 
                          initializePlay("http://techslides.com/demos/sample-videos/small.mp4");
                          print(heightBase);
                          setState((){
                            isChoose = true; 
                            animatedTime = 50;
                            heightBase = 250;
                            currentWidth = MediaQuery.of(context).size.width;
                          });
                          snappingSheetController.snapToPosition(snappingSheetController.snapPositions.last);
                        }
                      ),
                      VideoCard(
                        url : "https://instagram.fcgk9-1.fna.fbcdn.net/v/t51.2885-15/e35/123136813_725212508077121_7155286665660634922_n.jpg?_nc_ht=instagram.fcgk9-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=d0gBYFReYwUAX-Da3Pz&tp=1&oh=aa5dbfb2a70da260c16d6eb1d2db24d8&oe=5FE325E5", 
                        press : (){ 
                          initializePlay("http://techslides.com/demos/sample-videos/small.mp4");
                          print(heightBase);
                          setState((){
                            isChoose = true; 
                            animatedTime = 50;
                            heightBase = 250;
                            currentWidth = MediaQuery.of(context).size.width;
                          });
                          snappingSheetController.snapToPosition(snappingSheetController.snapPositions.last);
                        }
                      ),
                      VideoCard(
                        url : "https://instagram.fcgk9-1.fna.fbcdn.net/v/t51.2885-15/e35/123136813_725212508077121_7155286665660634922_n.jpg?_nc_ht=instagram.fcgk9-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=d0gBYFReYwUAX-Da3Pz&tp=1&oh=aa5dbfb2a70da260c16d6eb1d2db24d8&oe=5FE325E5", 
                        press : (){ 
                          initializePlay("http://techslides.com/demos/sample-videos/small.mp4");
                          print(heightBase);
                          setState((){
                            isChoose = true; 
                            animatedTime = 50;
                            heightBase = 250;
                            currentWidth = MediaQuery.of(context).size.width;
                          });
                          snappingSheetController.snapToPosition(snappingSheetController.snapPositions.last);
                        }
                      ),
                      VideoCard(
                        url : "https://instagram.fcgk9-1.fna.fbcdn.net/v/t51.2885-15/e35/123136813_725212508077121_7155286665660634922_n.jpg?_nc_ht=instagram.fcgk9-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=d0gBYFReYwUAX-Da3Pz&tp=1&oh=aa5dbfb2a70da260c16d6eb1d2db24d8&oe=5FE325E5", 
                        press : (){ 
                          initializePlay("http://techslides.com/demos/sample-videos/small.mp4");
                          print(heightBase);
                          setState((){
                            isChoose = true; 
                            animatedTime = 50;
                            heightBase = 250;
                            currentWidth = MediaQuery.of(context).size.width;
                          });
                          snappingSheetController.snapToPosition(snappingSheetController.snapPositions.last);
                        }
                      ),
                      VideoCard(
                        url : "https://instagram.fcgk9-1.fna.fbcdn.net/v/t51.2885-15/e35/123136813_725212508077121_7155286665660634922_n.jpg?_nc_ht=instagram.fcgk9-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=d0gBYFReYwUAX-Da3Pz&tp=1&oh=aa5dbfb2a70da260c16d6eb1d2db24d8&oe=5FE325E5", 
                        press : (){ 
                          initializePlay("http://techslides.com/demos/sample-videos/small.mp4");
                          print(heightBase);
                          setState((){
                            isChoose = true; 
                            animatedTime = 50;
                            heightBase = 250;
                            currentWidth = MediaQuery.of(context).size.width;
                          });
                          snappingSheetController.snapToPosition(snappingSheetController.snapPositions.last);
                        }
                      ),
                      VideoCard(
                        url : "https://instagram.fcgk9-1.fna.fbcdn.net/v/t51.2885-15/e35/123136813_725212508077121_7155286665660634922_n.jpg?_nc_ht=instagram.fcgk9-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=d0gBYFReYwUAX-Da3Pz&tp=1&oh=aa5dbfb2a70da260c16d6eb1d2db24d8&oe=5FE325E5", 
                        press : (){ 
                          initializePlay("http://techslides.com/demos/sample-videos/small.mp4");
                          print(heightBase);
                          setState((){
                            isChoose = true; 
                            animatedTime = 50;
                            heightBase = 250;
                            currentWidth = MediaQuery.of(context).size.width;
                          });
                          snappingSheetController.snapToPosition(snappingSheetController.snapPositions.last);
                        }
                      ),
                      VideoCard(
                        url : "https://instagram.fcgk9-1.fna.fbcdn.net/v/t51.2885-15/e35/123136813_725212508077121_7155286665660634922_n.jpg?_nc_ht=instagram.fcgk9-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=d0gBYFReYwUAX-Da3Pz&tp=1&oh=aa5dbfb2a70da260c16d6eb1d2db24d8&oe=5FE325E5", 
                        press : (){ 
                          initializePlay("http://techslides.com/demos/sample-videos/small.mp4");
                          print(heightBase);
                          setState((){
                            isChoose = true; 
                            animatedTime = 50;
                            heightBase = 250;
                            currentWidth = MediaQuery.of(context).size.width;
                          });
                          snappingSheetController.snapToPosition(snappingSheetController.snapPositions.last);
                        }
                      ),
                      
                    ]
                  )
              )
            ),
            snapPositions: [
                SnapPosition(
                    positionPixel: -70, 
                    snappingCurve: Curves.ease, 
                    snappingDuration: Duration(milliseconds: 300)
                ),
                SnapPosition(
                    positionPixel: 7, 
                    snappingCurve: Curves.ease, 
                    snappingDuration: Duration(milliseconds: 300)
                ),
                SnapPosition(
                    positionPixel: heightBody - 306, 
                    snappingCurve: Curves.easeInOut, 
                    snappingDuration: Duration(milliseconds: 500)
                ),
            ],
            onSnapEnd: () {
              
              setState((){
                if((currentPixel.round() - 70 )  == (heightBody- 306).round()){
                  isExpand = true;
                  // showController= true;
                }else{
                  isExpand = false;
                  // showController= false;
                }
                if(currentPixel < 0.0){
                  videoController = null;
                }
                animatedTime = 0;
              });

            },
          )
        ),
        Container(),
        Container(),
        Container(),
        Container(),
      ],
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true,
      onItemSelected: (int) {
        setState(() {}); // This is required to update the nav bar if Android back button is pressed
      },
      customWidget: CustomNavBar( // Your custom widget goes here
           items: [
            PersistentBottomNavBarItem(
                icon: Icon(Icons.home),
                title: ("Home"),
                activeColor: Colors.red,
                inactiveColor: Colors.grey[600],
            ),
            PersistentBottomNavBarItem(
                icon: Icon(Icons.explore),
                title: ("Eksplorasi"),
                activeColor: Colors.red,
                inactiveColor: Colors.grey[600],
            ),
            PersistentBottomNavBarItem(
                icon: Icon(Icons.add_circle_outline_rounded),
                title: ("no_title"),
                activeColor: Colors.red,
                inactiveColor: Colors.grey[600],
            ),
            PersistentBottomNavBarItem(
                icon: Icon(Icons.subscriptions),
                title: ("Subscription"),
                activeColor: Colors.red,
                inactiveColor: Colors.grey[600],
            ),

            PersistentBottomNavBarItem(
                icon: Icon(Icons.video_collection),
                title: ("Koleksi"),
                activeColor: Colors.red,
                inactiveColor: Colors.grey[600],
            ),
          ],
          selectedIndex: _tapController.index,
          onItemSelected: (index) {
            setState(() {
                _tapController.index = index; // NOTE: THIS IS CRITICAL!! Don't miss it!
            });
          },
      ),
      navBarStyle: NavBarStyle.custom,
    );
  }
}




