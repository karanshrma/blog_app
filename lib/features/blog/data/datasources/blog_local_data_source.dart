import 'package:hive/hive.dart';
import 'package:offline_first/features/blog/data/models/blog_models.dart';


abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
  void clearBlogs();
  BlogModel? getBlogById(String id);
  void addBlog(BlogModel blog);
  void removeBlog(String id);
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  static const String _blogsKey = 'blogs';

  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModel> loadBlogs() {
    try {
      // Method 1: Using a single key to store all blogs as a list
      final List<dynamic>? blogsJson = box.get(_blogsKey);
      if (blogsJson == null || blogsJson.isEmpty) {
        return [];
      }

      return blogsJson
          .map((blogJson) => BlogModel.fromJson(Map<String, dynamic>.from(blogJson)))
          .toList();
    } catch (e) {
      print('Error loading blogs: $e');
      return [];
    }
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    try {
      // Clear existing blogs and store new ones
      final List<Map<String, dynamic>> blogsJson = blogs
          .map((blog) => blog.toJson())
          .toList();

      box.put(_blogsKey, blogsJson);
    } catch (e) {
      print('Error uploading blogs: $e');
    }
  }

  @override
  void clearBlogs() {
    try {
      box.delete(_blogsKey);
    } catch (e) {
      print('Error clearing blogs: $e');
    }
  }

  @override
  BlogModel? getBlogById(String id) {
    try {
      final blogs = loadBlogs();
      return blogs.where((blog) => blog.id == id).firstOrNull;
    } catch (e) {
      print('Error getting blog by id: $e');
      return null;
    }
  }

  @override
  void addBlog(BlogModel blog) {
    try {
      final blogs = loadBlogs();
      blogs.add(blog);
      uploadLocalBlogs(blogs: blogs);
    } catch (e) {
      print('Error adding blog: $e');
    }
  }

  @override
  void removeBlog(String id) {
    try {
      final blogs = loadBlogs();
      blogs.removeWhere((blog) => blog.id == id);
      uploadLocalBlogs(blogs: blogs);
    } catch (e) {
      print('Error removing blog: $e');
    }
  }
}