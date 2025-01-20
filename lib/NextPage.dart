import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'FinalPage.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool isOnTrackSelected = false;
  bool isStartedSelected = false;
  bool isAdvancingSelected = false;
  bool isDreamingSelected = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Set up fade and slide animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward(); // Start animations
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToFinalPage() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FinalPage(), // Navigate to FinalPage
        ),
      );
    });
  }

  void resetSelections() {
    isOnTrackSelected = false;
    isStartedSelected = false;
    isAdvancingSelected = false;
    isDreamingSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Motivation"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressCategory("Day-to-Day Life", Icons.calendar_today,
                    isActive: true),
                _buildProgressCategory("Resilience", Icons.shield,
                    isActive: true),
                _buildProgressCategory("Goals", Icons.golf_course,
                    isActive: true), // Current step
                _buildProgressCategory("Trust", Icons.favorite,
                    isActive: false),
              ],
            ),
            const SizedBox(height: 16),

            // Animated Chat Section
            SlideTransition(
              position: _slideAnimation, // Slide animation
              child: FadeTransition(
                opacity: _fadeAnimation, // Fade animation
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: const AssetImage('assets/tongue.png'),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildChatBubble("Progress perspective."),
                          _buildChatBubble(
                              "Where are you on your goal journey? 🌟"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Options Section
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.8,
                children: [
                  _buildOptionCard(
                    "On track",
                    "Aligned with goals.",
                    Icons.verified,
                    isOnTrackSelected,
                    () {
                      setState(() {
                        resetSelections();
                        isOnTrackSelected = true;
                      });
                      navigateToFinalPage();
                    },
                  ),
                  _buildOptionCard(
                    "Started",
                    "Initial steps taken.",
                    FontAwesomeIcons.seedling,
                    isStartedSelected,
                    () {
                      setState(() {
                        resetSelections();
                        isStartedSelected = true;
                      });
                      navigateToFinalPage();
                    },
                  ),
                  _buildOptionCard(
                    "Advancing",
                    "Making progress, yet more to achieve.",
                    Icons.timeline,
                    isAdvancingSelected,
                    () {
                      setState(() {
                        resetSelections();
                        isAdvancingSelected = true;
                      });
                      navigateToFinalPage();
                    },
                  ),
                  _buildOptionCard(
                    "Dreaming",
                    "Planning stage.",
                    Icons.cloud,
                    isDreamingSelected,
                    () {
                      setState(() {
                        resetSelections();
                        isDreamingSelected = true;
                      });
                      navigateToFinalPage();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCategory(String title, IconData icon,
      {bool isActive = false}) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isActive ? Colors.orange.shade50 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? Colors.orange : Colors.grey.shade400,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.orange : Colors.grey,
                size: 30.0,
              ),
              const SizedBox(height: 4.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.orange : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildOptionCard(String title, String subtitle, IconData icon,
      bool isSelected, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade100 : Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 194, 119, 5)
                : Colors.grey.shade400,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.orange : Colors.grey,
              size: 32,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.orange : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
