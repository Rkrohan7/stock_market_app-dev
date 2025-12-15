import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_model.dart';
import 'admin_verification_viewmodel.dart';

class AdminVerificationView extends StackedView<AdminVerificationViewModel> {
  const AdminVerificationView({super.key});

  @override
  Widget builder(
    BuildContext context,
    AdminVerificationViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Verifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.goBack,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.pendingUsers.isEmpty
              ? _buildEmptyState(context)
              : _buildUserList(context, viewModel),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 80,
            color: AppColors.textSecondaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No Pending Verifications',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'All users have been verified',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildUserList(
    BuildContext context,
    AdminVerificationViewModel viewModel,
  ) {
    return RefreshIndicator(
      onRefresh: viewModel.initialize,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.pendingUsers.length,
        itemBuilder: (context, index) {
          final user = viewModel.pendingUsers[index];
          return _buildUserCard(context, viewModel, user, index)
              .animate()
              .fadeIn(delay: Duration(milliseconds: index * 100));
        },
      ),
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    AdminVerificationViewModel viewModel,
    UserModel user,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Header
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Text(
                          (user.displayName ?? user.email ?? 'U')[0]
                              .toUpperCase(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? 'No Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? 'No Email',
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Pending',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // KYC Details
            _buildInfoRow(
              context,
              'PAN Number',
              user.panNumber ?? 'Not provided',
              Icons.credit_card,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              'Aadhaar Number',
              _maskAadhaar(user.aadhaarNumber),
              Icons.badge,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              'Phone',
              user.phoneNumber ?? 'Not provided',
              Icons.phone,
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => viewModel.rejectUser(user),
                    icon: const Icon(Icons.close),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.loss,
                      side: BorderSide(color: AppColors.loss),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => viewModel.verifyUser(user),
                    icon: const Icon(Icons.check),
                    label: const Text('Verify'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.profit,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _maskAadhaar(String? aadhaar) {
    if (aadhaar == null || aadhaar.length < 4) return 'Not provided';
    return 'XXXX-XXXX-${aadhaar.substring(aadhaar.length - 4)}';
  }

  @override
  AdminVerificationViewModel viewModelBuilder(BuildContext context) =>
      AdminVerificationViewModel();

  @override
  void onViewModelReady(AdminVerificationViewModel viewModel) =>
      viewModel.initialize();
}
