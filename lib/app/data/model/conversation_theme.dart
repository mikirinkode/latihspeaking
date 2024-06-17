class ConversationTheme {
  final String emoji;
  final String theme;

  ConversationTheme({required this.emoji, required this.theme});

  factory ConversationTheme.fromJson(Map<String, dynamic> json) {
    return ConversationTheme(
      emoji: json['emoji'],
      theme: json['theme'],
    );
  }
}