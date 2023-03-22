import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_tradebook/widgets/widget_drawer.dart';
 final scaffoldKey = GlobalKey<ScaffoldState>();
class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: WidgetDrawer(),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(
              FontAwesomeIcons.user,
            ),
            onPressed: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
                //close drawer, if drawer is open
              } else {
                scaffoldKey.currentState!.openDrawer();
                //open drawer, if drawer is closed
              }
            },
          );
        }),
        backgroundColor: Colors.white,
      ),
      // appBar: PreferredSize(
      //     preferredSize: Size(double.infinity, 50), child: WidgetAppBar()),
      // body: Center(child: Text('Dashboard')),
    );
  }
}
