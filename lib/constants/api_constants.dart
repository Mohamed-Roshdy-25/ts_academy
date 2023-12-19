class ApiConstants {
  static const String baseUrl = "https://centerts.net/ts/";
  static const String rtcToken = "https://fciteams.onrender.com/agora_rtc/";
  static const String phoneEndpoint =
      "${baseUrl}user/auth/check_user_phone.php";
  static const String registerEndpoint = "${baseUrl}user/auth/sign_up.php";
  static const String userPermissionEndpoint =
      "${baseUrl}admin/select_permission.php";
  static const String onBoarding =
      "https://centerts.net/ts/user/select_on_boarding.php";
  static const String universityEndpoint =
      "${baseUrl}user/auth/select_all_university.php";
  static const String addCardEndpoint = "${baseUrl}user/check_card_code.php";
  static const String deleteQuizEndPoint = "${baseUrl}user/delete_quiz.php";
  static const String quizzesEndpoint =
      "${baseUrl}user/quizzes_about_course.php";
  static const String videoCourseEndpoint =
      "${baseUrl}user/select_video_by_chapter_id.php";
  static const String courseChaptersEndpoint =
      "${baseUrl}user/select_course_chapters.php";
  static const String studentCoursesEndpoint =
      "${baseUrl}user/select_courses_v2.php";
  static const String getImagePath = "${baseUrl}admin/item_img_uploader.php";
  static const String getLiveComments = "${baseUrl}user/select_live_comment.php";
  static const String getLiveSessionInfo = "${baseUrl}user/Select_live_session.php";
  static const String selectUserInfo = "${baseUrl}user/select_user_info_v2.php";
  static const String insertPost = "${baseUrl}admin/posts/insert_post.php";
  static const String sectionsForQuizzes =
      "${baseUrl}user/select_sections_from_quizzes.php";
  static const String questionAndAnswerEnpPointForSection =
      "${baseUrl}user/select_section_question.php";
  static const String getCommentsEndPoint =
      "${baseUrl}user/select_comment_by_course_id.php";
  static const String postCommentsEndPoint =
      "${baseUrl}user/insert_comment_course.php";
  static const String addAnswerForSectionForStudent =
      "${baseUrl}user/add_section_score.php";
  static const String selectAllTickets =
      "${baseUrl}user/select_ticket_with_user_id.php";
  static const String selectAboutUs = "${baseUrl}user/select_about.php";
  static const String insertTicket = "${baseUrl}user/insert_ticket.php";
  static const String selectPrivacyPolicy =
      "${baseUrl}user/select_privacy_policy.php";
  static const String insertCommentToPost =
      "${baseUrl}user/insert_comment_post.php";
  static const String insertCommentToLive =
      "${baseUrl}user/insert_comment_in_live.php";
  static const String selectAllPosts = "${baseUrl}user/select_all_posts.php";
  static const String selectPostsComments =
      "${baseUrl}user/select_comment_by_post_id.php";
  static const String insertNotification =
      "${baseUrl}user/insert_notification.php";
  static const String selectNotification =
      "${baseUrl}user/select_notification.php";
  static const String deleteNotification =
      "${baseUrl}user/delete_notification.php";
  static const String changeLike = "${baseUrl}user/add_like.php";
  static const String settings = "${baseUrl}admin/select_settings.php";
  static const String getChains = "${baseUrl}user/select_chain.php";
}
