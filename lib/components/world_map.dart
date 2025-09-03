import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../models/npc.dart';
import '../models/astral.dart';
import '../systems/game_state.dart';
import '../data/temple_data.dart';
import 'npc_component.dart';
import 'astral_component.dart';

class WorldMap extends Component {
  late GameState _gameState;
  final List<NPC> npcs = [];
  final List<Astral> astrals = [];
  final List<InteractableObject> objects = [];
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _gameState = GameState();
    
    await _createWorld();
    await _populateWithNPCs();
    await _populateWithAstrals();
    await _createInteractables();
  }
  
  Future<void> _createWorld() async {
    // Create ground/terrain components
    final ground = RectangleComponent(
      position: Vector2.zero(),
      size: Vector2(2000, 2000),
      paint: Paint()..color = const Color(0xFF2D5016), // Forest green
    );
    await add(ground);
    
    // Create water areas
    final lake = RectangleComponent(
      position: Vector2(400, 300),
      size: Vector2(200, 150),
      paint: Paint()..color = const Color(0xFF1E40AF), // Blue water
    );
    await add(lake);
    
    // Create rocky areas
    final rocks = RectangleComponent(
      position: Vector2(800, 600),
      size: Vector2(150, 100),
      paint: Paint()..color = const Color(0xFF6B7280), // Gray rocks
    );
    await add(rocks);
    
    // Create temple area
    final temple = RectangleComponent(
      position: Vector2(1000, 200),
      size: Vector2(100, 80),
      paint: Paint()..color = const Color(0xFF7C2D12), // Brown temple
    );
    await add(temple);
  }
  
  Future<void> _populateWithNPCs() async {
    // Elder Kaelen - Grove Mentor/Guide
    final elderKaelen = NPC(
      id: 'elder_kaelen',
      name: 'Elder Kaelen',
      role: NPCRole.elder,
      description: 'Grove mentor and guide who understands The Cycle. His connection to Dream Astrals lets him glimpse possible futures.',
      position: Vector2(200, 200), // Grove region (left side)
      dialogueTrees: {
        'default': DialogueTree(
          greeting: 'The Hollow whispers louder each cycle… but you, child, carry a voice strong enough to answer.',
          options: [
            DialogueOption(
              text: 'What is the Hollow you speak of?',
              response: 'Long ago, Hollow Essence nearly consumed all life. It stirs again, drawn to the breaking of The Cycle. SYN forges Synthetics, binding Astral essence to machines.',
              consequences: {'setFlag': {'flag': 'knows_hollow_threat', 'value': true}},
            ),
            DialogueOption(
              text: 'Teach me about true bonding.',
              response: 'Relics awaken the connection between human and Astra. Show Care, let trust grow, and they will choose to Bond with you. Starlight remembers all genuine bonds.',
            ),
            DialogueOption(
              text: 'The dreams show me darkness...',
              response: 'Yes, I see it too. The synthetic faction harvests living essence, binding it to machines. Each corruption frays the dreamscape further. We must act.',
              consequences: {'changeState': 'urgent'},
            ),
          ],
        ),
        'urgent': DialogueTree(
          greeting: 'Time grows short. The dragons Seoryn, Seovyn, and Hollowyn must not fall to SYN corruption.',
          options: [
            DialogueOption(
              text: 'How do I stop them?',
              response: 'Seek the Mythic Relic, the Spark of Creation. Only it can forge bonds strong enough to heal the cycle. But first, prove yourself worthy.',
              consequences: {'setFlag': {'flag': 'mythic_quest_started', 'value': true}},
            ),
          ],
        ),
      },
    );
    npcs.add(elderKaelen);
    _gameState.npcs.add(elderKaelen);
    
    // Add visual NPC component
    final elderKaelenComponent = NPCComponent(npc: elderKaelen);
    await add(elderKaelenComponent);
    
    // Seraya - Rival Shaman
    final seraya = NPC(
      id: 'seraya',
      name: 'Seraya',
      role: NPCRole.rival,
      description: 'Young, ambitious shaman with a sharp wit. Wields a Tide Serpent Astral as her partner.',
      position: Vector2(300, 600),
      dialogueTrees: {
        'default': DialogueTree(
          greeting: "I'll beat you fair and square—then we'll save Astralis together.",
          options: [
            DialogueOption(
              text: 'Want to have a friendly battle?',
              response: 'Always! My Tide Serpent and I have been training non-stop. Let me show you what real bonding looks like!',
              consequences: {'setFlag': {'flag': 'seraya_battle_available', 'value': true}},
            ),
            DialogueOption(
              text: 'Have you encountered SYN forces?',
              response: 'Those synthetic monsters? They tried to corrupt my Serpent with their fake relics. We sent them running back to their metal caves.',
            ),
          ],
        ),
      },
    );
    npcs.add(seraya);
    _gameState.npcs.add(seraya);
    
    // Add visual NPC component
    final serayaComponent = NPCComponent(npc: seraya);
    await add(serayaComponent);
    
    // Torren Duskbane - Relic Keeper
    final torren = NPC(
      id: 'torren_duskbane',
      name: 'Torren Duskbane',
      role: NPCRole.scholar,
      description: 'Tall, grizzled figure with ink-stained hands and glowing rune tattoos that mark his bond with countless Astrals. Keeps his workshop in the ruins of an old temple.',
      position: Vector2(1100, 300),
      dialogueTrees: {
        'default': DialogueTree(
          greeting: 'A relic\'s bond is only as strong as the heart behind it.',
          options: [
            DialogueOption(
              text: 'Can you upgrade my relics?',
              response: 'Aye, but it requires rare materials. Bring me Astral Essence Crystals and I can strengthen your bonds.',
            ),
            DialogueOption(
              text: 'What do you know about Synthetic Relics?',
              response: 'Abominations! They twist the sacred bond into chains. I\'ve seen what they do to Astral essence - it\'s slavery, pure and simple.',
              consequences: {'setFlag': {'flag': 'knows_synthetic_corruption', 'value': true}},
            ),
          ],
        ),
      },
    );
    npcs.add(torren);
    _gameState.npcs.add(torren);
    
    // Add visual NPC component  
    final torrenComponent = NPCComponent(npc: torren);
    await add(torrenComponent);
    
    // Add Temple Stewards based on canonical data
    for (final temple in TempleData.getAllTemples()) {
      final steward = TempleData.createTempleSteward(temple);
      npcs.add(steward);
      _gameState.npcs.add(steward);
      
      // Add visual temple steward component
      final stewardComponent = NPCComponent(npc: steward);
      await add(stewardComponent);
      
      // Add temple structure
      final templeStructure = RectangleComponent(
        position: Vector2(temple.position.x - 10, temple.position.y - 10),
        size: Vector2(60, 50),
        paint: Paint()..color = temple.templeColor.withOpacity(0.7),
      );
      await add(templeStructure);
      
      // Add temple marker with philosophy
      final templeLabel = TextComponent(
        text: temple.name,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        position: Vector2(temple.position.x, temple.position.y - 25),
        anchor: Anchor.center,
      );
      await add(templeLabel);
    }
  }
  
  Future<void> _populateWithAstrals() async {
    // Tuki - Dream Astral (can evolve to Chronotoucan)
    final tuki = Astral(
      id: 'tuki',
      name: 'Tuki',
      type: AstralType.luminous, // Using existing enum
      personality: AstralPersonality.gentle,
      description: 'A small dream bird that phases between reality and dreams. Born from the dreams of sleeping children, carrying whispers of tomorrow.',
      position: Vector2(300, 500),
    );
    tuki.abilities = ['Dream Wisp', 'Phase Step', 'Peaceful Aura'];
    tuki.preferences = ['quiet_approach', 'meditation', 'starlight'];
    tuki.behaviors = ['phases_between_dimensions', 'glows_with_dream_energy', 'whispers_prophecies'];
    
    astrals.add(tuki);
    _gameState.discoveredAstrals.add(tuki);
    
    // Add visual Astral component
    final tukiComponent = AstralComponent(astral: tuki);
    await add(tukiComponent);
    
    // Cindcub - Ember Astral (Grove Eternal region)
    final cindcub = Astral(
      id: 'cindcub',
      name: 'Cindcub',
      type: AstralType.flame,
      personality: AstralPersonality.playful,
      description: 'A playful fire cub with ember-bright fur. Found near the Grove Eternal, bringing warmth to cold nights.',
      position: Vector2(150, 300),
    );
    cindcub.abilities = ['Ember Claw', 'Warm Hug', 'Spark Dash'];
    cindcub.preferences = ['playful_interaction', 'warm_places', 'friendly_approach'];
    cindcub.behaviors = ['bounces_with_joy', 'purrs_when_content', 'creates_warm_spots'];
    
    astrals.add(cindcub);
    _gameState.discoveredAstrals.add(cindcub);
    
    // Add visual Astral component
    final cindcubComponent = AstralComponent(astral: cindcub);
    await add(cindcubComponent);
    
    // Rylotl - Blood Astral (regeneration focus)
    final rylotl = Astral(
      id: 'rylotl',
      name: 'Rylotl',
      type: AstralType.water, // Using existing enum for blood-like
      personality: AstralPersonality.wise,
      description: 'A crimson axolotl that regenerates from any wound. Its blood carries the memories of all who came before.',
      position: Vector2(420, 330),
    );
    rylotl.abilities = ['Regenerate', 'Blood Bond', 'Life Drain', 'Memory Share'];
    rylotl.preferences = ['ancient_knowledge', 'respect', 'understanding'];
    rylotl.behaviors = ['regenerates_constantly', 'shares_memories', 'glows_crimson'];
    
    astrals.add(rylotl);
    _gameState.discoveredAstrals.add(rylotl);
    
    // Add visual Astral component
    final rylotlComponent = AstralComponent(astral: rylotl);
    await add(rylotlComponent);
    
    // SYN Phantom - Corrupted synthetic Astral
    final synPhantom = Astral(
      id: 'syn_phantom',
      name: 'SYN Phantom',
      type: AstralType.shadow,
      personality: AstralPersonality.mysterious,
      description: 'A corrupted Astral forced into synthetic form. Once a proud Grove Astral, now enslaved by SYN\'s synthetic relics.',
      position: Vector2(800, 700),
    );
    synPhantom.abilities = ['Data Corruption', 'System Override', 'Error Cascade'];
    synPhantom.preferences = []; // No natural preferences due to corruption
    synPhantom.behaviors = ['glitches_periodically', 'emits_static', 'struggles_against_control'];
    synPhantom.trustLevel = -50.0; // Starts corrupted
    
    astrals.add(synPhantom);
    _gameState.discoveredAstrals.add(synPhantom);
    
    // Add visual Astral component
    final synPhantomComponent = AstralComponent(astral: synPhantom);
    await add(synPhantomComponent);
  }
  
  Future<void> _createInteractables() async {
    // Sacred Grove Shrine
    final shrine = InteractableObject(
      id: 'sacred_shrine',
      name: 'Sacred Shrine',
      description: 'An ancient shrine that pulses with mystical energy.',
      position: Vector2(600, 200),
      size: Vector2(40, 40),
      onInteract: () => 'The shrine glows softly as you approach. You feel a deep connection to the Astrals.',
    );
    objects.add(shrine);
    
    // Mysterious Crystal Formation
    final crystalFormation = InteractableObject(
      id: 'crystal_formation',
      name: 'Crystal Formation',
      description: 'Strange crystals that seem to resonate with Astral energy.',
      position: Vector2(900, 700),
      size: Vector2(60, 30),
      onInteract: () => 'The crystals hum with power. They might be useful for bonding with Crystal-type Astrals.',
    );
    objects.add(crystalFormation);
  }
}

class InteractableObject extends RectangleComponent with CollisionCallbacks {
  final String id;
  final String name;
  final String description;
  final String Function() onInteract;
  
  InteractableObject({
    required this.id,
    required this.name,
    required this.description,
    required Vector2 position,
    required Vector2 size,
    required this.onInteract,
  }) : super(
    position: position,
    size: size,
    paint: Paint()..color = const Color(0xFFDDDDDD),
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
  
  String interact() {
    return onInteract();
  }
}