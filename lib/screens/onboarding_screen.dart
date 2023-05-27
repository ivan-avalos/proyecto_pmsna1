import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:linkchat/settings/preferences.dart';
import 'package:lottie/lottie.dart';

import '../widgets/responsive.dart';

class PageData {
  final String title;
  final String icon;
  final MaterialColor bgColor;
  final Color textColor;

  const PageData({
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.textColor,
  });
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const pages = [
    PageData(
      title: '¡Bienvenidx a LinkChat!',
      icon: 'assets/star.json',
      bgColor: Colors.deepPurple,
      textColor: Colors.white,
    ),
    PageData(
      title:
          'Una nueva experiencia de chat donde solo puedes compartir enlaces',
      icon: 'assets/share.json',
      bgColor: Colors.red,
      textColor: Colors.white,
    ),
    PageData(
      title: 'Guarda tus enlaces favoritos para verlos más tarde',
      icon: 'assets/heart.json',
      bgColor: Colors.green,
      textColor: Colors.black,
    ),
  ];

  Widget icon(PageData data) => CircleAvatar(
        radius: 100.0,
        backgroundColor: data.bgColor.shade200,
        child: Lottie.asset(
          data.icon,
          height: 100.0,
          fit: BoxFit.fill,
        ),
      );

  Widget text(BuildContext context, PageData data) => Text(
        data.title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .typography
            .englishLike
            .headlineMedium!
            .copyWith(color: data.textColor),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((PageData p) => p.bgColor).toList(),
        itemCount: pages.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (int index) {
          PageData data = pages[index];
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Responsive(
                mobile: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon(data),
                    const SizedBox(height: 50.0),
                    text(context, data),
                  ],
                ),
                desktop: Row(
                  children: [
                    Expanded(child: icon(data)),
                    Expanded(child: text(context, data)),
                  ],
                ),
              ),
            ),
          );
        },
        onFinish: () {
          Preferences.setShowOnboarding(false);
          Navigator.of(context).pushNamed('/dash');
        },
      ),
    );
  }
}
