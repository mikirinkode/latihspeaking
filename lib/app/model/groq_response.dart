class GroqResponse {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<Choice> choices;
  final Usage usage;
  final String systemFingerprint;
  final Groq xGroq;

  GroqResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
    required this.systemFingerprint,
    required this.xGroq,
  });

  factory GroqResponse.fromJson(Map<String, dynamic> json) {
    return GroqResponse(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      choices: (json['choices'] as List).map((i) => Choice.fromJson(i)).toList(),
      usage: Usage.fromJson(json['usage']),
      systemFingerprint: json['system_fingerprint'],
      xGroq: Groq.fromJson(json['x_groq']),
    );
  }
}

class Choice {
  final int index;
  final Message message;
  final String finishReason;

  Choice({
    required this.index,
    required this.message,
    required this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      index: json['index'],
      message: Message.fromJson(json['message']),
      finishReason: json['finish_reason'],
    );
  }
}

class Message {
  final String role;
  final String content;

  Message({
    required this.role,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
    );
  }
}

class Usage {
  final int promptTokens;
  final double promptTime;
  final int completionTokens;
  final double completionTime;
  final int totalTokens;
  final double totalTime;

  Usage({
    required this.promptTokens,
    required this.promptTime,
    required this.completionTokens,
    required this.completionTime,
    required this.totalTokens,
    required this.totalTime,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'],
      promptTime: json['prompt_time'],
      completionTokens: json['completion_tokens'],
      completionTime: json['completion_time'],
      totalTokens: json['total_tokens'],
      totalTime: json['total_time'],
    );
  }
}

class Groq {
  final String id;

  Groq({
    required this.id,
  });

  factory Groq.fromJson(Map<String, dynamic> json) {
    return Groq(
      id: json['id'],
    );
  }
}
