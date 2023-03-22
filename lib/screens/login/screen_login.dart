import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_tradebook/authentication/phone_authentication.dart';

Widget sizedBoxTen = SizedBox(
  height: 10,
);

class Screen_login extends StatelessWidget {
  Screen_login({super.key});
  final _phoneController = TextEditingController();
  final contryCode = '+91';
  String completePhone = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(249, 255, 253, 253),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/login.png'),
                  ),
                  sizedBoxTen,
                  Text(
                    'Welcome..',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login with Mobile',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                        sizedBoxTen,
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: IntlPhoneField(
                            style: TextStyle(fontSize: 17),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              //labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              completePhone = phone.completeNumber;
                              print(phone.completeNumber);
                            },
                          ),
                        ),
                        // Card(
                        //   elevation: 5,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   child:
                        //   // child: TextFormField(
                        //   //   controller: _phoneController,
                        //   //   keyboardType: TextInputType.phone,
                        //   //   decoration: InputDecoration(
                        //   //     prefixText: '+91 ',
                        //   //     contentPadding: EdgeInsets.only(
                        //   //         left: 10, right: 10, top: 4, bottom: 4),
                        //   //     border: OutlineInputBorder(
                        //   //       borderRadius: BorderRadius.circular(10),
                        //   //     ),
                        //   //   ),
                        //   // ),
                        // ),
                        sizedBoxTen,
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 3, // the elevation of the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // the radius of the button
                                ),
                              ),
                              onPressed: () async {
                                await sendOtp(completePhone, context);
                              },
                              child: Text(
                                'Send OTP',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  'OR',
                                  style: TextStyle(fontSize: 19),
                                ),
                              ),
                              Expanded(
                                child: Divider(),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Color.fromARGB(255, 226, 223, 223),
                              child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset(
                                              'assets/images/google.png')),
                                      Text(
                                        'Contitue with google',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
