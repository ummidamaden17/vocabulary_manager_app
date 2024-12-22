class Word {
  final String word;
  final String transcription;
  final String definition;

  Word(
      {required this.word,
      required this.transcription,
      required this.definition});

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['word'],
      transcription: map['transcription'],
      definition: map['definition'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'transcription': transcription,
      'definition': definition,
    };
  }
}
