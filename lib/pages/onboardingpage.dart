import 'package:cleanify/elements/project_elements.dart';
import 'package:flutter/material.dart';
import 'package:cleanify/pages/signuplogin.dart'; // SignupLogin sayfasını import edin

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "icon": Icons.home,
      "title": "Welcome to Cleanify!",
      "description": "Discover and share pollution reports in your area."
    },
    {
      "icon": Icons.map,
      "title": "Explore the Map",
      "description":
          "Find pollution hotspots and contribute to a cleaner environment."
    },
    {
      "icon": Icons.share,
      "title": "Share Your Findings",
      "description": "Report pollution incidents and help raise awareness."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.projectBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                return _buildOnboardingStep(
                  icon: _onboardingData[index]["icon"],
                  title: _onboardingData[index]["title"],
                  description: _onboardingData[index]["description"],
                );
              },
            ),
          ),
          _buildPageIndicator(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_currentIndex == _onboardingData.length - 1) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: Text(_currentIndex == _onboardingData.length - 1
                  ? "Get Started"
                  : "Next"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingStep(
      {required IconData icon,
      required String title,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: ProjectColors.projectPrimaryWidgetColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingData.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: _currentIndex == index ? 24.0 : 8.0,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? ProjectColors.projectPrimaryWidgetColor
                : Colors.grey,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }
}
