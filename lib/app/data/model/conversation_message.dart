class ConversationMessage {
  final String role;
  final String content;
  String? translation; // used on local only
  String? wordSaidByUser; // used on local only

  ConversationMessage(
      {required this.role,
      required this.content,
      this.translation,
      this.wordSaidByUser});

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    return ConversationMessage(
      role: json['role'],
      content: json['content'],
      translation: null,
      wordSaidByUser: null,
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
        'wordSaidByUser': wordSaidByUser,
      };

  @override
  String toString() => "Conversation(role: $role, content: $content, wordSaidByUser: $wordSaidByUser)";
}
