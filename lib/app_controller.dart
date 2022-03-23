import 'package:animal_animation_app/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appStateProvider = StateNotifierProvider<AppControllerState, AppState>(
    (ref) => AppControllerState());

class AppControllerState extends StateNotifier<AppState> {
  AppControllerState() : super(AppState.initial());

  void observePageState(PageController pageController) {
    pageController.addListener(() {
      state = state.copyWith(
          page: pageController.page, offset: pageController.offset);
    });
  }

  late AnimationController mapAnimationController;
  void observeAnimationState(AnimationController animationController) {
    animationController.addListener(() {
      state = state.copyWith(value: animationController.value);
    });
  }

  void observeMapAnimationState(AnimationController animationController) {
    mapAnimationController = animationController;
    animationController.addListener(() {
      state = state.copyWith(mapvalue: animationController.value);
    });
  }

  void toggleMap() {
    if (state.mapvalue == 0) {
      mapAnimationController.forward();
    } else {
      mapAnimationController.reverse();
    }
  }
}
