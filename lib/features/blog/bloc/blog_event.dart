import '../data/models/blog_model.dart';

abstract class BlogEvent {}

class FetchBlogsEvent extends BlogEvent {}

class AddBlogEvent extends BlogEvent {
  final BlogModel blog;
  AddBlogEvent(this.blog);
}

class UpdateBlogEvent extends BlogEvent {
  final BlogModel blog;
  final String? oldImageUrl;
  
  UpdateBlogEvent(this.blog, {this.oldImageUrl});}

class DeleteBlogEvent extends BlogEvent {
  final String id;
  DeleteBlogEvent(this.id);
}