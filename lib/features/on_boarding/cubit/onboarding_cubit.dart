import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'onboarding_state.dart';


class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());
  PageController pageController = PageController(initialPage: 0);
  int numPages = 2;
  double currentPage = 0;

  changePages() {
    currentPage = pageController.page!;
    emit(ChangingPagesState());
  }

  onPageChanged(int page) {
    currentPage = page.toDouble();
    emit(ChangingPagesState());
  }
}
