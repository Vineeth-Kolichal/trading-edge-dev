import 'package:flutter/material.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/views/widgets/widget_appbar.dart';

class PageTermsOfUser extends StatelessWidget {
  const PageTermsOfUser({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 247),
      appBar: WidgetAppbar(title: 'Terms of use'),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(children: [
            Text(
              '1. This terms of use is an electronic record in the form of an electronic contract by and between Us and You under the Information Technology Act, 2000 and the rules made thereunder, as applicable, and the amended provisions pertaining to electronic records in various statutes, as amended from time to time (“Terms of Use”). This Terms of Use, the privacy policy, the disclaimer and any other applicable policies (the “Policies”) is published in accordance with Rule 3(1)(a) of the Information Technology (Intermediaries Guidelines and Digital Medial Ethics Code) Rules, 2021, which requires the publication of rules and regulations',
              style: TextStyle(fontSize: 12),
            ),
            sizedBoxTen,
            Text(
                '2. The Policies, as updated by Us from time to time, govern the relationship and transactions between You and Us, in relation to the access and/or use of the Services offered through the Platform.',
                style: TextStyle(fontSize: 12)),
            sizedBoxTen,
            Text(
                '3.Please read the terms and conditions of the Terms of Use fully before using, signing up on the Platform or accessing any material, information, content or availing Services through the Platform. By downloading, installing, or otherwise accessing or using Our Platform or Services (whether in whole or in part), You agree that You have read, understood, and agree to be bound by the Terms of Use. By agreeing to the Terms of Use, You represent and warrant that You are at least the age of majority in Your state/province/country of permanent residence and/or nationality, or that You are the age of majority in Your state/province/country of permanent residence and /or nationality or  You have given Us Your consent to allow any of Your minor dependents to use Our Services and You are not a person barred under applicable law from receiving the Service and are competent to enter into a binding contract. You also represent and warrant to Us that You will use the Platform in a manner consistent with any and all applicable laws and regulations, and/or have not been barred, suspended or removed by Us for any reason whatsoever.',
                style: TextStyle(fontSize: 12)),
            sizedBoxTen,
            Text(
                '4.This Terms of Use is an electronic document and does not require any physical, electronic or digital signature. By accessing or using the Platform, You indicate that You understand, agree and consent to the terms and conditions contained in this Terms of Use. If You do not agree with the terms and conditions of this Terms of Use, please do not use this Platform.',
                style: TextStyle(fontSize: 12)),
            sizedBoxTen,
            Text(
                '5. We do not guarantee, represent or warrant in any manner that Your use of Our Services will be uninterrupted, timely, secure or error-free, on account of telecommunication interruptions or other disruptions. We also do not warrant that the Platform and its servers are free of computer viruses or other harmful mechanisms. If Your use of the Platform or content therein results in the need for servicing or replacing Your computer, mobile or other equipment or data, We are not responsible for any such costs.',
                style: TextStyle(fontSize: 12)),
            sizedBoxTen,
            Text(
                '6.We shall not be liable for any damage to Your computer, mobile or other equipment or for loss of data that may result from the download of any content, material, and information from the Platform or use of any software, systems, functionality, or other services on the Platform.',
                style: TextStyle(fontSize: 12))
          ]),
        ),
      )),
    );
  }
}
