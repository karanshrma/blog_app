import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first/core/theme/app_pallete.dart';
import 'package:offline_first/core/utils/show_snackbar.dart';
import 'package:offline_first/features/auth/presentation/pages/login_page.dart';
import 'package:offline_first/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:offline_first/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:offline_first/features/blog/presentation/widgets/blog_card.dart';

import '../../../../core/common/widgets/Loader.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/blog_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          // Navigate to login safely after logout
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              LoginPage.route(),
              (route) => false,
            );
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blog App'),
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle_outline_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  AddNewBlogPage.route(),
                );
              },
            ),

            GestureDetector(
              onTap: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.logout),
              ),
            ),
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              print('BlogPage ${state.message}');
              showSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Loader();
            }
            if (state is BlogDisplaySuccess) {
              return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return GestureDetector(
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlogViewerPage(blog: blog),
                          ),
                        );
                      });
                    },
                    child: BlogCard(
                      blog: blog,
                      color: index % 3 == 0
                          ? AppPallete.gradient1
                          : index % 3 == 1
                          ? AppPallete.gradient2
                          : AppPallete.gradient3,
                    ),
                  );
                },
              );
            }
            return const Loader();
          },
        ),
      ),
    );
  }
}
