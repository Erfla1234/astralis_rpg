import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'game_screen.dart';
import 'intro_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _menuController;
  late AnimationController _particleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _selectedIndex = 0;
  final List<MenuOption> _menuOptions = [
    MenuOption(
      title: 'New Journey',
      subtitle: 'Begin your path as an Astral Shaman',
      icon: Icons.explore,
      gradient: const LinearGradient(
        colors: [Color(0xFF9D4EDD), Color(0xFF5A189A)],
      ),
    ),
    MenuOption(
      title: 'Continue',
      subtitle: 'Resume your adventure',
      icon: Icons.play_arrow,
      gradient: const LinearGradient(
        colors: [Color(0xFF7B2CBF), Color(0xFF5A189A)],
      ),
    ),
    MenuOption(
      title: 'Multiplayer',
      subtitle: 'Battle & trade with other Shamans',
      icon: Icons.public,
      gradient: const LinearGradient(
        colors: [Color(0xFF240046), Color(0xFF3C096C)],
      ),
    ),
    MenuOption(
      title: 'Astral Dex',
      subtitle: 'View discovered Astrals',
      icon: Icons.book,
      gradient: const LinearGradient(
        colors: [Color(0xFF10002B), Color(0xFF240046)],
      ),
    ),
    MenuOption(
      title: 'Settings',
      subtitle: 'Configure your experience',
      icon: Icons.settings,
      gradient: const LinearGradient(
        colors: [Color(0xFF240046), Color(0xFF10002B)],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _menuController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeOutCubic,
    ));
    
    _menuController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _menuController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(
                      math.sin(_backgroundController.value * 2 * math.pi),
                      math.cos(_backgroundController.value * 2 * math.pi),
                    ),
                    end: Alignment(
                      -math.sin(_backgroundController.value * 2 * math.pi),
                      -math.cos(_backgroundController.value * 2 * math.pi),
                    ),
                    colors: const [
                      Color(0xFF0A0E27),
                      Color(0xFF240046),
                      Color(0xFF10002B),
                      Color(0xFF5A189A),
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              );
            },
          ),
          
          // Floating particles
          ...List.generate(15, (index) => _buildParticle(index)),
          
          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // Logo and title
                    _buildLogo(),
                    
                    const SizedBox(height: 60),
                    
                    // Menu options
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _menuOptions.length,
                        itemBuilder: (context, index) {
                          return _buildMenuItem(index);
                        },
                      ),
                    ),
                    
                    // Version info
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Version 1.0.0 • © 2025 Astralis',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Animated logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [
                Color(0xFFE0AAFF),
                Color(0xFFC77DFF),
                Color(0xFF9D4EDD),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9D4EDD).withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.star,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Title
        const Text(
          'ASTRALIS',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 6,
            shadows: [
              Shadow(
                color: Color(0xFF9D4EDD),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          'Monster Tamer RPG',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(int index) {
    final option = _menuOptions[index];
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _handleMenuSelection(index),
      onTapDown: (_) => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected ? option.gradient : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? Colors.white.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: option.gradient.colors.first.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: Icon(
                option.icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticle(int index) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final progress = (_particleController.value + index * 0.1) % 1.0;
        final yOffset = MediaQuery.of(context).size.height * (1 - progress);
        final xOffset = MediaQuery.of(context).size.width *
            (0.5 + 0.3 * math.sin(progress * 2 * math.pi + index));
        
        return Positioned(
          left: xOffset,
          top: yOffset,
          child: Container(
            width: 4 + (index % 3) * 2.0,
            height: 4 + (index % 3) * 2.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF9D4EDD).withOpacity(0.3 * progress),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9D4EDD).withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleMenuSelection(int index) {
    HapticFeedback.lightImpact();
    
    switch (index) {
      case 0: // New Journey
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const GameScreen(),
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
        break;
        
      case 1: // Continue
        // Load saved game
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GameScreen()),
        );
        break;
        
      case 2: // Multiplayer
        // Open multiplayer menu
        _showMultiplayerDialog();
        break;
        
      case 3: // Astral Dex
        // Open Astral Dex
        break;
        
      case 4: // Settings
        // Open settings
        break;
    }
  }

  void _showMultiplayerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF240046),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Multiplayer Mode',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMultiplayerOption('Local Co-op', Icons.people),
            _buildMultiplayerOption('Online Battle', Icons.flash_on),
            _buildMultiplayerOption('Trading Hub', Icons.swap_horiz),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiplayerOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9D4EDD)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        // Handle multiplayer option
      },
    );
  }
}

class MenuOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;

  MenuOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}