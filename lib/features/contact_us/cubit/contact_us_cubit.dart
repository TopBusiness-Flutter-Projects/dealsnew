
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:top_sale/core/remote/service.dart';
import 'package:top_sale/core/utils/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/assets_manager.dart';
import 'contact_us_state.dart';
class ContactUsCubit extends Cubit<ContactUsState> {

  ContactUsCubit(this.api) : super(ContactUsInitial());
  ServiceApi api;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  List<String>Images=[ImageAssets.callIcon,ImageAssets.emailIcon,ImageAssets.whatsAppIcon];
  List<String>Texts=["01011827324","info@topbusiness.io","+201011827324"];
  final String phoneNumber = '01011827324'; // replace with actual phone number
  final String email = 'info@topbusiness.io'; // replace with actual email
  final String whatsAppNumber = '+201011827324';
  Future<void> launchURL(String url) async {
     try {
      launchUrl(Uri.parse(url));
    } catch (e) {
    errorGetBar("error from url");
    }
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  // Function to launch mailto (with better error handling)
  Future<void> launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Contacting Support', // optional subject
      },
    );
 try {

      launchUrl(emailUri);
    } catch (e) {
    errorGetBar("error from email");
    }
    // if (await canLaunchUrl(emailUri)) {
    //   await launchUrl(emailUri);
    // } else {
    //   throw 'Could not launch $emailUri';
    // }
  }
  final Map<String, String> links = {
    // 'instagram': 'https://www.instagram.com',
    'facebook': 'https://www.facebook.com/topbusiness.io?mibextid=ZbWKwL',
    // 'twitter': 'https://www.twitter.com',
    // 'youtube': 'https://www.youtube.com/channel/UC7ZV_0avpuVoESi7Ku43T5w',
    'web': 'https://topbuziness.com/', // replace with actual website URL
  };
}
