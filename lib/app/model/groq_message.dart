class GroqMessage {
  final String role;
  final String content;

  GroqMessage(this.role, this.content);

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };
}
