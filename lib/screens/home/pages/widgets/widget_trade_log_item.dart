import 'package:flutter/material.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

enum PopupItem {
  edit,
  delete,
}

class WidgetTradeLogItem extends StatelessWidget {
  WidgetTradeLogItem({super.key});

  PopupItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profit',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: true ? Colors.green : Colors.red),
                  ),
                  Visibility(
                    visible: true,
                    child: PopupMenuButton<PopupItem>(
                      splashRadius: 20,
                      onSelected: (PopupItem item) {
                        if (item == PopupItem.delete) {
                          print('delete');
                        } else {
                          print('Update');
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<PopupItem>>[
                        const PopupMenuItem<PopupItem>(
                          value: PopupItem.edit,
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<PopupItem>(
                          value: PopupItem.delete,
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.2, color: Color.fromARGB(255, 206, 205, 205)),
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        whiteColor,
                        Color.fromARGB(255, 238, 238, 247),
                      ],
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 0),
                  child: GridView.count(
                    childAspectRatio: 3.2,
                    shrinkWrap: true,
                    //primary: true,
                    padding: const EdgeInsets.all(8),
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2, childAspectRatio: 3),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PNL',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey)),
                          sizedBoxTen,
                          Text(
                            'PNL',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Trade Date',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey)),
                          sizedBoxTen,
                          Text(
                            'PNL',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              sizedBoxTen,
              GridView.count(
                childAspectRatio: 1.8,
                shrinkWrap: true,
                //primary: true,
                padding: const EdgeInsets.all(8),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2, childAspectRatio: 3),
                children: [
                  gridColumnItem(title: 'Swing(Profit)', content: '0'),
                  gridColumnItem(title: 'Swing(Loss)', content: '0'),
                  gridColumnItem(title: 'Intraday(Profit)', content: '0'),
                  gridColumnItem(title: 'Intraday(Loss)', content: '0'),
                ],
              ),
              Divider(),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'Comments',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'kjhdjksdf, hkajdhjs husafdh hasfghgdjhsdjhhdfggsdfhgdfgsdfgsdjkhg',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget gridColumnItem({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey)),
        sizedBoxTen,
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
