import 'package:flutter/material.dart';
import 'FinancialHealthPage.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({super.key});

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State variables for card selections
  bool isFullyConfidentSelected = false;
  bool isConfidentSelected = false;
  bool isUncertainSelected = false;
  bool isNotConfidentSelected = false;

  bool showButton = false; // State to control button visibility

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Define slide animation
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animations
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void resetSelections() {
    setState(() {
      isFullyConfidentSelected = false;
      isConfidentSelected = false;
      isUncertainSelected = false;
      isNotConfidentSelected = false;
    });
  }

  void onCardTap(String cardType) {
    setState(() {
      resetSelections();
      showButton = true; // Show the button after a card is selected
      switch (cardType) {
        case "FullyConfident":
          isFullyConfidentSelected = true;
          break;
        case "Confident":
          isConfidentSelected = true;
          break;
        case "Uncertain":
          isUncertainSelected = true;
          break;
        case "NotConfident":
          isNotConfidentSelected = true;
          break;
      }
    });
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
                    isActive: true),
                _buildProgressCategory("Trust", Icons.favorite,
                    isActive: true), // Current step
              ],
            ),
            const SizedBox(height: 16),

            // Animated Chat Section
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: const AssetImage('assets/hmmm.png'),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildChatBubble("Looking ahead with confidence."),
                          _buildChatBubble(
                              "How secure do you feel about your financial future? 🏆"),
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
                    "Fully confident",
                    "Well-prepared with a solid plan.",
                    Icons.sentiment_very_satisfied,
                    isFullyConfidentSelected,
                    () {
                      onCardTap("FullyConfident");
                    },
                  ),
                  _buildOptionCard(
                    "Confident",
                    "Good plan, some room for improvement.",
                    Icons.sentiment_satisfied,
                    isConfidentSelected,
                    () {
                      onCardTap("Confident");
                    },
                  ),
                  _buildOptionCard(
                    "Uncertain",
                    "Facing uncertainties, seeking improvements.",
                    Icons.sentiment_dissatisfied,
                    isUncertainSelected,
                    () {
                      onCardTap("Uncertain");
                    },
                  ),
                  _buildOptionCard(
                    "Not confident",
                    "Significant planning needed.",
                    Icons.sentiment_very_dissatisfied,
                    isNotConfidentSelected,
                    () {
                      onCardTap("NotConfident");
                    },
                  ),
                ],
              ),
            ),

            // Button Section
            if (showButton) ...[
              const SizedBox(height: 16),
              const Text(
                "Congratulations! 🎉 Wanna see your results?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to FinancialHealthPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FinancialHealthPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.flag,
                  size: 32, // Icon size
                  color: Colors.white,
                ),
                label: Text(
                  "See Results",
                  style: TextStyle(
                    fontSize: 20, // Text size
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // Change the text color here
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Button background color
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0, // Increase vertical padding for height
                    horizontal: 70.0, // Increase horizontal padding for width
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
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
            color: isActive ? Colors.red.shade50 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? Colors.red : Colors.grey.shade400,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.red : Colors.grey,
                size: 30.0,
              ),
              const SizedBox(height: 4.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.red : Colors.grey.shade600,
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
        color: Colors.red.shade300,
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
      bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.shade100 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade400,
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
              color: isSelected ? Colors.red : Colors.grey,
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
                    color: isSelected ? Colors.red : Colors.black,
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
