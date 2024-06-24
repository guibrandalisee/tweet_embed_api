import 'package:tweet_embed_api/native_tweet_embed.dart';

void main() async {
  TweetData tweet = await TweetEmbedAPI().fetchTweet(id: 1803776897790140449);
  print(tweet.text);
}
