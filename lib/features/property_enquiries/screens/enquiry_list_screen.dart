import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/property_enquiry_bloc.dart';
import '../bloc/property_enquiry_state.dart';
import '../../../core/localization/app_locale.dart';

class EnquiryListScreen extends StatelessWidget {
  const EnquiryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Property Enquiries', 'استفسارات العقارات')),
      ),
      body: BlocBuilder<PropertyEnquiryBloc, PropertyEnquiryState>(
        builder: (context, state) {
          if (state is PropertyEnquiryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PropertyEnquiryLoaded) {
            final enquiries = state.enquiries;
            if (enquiries.isEmpty) {
              return Center(
                child: Text(
                  context.t('No enquiries found', 'لا توجد استفسارات'),
                ),
              );
            }
            return ListView.builder(
              itemCount: enquiries.length,
              itemBuilder: (context, index) {
                final item = enquiries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.propertyTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${context.t('From', 'من')}: ${item.name} (${item.email})',
                        ),
                        const SizedBox(height: 8),
                        Text(item.message),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            item.createdAt.toString().split('.').first,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          if (state is PropertyEnquiryError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
