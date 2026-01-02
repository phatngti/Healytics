import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class SpaTherapistFields extends StatelessWidget {
  const SpaTherapistFields({super.key});

  static const List<String> _therapistLevels = ['Junior', 'Senior', 'Master'];

  static const Map<String, String> _spaSkills = {
    'facial_treatment': 'Facial Treatment',
    'body_scrub': 'Body Scrub',
    'body_wrap': 'Body Wrap',
    'aromatherapy': 'Aromatherapy',
    'manicure_pedicure': 'Manicure & Pedicure',
    'waxing': 'Waxing',
    'skin_care': 'Skin Care',
  };

  static const Map<String, String> _deviceProficiency = {
    "laser_co2_fractional": "CO2 Fractional Laser",
    "laser_nd_yag": "Nd:YAG Laser",
    "laser_pico": "Picosecond Laser",
    "laser_diode": "Diode Laser",
    "ipl_therapy": "IPL Therapy",
    "hifu_lifting": "HIFU Technology",
    "rf_microneedling": "RF Microneedling",
    "radio_frequency_face": "Facial Radio Frequency",
    "radio_frequency_body": "Body Radio Frequency",
    "galvanic_ion": "Galvanic Ion",
    "ultrasonic_scrubber": "Ultrasonic Scrubber",
    "hydro_dermabrasion": "Hydro Dermabrasion",
    "microdermabrasion": "Diamond Microdermabrasion",
    "oxygen_jet_peel": "Oxygen Jet Peel",
    "led_phototherapy": "LED Phototherapy",
    "high_frequency_wand": "High Frequency Wand",
    "electroporation": "Electroporation",
    "cryolipolysis": "Cryolipolysis",
    "ultrasonic_cavitation": "Ultrasonic Cavitation",
    "ems_sculpting": "EMS Muscle Sculpting",
    "pressotherapy": "Pressotherapy",
    "skin_analyzer": "Digital Skin Analyzer",
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDimens.verticalMedium,
        Row(
          children: [
            Expanded(
              child: FormFieldBuilders.buildDropdownField(
                context,
                label: 'Therapist Level',
                items: _therapistLevels,
                fieldKey: 'therapist_level',
              ),
            ),
            AppDimens.horizontalLarge,
            Expanded(
              child: FormFieldBuilders.buildTextField(
                context,
                fieldKey: 'commission_rate',
                label: 'Commission Rate',
                hintText: '0',
                keyboardType: TextInputType.number,
                suffixIcon: Icon(
                  Icons.percent,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        AppDimens.verticalMedium,
        FormFieldBuilders.buildDateField(
          context,
          fieldKey: 'health_check_date',
          label: 'Last Health Check',
          hintText: 'Select date',
        ),
        AppDimens.verticalMedium,
        FormFieldBuilders.buildMultiSelectChipField(
          context,
          fieldKey: 'spa_skills',
          label: 'Skill Set',
          availableOptions: _spaSkills,
          searchHint: 'Search spa skills...',
          allowCreate: true,
          width: double.infinity,
        ),
        AppDimens.verticalMedium,
        FormFieldBuilders.buildMultiSelectChipField(
          context,
          fieldKey: 'device_proficiency',
          label: 'Device Proficiency',
          availableOptions: _deviceProficiency,
          searchHint: 'Search device proficiency...',
          allowCreate: true,
          width: double.infinity,
        ),
      ],
    );
  }
}
