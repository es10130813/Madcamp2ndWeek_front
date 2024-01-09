class Room {
  final String roomName;
  final String roomCode;
  final List<String> playerIDs;
  final List<String> playerNames;
  final int numOfPlayer;

  Room({
    required this.roomName,
    required this.roomCode,
    required this.playerIDs,
    required this.playerNames,
    required this.numOfPlayer,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomName: json['roomName']?.toString() ?? 'Unknown',
      roomCode: json['roomCode']?.toString() ?? 'Unknown',
      playerIDs: List<String>.from(json['playerIDs'] ?? []),
      playerNames: List<String>.from(json['playerNames'] ?? []),
      numOfPlayer: json['numOfPlayer'] ?? 0,
    );
  }
  factory Room.empty() {
    return Room(
      roomName: 'Unknown',
      roomCode: 'Unknown',
      playerIDs: [],
      playerNames: [],
      numOfPlayer: 0,
    );
  }
}