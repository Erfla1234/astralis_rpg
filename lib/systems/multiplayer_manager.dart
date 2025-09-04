import 'dart:async';
import 'dart:convert';
import 'package:flame/components.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:uuid/uuid.dart';
import '../models/player_character.dart';
import '../models/astral.dart';

enum MultiplayerMode {
  offline,
  localCoop,
  onlineLobby,
  onlineBattle,
  onlineTrade
}

class MultiplayerPlayer {
  final String id;
  final String name;
  Vector2 position;
  List<Astral> team;
  bool isReady;
  int ping;
  
  MultiplayerPlayer({
    required this.id,
    required this.name,
    required this.position,
    this.team = const [],
    this.isReady = false,
    this.ping = 0,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'position': {'x': position.x, 'y': position.y},
    'team': team.map((a) => a.id).toList(),
    'isReady': isReady,
    'ping': ping,
  };
  
  factory MultiplayerPlayer.fromJson(Map<String, dynamic> json) {
    return MultiplayerPlayer(
      id: json['id'] as String,
      name: json['name'] as String,
      position: Vector2(
        (json['position']['x'] as num).toDouble(),
        (json['position']['y'] as num).toDouble(),
      ),
      isReady: json['isReady'] as bool? ?? false,
      ping: json['ping'] as int? ?? 0,
    );
  }
}

class MultiplayerManager {
  static final MultiplayerManager _instance = MultiplayerManager._internal();
  factory MultiplayerManager() => _instance;
  MultiplayerManager._internal();
  
  final _uuid = const Uuid();
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  
  MultiplayerMode currentMode = MultiplayerMode.offline;
  String? sessionId;
  String playerId = '';
  final Map<String, MultiplayerPlayer> connectedPlayers = {};
  final StreamController<MultiplayerEvent> _eventController = StreamController.broadcast();
  
  Stream<MultiplayerEvent> get events => _eventController.stream;
  
  // Initialize multiplayer session
  Future<bool> initializeSession({
    required MultiplayerMode mode,
    String? serverUrl,
    String? roomCode,
  }) async {
    currentMode = mode;
    playerId = _uuid.v4();
    
    switch (mode) {
      case MultiplayerMode.offline:
        return true;
        
      case MultiplayerMode.localCoop:
        return _startLocalCoop();
        
      case MultiplayerMode.onlineLobby:
      case MultiplayerMode.onlineBattle:
      case MultiplayerMode.onlineTrade:
        return await _connectToServer(serverUrl ?? 'ws://localhost:8080', roomCode);
    }
  }
  
  bool _startLocalCoop() {
    // Local co-op uses split screen or shared screen
    sessionId = 'local_${_uuid.v4()}';
    _eventController.add(MultiplayerEvent(
      type: EventType.sessionStarted,
      data: {'sessionId': sessionId, 'mode': 'localCoop'},
    ));
    return true;
  }
  
  Future<bool> _connectToServer(String serverUrl, String? roomCode) async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(serverUrl));
      
      // Send join request
      sendMessage({
        'type': 'join',
        'playerId': playerId,
        'roomCode': roomCode ?? 'global',
        'mode': currentMode.name,
      });
      
      // Listen for messages
      _subscription = _channel!.stream.listen(
        _handleServerMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );
      
      return true;
    } catch (e) {
      print('Failed to connect to multiplayer server: $e');
      return false;
    }
  }
  
  void _handleServerMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String;
      
      switch (type) {
        case 'connected':
          sessionId = data['sessionId'] as String?;
          _eventController.add(MultiplayerEvent(
            type: EventType.connected,
            data: data,
          ));
          break;
          
        case 'playerJoined':
          final player = MultiplayerPlayer.fromJson(data['player'] as Map<String, dynamic>);
          connectedPlayers[player.id] = player;
          _eventController.add(MultiplayerEvent(
            type: EventType.playerJoined,
            data: {'player': player},
          ));
          break;
          
        case 'playerLeft':
          final playerId = data['playerId'] as String;
          connectedPlayers.remove(playerId);
          _eventController.add(MultiplayerEvent(
            type: EventType.playerLeft,
            data: {'playerId': playerId},
          ));
          break;
          
        case 'playerUpdate':
          final playerId = data['playerId'] as String;
          final position = data['position'] as Map<String, dynamic>;
          if (connectedPlayers.containsKey(playerId)) {
            connectedPlayers[playerId]!.position = Vector2(
              (position['x'] as num).toDouble(),
              (position['y'] as num).toDouble(),
            );
          }
          _eventController.add(MultiplayerEvent(
            type: EventType.playerUpdate,
            data: data,
          ));
          break;
          
        case 'battleRequest':
          _eventController.add(MultiplayerEvent(
            type: EventType.battleRequest,
            data: data,
          ));
          break;
          
        case 'tradeRequest':
          _eventController.add(MultiplayerEvent(
            type: EventType.tradeRequest,
            data: data,
          ));
          break;
          
        case 'astralSync':
          _eventController.add(MultiplayerEvent(
            type: EventType.astralSync,
            data: data,
          ));
          break;
      }
    } catch (e) {
      print('Error parsing server message: $e');
    }
  }
  
  void _handleError(error) {
    print('WebSocket error: $error');
    _eventController.add(MultiplayerEvent(
      type: EventType.error,
      data: {'error': error.toString()},
    ));
  }
  
  void _handleDisconnect() {
    print('Disconnected from server');
    _eventController.add(MultiplayerEvent(
      type: EventType.disconnected,
      data: {},
    ));
    cleanup();
  }
  
  // Send messages to server
  void sendMessage(Map<String, dynamic> message) {
    if (_channel == null) return;
    
    message['timestamp'] = DateTime.now().millisecondsSinceEpoch;
    _channel!.sink.add(jsonEncode(message));
  }
  
  // Send player position update
  void updatePlayerPosition(Vector2 position) {
    if (currentMode == MultiplayerMode.offline) return;
    
    sendMessage({
      'type': 'playerUpdate',
      'playerId': playerId,
      'position': {'x': position.x, 'y': position.y},
    });
  }
  
  // Send battle request
  void requestBattle(String targetPlayerId, List<Astral> team) {
    sendMessage({
      'type': 'battleRequest',
      'from': playerId,
      'to': targetPlayerId,
      'team': team.map((a) => a.toJson()).toList(),
    });
  }
  
  // Send trade request
  void requestTrade(String targetPlayerId, List<String> offeredAstrals) {
    sendMessage({
      'type': 'tradeRequest',
      'from': playerId,
      'to': targetPlayerId,
      'offered': offeredAstrals,
    });
  }
  
  // Accept or decline battle
  void respondToBattle(String requestId, bool accept) {
    sendMessage({
      'type': 'battleResponse',
      'requestId': requestId,
      'accept': accept,
      'playerId': playerId,
    });
  }
  
  // Accept or decline trade
  void respondToTrade(String requestId, bool accept, List<String>? counterOffer) {
    sendMessage({
      'type': 'tradeResponse',
      'requestId': requestId,
      'accept': accept,
      'counterOffer': counterOffer,
      'playerId': playerId,
    });
  }
  
  // Sync Astral state
  void syncAstralState(Astral astral, String action) {
    sendMessage({
      'type': 'astralSync',
      'playerId': playerId,
      'astralId': astral.id,
      'action': action, // 'bond', 'release', 'evolve', 'heal'
      'astralData': {
        'trustLevel': astral.trustLevel,
        'isBonded': astral.isBonded,
      },
    });
  }
  
  // Create or join room
  Future<String?> createRoom() async {
    final roomCode = _uuid.v4().substring(0, 6).toUpperCase();
    sendMessage({
      'type': 'createRoom',
      'playerId': playerId,
      'roomCode': roomCode,
    });
    return roomCode;
  }
  
  Future<bool> joinRoom(String roomCode) async {
    sendMessage({
      'type': 'joinRoom',
      'playerId': playerId,
      'roomCode': roomCode,
    });
    return true;
  }
  
  // Leave current session
  void leaveSession() {
    if (_channel != null) {
      sendMessage({
        'type': 'leave',
        'playerId': playerId,
      });
    }
    cleanup();
  }
  
  // Cleanup resources
  void cleanup() {
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
    connectedPlayers.clear();
    currentMode = MultiplayerMode.offline;
  }
  
  // Check if connected
  bool get isConnected => _channel != null && currentMode != MultiplayerMode.offline;
  
  // Get player count
  int get playerCount => connectedPlayers.length + 1; // +1 for local player
}

// Event types for multiplayer
enum EventType {
  connected,
  disconnected,
  sessionStarted,
  playerJoined,
  playerLeft,
  playerUpdate,
  battleRequest,
  battleStarted,
  battleEnded,
  tradeRequest,
  tradeCompleted,
  astralSync,
  error
}

class MultiplayerEvent {
  final EventType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  
  MultiplayerEvent({
    required this.type,
    required this.data,
  }) : timestamp = DateTime.now();
}

// Multiplayer UI components
class MultiplayerIndicator extends TextComponent {
  MultiplayerIndicator() : super(
    text: '',
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
    position: Vector2(10, 10),
  );
  
  void updateStatus(MultiplayerMode mode, int playerCount) {
    switch (mode) {
      case MultiplayerMode.offline:
        text = 'Offline';
        break;
      case MultiplayerMode.localCoop:
        text = 'Local Co-op ($playerCount players)';
        break;
      case MultiplayerMode.onlineLobby:
        text = 'Online Lobby ($playerCount players)';
        break;
      case MultiplayerMode.onlineBattle:
        text = 'Battle Mode ($playerCount players)';
        break;
      case MultiplayerMode.onlineTrade:
        text = 'Trading Hub ($playerCount players)';
        break;
    }
  }
}