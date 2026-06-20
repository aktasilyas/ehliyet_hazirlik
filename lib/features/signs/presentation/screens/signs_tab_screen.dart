import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/sign_entity.dart';
import '../providers/signs_providers.dart';

class SignsTabScreen extends ConsumerStatefulWidget {
  const SignsTabScreen({super.key});

  @override
  ConsumerState<SignsTabScreen> createState() => _SignsTabScreenState();
}

class _SignsTabScreenState extends ConsumerState<SignsTabScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedCategory = ref.watch(selectedSignCategoryProvider);
    final signsAsync = selectedCategory == null
        ? ref.watch(filteredSignsProvider)
        : ref.watch(signsByCategoryProvider(selectedCategory));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.signsTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(108),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: SearchBar(
                  controller: _searchController,
                  hintText: l10n.signsSearch,
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(signsSearchQueryProvider.notifier).state = '';
                        },
                      ),
                  ],
                  onChanged: (value) {
                    ref.read(signsSearchQueryProvider.notifier).state = value;
                    if (value.isNotEmpty) {
                      ref.read(selectedSignCategoryProvider.notifier).state =
                          null;
                    }
                  },
                ),
              ),
              _CategoryFilterRow(selected: selectedCategory),
            ],
          ),
        ),
      ),
      body: signsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (signs) {
          if (signs.isEmpty) {
            return Center(child: Text(l10n.signsEmpty));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: signs.length,
            itemBuilder: (context, index) {
              final sign = signs[index];
              return _SignCard(sign: sign);
            },
          );
        },
      ),
    );
  }
}

class _CategoryFilterRow extends ConsumerWidget {
  const _CategoryFilterRow({required this.selected});

  final SignCategory? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        children: [
          _FilterChip(
            label: 'Tümü',
            selected: selected == null,
            onTap: () {
              ref.read(selectedSignCategoryProvider.notifier).state = null;
              ref.read(signsSearchQueryProvider.notifier).state = '';
            },
          ),
          ...SignCategory.values.map((cat) => _FilterChip(
                label: cat.displayName,
                selected: selected == cat,
                onTap: () {
                  ref.read(selectedSignCategoryProvider.notifier).state = cat;
                  ref.read(signsSearchQueryProvider.notifier).state = '';
                },
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
      ),
    );
  }
}

class _SignCard extends StatelessWidget {
  const _SignCard({required this.sign});

  final SignEntity sign;

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(sign.category);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.signDetail.replaceFirst(':id', sign.id),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                String.fromCharCode(sign.iconCode),
                style: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                sign.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                sign.code,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (sign.isPremium) ...[
              const SizedBox(height: 4),
              const Icon(Icons.lock, size: 14, color: Colors.amber),
            ],
          ],
        ),
      ),
    );
  }

  Color _categoryColor(SignCategory category) => switch (category) {
        SignCategory.warning => Colors.orange,
        SignCategory.prohibition => Colors.red,
        SignCategory.obligation => Colors.blue,
        SignCategory.informational => Colors.green,
        SignCategory.priority => Colors.purple,
      };
}
