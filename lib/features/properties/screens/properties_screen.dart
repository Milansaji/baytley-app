import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/widgets/shimmer.dart';
import '../bloc/property_bloc.dart';
import '../bloc/property_event.dart';
import '../bloc/property_state.dart';
import '../data/models/property_model.dart';
import '../../../core/constants/colors.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  String _selectedType = 'All';
  final List<String> _types = [
    'All',
    'Apartment',
    'Villa',
    'Townhouse',
    'Penthouse',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t('Properties', 'العقارات'),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.t('Explore our listings', 'استكشف قوائمنا'),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Type filter chips
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _types.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (ctx, i) {
                        final selected = _types[i] == _selectedType;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedType = _types[i]),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              _typeLabel(context, _types[i]),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? AppColors.textPrimaryLight
                                    : AppColors.textSecondaryDark,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── List ────────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<PropertyBloc, PropertyState>(
                builder: (context, state) {
                  if (state is PropertyLoading) {
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: 4,
                      itemBuilder: (_, __) => const PropertyListCardShimmer(),
                    );
                  }
                  if (state is PropertyError) {
                    return _ErrorState(
                      message: state.message,
                      onRetry: () => context.read<PropertyBloc>().add(
                        FetchPropertiesEvent(),
                      ),
                    );
                  }
                  if (state is PropertyLoaded) {
                    final filtered = _selectedType == 'All'
                        ? state.properties
                        : state.properties
                              .where((p) => p.type == _selectedType)
                              .toList();
                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.t(
                                'No ${_typeLabel(context, _selectedType)} listings found',
                                'لا توجد قوائم ${_typeLabel(context, _selectedType)}',
                              ),
                              style: const TextStyle(
                                color: AppColors.textSecondaryDark,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) =>
                          _PropertyCard(property: filtered[i]),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(BuildContext context, String type) {
    switch (type) {
      case 'All':
        return context.t('All', 'الكل');
      case 'Apartment':
        return context.t('Apartment', 'شقة');
      case 'Villa':
        return context.t('Villa', 'فيلا');
      case 'Townhouse':
        return context.t('Townhouse', 'تاون هاوس');
      case 'Penthouse':
        return context.t('Penthouse', 'بنتهاوس');
      default:
        return type;
    }
  }
}

// ── Property List Card ─────────────────────────────────────────────────────
class _PropertyCard extends StatelessWidget {
  final PropertyModel property;
  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + status badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  property.image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const ShimmerBox(
                      width: double.infinity,
                      height: 180,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: AppColors.surfaceVariant,
                    child: const Icon(
                      Icons.image_not_supported_rounded,
                      color: AppColors.secondary,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: property.status == 'Current'
                        ? AppColors.success
                        : AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    property.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _typeLabel(context, property.type),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      property.location,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      property.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    _Stat(
                      icon: Icons.bed_rounded,
                      label: '${property.beds} ${context.t('bd', 'غرف')}',
                    ),
                    const SizedBox(width: 10),
                    _Stat(
                      icon: Icons.bathtub_rounded,
                      label: '${property.baths} ${context.t('ba', 'حمام')}',
                    ),
                    const SizedBox(width: 10),
                    _Stat(
                      icon: Icons.straighten_rounded,
                      label: '${property.sqft} ${context.t('sqft', 'قدم²')}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(BuildContext context, String type) {
    switch (type) {
      case 'Apartment':
        return context.t('Apartment', 'شقة');
      case 'Villa':
        return context.t('Villa', 'فيلا');
      case 'Townhouse':
        return context.t('Townhouse', 'تاون هاوس');
      case 'Penthouse':
        return context.t('Penthouse', 'بنتهاوس');
      default:
        return type;
    }
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Stat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.secondary),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryDark,
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.t('Retry', 'إعادة المحاولة')),
            ),
          ],
        ),
      ),
    );
  }
}
