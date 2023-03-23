//  import 'package:flutter/material.dart';

// Widget get bottomNavigationBar {
//         return Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(30), topLeft: Radius.circular(30)),
//               boxShadow: [
//                 BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30.0),
//                 topRight: Radius.circular(30.0),
//               ),
//               child: BottomNavigationBar(
//                 currentIndex: _selectedTabIndex,
//                 onTap: _changeIndex,
//                 type: BottomNavigationBarType.fixed,
//                 selectedFontSize: 12,
//                 unselectedFontSize: 12,
//                 selectedItemColor: Colors.amber[800],
//                 unselectedItemColor: Colors.grey[500],
//                 showUnselectedLabels: true,
//                 items: <BottomNavigationBarItem>[
//                   BottomNavigationBarItem(
//                     icon: new Icon(Icons.home),
//                     title: new Text('Home'),
//                   ),
//                   BottomNavigationBarItem(
//                     icon: new Icon(Icons.shopping_cart_outlined),
//                     title: new Text('Order'),
//                   ),
//                   BottomNavigationBarItem(
//                     icon: new Icon(Icons.mail),
//                     title: new Text('Messages'),
//                   ),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.more_horiz_rounded), title: Text('More')),
//                 ],
//               ),
//             ));
//       }