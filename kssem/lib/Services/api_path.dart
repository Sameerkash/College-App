class APIPath {
  static String post(String uid, String postId) =>
      'posts/$uid/userPosts/$postId';
  static String timeline(String postId) => 'timeline/$postId';
}
