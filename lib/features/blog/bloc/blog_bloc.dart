import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/blog_repository.dart';
import 'blog_event.dart';
import 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository _repository;

  BlogBloc({BlogRepository? repository})
    : _repository = repository ?? BlogRepository(),
      super(BlogInitial()) {
    on<FetchBlogsEvent>(_onFetchBlogs);
    on<AddBlogEvent>(_onAddBlog);
    on<UpdateBlogEvent>(_onUpdateBlog);
    on<DeleteBlogEvent>(_onDeleteBlog);
  }

  Future<void> _onFetchBlogs(
    FetchBlogsEvent event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());
    try {
      final blogs = await _repository.fetchBlogs();
      emit(BlogLoaded(blogs));
    } catch (e) {
      emit(BlogError(e.toString()));
    }
  }

  Future<void> _onAddBlog(AddBlogEvent event, Emitter<BlogState> emit) async {
    try {
      await _repository.addBlog(event.blog);
      add(FetchBlogsEvent());
    } catch (e) {
      emit(BlogError(e.toString()));
    }
  }

  Future<void> _onUpdateBlog(
    UpdateBlogEvent event,
    Emitter<BlogState> emit,
  ) async {
    try {
      await _repository.updateBlog(event.blog, oldImageUrl: event.oldImageUrl);
      add(FetchBlogsEvent());
    } catch (e) {
      emit(BlogError(e.toString()));
    }
  }

  Future<void> _onDeleteBlog(
    DeleteBlogEvent event,
    Emitter<BlogState> emit,
  ) async {
    try {
      await _repository.deleteBlog(event.id);
      add(FetchBlogsEvent());
    } catch (e) {
      emit(BlogError(e.toString()));
    }
  }
}
