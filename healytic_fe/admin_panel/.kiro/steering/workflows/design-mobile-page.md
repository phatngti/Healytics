---
inclusion: manual
---

# Workflow: Design Mobile Page

Creates a mobile page following the UI design system with proper theming, responsive layout, shared components, and a compliance checklist.

## Input Required
- `<page_name>`: Page name (PascalCase, e.g., `BookingList`)
- `<feature_name>`: Feature it belongs to

## Steps

1. **Create the screen file** at `lib/features/<feature>/presentation/screens/<page_name_snake>.screen.dart` using this template:

   ```dart
   import 'package:flutter/material.dart';
   import 'package:hooks_riverpod/hooks_riverpod.dart';
   import 'package:common/utils/demensions.dart';

   class <PageName>Screen extends ConsumerWidget {
     const <PageName>Screen({super.key});

     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final colorScheme = Theme.of(context).colorScheme;
       final textTheme = Theme.of(context).textTheme;

       return Scaffold(
         appBar: AppBar(
           title: Text(
             'Page Title',
             style: textTheme.titleLarge,
           ),
           backgroundColor: colorScheme.surface,
         ),
         body: SafeArea(
           child: SingleChildScrollView(
             padding: EdgeInsets.all(Demensions.paddingMedium),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 _Header(),
                 SizedBox(height: Demensions.spacingMedium),
                 _Content(),
                 SizedBox(height: Demensions.spacingMedium),
                 _Actions(),
               ],
             ),
           ),
         ),
       );
     }
   }
   ```

2. **Extract sections into private widgets:**
   Each major section of the page should be its own private widget class:
   ```dart
   class _Header extends StatelessWidget {
     const _Header();

     @override
     Widget build(BuildContext context) {
       return Text(
         'Header',
         style: Theme.of(context).textTheme.headlineSmall,
       );
     }
   }
   ```

3. **For lists, use ListView.builder:**
   ```dart
   ListView.builder(
     shrinkWrap: true,
     physics: const NeverScrollableScrollPhysics(),
     itemCount: items.length,
     itemBuilder: (context, index) =>
         ItemWidget(item: items[index]),
   )
   ```

4. **For data-driven pages, handle loading/error states:**
   ```dart
   final dataAsync = ref.watch(dataProvider);
   return dataAsync.when(
     data: (data) => _buildContent(context, data),
     loading: () => Center(
       child: CircularProgressIndicator(
         color: colorScheme.primary,
       ),
     ),
     error: (err, _) => Center(
       child: Text(
         'Error: $err',
         style: textTheme.bodyMedium?.copyWith(
           color: colorScheme.error,
         ),
       ),
     ),
   );
   ```

5. **Use shared components** from `package:common` wherever applicable:
   ```dart
   import 'package:common/widgets/button/button.dart';
   import 'package:common/widgets/input/simple_fields.dart';
   ```

6. **Add the route** in `lib/router/routes.dart` with slide transition.

7. **Run code generation:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

8. **Verify compliance checklist:**
   - [ ] All colors from `Theme.of(context).colorScheme.*`
   - [ ] All text styles from `Theme.of(context).textTheme.*`
   - [ ] All spacing from `Demensions.*` constants
   - [ ] Using `package:common` widgets where available
   - [ ] Widget composition (no build method > 50 lines)
   - [ ] `const` constructors where possible
   - [ ] `ListView.builder` for dynamic lists
   - [ ] `SafeArea` for proper display
   - [ ] Loading/error state handling
   - [ ] `Image.network` has `errorBuilder`
   - [ ] Semantic labels for accessibility
   - [ ] No magic numbers
   - [ ] `Color.withValues(alpha:)` not `.withOpacity()`
   - [ ] Responsive sizing with `MediaQuery` or `LayoutBuilder`
