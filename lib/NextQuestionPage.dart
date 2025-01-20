import 'package:flutter/material.dart';
import 'NextPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NextQuestionPage extends StatefulWidget {
  const NextQuestionPage({super.key});

  @override
  _NextQuestionPageState createState() => _NextQuestionPageState();
}

class _NextQuestionPageState extends State<NextQuestionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool isResilienceActive = false;

  // Add booleans for option selection
  bool isEasilyCoverSelected = false;
  bool isManageCoverSelected = false;
  bool isStruggleCoverSelected = false;
  bool isUnableCoverSelected = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToNextPage() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NextPage(), // Navigate to the NextPage
        ),
      );
    });
  }

  void _resetSelections() {
    isEasilyCoverSelected = false;
    isManageCoverSelected = false;
    isStruggleCoverSelected = false;
    isUnableCoverSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        title: const Text("Motivation"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress Bar Section
            _buildProgressBar(),
            const SizedBox(height: 16),

            // Animated Chat Section
            SlideTransition(
              position: _slideAnimation, // Slide animation
              child: FadeTransition(
                opacity: _fadeAnimation, // Fade animation
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: const AssetImage('assets/happy.png'),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildChatBubble("Life throws a curveball! ⚾"),
                          _buildChatBubble(
                              "Unexpected 1,500€ expense today, how do you manage? 💸"),
                        ],
                      ),
                    ],
                  ),
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
                    "Easily cover",
                    "No impact on my financial stability.",
                    Icons.check_circle,
                    isEasilyCoverSelected,
                    () {
                      setState(() {
                        _resetSelections();
                        isEasilyCoverSelected = true;
                        isResilienceActive = true;
                      });
                      _navigateToNextPage();
                    },
                  ),
                  _buildOptionCard(
                    "Manage to cover",
                    "Needs budget adjustments.",
                    Icons.settings,
                    isManageCoverSelected,
                    () {
                      setState(() {
                        _resetSelections();
                        isManageCoverSelected = true;
                        isResilienceActive = true;
                      });
                      _navigateToNextPage();
                    },
                  ),
                  _buildOptionCard(
                    "Struggle to cover",
                    "Might borrow or cut essentials.",
                    Icons.warning,
                    isStruggleCoverSelected,
                    () {
                      setState(() {
                        _resetSelections();
                        isStruggleCoverSelected = true;
                        isResilienceActive = true;
                      });
                      _navigateToNextPage();
                    },
                  ),
                  _buildOptionCard(
                    "Unable to cover",
                    "Causes significant distress.",
                    Icons.error,
                    isUnableCoverSelected,
                    () {
                      setState(() {
                        _resetSelections();
                        isUnableCoverSelected = true;
                        isResilienceActive = true;
                      });
                      _navigateToNextPage();
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

  Widget _buildProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildProgressCategory("Day-to-Day Life", Icons.calendar_today,
            isActive: true), // Previous step remains active
        _buildProgressCategory("Resilience", Icons.shield,
            isActive: isResilienceActive), // Current step
        _buildProgressCategory("Goals", FontAwesomeIcons.bullseye,
            isActive: false),
        _buildProgressCategory("Trust", Icons.favorite, isActive: false),
      ],
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
            color: isActive ? Colors.green.shade50 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? Colors.green : Colors.grey.shade400,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.green : Colors.grey,
                size: 30.0,
              ),
              const SizedBox(height: 4.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.green : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(
                index == 0 && isActive ? Icons.check_circle : Icons.circle,
                size: 12,
                color: isActive ? Colors.green : Colors.grey.shade400,
              ),
            ),
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
        color: Colors.green.shade300,
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
          color: isSelected ? Colors.green.shade100 : Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 15, 163, 20)
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
              color: isSelected ? Colors.green : Colors.grey,
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
                    color: isSelected ? Colors.green : Colors.black,
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
