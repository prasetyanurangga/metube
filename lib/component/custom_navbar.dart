import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items; // NOTE: You CAN declare your own model here instead of `PersistentBottomNavBarItem`.
  final ValueChanged<int> onItemSelected;

  CustomNavBar(
     {Key key,
     this.selectedIndex,
     @required this.items,
     this.onItemSelected,});

  Widget _buildItem(
     PersistentBottomNavBarItem item, bool isSelected) {
     return Container(
     alignment: Alignment.center,
     height: 60.0,
     child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisSize: MainAxisSize.min,
         children: <Widget>[
         Flexible(
             child: IconTheme(
             data: IconThemeData(
                 size: (item.title != "no_title") ? 26.0 : 52.0,
                 color: isSelected
                     ? (item.activeContentColor == null
                         ? item.activeColor
                         : item.activeContentColor)
                     : item.inactiveColor == null
                         ? item.activeColor
                         : item.inactiveColor),
             child: item.icon,
             ),
         ),
         (item.title != "no_title") ? Padding(
             padding: const EdgeInsets.only(top: 5.0),
             child: Material(
             type: MaterialType.transparency,
             child: FittedBox(
                 child: Text(
                 item.title,
                 style: TextStyle(
                     color: isSelected
                         ? (item.activeContentColor == null
                             ? item.activeColor
                             : item.activeContentColor)
                         : item.inactiveColor,
                     fontWeight: FontWeight.w400,
                     fontSize: item.titleFontSize),
             )),
             ),
         ) : Container()
         ],
     ),
     );
  }

  @override
  Widget build(BuildContext context) {
     return Container(
     color: Colors.white,
     child: Container(
         width: double.infinity,
         height: 60.0,
         child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: items.map((item) {
             var index = items.indexOf(item);
             return Flexible(
             child: GestureDetector(
                 onTap: () {
                 this.onItemSelected(index);
                 },
                 child: _buildItem(
                     item, selectedIndex == index),
             ),
             );
         }).toList(),
         ),
     ),
     );
  }
}