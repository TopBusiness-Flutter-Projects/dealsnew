import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/assets_manager.dart';

import '../../../core/utils/get_size.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';

class OnBoarding1 extends StatelessWidget {
  const OnBoarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {},
      builder: (context, state) {
        OnboardingCubit cubit = context.read<OnboardingCubit>();
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions: [],
          ),
          body: Column(
            children: [
              SizedBox(
                height: getSize(context) / 22,
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(getSize(context) / 22),
                    child: Image.asset(
                      ImageAssets.introBackgroundImage,
                      // width: getSize(context) / 1.1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: getSize(context) / 12),

              // SizedBox(height: getSize(context) / 12),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: getSize(context) / 44),
                child: Text(
                  "onBoarding1title".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: getSize(context) / 18),
                ),
              ),
              Container(
                padding: EdgeInsets.all(getSize(context) / 44),
                child: Text(
                  "onBoarding1desc".tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'cairo',
                      fontSize: getSize(context) / 22),
                ),
              ),

              // SizedBox(height: getSize(context) / 12)
            ],
          ),
        );
      },
    );
  }
}
