part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final List<String> topics;
  final File image;

  BlogUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.topics,
    required this.image,
  });
}

final class BlogFetchAllBlogs extends BlogEvent {}
