import 'package:equatable/equatable.dart';

class PrivacyModel extends Equatable {
  final String privacyId;
  final String privacyText;

  const PrivacyModel({required this.privacyId, required this.privacyText});

  @override
  List<Object?> get props => [privacyId, privacyText];
  factory PrivacyModel.fromjson(Map<String, dynamic> json) => PrivacyModel(
      privacyId: json['privacy_policy_id'],
      privacyText: json['privacy_policy_txt']);
}
