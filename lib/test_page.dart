import 'package:animal_animation_app/app_controller.dart';
import 'package:animal_animation_app/new_leopard_page.dart';
import 'package:animal_animation_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math' as math;
import 'constants.dart';
import 'leopard_page.dart';

class TestPage extends StatefulHookConsumerWidget {
  const TestPage({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestPage();
}

// ignore: must_be_immutable
class _TestPage extends ConsumerState<TestPage> {
  late AnimationController _animationController;
  late AnimationController _mapAnimationController;
  late double maxHeight = mainSquareSize(context) + 32 + 24;
  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    _animationController = useAnimationController();
    _mapAnimationController =
        useAnimationController(duration: const Duration(milliseconds: 500));

    ref.read(appStateProvider.notifier).observePageState(pageController);
    ref
        .read(appStateProvider.notifier)
        .observeMapAnimationState(_mapAnimationController);

    bool isFistPage = ref.watch(appStateProvider).page == 0;
    return Scaffold(
        body: Stack(
      children: [
        const MapImage(),
        GestureDetector(
          onVerticalDragEnd: !isFistPage ? _handleDragEnd : null,
          onVerticalDragUpdate: !isFistPage ? _handleDragUpdate : null,
          child: Stack(alignment: Alignment.center, children: [
            PageView(
              controller: pageController,
              children: [NewLeopardPage(), Container()],
            ),
            const AppBar(),
            const MyLeopardImage(),
            const MyVultureImage(),
            const MyShareButton(),
            const MyIndicator(),
            const ArrowIcon(),
            const MyTravelDetailsLabel(),
            const StartCampLabel(),
            const BaseCampLabel(),
            const BaseTimeLabel(),
            const DistanceLabel(),
            const HorizontalTravelDots(),
            const MapButton(),
            const VerticalTravelDots(),
            const VultureIconLabel(),
            const LeopardIconLabel(),
            const CurvedRoute(),
            const MapBaseCamp(),
            const MapLeopards(),
            const MapVultures(),
            const MapStartCamp()
          ]),
        ),
      ],
    ));
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -= details.primaryDelta! / maxHeight;

    ref
        .read(appStateProvider.notifier)
        .observeAnimationState(_animationController);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;
    final flingVelocity = details.velocity.pixelsPerSecond.dy / maxHeight;

    if (flingVelocity < 0.0) {
      _animationController.fling(velocity: math.max(2, -flingVelocity));
    } else if (flingVelocity > 0.0) {
      _animationController.fling(velocity: math.min(-2, -flingVelocity));
    } else {
      _animationController.fling(
          velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
    }
  }
}

class MyLeopardImage extends HookConsumerWidget {
  const MyLeopardImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(appStateProvider);
    return Positioned(
        left: -0.85 * notifier.offset,
        width: MediaQuery.of(context).size.width * 1.6,
        child: IgnorePointer(child: Image.asset('assets/leopard.png')));
  }
}

class MyVultureImage extends HookConsumerWidget {
  const MyVultureImage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(appStateProvider);
    return Positioned(
      left: 1.2 * MediaQuery.of(context).size.width - 0.85 * notifier.offset,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: IgnorePointer(
            child: Image.asset(
          'assets/vulture.png',
          height: MediaQuery.of(context).size.height / 4,
        )),
      ),
    );
  }
}

class MyShareButton extends StatelessWidget {
  const MyShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Positioned(right: 24, bottom: 16, child: Icon(Icons.share));
  }
}

class AppBar extends StatelessWidget {
  const AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      right: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "SY",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Icon(Icons.menu)
          ],
        ),
      ),
    );
  }
}

class MyIndicator extends HookConsumerWidget {
  const MyIndicator({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(appStateProvider).page.round();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: page == 0 ? white : lightGrey),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: page == 1 ? white : lightGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class ArrowIcon extends StatelessWidget {
  const ArrowIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final animation = ref.watch(appStateProvider);
        double opacity = math.max(0, 4 * ref.watch(appStateProvider).page - 3);
        return Positioned(
            top: topMargin(context) +
                (1 - animation.value) * mainSquareSize(context) +
                32 -
                4,
            right: 24,
            child: Opacity(
              opacity: opacity,
              child: Icon(
                animation.value == 1
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                size: 28,
                color: lighterGrey,
              ),
            ));
      },
    );
  }
}

class MyTravelDetailsLabel extends StatelessWidget {
  const MyTravelDetailsLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appstate = ref.watch(appStateProvider);
        return Positioned(
            top: topMargin(context) +
                (1 - appstate.value) * (mainSquareSize(context) + 32 - 4),
            left: 24 + MediaQuery.of(context).size.width - appstate.offset,
            child: Opacity(
                opacity: math.max(0, 4 * appstate.page - 3), child: child));
      },
      child: const MapHider(
        child: Text(
          'Travel details',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class MapHider extends StatelessWidget {
  const MapHider({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        return Opacity(
          opacity: math.max(0, 1 - (2 * appState.mapvalue)),
          child: child,
        );
      },
      child: child,
    );
  }
}

class StartCampLabel extends StatelessWidget {
  const StartCampLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        double opacity = math.max(0, 4 * ref.watch(appStateProvider).page - 3);
        return Positioned(
            top: topMargin(context) + mainSquareSize(context) + 32 + 16 + 32,
            width: (MediaQuery.of(context).size.width - 48) / 3,
            left: opacity * 24.0,
            child: Opacity(opacity: opacity, child: child!));
      },
      child: const MapHider(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Start camp',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ),
      ),
    );
  }
}

class BaseCampLabel extends StatelessWidget {
  const BaseCampLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        double opacity = math.max(0, 4 * appState.page - 3);
        return Positioned(
          top: topMargin(context) +
              32 +
              16 +
              4 +
              (1 - appState.value) * (mainSquareSize(context) + 32 - 4),
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: opacity * 24.0,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: const MapHider(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Base camp',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}

class BaseTimeLabel extends StatelessWidget {
  const BaseTimeLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);

        double opacity = math.max(0, 4 * appState.page - 3);
        return Positioned(
          top: topMargin(context) +
              32 +
              16 +
              44 +
              (1 - appState.value) * (mainSquareSize(context) + 32 - 4),
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: opacity * 24.0,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: const MapHider(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '07:30 am',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: lighterGrey,
            ),
          ),
        ),
      ),
    );
  }
}

class DistanceLabel extends StatelessWidget {
  const DistanceLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        double opacity = math.max(0, 4 * ref.watch(appStateProvider).page - 3);
        return Positioned(
          top: topMargin(context) + mainSquareSize(context) + 32 + 16 + 32 + 40,
          width: MediaQuery.of(context).size.width,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: const MapHider(
        child: Center(
          child: Text(
            '72 km',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: white,
            ),
          ),
        ),
      ),
    );
  }
}

class HorizontalTravelDots extends StatelessWidget {
  const HorizontalTravelDots({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        if (appState.value == 1) {
          return Container();
        }
        double spacingFactor;
        double opacity;
        if (appState.value == 0) {
          spacingFactor = math.max(0, 4 * appState.page - 3);
          opacity = spacingFactor;
        } else {
          spacingFactor = math.max(0, 1 - 6 * appState.value);
          opacity = 1;
        }
        return Positioned(
          top: dotsTopMargin(context),
          left: 0,
          right: 0,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: spacingFactor * 10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGrey,
                    ),
                    height: 4,
                    width: 4,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: spacingFactor * 10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightGrey,
                    ),
                    height: 4,
                    width: 4,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: spacingFactor * 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: white),
                    ),
                    height: 8,
                    width: 8,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: spacingFactor * 40),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    height: 8,
                    width: 8,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MapButton extends StatelessWidget {
  const MapButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      bottom: 0,
      child: Consumer(
        builder: (context, ref, child) {
          final appState = ref.watch(appStateProvider);
          double opacity = math.max(0, 4 * appState.page - 3);
          return Opacity(
            opacity: opacity,
            child: TextButton(
              child: const Text(
                'ON MAP',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: () {
                ref.read(appStateProvider.notifier).toggleMap();
              },
            ),
          );
        },
      ),
    );
  }
}

class VerticalTravelDots extends StatelessWidget {
  const VerticalTravelDots({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        if (appState.value < 1 / 6 || appState.mapvalue > 0) {
          return Container();
        }
        double startTop = dotsTopMargin(context);
        double endTop = topMargin(context) + 32 + 16 + 8;

        double top = endTop +
            (1 - (1.2 * (appState.value - 1 / 6))) *
                (mainSquareSize(context) + 32 - 4);

        double oneThird = (startTop - endTop) / 3;

        return Positioned(
          top: top,
          bottom: bottom(context) - mediaPadding(context).vertical,
          child: Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  width: 2,
                  height: double.infinity,
                  color: white,
                ),
                Positioned(
                  top: top > oneThird + endTop ? 0 : oneThird + endTop - top,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: white, width: 2.5),
                      color: mainBlack,
                    ),
                    height: 8,
                    width: 8,
                  ),
                ),
                Positioned(
                  top: top > 2 * oneThird + endTop
                      ? 0
                      : 2 * oneThird + endTop - top,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: white, width: 2.5),
                      color: mainBlack,
                    ),
                    height: 8,
                    width: 8,
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 1),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: white, width: 1),
                      color: mainBlack,
                    ),
                    height: 8,
                    width: 8,
                  ),
                ),
                Align(
                  alignment: const Alignment(0, -1),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    height: 8,
                    width: 8,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VultureIconLabel extends StatelessWidget {
  const VultureIconLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        double startTop =
            topMargin(context) + mainSquareSize(context) + 32 + 16 + 32 + 4;
        double endTop = topMargin(context) + 32 + 16 + 8;
        double oneThird = (startTop - endTop) / 3;
        double opacity;
        if (appState.value < 2 / 3) {
          opacity = 0;
        } else if (appState.mapvalue == 0) {
          opacity = 3 * (appState.value - 2 / 3);
        } else if (appState.mapvalue < 0.33) {
          opacity = 1 - 3 * appState.mapvalue;
        } else {
          opacity = 0;
        }

        return Positioned(
          top: endTop + 2 * oneThird - 28 - 16 - 7,
          right: 10 + opacity * 16,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: const SmallAnimalIconLabel(
        isVulture: true,
        showLine: true,
      ),
    );
  }
}

class SmallAnimalIconLabel extends StatelessWidget {
  final bool isVulture;
  final bool showLine;

  const SmallAnimalIconLabel(
      {Key? key, required this.isVulture, required this.showLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (showLine && isVulture)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            width: 16,
            height: 1,
            color: white,
          ),
        const SizedBox(width: 24),
        Column(
          children: <Widget>[
            Image.asset(
              isVulture ? 'assets/vultures.png' : 'assets/leopards.png',
              width: 28,
              height: 28,
            ),
            SizedBox(height: showLine ? 16 : 0),
            Text(
              isVulture ? 'Vultures' : 'Leopards',
              style: TextStyle(fontSize: showLine ? 14 : 12),
            )
          ],
        ),
        const SizedBox(width: 24),
        if (showLine && !isVulture)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            width: 16,
            height: 1,
            color: white,
          ),
      ],
    );
  }
}

class LeopardIconLabel extends StatelessWidget {
  const LeopardIconLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        double opacity;
        if (appState.value < 3 / 4) {
          opacity = 0;
        } else if (appState.mapvalue == 0) {
          opacity = 4 * (appState.value - 3 / 4);
        } else if (appState.mapvalue < 0.33) {
          opacity = 1 - 3 * appState.mapvalue;
        } else {
          opacity = 0;
        }
        return Positioned(
          top: endTop(context) + oneThird(context) - 28 - 16 - 7,
          left: 10 + opacity * 16,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: const SmallAnimalIconLabel(
        isVulture: false,
        showLine: true,
      ),
    );
  }
}

class CurvedRoute extends StatelessWidget {
  const CurvedRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        if (appState.mapvalue == 0) {
          return Container();
        }
        double startTop =
            topMargin(context) + mainSquareSize(context) + 32 + 16 + 32 + 4;
        double endTop = topMargin(context) + 32 + 16 + 8;
        double oneThird = (startTop - endTop) / 3;
        double width = MediaQuery.of(context).size.width;

        return Positioned(
          top: endTop,
          bottom: bottom(context) - mediaPadding(context).vertical,
          left: 0,
          right: 0,
          child: CustomPaint(
            painter: CurvePainter(appState.mapvalue),
            child: Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Positioned(
                    top: oneThird,
                    right: width / 2 - 4 - appState.mapvalue * 60,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: white, width: 2.5),
                        color: mainBlack,
                      ),
                      height: 8,
                      width: 8,
                    ),
                  ),
                  Positioned(
                    top: 2 * oneThird,
                    right: width / 2 - 4 - appState.mapvalue * 50,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: white, width: 2.5),
                        color: mainBlack,
                      ),
                      height: 8,
                      width: 8,
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 1),
                    child: Container(
                      margin: EdgeInsets.only(right: 100 * appState.mapvalue),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: white, width: 1),
                        color: mainBlack,
                      ),
                      height: 8,
                      width: 8,
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, -1),
                    child: Container(
                      margin: EdgeInsets.only(left: 40 * appState.mapvalue),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: white,
                      ),
                      height: 8,
                      width: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CurvePainter extends CustomPainter {
  final double animationValue;
  double width = 0;

  CurvePainter(this.animationValue);

  double interpolate(double x) {
    return width / 2 + (x - width / 2) * animationValue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    width = size.width;
    paint.color = white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    var path = Path();

//    print(interpolate(size, x))
    var startPoint = Offset(interpolate(width / 2 + 20), 4);
    var controlPoint1 = Offset(interpolate(width / 2 + 60), size.height / 4);
    var controlPoint2 = Offset(interpolate(width / 2 + 20), size.height / 4);
    var endPoint = Offset(interpolate(width / 2 + 55 + 4), size.height / 3);

    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    startPoint = endPoint;
    controlPoint1 = Offset(interpolate(width / 2 + 100), size.height / 2);
    controlPoint2 = Offset(interpolate(width / 2 + 20), size.height / 2 + 40);
    endPoint = Offset(interpolate(width / 2 + 50 + 2), 2 * size.height / 3 - 1);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    startPoint = endPoint;
    controlPoint1 =
        Offset(interpolate(width / 2 - 20), 2 * size.height / 3 - 10);
    controlPoint2 =
        Offset(interpolate(width / 2 + 20), 5 * size.height / 6 - 10);
    endPoint = Offset(interpolate(width / 2), 5 * size.height / 6 + 2);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    startPoint = endPoint;
    controlPoint1 = Offset(interpolate(width / 2 - 100), size.height - 80);
    controlPoint2 = Offset(interpolate(width / 2 - 40), size.height - 50);
    endPoint = Offset(interpolate(width / 2 - 50), size.height - 4);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class MapBaseCamp extends StatelessWidget {
  const MapBaseCamp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        double opacity = math.max(0, 4 * (appState.mapvalue - 3 / 4));
        return Positioned(
          top: topMargin(context) + 32 + 16 + 4,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          right: 30.0,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Base camp',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class MapLeopards extends StatelessWidget {
  const MapLeopards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        double opacity = math.max(0, 4 * (appState.mapvalue - 3 / 4));
        return Positioned(
          top: topMargin(context) + 32 + 16 + 4 + oneThird(context),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.only(left: 30),
        child: SmallAnimalIconLabel(
          isVulture: false,
          showLine: false,
        ),
      ),
    );
  }
}

class MapVultures extends StatelessWidget {
  const MapVultures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        double opacity = math.max(0, 4 * (appState.mapvalue - 3 / 4));
        return Positioned(
          top: topMargin(context) + 32 + 16 + 4 + 2 * oneThird(context),
          right: 50,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: const SmallAnimalIconLabel(
        isVulture: true,
        showLine: false,
      ),
    );
  }
}

class MapImage extends StatelessWidget {
  const MapImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        double scale = 1 + 0.3 * (1 - appState.mapvalue);
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(scale, scale)
            ..rotateZ(0.05 * math.pi * (1 - appState.mapvalue)),
          child: Opacity(
            opacity: appState.mapvalue,
            child: child,
          ),
        );
      },
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(
          'assets/map-min.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class MapStartCamp extends StatelessWidget {
  const MapStartCamp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appState = ref.watch(appStateProvider);
        double opacity = math.max(0, 4 * (appState.mapvalue - 3 / 4));
        return Positioned(
          top: startTop(context) - 4,
          width: (MediaQuery.of(context).size.width - 48) / 3,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: const Align(
        alignment: Alignment.center,
        child: Text(
          'Start camp',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
