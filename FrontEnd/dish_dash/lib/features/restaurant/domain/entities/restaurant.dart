import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final int id;
  final String name;
  final String type;
  final String location;
  final double latitude;
  final double longitude;
  final String imgUrl;

  const Restaurant({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.imgUrl,
  });

  @override
  List<Object?> get props => [id, name, type, location, latitude, longitude, imgUrl];
}
