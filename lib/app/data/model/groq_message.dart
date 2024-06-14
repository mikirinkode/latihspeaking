class GroqMessage {
  final String role;
  final String content;
  String? translation; // used on local only

  GroqMessage(this.role, this.content, {this.translation});

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };
}
