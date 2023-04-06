import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/pages/widgets/widget_fund_tile.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/widgets/widget_search_gif.dart';

class PageFund extends StatelessWidget {
  final CollectionReference tradesAndFund = FirebaseFirestore.instance
      .collection('users')
      .doc(returnCurrentUserId())
      .collection('Trades_and_fund');
  PageFund({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StreamBuilder(
          stream: tradesAndFund
              // .where('type', whereIn: ['profit', 'loss'])
              .orderBy('date', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong 😟'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SpinKitCircle(
                color: whiteColor,
                duration: Duration(milliseconds: 3000),
              ));
            }
            List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot
                .data!.docs
                .cast<QueryDocumentSnapshot<Map<String, dynamic>>>();

            if (docs.isEmpty) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    WidgetSearchGif(),
                    Text('No fund entries found! 😧')
                  ],
                ),
              );
            } else {
              return ListView.separated(
                //shrinkWrap: true,
                itemBuilder: ((context, index) {
                  Map<String, dynamic> data = docs[index].data();
                  String docId = docs[index].id;
                  return WidgetFundTile(
                    docId: docId,
                    amount: data['amount'].toString(),
                    type: data['type'],
                    date: data['date'].toDate(),
                  );
                }),
                separatorBuilder: (context, index) => sizedBoxTen,
                itemCount: docs.length,
              );
            }
          }),
    );
  }
}
