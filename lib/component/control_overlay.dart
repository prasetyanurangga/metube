import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ControlsOverlay extends StatelessWidget {
  const ControlsOverlay({
    Key key, 
    this.controller, 
    this.animationController,
    this.isExpand,
    this.onBackPress,
    this.onPlayPause,
  }) : super(key: key);

  final VideoPlayerController controller;
  final AnimationController animationController;
  final Function onBackPress, onPlayPause;
  final bool isExpand;

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitHour =twoDigits(duration.inHours);

    if(duration.inHours > 0 ){
      return "$twoDigitHour:$twoDigitMinutes:$twoDigitSeconds";
    }
    else{
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width : double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(.50),
      child : AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        opacity: isExpand ? 1.0 : 0.0,
        child : Stack(
          children : [
            Center(
              child :SizedBox(
                width : 70,
                height: 70,    
                child: IconButton(
                  onPressed : onPlayPause,
                  icon : AnimatedIcon(
                     size:60,
                     color: Colors.white.withOpacity(0.90),
                     icon: AnimatedIcons.play_pause,
                     progress: animationController,
                  )
                )
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child  : Padding(
                padding: EdgeInsets.only(left : 20   ),
                  child : Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children : [
                        ValueListenableBuilder(
                          valueListenable: controller,
                          builder: (context, VideoPlayerValue value, child) {
                            var duration =  (value.duration == null) ? "00:00" : printDuration(value.duration);
                            var position =  (value.position == null) ? "00:00" : printDuration(value.position);
                            return Text("$position / $duration", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white));
                          },
                        ),
                        IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.fullscreen, color: Colors.white)
                        )
                      ]
                  )
              )
            ),
            Align(
              alignment: Alignment.topCenter,
              child  : Row(
                mainAxisAlignment:MainAxisAlignment.start,
                children : [
                  IconButton(
                      onPressed: onBackPress,
                      icon: Icon(Icons.keyboard_arrow_down, color: Colors.white)
                  ),
                  Text("Malam MInggu Miko Season 2", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white)),
                  
                ]
              )
            ),

            
          ]
        )
      )
    );
  }
}