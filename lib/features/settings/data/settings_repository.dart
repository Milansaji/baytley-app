import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/home_content_model.dart';
import '../models/about_content_model.dart';
import '../models/company_info_model.dart';
import '../models/contact_info_model.dart';

class SettingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Single document fetchers/updaters

  Future<HomeContentModel> getHomeContent() async {
    final doc = await _firestore.collection('home_content').doc('main').get();
    if (!doc.exists) {
      return HomeContentModel(
        featuredPropertiesTitle: '',
        heroBackgroundImage: '',
        heroSubtitle: '',
        heroTitle: '',
        heroVideo: '',
        upcomingProjectsTitle: '',
        updatedAt: DateTime.now(),
      );
    }
    return HomeContentModel.fromFirestore(doc);
  }

  Future<void> updateHomeContent(HomeContentModel content) async {
    await _firestore
        .collection('home_content')
        .doc('main')
        .set(content.toMap());
  }

  Future<AboutContentModel> getAboutContent() async {
    final doc = await _firestore.collection('about_content').doc('main').get();
    return AboutContentModel.fromFirestore(doc);
  }

  Future<void> updateAboutContent(AboutContentModel content) async {
    await _firestore
        .collection('about_content')
        .doc('main')
        .set(content.toMap());
  }

  Future<CompanyInfoModel> getCompanyInfo() async {
    final doc = await _firestore.collection('company_info').doc('main').get();
    return CompanyInfoModel.fromFirestore(doc);
  }

  Future<void> updateCompanyInfo(CompanyInfoModel info) async {
    await _firestore.collection('company_info').doc('main').set(info.toMap());
  }

  Future<ContactInfoModel> getContactInfo() async {
    final doc = await _firestore.collection('contact_info').doc('main').get();
    return ContactInfoModel.fromFirestore(doc);
  }

  Future<void> updateContactInfo(ContactInfoModel info) async {
    await _firestore.collection('contact_info').doc('main').set(info.toMap());
  }
}
