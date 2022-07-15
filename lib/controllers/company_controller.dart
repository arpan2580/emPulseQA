import 'package:empulse/models/company.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class CompanyController extends GetxController {
  var companyTypes = <Company>[].obs;

  getCompanies() {
    final storeMasterData = GetStorage();
    var companies = storeMasterData.read('company');
    if (companies != null) {
      companies.split(':').forEach((comp) => companyTypes.add(Company(comp)));
    }
  }

  List<Company> getCompanyList(String query) {
    return List.of(companyTypes).where((company) {
      final companyLower = company.companyName.toLowerCase();
      final queryLower = query.toLowerCase();
      return companyLower.contains(queryLower);
    }).toList();
  }
}
