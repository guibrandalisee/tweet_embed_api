import 'package:test/test.dart';
import 'package:tweet_embed_api/native_tweet_embed.dart';

void main() {
  group('A group of tests', () {
    final tweetEmbed = TweetEmbedAPI();
    late TweetData tweet;
    setUp(() async {
      tweet = await tweetEmbed.fetchTweet(id: 1803776897790140449);
    });

    test('First Test', () {
      expect(tweet.id, '1803776897790140449');
    });
  });
}
