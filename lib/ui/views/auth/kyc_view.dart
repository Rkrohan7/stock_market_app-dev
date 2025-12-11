import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import 'kyc_viewmodel.dart';

class KycView extends StackedView<KycViewModel> {
  const KycView({super.key});

  @override
  Widget builder(
    BuildContext context,
    KycViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Verification'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Steps
              _buildProgressSteps(viewModel.currentStep),

              const SizedBox(height: 32),

              // Step Content
              if (viewModel.currentStep == 0) ...[
                _buildPanSection(context, viewModel),
              ] else if (viewModel.currentStep == 1) ...[
                _buildAadhaarSection(context, viewModel),
              ] else if (viewModel.currentStep == 2) ...[
                _buildSelfieSection(context, viewModel),
              ] else ...[
                _buildReviewSection(context, viewModel),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSteps(int currentStep) {
    return Row(
      children: List.generate(4, (index) {
        final isActive = index <= currentStep;
        final isCompleted = index < currentStep;

        return Expanded(
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.borderLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              if (index < 3)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted ? AppColors.primary : AppColors.borderLight,
                  ),
                ),
            ],
          ),
        );
      }),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildPanSection(BuildContext context, KycViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PAN Card Details',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ).animate().fadeIn().slideX(begin: -0.1),

        const SizedBox(height: 8),

        Text(
          'Enter your PAN card number for verification',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 24),

        TextField(
          controller: viewModel.panController,
          textCapitalization: TextCapitalization.characters,
          maxLength: 10,
          decoration: InputDecoration(
            labelText: 'PAN Number',
            hintText: 'ABCDE1234F',
            prefixIcon: const Icon(Icons.credit_card_rounded),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (_) => viewModel.validatePan(),
        ).animate().fadeIn(delay: 200.ms),

        if (viewModel.panError != null) ...[
          const SizedBox(height: 8),
          Text(
            viewModel.panError!,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
        ],

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: viewModel.canProceedFromPan ? viewModel.nextStep : null,
            child: const Text('Continue'),
          ),
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 16),

        Center(
          child: TextButton(
            onPressed: viewModel.skipKyc,
            child: const Text('Skip for now'),
          ),
        ),
      ],
    );
  }

  Widget _buildAadhaarSection(BuildContext context, KycViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aadhaar Details',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ).animate().fadeIn().slideX(begin: -0.1),

        const SizedBox(height: 8),

        Text(
          'Enter your 12-digit Aadhaar number',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 24),

        TextField(
          controller: viewModel.aadhaarController,
          keyboardType: TextInputType.number,
          maxLength: 12,
          decoration: InputDecoration(
            labelText: 'Aadhaar Number',
            hintText: '1234 5678 9012',
            prefixIcon: const Icon(Icons.fingerprint_rounded),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (_) => viewModel.validateAadhaar(),
        ).animate().fadeIn(delay: 200.ms),

        if (viewModel.aadhaarError != null) ...[
          const SizedBox(height: 8),
          Text(
            viewModel.aadhaarError!,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
        ],

        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: viewModel.previousStep,
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: viewModel.canProceedFromAadhaar ? viewModel.nextStep : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }

  Widget _buildSelfieSection(BuildContext context, KycViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selfie Verification',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ).animate().fadeIn().slideX(begin: -0.1),

        const SizedBox(height: 8),

        Text(
          'Take a clear selfie for identity verification',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 32),

        Center(
          child: GestureDetector(
            onTap: viewModel.takeSelfie,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: AppColors.primary,
                  width: 3,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: viewModel.selfieUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        viewModel.selfieUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          size: 48,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to capture',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9, 0.9)),

        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: viewModel.previousStep,
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: viewModel.nextStep,
                child: const Text('Continue'),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }

  Widget _buildReviewSection(BuildContext context, KycViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review & Submit',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ).animate().fadeIn().slideX(begin: -0.1),

        const SizedBox(height: 8),

        Text(
          'Please verify your details before submitting',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 24),

        _buildReviewItem('PAN Number', viewModel.panController.text),
        _buildReviewItem('Aadhaar Number', '****${viewModel.aadhaarController.text.substring(8)}'),
        _buildReviewItem('Selfie', viewModel.selfieUrl != null ? 'Captured' : 'Not captured'),

        const SizedBox(height: 32),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: viewModel.previousStep,
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: viewModel.isBusy ? null : viewModel.submitKyc,
                child: viewModel.isBusy
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Submit KYC'),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondaryLight,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  @override
  KycViewModel viewModelBuilder(BuildContext context) => KycViewModel();
}
