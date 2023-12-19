import 'package:ts_academy/models/get_chapter_content.dart';
import 'package:ts_academy/models/select_course_comments.dart';

abstract class CourseContentStates {}

class CourseContentInitialState extends CourseContentStates {}

class GetChapterContentLoadingState extends CourseContentStates {}

class ChangeKeyboardValue extends CourseContentStates {}

class GetChapterContentSuccessState extends CourseContentStates {
  final ChapterContent chapterContent;
  GetChapterContentSuccessState(this.chapterContent);
}

class GetChapterContentErrorState extends CourseContentStates {
  final String err;
  GetChapterContentErrorState(this.err);
}

class ChangeCurrentContentIndex extends CourseContentStates {}

class ChangeSplitScreenState extends CourseContentStates {}

class GetCourseCommentsLoadingState extends CourseContentStates {}

class GetCourseCommentsSuccessState extends CourseContentStates {
  final CourseCommentsModel courseCommentsModel;
  GetCourseCommentsSuccessState(this.courseCommentsModel);
}

class GetCourseCommentsErrorState extends CourseContentStates {
  final String err;
  GetCourseCommentsErrorState(this.err);
}

class MakeCourseCommentLoadingState extends CourseContentStates {}

class MakeCourseCommentSuccessState extends CourseContentStates {
  final String msg;
  MakeCourseCommentSuccessState(this.msg);
}

class MakeCourseCommentErrorState extends CourseContentStates {
  final String err;
  MakeCourseCommentErrorState(this.err);
}
