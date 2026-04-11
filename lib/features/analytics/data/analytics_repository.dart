import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsData {
  final int totalProperties;
  final int totalEnquiries;
  final int totalUpcoming;
  final int totalBlogs;
  final Map<DateTime, int> enquiryTrends;
  final Map<String, int> propertyDistribution;

  AnalyticsData({
    required this.totalProperties,
    required this.totalEnquiries,
    required this.totalUpcoming,
    required this.totalBlogs,
    required this.enquiryTrends,
    required this.propertyDistribution,
  });
}

class AnalyticsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AnalyticsData> fetchDashboardStats() async {
    final properties = await _firestore.collection('properties').get();
    final enquiries = await _firestore.collection('property_enquiries').get();
    final upcomingCloud = await _firestore
        .collection('upcoming_projects')
        .get();
    final blogs = await _firestore.collection('blogs').get();

    // Calculate Enquiry Trends (Last 7 days)
    final now = DateTime.now();
    final Map<DateTime, int> trends = {};
    for (int i = 0; i < 7; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      trends[date] = 0;
    }

    for (var doc in enquiries.docs) {
      final data = doc.data();
      final Timestamp? ts = data['createdAt'] as Timestamp?;
      if (ts != null) {
        final date = ts.toDate();
        final dayKey = DateTime(date.year, date.month, date.day);
        if (trends.containsKey(dayKey)) {
          trends[dayKey] = (trends[dayKey] ?? 0) + 1;
        }
      }
    }

    // Calculate Property Distribution by Type/Category
    final Map<String, int> distribution = {};
    for (var doc in properties.docs) {
      final data = doc.data();
      final type = data['type'] ?? 'Unknown';
      distribution[type] = (distribution[type] ?? 0) + 1;
    }

    return AnalyticsData(
      totalProperties: properties.size,
      totalEnquiries: enquiries.size,
      totalUpcoming: upcomingCloud.size,
      totalBlogs: blogs.size,
      enquiryTrends: trends,
      propertyDistribution: distribution,
    );
  }
}
