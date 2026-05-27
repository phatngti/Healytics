import { DashboardTimePeriod } from '../dto/query/dashboard-period-query.dto';

export interface DateRange {
  startDate: Date;
  endDate: Date;
  prevStartDate: Date;
  prevEndDate: Date;
}

/**
 * Resolves the date range for a given dashboard time period.
 * Also computes the previous period of equal duration for growth comparison.
 */
export function resolveDateRange(period: DashboardTimePeriod): DateRange {
  const now = new Date();
  let startDate: Date;
  let endDate: Date;

  switch (period) {
    case DashboardTimePeriod.TODAY:
      startDate = startOfDay(now);
      endDate = endOfDay(now);
      break;
    case DashboardTimePeriod.THIS_WEEK:
      startDate = startOfWeek(now);
      endDate = endOfWeek(now);
      break;
    case DashboardTimePeriod.THIS_MONTH:
      startDate = startOfMonth(now);
      endDate = endOfMonth(now);
      break;
    case DashboardTimePeriod.THIS_QUARTER:
      startDate = startOfQuarter(now);
      endDate = endOfQuarter(now);
      break;
    case DashboardTimePeriod.THIS_YEAR:
      startDate = startOfYear(now);
      endDate = endOfYear(now);
      break;
  }

  // Previous period: shift back by the same duration
  const durationMs = endDate.getTime() - startDate.getTime();
  const prevEndDate = new Date(startDate.getTime() - 1);
  const prevStartDate = new Date(prevEndDate.getTime() - durationMs);

  return { startDate, endDate, prevStartDate, prevEndDate };
}

/**
 * Maps a dashboard time period to the PostgreSQL date_trunc granularity
 * used for revenue time-series bucketing.
 */
export function resolveGranularity(
  period: DashboardTimePeriod,
): 'hour' | 'day' | 'week' | 'month' {
  switch (period) {
    case DashboardTimePeriod.TODAY:
      return 'hour';
    case DashboardTimePeriod.THIS_WEEK:
      return 'day';
    case DashboardTimePeriod.THIS_MONTH:
      return 'week';
    case DashboardTimePeriod.THIS_QUARTER:
      return 'month';
    case DashboardTimePeriod.THIS_YEAR:
      return 'month';
  }
}

// ── Vanilla Date Helpers ──────────────────────────────────────

function startOfDay(d: Date): Date {
  const r = new Date(d);
  r.setHours(0, 0, 0, 0);
  return r;
}

function endOfDay(d: Date): Date {
  const r = new Date(d);
  r.setHours(23, 59, 59, 999);
  return r;
}

/** Week starts on Monday (ISO standard) */
function startOfWeek(d: Date): Date {
  const r = new Date(d);
  const day = r.getDay();
  const diff = day === 0 ? 6 : day - 1; // Monday = 0 offset
  r.setDate(r.getDate() - diff);
  r.setHours(0, 0, 0, 0);
  return r;
}

function endOfWeek(d: Date): Date {
  const r = startOfWeek(d);
  r.setDate(r.getDate() + 6);
  r.setHours(23, 59, 59, 999);
  return r;
}

function startOfMonth(d: Date): Date {
  return new Date(d.getFullYear(), d.getMonth(), 1, 0, 0, 0, 0);
}

function endOfMonth(d: Date): Date {
  return new Date(d.getFullYear(), d.getMonth() + 1, 0, 23, 59, 59, 999);
}

function startOfQuarter(d: Date): Date {
  const quarterStartMonth = Math.floor(d.getMonth() / 3) * 3;
  return new Date(d.getFullYear(), quarterStartMonth, 1, 0, 0, 0, 0);
}

function endOfQuarter(d: Date): Date {
  const quarterStartMonth = Math.floor(d.getMonth() / 3) * 3;
  return new Date(d.getFullYear(), quarterStartMonth + 3, 0, 23, 59, 59, 999);
}

function startOfYear(d: Date): Date {
  return new Date(d.getFullYear(), 0, 1, 0, 0, 0, 0);
}

function endOfYear(d: Date): Date {
  return new Date(d.getFullYear(), 11, 31, 23, 59, 59, 999);
}
