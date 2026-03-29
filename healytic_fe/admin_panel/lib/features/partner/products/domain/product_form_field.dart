/// Enum representing all form field keys used across
/// product add/edit forms.
///
/// Centralises string literals to prevent typos and
/// enable IDE auto-complete.
enum ProductFormField {
  // ── General info ───────────────────────────────
  productName('product_name'),
  productDescription('product_description'),
  productType('product_type'),

  // ── Pricing ────────────────────────────────────
  basePrice('base_price'),
  salePrice('sale_price'),

  // ── Visibility ─────────────────────────────────
  visibilityStatus('visibility_status'),
  onlineStore('online_store'),

  // ── Organization ───────────────────────────────
  category('category'),

  // ── Operations & scheduling ────────────────────
  duration('duration'),
  buffer('buffer'),
  capacity('capacity'),
  leadTime('lead_time'),
  staffAllocation('staff_allocation'),
  selectedStaffIds('selected_staff_ids'),

  // ── Media ──────────────────────────────────────
  productImages('product_images'),
  facilityImages('facility_images');

  const ProductFormField(this.key);

  /// The string key used in `FormBuilder` values map.
  final String key;
}
