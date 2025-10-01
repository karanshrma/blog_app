import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:offline_first/core/error/exceptions.dart';
import 'package:offline_first/core/error/failures.dart';
import 'package:offline_first/core/network/network_checker.dart';
import 'package:offline_first/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:offline_first/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:offline_first/features/blog/data/models/blog_models.dart';
import 'package:offline_first/features/blog/domain/entities/blog.dart';
import 'package:offline_first/features/blog/domain/repositories/blog_repository.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(this.blogRemoteDataSource, this.blogLocalDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    if(! await(connectionChecker.isConnected)){
      return left(Failure('No internet connection'));
    }
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        blog: blogModel,
        image: image,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      print('BlogRepositoryImpl${e.message}');
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    if(! await(connectionChecker.isConnected)){
      final blogs = blogLocalDataSource.loadBlogs();
      return right(blogs);
    }
    try{

      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e){
      print('BlogRepositoryImpl${e.message}');
      return left(Failure(e.toString()));
    }

  }
}
