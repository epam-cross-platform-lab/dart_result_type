import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:result_type/result_type.dart';

void main() async {
  final client = http.Client();

  final result = await getPhotos(client);
  if (result.isFailure) {
    print('Error: ${result.failure}');
  } else {
    print('Photos: ${result.success}');
  }

  await getPhotos(client)
    ..result((error) {
      print('Error: $error');
    }, (photos) {
      print('Photos: $photos');
    });
}

class Photo {
  final int id;
  final String title;
  final String thumbnailUrl;

  const Photo({this.id, this.title, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, Object> json) {
    return Photo(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }

  @override
  String toString() =>
      'Photo(id: $id, title: $title, thumbnailUrl: $thumbnailUrl)';
}

extension PhotoExtension on Photo {
  static List<Photo> parsePhotos(String responseBody) {
    final jsonObject = jsonDecode(responseBody) as Iterable;
    return jsonObject
        .map<Photo>((json) => Photo.fromJson((json as Map<String, Object>)))
        .toList();
  }
}

class NetworkError implements Exception {
  final int code;
  final String description;

  const NetworkError({this.code, this.description});

  @override
  String toString() => 'NetworkError(code: $code, description: $description)';

  static const notFound = NetworkError(code: 404, description: 'Not Found');
}

Future<Result<List<Photo>, NetworkError>> getPhotos(http.Client client) async {
  const path = 'https://jsonplaceholder.typicode.com/photos';
  try {
    final jsonString = await client.get(path);
    return Success(PhotoExtension.parsePhotos(jsonString.body));
  } catch (error) {
    return Failure(NetworkError.notFound);
  }
}
