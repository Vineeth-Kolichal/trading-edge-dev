import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trading_edge/services/current_user_data.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/views/widgets/widget_appbar.dart';
import 'package:trading_edge/views/widgets/widget_search_gif.dart';

class PageAllUser extends StatelessWidget {
  PageAllUser({super.key});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 247),
      appBar: const WidgetAppbar(title: 'All Users'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: users.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong 😟'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitCircle(
                  color: whiteColor,
                  duration: Duration(milliseconds: 3000),
                ),
              );
            }

            List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot
                .data!.docs
                .cast<QueryDocumentSnapshot<Map<String, dynamic>>>();

            if (docs.isEmpty) {
              return const SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [WidgetSearchGif(), Text('No users found! 😧')],
                ),
              );
            } else {
              return ListView.builder(
                itemBuilder: (ctx, index) {
                  Map<String, dynamic> data = docs[index].data();
                  String docId = docs[index].id;
                  if (docId != CurrentUserData.returnCurrentUserId()) {
                    return UserTile(
                      name: data['name'],
                      photoUrl: data['photUrl'],
                      docId: docId,
                      emailOrPhone: data['contact'] ?? '',
                      index: index + 1,
                    );
                  }
                  return null;
                },
                itemCount: docs.length,
              );
            }
          },
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final String docId;
  final String name;
  final String photoUrl;
  final String emailOrPhone;
  final int index;
  const UserTile(
      {super.key,
      required this.name,
      required this.photoUrl,
      required this.docId,
      required this.emailOrPhone,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(name),
        leading: Material(
          borderRadius: BorderRadius.circular(8),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 235, 232, 232),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        subtitle: Text(
          emailOrPhone,
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Text(
          index.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
