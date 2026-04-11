import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/presentation/providers/transaction_details.provider.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailsDesktop extends ConsumerWidget {
  const TransactionDetailsDesktop({super.key, required this.transactionId});

  final TransactionRecordId transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(transactionDetailsProvider(transactionId));

    return detailAsync.when(
      data: (detail) {
        final record = detail.record;
        return SingleChildScrollView(
          child: Padding(
            padding: AppDimens.paddingAllMedium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaction ${record.id.value}',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${record.sourceType.label} • ${record.reference}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    FinanceStatusBadge(
                      label: record.status.label,
                      backgroundColor: financeStatusBackground(
                        context,
                        record.status.label,
                      ),
                      foregroundColor: financeStatusForeground(
                        context,
                        record.status.label,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FinanceStatusBadge(
                      label: record.settlementStatus.label,
                      backgroundColor: financeStatusBackground(
                        context,
                        record.settlementStatus.label,
                      ),
                      foregroundColor: financeStatusForeground(
                        context,
                        record.settlementStatus.label,
                      ),
                    ),
                  ],
                ),
                AppDimens.verticalLarge,
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _DetailCard(
                      title: 'Amount Breakdown',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetailLine(
                            label: 'Gross amount',
                            value: formatFinanceCurrency(
                              record.grossAmount,
                              record.currency,
                            ),
                          ),
                          _DetailLine(
                            label: 'Fee amount',
                            value: formatFinanceCurrency(
                              record.feeAmount,
                              record.currency,
                            ),
                          ),
                          _DetailLine(
                            label: 'Net amount',
                            value: formatFinanceCurrency(
                              record.netAmount,
                              record.currency,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _DetailCard(
                      title: 'Source Summary',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.sourceSummaryTitle,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(detail.sourceSummarySubtitle),
                          const SizedBox(height: 12),
                          _DetailLine(
                            label: 'Customer',
                            value: record.customerName,
                          ),
                          _DetailLine(
                            label: 'Payment method',
                            value: record.paymentMethod,
                          ),
                          _DetailLine(
                            label: 'Created',
                            value: formatFinanceDateTime(record.createdAt),
                          ),
                        ],
                      ),
                    ),
                    _DetailCard(
                      title: 'Settlement & Payout',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetailLine(
                            label: 'Payout status',
                            value: record.payoutStatus.label,
                          ),
                          _DetailLine(
                            label: 'Payout ID',
                            value:
                                detail.payoutRecord?.id.value ?? 'Not assigned',
                          ),
                          _DetailLine(
                            label: 'Payout method',
                            value:
                                detail.payoutRecord?.method ??
                                'Primary settlement account',
                          ),
                          _DetailLine(
                            label: 'Scheduled payout',
                            value: detail.payoutRecord == null
                                ? 'Pending assignment'
                                : formatFinanceDateTime(
                                    detail.payoutRecord!.scheduledDate,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppDimens.verticalLarge,
                _DetailCard(
                  title: 'Refund History',
                  child: detail.relatedRefundCases.isEmpty
                      ? const Text(
                          'No refund or dispute history linked to this transaction.',
                        )
                      : Column(
                          children: detail.relatedRefundCases
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FinanceStatusBadge(
                                        label: item.status.label,
                                        backgroundColor:
                                            financeStatusBackground(
                                              context,
                                              item.status.label,
                                            ),
                                        foregroundColor:
                                            financeStatusForeground(
                                              context,
                                              item.status.label,
                                            ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${item.caseType.label} • ${formatFinanceCurrency(item.amount, item.currency)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(item.reason),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Owner: ${item.owner} • Requested ${formatFinanceDateTime(item.requestedAt)}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ),
                AppDimens.verticalLarge,
                _DetailCard(
                  title: 'Timeline & Notes',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (record.notes != null) ...[
                        Text(
                          'Notes',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(record.notes!),
                        const SizedBox(height: 16),
                      ],
                      ...record.timeline.map(
                        (event) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(event.description),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatFinanceDateTime(event.occurredAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: ErrorCard(
          title: 'Failed to load transaction',
          error: error,
          stackTrace: stack,
          onRetry: () => ref.invalidate(
            transactionDetailsProvider(transactionId),
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
