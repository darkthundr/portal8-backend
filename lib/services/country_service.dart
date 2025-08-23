import 'package:ip_country_lookup/ip_country_lookup.dart';

class CountryService {
  Future<bool> isUserInIndia() async {
    try {
      final countryData = await IpCountryLookup().getIpLocationData();
      return countryData?.countryCode == 'IN';
    } catch (e) {
      print('Error fetching country data: $e');
      return false; // Default to false if there's an error
    }
  }
}
