import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/controllers/profile_controller/profile_controller.dart';
import 'package:my_tradebook/views/drawer/widgets/edit_name_dialog.dart';

ProfileController profileController = Get.put(ProfileController());

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      profileController.getUserProfile();
      profileController.changeLoading(false);
    });

    return Material(
      elevation: 3,
      child: DrawerHeader(
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
            child: Obx(
              () {
                if (profileController.isLoading.value) {
                  return const CircularProgressIndicator();
                }
                return Column(
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
                            await profileController.updateImage();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 235, 232, 232),
                                borderRadius: BorderRadius.circular(10)),
                            height: 60,
                            width: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                profileController.imgurl.value,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          profileController.name.value,
                          style: const TextStyle(fontSize: 17),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            editNameDialoge(profileController.name.value);
                            
                          },
                          child: const Icon(
                            Icons.edit,
                            size: 15,
                            color: Color.fromARGB(255, 145, 144, 144),
                          ),
                        )
                      ],
                    ),
                    Text(
                      profileController.contact.value,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }
}
