import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'NextQuestionPage.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int currentStep = 0;

  bool isDayToDayActive = false;

  // Add booleans for each option card
  bool isSaverSelected = false;
  bool isSpenderSelected = false;
  bool isBalancedSelected = false;
  bool isStrugglingSelected = false;

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

  void navigateToNextQuestion() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NextQuestionPage(), // Navigate to the next page
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
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

            // Centered Chat Section
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 36),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: const AssetImage('assets/wonder.png'),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildChatBubble("Welcome! 🚀"),
                          _buildChatBubble(
                              "Let's evaluate your financial flow."),
                          _buildChatBubble(
                              "How do you manage your monthly finances? 🧑‍💼"),
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
                    "Saver",
                    "I save more than I spend.",
                    Icons.savings,
                    isSaverSelected,
                    () {
                      setState(() {
                        _resetSelections();
                        isSaverSelected = true;
                        isDayToDayActive = true;
                      });
                      navigateToNextQuestion(); // Navigate on click
                    },
                  ),
                  _buildOptionCard(
                    "Spender",
                    "I often spend more than I save.",
                    Icons.money_off,
                    isSpenderSelected,
                    () {
                      setState(() {
                        _resetSelections();
                        isSpenderSelected = true;
                        isDayToDayActive = true;
                      });
                      navigateToNextQuestion(); // Navigate on click
                    },
                  ),
                  _buildOptionCard(
                    "Balanced",
                    "I save a bit, spend a bit.",
                    Icons.balance,
                    isBalancedSelected,
                    () {
                      setState(() {
                        _resetSelections();
                        isBalancedSelected = true;
                        isDayToDayActive = true;
                      });
                      navigateToNextQuestion(); // Navigate on click
                    },
                  ),
                  _buildOptionCard(
                    "Struggling",
                    "I'm struggling to make ends meet.",
                    Icons.error_outline,
                    isStrugglingSelected,
                    () {
                      setState(() {
                        _resetSelections();
                        isStrugglingSelected = true;
                        isDayToDayActive = true;
                      });
                      navigateToNextQuestion(); // Navigate on click
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

  void _resetSelections() {
    isSaverSelected = false;
    isSpenderSelected = false;
    isBalancedSelected = false;
    isStrugglingSelected = false;
  }

  Widget _buildProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildProgressCategory("Day-to-Day Life", Icons.calendar_today,
            isActive: isDayToDayActive),
        _buildProgressCategory("Resilience", Icons.shield, isActive: false),
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
            color: isActive ? Colors.blue.shade50 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? Colors.blue : Colors.grey.shade400,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.blue : Colors.grey,
                size: 30.0,
              ),
              const SizedBox(height: 4.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.blue : Colors.grey.shade600,
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
                color: isActive ? Colors.blue : Colors.grey.shade400,
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
        color: const Color.fromARGB(255, 11, 121, 211),
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
          color: isSelected ? Colors.blue.shade100 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade400,
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
              color: Colors.blue,
              size: 32,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
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


