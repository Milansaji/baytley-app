import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/property_model.dart';
import '../bloc/property_bloc.dart';
import '../bloc/property_event.dart';
import '../bloc/property_state.dart';
import '../../../core/localization/app_locale.dart';
import 'add_edit_property_screen.dart';

class PropertyManagementScreen extends StatelessWidget {
  const PropertyManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Manage Properties', 'إدارة العقارات')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditPropertyScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PropertyBloc, PropertyState>(
        builder: (context, state) {
          if (state is PropertyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PropertyLoaded) {
            final properties = state.properties;
            if (properties.isEmpty) {
              return Center(
                child: Text(context.t('No properties found', 'لا توجد عقارات')),
              );
            }
            return ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return ListTile(
                  leading: property.image.isNotEmpty
                      ? Image.network(
                          property.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.home),
                        )
                      : const Icon(Icons.home),
                  title: Text(property.title),
                  subtitle: Text(property.location),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddEditPropertyScreen(property: property),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, property),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          if (state is PropertyError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, PropertyModel property) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.t('Delete Property', 'حذف العقار')),
        content: Text(
          context.t(
            'Are you sure you want to delete this property?',
            'هل أنت متأكد أنك تريد حذف هذا العقار؟',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.t('Cancel', 'إلغاء')),
          ),
          TextButton(
            onPressed: () {
              // Note: I need to add DeletePropertyEvent to PropertyBloc
              context.read<PropertyBloc>().add(
                DeletePropertyEvent(property.id),
              );
              Navigator.pop(ctx);
            },
            child: Text(
              context.t('Delete', 'حذف'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
