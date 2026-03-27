# Create Component

Description: Creates a reusable widget component following the UI design system with proper theming, documentation, and test scaffolding.

## Input Required
- `<component_name>`: Component name (PascalCase, e.g., `ProductCard`)
- `<feature_name>`: Feature it belongs to (or `core` for app-wide)
- `<widget_type>`: `stateless`, `stateful`, or `consumer`

## Steps

1. **Check if component exists in common package:**
   Search `package:common/widgets/` for similar components:
   - `button/button.dart` — Buttons
   - `input/simple_fields.dart` — AppTextField, AppDatePickField
   - `toast.dart` — Toast notifications
   - `linear_indicator.dart` — Progress indicators
   - `adaptive_root_scaffold/adaptive_root_scraffold.dart` — Root scaffold

   If a similar component exists, suggest using it instead.

2. **Determine placement:**
   - Feature-specific → `lib/features/<feature>/presentation/widgets/<name>.widget.dart`
   - App-wide → `lib/core/widgets/<name>.widget.dart`
   - Cross-app shared → `../common/widgets/<name>/`

3. **Create the widget file** using the appropriate template:

   **Stateless (preferred):**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:common/utils/demensions.dart';

   /// A [ComponentName] widget that [brief description].
   ///
   /// Example:
   /// ```dart
   /// ComponentName(
   ///   title: 'Hello',
   ///   onTap: () {},
   /// )
   /// ```
   class ComponentName extends StatelessWidget {
     const ComponentName({
       super.key,
       required this.title,
       this.subtitle,
       this.onTap,
     });

     /// The main title displayed in the component.
     final String title;

     /// Optional subtitle text.
     final String? subtitle;

     /// Callback when component is tapped.
     final VoidCallback? onTap;

     @override
     Widget build(BuildContext context) {
       final colorScheme = Theme.of(context).colorScheme;
       final textTheme = Theme.of(context).textTheme;

       return GestureDetector(
         onTap: onTap,
         child: Container(
           padding: EdgeInsets.all(Demensions.paddingMedium),
           decoration: BoxDecoration(
             color: colorScheme.surface,
             borderRadius: BorderRadius.circular(
               Demensions.borderRadiusMedium,
             ),
             border: Border.all(color: colorScheme.outline),
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(title, style: textTheme.titleMedium),
               if (subtitle != null) ...[
                 SizedBox(height: Demensions.spacingSmall),
                 Text(
                   subtitle!,
                   style: textTheme.bodyMedium?.copyWith(
                     color: colorScheme.onSurface
                         .withValues(alpha: 0.7),
                   ),
                 ),
               ],
             ],
           ),
         ),
       );
     }
   }
   ```

   **Consumer (Riverpod-connected):**
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   import 'package:common/utils/demensions.dart';

   class ComponentName extends ConsumerWidget {
     const ComponentName({super.key, required this.itemId});

     final String itemId;

     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final itemAsync = ref.watch(itemProvider(itemId));
       return itemAsync.when(
         data: (item) => _buildContent(context, item),
         loading: () => const Center(
           child: CircularProgressIndicator(),
         ),
         error: (err, _) => Center(
           child: Text('Error: $err'),
         ),
       );
     }
   }
   ```

4. **Create test file** at `test/features/<feature>/presentation/widgets/<name>_test.dart`:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_test/flutter_test.dart';

   void main() {
     testWidgets('ComponentName displays title', (tester) async {
       await tester.pumpWidget(
         const MaterialApp(
           home: Scaffold(
             body: ComponentName(title: 'Test Title'),
           ),
         ),
       );
       expect(find.text('Test Title'), findsOneWidget);
     });
   }
   ```

5. **Verify compliance:**
   - [ ] File named `*.widget.dart`
   - [ ] `const` constructor
   - [ ] All colors from `Theme.of(context).colorScheme.*`
   - [ ] All text styles from `Theme.of(context).textTheme.*`
   - [ ] Spacing from `Demensions.*`
   - [ ] `///` doc comments with usage example
   - [ ] Parameters documented
   - [ ] Accessibility labels on interactive elements
   - [ ] No hardcoded dimensions
   - [ ] Test file created
