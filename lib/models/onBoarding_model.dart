import 'package:equatable/equatable.dart';

class OnBoardingModel extends Equatable {
  // "id": "2",
  // "text": "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum",
  // "image_url": ""

  final String id;
  final String text;
  final String image_url;
  OnBoardingModel({
    required this.text,
    required this.id,
    required this.image_url,
  });

  factory OnBoardingModel.fromJson(Map<String, dynamic> json) {
    return OnBoardingModel(
        text: json["text"],
        id: json["id"], image_url: json["image_url"]);
  }

  @override
  List<Object?> get props => [
     this.text,
     this.id,
     this.image_url,
  ] ;

}
