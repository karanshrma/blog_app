import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:offline_first/core/error/failures.dart';
import 'package:offline_first/core/usecase/usecase.dart';
import 'package:offline_first/features/blog/domain/entities/blog.dart';
import 'package:offline_first/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:offline_first/features/blog/domain/usecases/upload_blog.dart';

part 'blog_event.dart';

part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
    : _getAllBlogs = getAllBlogs,
      _uploadBlog = uploadBlog,
      super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_fetchAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final response = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        topics: event.topics,
        image: event.image,
      ),
    );
    response.fold(
      (failure) {
        print('blog_bloc${failure.message}');
        emit(BlogFailure(failure.message));
      },
      (blog) {
        emit(BlogUploadSuccess());
      },
    );
  }

  void _fetchAllBlogs(BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    final response = await _getAllBlogs(NoParams());
    response.fold(
      (failure) {
        print('_fetchAllBlogs${failure.message}');
        emit(BlogFailure(failure.message));
      },
      (blogs) {
        print(blogs);
        emit(BlogDisplaySuccess(blogs));
      },
    );
  }
}
