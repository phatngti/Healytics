/**
 * Format a Date to a Redis-key-safe slot identifier: `YYYY-MM-DD_HHmm`
 *
 * Used across booking handlers for constructing Redis lock keys like
 * `lock:checkout:${staffId}_${dateStr}` and `lock:intent:${staffId}_${dateStr}`.
 */
export function formatSlotKey(date: Date): string {
  const yyyy = date.getUTCFullYear();
  const mm = String(date.getUTCMonth() + 1).padStart(2, '0');
  const dd = String(date.getUTCDate()).padStart(2, '0');
  const hh = String(date.getUTCHours()).padStart(2, '0');
  const min = String(date.getUTCMinutes()).padStart(2, '0');
  return `${yyyy}-${mm}-${dd}_${hh}${min}`;
}
