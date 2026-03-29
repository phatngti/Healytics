import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:common/utils/demensions.dart';

import 'package:user_app/features/employee/'
    'domain/entities/employee_preview.entity.dart';
import 'package:user_app/features/employee/'
    'presentation/providers/'
    'employee_preview_cache.provider.dart';
import '../../../../router/routes.dart';
import '../../domain/entities/booking.entity.dart';
import '../../domain/entities/home.entity.dart';
import '../providers/booking.provider.dart';
import '../providers/booking_flow.provider.dart';
import '../providers/home.provider.dart';
import '../widgets/book_appointment/booking_bottom_action.widget.dart';
import '../widgets/book_appointment/booking_step_indicator.widget.dart';
import '../widgets/book_appointment/category_filter_row.widget.dart';
import '../widgets/book_appointment/booking_search_bar.widget.dart';
import '../widgets/book_appointment/service_radio_list.widget.dart';

/// Step 1 of the booking flow: Select Category
/// and Service.
///
/// Uses a cascading selection pattern:
/// 1. Select Category → loads services
/// 2. Select Service → enables Continue
///
/// Navigates to [SelectSpecialistRoute] on
/// continue.
class BookAppointmentScreen
    extends ConsumerStatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  ConsumerState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState
    extends ConsumerState<BookAppointmentScreen> {
  int _selectedCategoryIdx = -1;
  int _selectedServiceIdx = -1;

  List<HomeCategory> _categories = [];

  bool get _canContinue =>
      _selectedCategoryIdx >= 0 &&
      _selectedServiceIdx >= 0;

  void _handleBack() {
    // Reset flow state when leaving Step 1.
    ref.read(bookingFlowProvider.notifier).reset();
    if (context.canPop()) context.pop();
  }

  void _handleContinue() {
    if (!_canContinue) return;

    // Persist selections to shared flow state.
    final category =
        _categories[_selectedCategoryIdx];
    ref
        .read(bookingFlowProvider.notifier)
        .selectCategory(category);

    final servicesAsync = ref.read(
      servicesByCategoryProvider(category.id),
    );
    servicesAsync.whenData((services) {
      if (_selectedServiceIdx < services.length) {
        ref
            .read(bookingFlowProvider.notifier)
            .selectService(
              services[_selectedServiceIdx],
            );
      }
    });

    SelectSpecialistRoute(
      categoryId: category.id,
    ).push(context);
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIdx = index;
      _selectedServiceIdx = -1;
    });
  }

  void _onServiceSelected(int index) {
    setState(() => _selectedServiceIdx = index);
  }

  /// Handles tapping a service from the search
  /// popup by matching it to a category and
  /// service index.
  void _onSearchServiceSelected(
    BookingService service,
  ) {
    for (var ci = 0; ci < _categories.length; ci++) {
      final asyncServices = ref.read(
        servicesByCategoryProvider(
          _categories[ci].id,
        ),
      );
      asyncServices.whenData((services) {
        final si = services.indexWhere(
          (s) => s.id == service.id,
        );
        if (si >= 0) {
          setState(() {
            _selectedCategoryIdx = ci;
            _selectedServiceIdx = si;
          });
        }
      });
    }

    // Immediately route to the service details screen
    ServiceDetailsRoute(
      serviceId: service.id,
    ).push(context);
  }

  /// Handles tapping a specialist from the
  /// search popup — navigates to their screen.
  void _onSearchSpecialistSelected(
    BookingSpecialist specialist,
  ) {
    // Navigate to the specialist's detail page.
    ref
        .read(
          employeePreviewCacheProvider.notifier,
        )
        .seed(
          EmployeePreview(
            id: specialist.id,
            name: specialist.name,
            avatarUrl: specialist.avatarUrl,
            specialty: specialist.specialty,
          ),
        );
    EmployeeDetailRoute(
      employeeId: specialist.id,
    ).push(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hPad =
        AppDimens.horizontalPadding(context);
    final sectionGap =
        AppDimens.sectionSpacing(context);

    final categoriesAsync = ref.watch(
      categoriesProvider,
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: _handleBack,
        ),
        title: const Text('Book Appointment'),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(
            'Error loading categories: $e',
          ),
        ),
        data: (categories) {
          _categories = categories;
          return _Step1Body(
            hPad: hPad,
            sectionGap: sectionGap,
            categories: categories,
            selectedCategoryIdx:
                _selectedCategoryIdx,
            selectedServiceIdx: _selectedServiceIdx,
            onCategorySelected: _onCategorySelected,
            onServiceSelected: _onServiceSelected,
            onSearchServiceSelected:
                _onSearchServiceSelected,
            onSearchSpecialistSelected:
                _onSearchSpecialistSelected,
            serviceSection:
                _buildServiceSection(sectionGap),
          );
        },
      ),
      bottomNavigationBar: BookingBottomAction(
        canContinue: _canContinue,
        onContinue: _handleContinue,
      ),
    );
  }

  /// Builds the service section when a category
  /// is selected.
  Widget _buildServiceSection(double sectionGap) {
    if (_selectedCategoryIdx < 0 ||
        _categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final categoryId =
        _categories[_selectedCategoryIdx].id;
    final servicesAsync = ref.watch(
      servicesByCategoryProvider(categoryId),
    );

    return servicesAsync.when(
      loading: () => Padding(
        padding: EdgeInsets.only(top: sectionGap),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Padding(
        padding: EdgeInsets.only(top: sectionGap),
        child: Text('Error: $e'),
      ),
      data: (services) {
        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            SizedBox(height: sectionGap),
            _SectionTitle(title: 'Select Service'),
            SizedBox(height: AppDimens.spaceMd),
            ServiceRadioList(
              services: services,
              selectedIndex: _selectedServiceIdx,
              onSelected: _onServiceSelected,
            ),
          ],
        );
      },
    );
  }
}

/// Scrollable body for Step 1.
class _Step1Body extends StatelessWidget {
  const _Step1Body({
    required this.hPad,
    required this.sectionGap,
    required this.categories,
    required this.selectedCategoryIdx,
    required this.selectedServiceIdx,
    required this.onCategorySelected,
    required this.onServiceSelected,
    required this.serviceSection,
    this.onSearchServiceSelected,
    this.onSearchSpecialistSelected,
  });

  final double hPad;
  final double sectionGap;
  final List<HomeCategory> categories;
  final int selectedCategoryIdx;
  final int selectedServiceIdx;
  final ValueChanged<int> onCategorySelected;
  final ValueChanged<int> onServiceSelected;
  final Widget serviceSection;

  /// Called when a service is tapped in the
  /// search popup.
  final ValueChanged<BookingService>?
      onSearchServiceSelected;

  /// Called when a specialist is tapped in the
  /// search popup.
  final ValueChanged<BookingSpecialist>?
      onSearchSpecialistSelected;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.of(context)
            .textScaler
            .clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.3,
            ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: hPad,
          vertical: AppDimens.spaceLg,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Progress indicator
            BookingStepIndicator(
              currentStep: 1,
              totalSteps: 3,
              stepLabel: 'Details',
            ),
            SizedBox(height: sectionGap),

            // Search bar
            BookingSearchBar(
              onServiceSelected:
                  onSearchServiceSelected,
              onSpecialistSelected:
                  onSearchSpecialistSelected,
            ),
            SizedBox(height: sectionGap),

            // Select Category
            _SectionTitle(
              title: 'Select Category',
            ),
            CategoryFilterRow(
              categories: categories,
              selectedIndex: selectedCategoryIdx,
              onSelected: onCategorySelected,
            ),

            // Select Service (cascading)
            serviceSection,

            SizedBox(height: sectionGap),
          ],
        ),
      ),
    );
  }
}

/// Reusable section heading.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
