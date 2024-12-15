// class Word {
//   final String word;
//   final String definition;
//   final String category;
//   final String transcription; // Add the image URL or asset path
//
//   Word(
//       {required this.word,
//       required this.definition,
//       required this.category,
//       required this.transcription // Include the image in the constructor
//       });
//
//   // Factory method to create a Word from a map (e.g., from JSON)
//   factory Word.fromMap(Map<String, dynamic> map) {
//     return Word(
//       word: map['word'] ?? '', // If 'word' is null, default to an empty string
//       definition: map['definition'] ??
//           '', // If 'definition' is null, default to an empty string
//       category: map['category'] ??
//           '', // If 'category' is null, default to an empty string
//       transcription: map['transcription'] ??
//           '', // If 'image' is null, default to an empty string or an empty asset path
//     );
//   }
// }


class Word {
  String word;
  String definition;
  String transcription;

  Word({
    required this.word,
    required this.definition,
    required this.transcription,
  });

  // Convert Word object to Map
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'definition': definition,
      'transcription': transcription,
    };
  }

  // Create a Word object from a Map (used for decoding)
  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['word'],
      definition: map['definition'],
      transcription: map['transcription'],
    );
  }
}
