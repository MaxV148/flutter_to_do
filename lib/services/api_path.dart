class APIPath {
  static String task(String uid, String taskId) => 'users/$uid/tasks/$taskId';
  static String tasks(String uid) => 'users/$uid/tasks';

  static String category(String uid, String categoryId) =>
      'users/$uid/cagories/$categoryId';
  static String categories(String uid) => 'users/$uid/cagories';
}
