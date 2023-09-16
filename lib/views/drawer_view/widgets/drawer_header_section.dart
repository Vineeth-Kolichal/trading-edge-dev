import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trading_edge/database/firebase/user_profile/user_profile_photo_name_uplaod.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/views/drawer_view/drawer_view.dart';
import 'package:trading_edge/views/drawer_view/utils/edit_name_dialoge.dart';
import 'package:trading_edge/views/screens/home/screen_home.dart';

class DrawerHeaderSection extends StatelessWidget {
  const DrawerHeaderSection({
    super.key,
    required this.fireStoreImgPath,
    required this.name,
    required this.mail,
  });

  final String? fireStoreImgPath;
  final String? name;
  final String? mail;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/drawer_header_bg.png'),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () async {
                    try {
                      final imgurl =
                          await pickAndUploadImageToFirebaseStorage();
                      await updateImageUrl(imgurl);
                    } catch (e) {
                      ('image exception $e');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 232, 232),
                        borderRadius: BorderRadius.circular(10)),
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: ((fireStoreImgPath == null)
                          ? Image.asset(
                              'assets/images/user_image_drawer.png',
                              fit: BoxFit.cover)
                          : FutureBuilder<String>(
                              future: getImageUrlFromFirebase(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  return Image.network(snapshot.data!,
                                      fit: BoxFit.cover);
                                } else {
                                  return const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: SpinKitCircle(
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  );
                                }
                              },
                            )),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.62,
                  child: Text(
                    name!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    editNameDialoge(context);
                    scaffoldKey.currentState!.closeDrawer();
                  },
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Icon(
                        Iconsax.edit,
                        size: 15,
                        color: Color.fromARGB(255, 145, 144, 144),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Text(
              mail!,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
