import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/view_model/user_profile_viewmodel/user_profile_viewmodel.dart';
import 'package:trading_edge/views/drawer_view/utils/edit_name_dialoge.dart';

class DrawerHeaderSection extends StatelessWidget {
  const DrawerHeaderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<UserProfileViewModel>().getProfileDetails();
      },
    );

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
            const ProfileImage(),
            Consumer<UserProfileViewModel>(
              builder: (context, value, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.62,
                          child: Text(
                            '${value.name}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            editNameDialoge(context, value.name ?? '');
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
                      '${value.contact}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onTap: () async {
            context.read<UserProfileViewModel>().updateImage();
          },
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 235, 232, 232),
                borderRadius: BorderRadius.circular(10)),
            height: 60,
            width: 60,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Selector<UserProfileViewModel, String>(
                    selector: (p0, p1) => p1.imageUrl,
                    builder: (context, imagePath, _) {
                      return CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: imagePath,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 2, value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    })),
          ),
        ),
      ),
    );
  }
}
