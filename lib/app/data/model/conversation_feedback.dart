class ConversationFeedback {
  final CriteriaFeedback? accuracy;
  final CriteriaFeedback? fluency;
  final CriteriaFeedback? pronunciation;
  final CriteriaFeedback? overall;
  final String? feedbackAndSuggestion;

  ConversationFeedback(
      {required this.accuracy,
      required this.fluency,
      required this.pronunciation,
      required this.overall,
      required this.feedbackAndSuggestion});

  factory ConversationFeedback.fromJson(Map<String, dynamic> json) {
    return ConversationFeedback(
      accuracy: CriteriaFeedback.fromJson(json['accuracy']),
      fluency: CriteriaFeedback.fromJson(json['fluency']),
      pronunciation: CriteriaFeedback.fromJson(json['pronunciation']),
      overall: CriteriaFeedback.fromJson(json['overall']),
      feedbackAndSuggestion: json['feedbackAndSuggestion'],
    );
  }
}

class CriteriaFeedback {
  final int? score;
  final String? shortFeedback;

  CriteriaFeedback({
    required this.score,
    required this.shortFeedback,
  });

  factory CriteriaFeedback.fromJson(Map<String, dynamic> json) {
    return CriteriaFeedback(
        score: json['score'], shortFeedback: json['shortFeedback']);
  }
}
