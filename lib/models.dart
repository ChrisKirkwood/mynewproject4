// If you have specific models for the API responses or requests, you can define them here.
// This could include classes to represent the structure of the data returned by Google Vision, OpenAI, etc.

class ImageAnnotation {
  final String text;

  ImageAnnotation({required this.text});

  factory ImageAnnotation.fromJson(Map<String, dynamic> json) {
    return ImageAnnotation(
      text: json['fullTextAnnotation']['text'] as String,
    );
  }
}

class VideoAnnotation {
  final String text;

  VideoAnnotation({required this.text});

  factory VideoAnnotation.fromJson(Map<String, dynamic> json) {
    return VideoAnnotation(
      text: json['textAnnotations'][0]['text'] as String,
    );
  }
}
