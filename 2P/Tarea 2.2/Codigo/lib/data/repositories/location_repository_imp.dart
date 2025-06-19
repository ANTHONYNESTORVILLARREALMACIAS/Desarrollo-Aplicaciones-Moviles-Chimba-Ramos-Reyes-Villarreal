import '../../domain/entities/location.dart';
import '../../data/datasource/location_datasource.dart';

abstract class LocationRepository {
  Future<LocationEntity> getCurrentLocation();
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<LocationEntity> getCurrentLocation() async {
    final location = await dataSource.getCurrentLocation();
    return LocationEntity(
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }
}