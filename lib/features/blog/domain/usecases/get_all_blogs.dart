
import 'package:fpdart/fpdart.dart';
import 'package:offline_first/core/error/failures.dart';
import 'package:offline_first/core/usecase/usecase.dart';
import 'package:offline_first/features/blog/domain/repositories/blog_repository.dart';
import '../entities/blog.dart';

class GetAllBlogs implements UseCase<List<Blog>,NoParams>{
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async{
    return await blogRepository.getAllBlogs();

  }
  
}