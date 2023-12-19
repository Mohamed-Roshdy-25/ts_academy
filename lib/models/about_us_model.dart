import 'package:equatable/equatable.dart';

class AboutUSModel extends Equatable {
  final String aboutId;
  final String aboutText;

  const AboutUSModel({required this.aboutId, required this.aboutText});

  @override
  List<Object?> get props => [aboutId, aboutText];
  factory AboutUSModel.fromjson(Map<String, dynamic> json) =>
      AboutUSModel(aboutId: json['about_id'], aboutText: json['about_txt']);
}
