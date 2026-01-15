class BookEventModel {
  final bool isSuccess;
  final String message;

  BookEventModel({required this.isSuccess, required this.message});

  factory BookEventModel.fromJson(Map<String, dynamic> json) {
    return BookEventModel(
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'isSuccess': isSuccess, 'message': message};
  }
}
