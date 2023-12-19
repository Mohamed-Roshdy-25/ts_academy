import 'package:equatable/equatable.dart';

class ChainModel extends Equatable {
  // "chain_id": "1",
  // "chain_name": "كورسات مكثفة",
  // "university_id": "1"

  final String chain_id ;
  final String chain_name ;
  final String university_id ;
  final String photo ;
  ChainModel(
      {
    required this.chain_id,
        required this.chain_name,
        required this.university_id,
        required this.photo,
}
      );
  factory ChainModel.fromJson( Map<String,dynamic> json  )  {
    return ChainModel(
        photo: json["photo"],
        chain_id: json["chain_id"], chain_name: json["chain_name"], university_id: json["university_id"]);

  }

  @override
  List<Object?> get props =>[
   chain_id,
   chain_name,
   university_id,
    photo
  ];

}