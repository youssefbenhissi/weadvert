import 'package:flutter_test/flutter_test.dart';
import 'package:pim/screens/annonceur_side/candidates.dart';

void main(){
  group('Candidates filter test', (){
    
  
    test('when a city is added', (){
      var city = 'Tunis'; 
      FilterChipDisplay.selectedCities.add(city);
      expect(FilterChipDisplay.selectedCities.contains(city), true);
    });
    test('when a city is removed', (){
      var city = 'Tunis'; 
      expect(FilterChipDisplay.selectedCities.contains(city), true);
      FilterChipDisplay.selectedCities.remove(city);
      expect(FilterChipDisplay.selectedCities.contains(city), false);
    });

    test('when a manufacturer is added', (){
      var manu = 'Seat'; 
      FilterChipDisplay.selectedManufacturer.add(manu);
      expect(FilterChipDisplay.selectedManufacturer.contains(manu), true);
    });
    test('when a manufacturer is removed', (){
      var manu = 'Seat'; 
      expect(FilterChipDisplay.selectedManufacturer.contains(manu), true);
      FilterChipDisplay.selectedManufacturer.remove(manu);
      expect(FilterChipDisplay.selectedManufacturer.contains(manu), false);
    });
    test('when a vehicleType is added', (){
      var type = 'Taxi'; 
      FilterChipDisplay.vehicleType.add(type);
      expect(FilterChipDisplay.vehicleType.contains(type), true);
    });
    test('when a vehicleType is removed', (){
      var type = 'Taxi'; 
      expect(FilterChipDisplay.vehicleType.contains(type), true);
      FilterChipDisplay.vehicleType.remove(type);
      expect(FilterChipDisplay.vehicleType.contains(type), false);
    });
  });
}