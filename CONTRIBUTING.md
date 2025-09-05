# 🤝 Contributing to Astralis RPG

Thank you for your interest in contributing to Astralis RPG! We're excited to work with the community to build the future of monster taming games.

## 🎯 **Ways to Contribute**

### 🐛 **Bug Reports**
Found a bug? Help us squash it!
- Check [existing issues](https://github.com/yourusername/astralis-rpg/issues) first
- Use our [bug report template](.github/ISSUE_TEMPLATE/bug_report.md)
- Include screenshots/videos when possible
- Provide device/platform information

### ✨ **Feature Requests**
Have an amazing idea for Astralis?
- Check the [roadmap](README.md#roadmap) and existing requests
- Use our [feature request template](.github/ISSUE_TEMPLATE/feature_request.md)
- Explain the use case and benefit to players
- Consider how it fits with the trust-based theme

### 💻 **Code Contributions**
Ready to dive into development?
- Fork the repository
- Create a feature branch: `git checkout -b feature/amazing-feature`
- Follow our [coding standards](#coding-standards)
- Write tests for new functionality
- Submit a pull request with clear description

### 🎨 **Asset Contributions**
Help make Astralis more beautiful!
- **Audio**: Music, sound effects, ambient sounds
- **Art**: Astral sprites, UI elements, environmental art
- **Maps**: New regions using Tiled Map Editor
- **Translations**: Localization for different languages

## 🏗️ **Development Setup**

### **Prerequisites**
```bash
# Install Flutter SDK (3.24.0+)
flutter --version

# Install Dart SDK (included with Flutter)
dart --version

# Clone the repository
git clone https://github.com/yourusername/astralis-rpg.git
cd astralis-rpg
```

### **Setup**
```bash
# Get dependencies
flutter pub get

# Run code generation (if needed)
flutter packages pub run build_runner build

# Run the game in development
flutter run -d macos  # or android, ios, web
```

### **Testing**
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Build for production
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## 📝 **Coding Standards**

### **Dart Style Guide**
We follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) with these additions:

#### **File Organization**
```dart
// 1. Imports (Flutter first, then external packages, then internal)
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../models/astral.dart';

// 2. Class declaration with clear documentation
/// Represents a wild Astral that can be encountered in the game world.
/// 
/// Wild Astrals have trust levels that increase through positive interactions
/// and can eventually form bonds with the player.
class WildAstral extends Component {
  // 3. Constants and static members first
  static const double baseInteractionRange = 50.0;
  
  // 4. Public fields
  final String species;
  final int level;
  
  // 5. Private fields
  double _trustLevel = 0.0;
  
  // 6. Constructor
  WildAstral({
    required this.species,
    required this.level,
  });
  
  // 7. Public methods
  bool canBond() => _trustLevel >= 80.0;
  
  // 8. Private methods
  void _increaseTrust(double amount) {
    _trustLevel = (_trustLevel + amount).clamp(0.0, 100.0);
  }
}
```

#### **Naming Conventions**
- **Classes**: `PascalCase` - `WildAstral`, `NPCComponent`
- **Variables/Methods**: `camelCase` - `trustLevel`, `increaseTrust()`
- **Constants**: `camelCase` - `maxTrustLevel`, `interactionRange`
- **Files**: `snake_case` - `wild_astral.dart`, `npc_component.dart`

#### **Documentation**
```dart
/// Creates a new bonding effect at the specified position.
/// 
/// The [position] determines where the effect appears in world space.
/// The [intensity] controls the number and brightness of particles (0.0-1.0).
/// 
/// Returns true if the effect was successfully created.
bool createBondingEffect(Vector2 position, {double intensity = 1.0}) {
  // Implementation
}
```

### **Flutter/Flame Specific**

#### **Component Structure**
```dart
class MyGameComponent extends Component {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Initialize component here
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    // Update logic here
  }
  
  @override
  void onRemove() {
    // Cleanup resources
    super.onRemove();
  }
}
```

#### **Asset Management**
```dart
// Preload assets in component onLoad()
@override
Future<void> onLoad() async {
  sprite = await Sprite.load('astral/tuki.png');
  bgm = await AudioPool.create('music/grove_theme.mp3', maxPlayers: 1);
}
```

## 🎮 **Game Design Guidelines**

### **Trust-Based Philosophy**
All new features should support the core trust-based bonding system:
- ❌ **Avoid**: Forced capture, cage mechanics, dominance themes
- ✅ **Embrace**: Choice, mutual respect, gradual relationship building
- ✅ **Consider**: How does this feature build or express trust?

### **Accessibility**
- Support both touch and keyboard controls
- Include visual feedback for audio cues
- Consider colorblind-friendly palettes
- Provide difficulty options where appropriate

### **Performance**
- Target 60fps on mobile devices
- Minimize memory allocations in update loops
- Use object pooling for frequently created/destroyed objects
- Profile performance regularly

## 🔍 **Pull Request Process**

### **Before Submitting**
1. ✅ Code follows our style guide
2. ✅ All tests pass (`flutter test`)
3. ✅ No new lint warnings (`flutter analyze`)
4. ✅ Performance tested on target platforms
5. ✅ Documentation updated (if needed)

### **PR Description Template**
```markdown
## Description
Brief description of the changes and motivation.

## Type of Change
- [ ] 🐛 Bug fix
- [ ] ✨ New feature  
- [ ] 💥 Breaking change
- [ ] 📚 Documentation update
- [ ] 🎨 Asset update

## Testing
- [ ] Unit tests added/updated
- [ ] Manual testing completed
- [ ] Performance impact assessed

## Screenshots/Videos
Include visual evidence of changes (if applicable)

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex areas
- [ ] Documentation updated
```

## 🐛 **Bug Report Guidelines**

### **Good Bug Report**
```markdown
**Description**: Astral trust level doesn't save between sessions

**Steps to Reproduce**:
1. Interact with a Tuki until trust level reaches 50%
2. Close the game completely
3. Restart the game
4. Check the same Tuki's trust level

**Expected**: Trust level should remain at 50%
**Actual**: Trust level reset to 0%

**Environment**:
- Device: iPhone 14 Pro
- OS: iOS 17.2
- App Version: 0.1.0

**Additional Info**: Happens with all Astral species, not just Tuki
```

## 🌟 **Recognition**

### **Contributor Rewards**
- 🏆 **Contributors Wall** - Your name in the game credits
- 🎮 **Beta Access** - Early access to new features
- 🎨 **Custom Astral** - Design your own Astral species
- 💫 **Special Badge** - Unique in-game contributor badge

### **Major Contributors**
Significant contributions may earn:
- 🥇 **Core Team Invitation** - Join the core development team
- 📱 **App Store Credits** - Listed as co-developer
- 💰 **Revenue Share** - Percentage of game profits

## 📞 **Getting Help**

### **Community Channels**
- 💬 **Discord**: [Join our server](https://discord.gg/astralis) for real-time chat
- 🐛 **GitHub Issues**: For bugs and feature requests
- 📧 **Email**: dev@astralis-rpg.com for sensitive issues

### **Code Review**
- All pull requests require review from at least one core team member
- Complex changes may need additional domain expert review
- We provide constructive feedback to help improve contributions

## 🎯 **Current Priority Areas**

Looking for ways to contribute? These areas need attention:

### **High Priority**
- 🎵 **Audio System**: More music tracks and sound effects
- 📱 **Mobile Optimization**: Touch control improvements
- 🌐 **Localization**: Translation support for multiple languages
- 🧪 **Testing**: Automated testing coverage improvement

### **Medium Priority**
- 🎨 **Visual Polish**: More detailed sprites and animations
- 🗺️ **Map Content**: Additional regions and areas
- 💾 **Save System**: Cloud save and cross-device sync
- 🏆 **Achievement System**: Player progression tracking

### **Future Goals**
- 🌐 **Multiplayer**: Real-time co-op exploration
- 🛠️ **Mod Support**: Community content creation tools
- 🎮 **Controller Support**: Gamepad integration
- 📊 **Analytics**: Player behavior insights

---

**Thank you for helping make Astralis RPG the future of monster taming! Every contribution, no matter how small, makes a difference.** 🌟

*"In Astralis, we build trust not just with creatures, but with each other."*