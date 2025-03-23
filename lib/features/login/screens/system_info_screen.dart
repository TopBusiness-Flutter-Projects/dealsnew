import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/core/preferences/preferences.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_strings.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/core/utils/dialogs.dart';
import 'package:top_sale/features/login/cubit/cubit.dart';
import 'package:top_sale/features/login/cubit/state.dart';
import '../../../config/routes/app_routes.dart';
import '../../../core/utils/get_size.dart';
import '../widget/custom_button.dart';
import '../widget/textfield_with_text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
@override
  void initState() {
Preferences.instance.setIsVisitor(false);
 Preferences.instance.removeEmployeeIdNumber();
 Preferences.instance.removeEmployeeId();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      var cubit = context.read<LoginCubit>();
      return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              'new_account'.tr(),
              style: TextStyle(
                  fontFamily: AppStrings.fontFamily,
                  color: AppColors.black,
                  fontWeight: FontWeight.w700),
            ),
          ),
          body: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                  child: Image.asset(
                ImageAssets.logoImage,
                width: getSize(context) / 1.4,
                // height: getSize(context) / 1.4,
              )),
              SizedBox(
                height: getSize(context) / 8,
              ),
              CustomTextFieldWithTitle(
                controller: cubit.companynameController,
                hint: 'companyname_invalid'.tr(),
                keyboardType: TextInputType.name,
                title: 'companyname'.tr(),
              ),
              CustomTextFieldWithTitle(
                  keyboardType: TextInputType.url,
                  controller: cubit.odooLinkController,
                  hint: 'odoo_link_invalid'.tr(),
                  title: 'odoo_link'.tr()),
              CustomTextFieldWithTitle(
                  controller: cubit.dbNumberController,
                  hint: 'db_name_invalid'.tr(),
                  title: 'db_name'.tr(),
                  keyboardType: TextInputType.text),
              CustomTextFieldWithTitle(
                  controller: cubit.adminNameController,
                  hint: 'username_invalid'.tr(),
                  title: 'admin_name'.tr(),
                  keyboardType: TextInputType.text),
              CustomTextFieldWithTitle(
                  keyboardType: TextInputType.visiblePassword,
                  controller: cubit.adminPasswordController,
                  hint: 'password_invalid'.tr(),
                  title: 'password'.tr()),
              CustomButton(
                  title: 'register'.tr(),
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      cubit.login(context,
                          isEmployeeType: true,
                          isVisitor: false,
                          phoneOrMail: cubit.adminNameController.text,
                          password: cubit.adminPasswordController.text,
                          baseUrl: cubit.odooLinkController.text,
                          database: cubit.dbNumberController.text);
                    } else {
                      errorGetBar( "please_enter_fields".tr());
                      print('Form is Not valid');
                    }
                  }),
              Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // InkWell(
                        //     onTap: () {
                        //       Navigator.pushNamed(
                        //           context, Routes.registerScreen);
                        //     },
                        //     child: Text('login'.tr())),
                        InkWell(
                            onTap: () {
                              cubit.login(context,
                                  isVisitor: true,
                                  isEmployeeType: false,
                                  phoneOrMail: "",
                                  password: "",
                                  baseUrl: "",
                                  database: "");
                            },
                            child: Text('try_the_app'.tr(),
                                style: TextStyle(
                                    color: AppColors.orangeThirdPrimary))),
                      ])),
            ]),
          )));
    });
  }
}
