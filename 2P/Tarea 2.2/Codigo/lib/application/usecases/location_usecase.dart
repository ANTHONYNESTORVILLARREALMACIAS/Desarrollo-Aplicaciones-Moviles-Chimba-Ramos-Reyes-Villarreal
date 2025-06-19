import '../../domain/entities/location.dart';
import '../../data/repositories/location_repository_imp.dart';

class GetCurrentLocation {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  Future<LocationEntity> call() async {
    return await repository.getCurrentLocation();
  }
}