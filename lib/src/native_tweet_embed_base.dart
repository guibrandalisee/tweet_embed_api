import 'dart:convert';

import 'package:http/http.dart' as http;

class TweetEmbedAPI {
  Future<TweetData> fetchTweet({required int id}) async {
    //URL an official twitter API that for some reason is public
    Uri url = Uri.https('cdn.syndication.twimg.com', 'tweet-result', {
      'id': id.toString(),
      'lang': 'en',
      'token':
          '1', //Have no idea why, but this cannot be blank and also does nothing if you change it to any other value
    });

    //Makes the HTTP resquest
    final response = await http.get(url);

    //"renames" the variable for a more readable code
    final e = jsonDecode(response.body);

    //Parses the JSON response into a Dart Object
    return TweetData(
      rawResponse: response.body,
      language: e['lang'],
      favoriteCount: e['favorite_count'],
      possiblySensitive: e['possibly_sensitive'],
      createdAt: DateTime.parse(e['created_at']),
      displayTextRange: e['display_text_range'].cast<int>(),
      media: e['entities']['media'].map<TweetMedia>(
        (f) {
          Map<String, dynamic>? aux;
          if (e['mediaDetails'] != null) {
            //Find the details of the current media
            aux = e['mediaDetails'].firstWhere(
              (g) => g['expanded_url'] == f['expanded_url'],
              orElse: () => null,
            );
          }

          return TweetMedia(
              displayUrl: f['display_url'],
              expandedUrl: f['expanded_url'],
              indices: f['indices'].cast<int>(),
              url: f['url'],
              originalHeight: aux == null ? null : aux['height'],
              originalWidth: aux == null ? null : aux['width'],
              mediaUrlHttps: aux == null ? null : aux['media_url_https']);
        },
      ).toList(),
      id: e['id_str'],
      text: e['text'],
      user: TweetUser(
        id: e['user']['id_str'],
        name: e['user']['name'],
        photoUrl: e['user']['profile_image_url_https'],
        screenName: e['user']['screen_name'],
        verified: e['user']['verified'],
        isBlueVerified: e['user']['is_blue_verified'],
        profileImageShape: e['user']['profile_image_shape'],
      ),
    );
  }
}

class TweetData {
  final String rawResponse;
  final String language;
  final int favoriteCount;
  final bool possiblySensitive;
  final DateTime createdAt;
  final List<int> displayTextRange;
  final List<TweetMedia> media;
  final String id;
  final String text;
  final TweetUser user;
  TweetData({
    required this.rawResponse,
    required this.language,
    required this.favoriteCount,
    required this.possiblySensitive,
    required this.createdAt,
    required this.displayTextRange,
    required this.media,
    required this.id,
    required this.text,
    required this.user,
  });
}

class TweetMedia {
  final String displayUrl;
  final String expandedUrl;
  final List<int> indices;
  final String url;
  final int? originalHeight;
  final int? originalWidth;
  final String? mediaUrlHttps;
  TweetMedia({
    required this.displayUrl,
    required this.expandedUrl,
    required this.indices,
    required this.url,
    required this.originalHeight,
    required this.originalWidth,
    required this.mediaUrlHttps,
  });
}

class TweetUser {
  final String id;
  final String name;
  final String photoUrl;
  final String screenName;
  final bool verified;
  final bool isBlueVerified;
  final String? profileImageShape;
  TweetUser({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.screenName,
    required this.verified,
    required this.isBlueVerified,
    required this.profileImageShape,
  });
}
