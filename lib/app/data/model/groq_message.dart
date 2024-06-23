class GroqMessage {
  final String role;
  final String content;
  String? translation; // used on local only

  GroqMessage(this.role, this.content, {this.translation});

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };

  factory GroqMessage.fromJson(Map<String, dynamic> json) {
    return GroqMessage(
       json['role'],
      json['content'],
      translation: null,
    );
  }

  @override
  String toString() => "Conversation(role: $role, content: $content)";

}
