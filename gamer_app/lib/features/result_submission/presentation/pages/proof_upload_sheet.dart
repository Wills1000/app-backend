import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/proof_upload_button.dart';
import '../widgets/proof_preview.dart';
import 'dispute_screen.dart';

enum ProofStep { conflictAlert, uploadProof, addExplanation, reviewDispute }

class ProofUploadSheet extends StatefulWidget {
  const ProofUploadSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProofUploadSheet(),
    );
  }

  @override
  State<ProofUploadSheet> createState() => _ProofUploadSheetState();
}

class _ProofUploadSheetState extends State<ProofUploadSheet> {
  ProofStep currentStep = ProofStep.conflictAlert;
  bool isFileUploaded = false;
  final explanationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF121214),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            if (currentStep != ProofStep.conflictAlert) _buildStepperHeader(),
            const SizedBox(height: 16),
            Expanded(child: _buildStepContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperHeader() {
    int activeIndex = currentStep == ProofStep.uploadProof ? 2 : (currentStep == ProofStep.addExplanation ? 2 : 3);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(1, 'Result', true),
        _buildStepLine(true),
        _buildStepCircle(2, 'Proof', activeIndex >= 2),
        _buildStepLine(activeIndex >= 3),
        _buildStepCircle(3, 'Confirm', activeIndex >= 3),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label, bool isActive) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive ? AppColors.primaryRed : Colors.grey[800],
          child: Text('$step', style: const TextStyle(color: AppColors.textWhite, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: isActive ? AppColors.textWhite : AppColors.textMuted, fontSize: 11)),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(width: 20, height: 1, margin: const EdgeInsets.symmetric(horizontal: 8), color: isActive ? AppColors.primaryRed : Colors.grey[800]);
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case ProofStep.conflictAlert:
        return _buildConflictAlert();
      case ProofStep.uploadProof:
        return _buildUploadProof();
      case ProofStep.addExplanation:
        return _buildAddExplanation();
      case ProofStep.reviewDispute:
        return _buildReviewDispute();
    }
  }

  // STEP 1: CONFLICT ALERT
  Widget _buildConflictAlert() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.warning_amber_rounded, color: AppColors.primaryRed, size: 60),
        const SizedBox(height: 12),
        const Text("SCORES DON'T MATCH", style: TextStyle(color: AppColors.primaryRed, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('The submitted scores are different.\nPlease submit proof to continue.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 24),

        _buildScoreRow('YOUR SUBMISSION', 'DaPrince (You)', '25 - 18', 'Submitted 1 min ago'),
        const SizedBox(height: 12),
        _buildScoreRow('OPPONENT SUBMISSION', 'qqgamerbeast', '21 - 17', 'Submitted just now'),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => setState(() => currentStep = ProofStep.uploadProof),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('SUBMIT PROOF', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white.withOpacity(0.1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  // STEP 2: UPLOAD PROOF
  Widget _buildUploadProof() {
    return Column(
      children: [
        const Text('UPLOAD PROOF', style: TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Upload screenshot or video as proof of your match result.', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 24),

        if (!isFileUploaded)
          ProofUploadButton(onTap: () => setState(() => isFileUploaded = true))
        else
          ProofPreviewWidget(
            fileName: 'codm_match_result.png',
            fileSize: '1.4 MB',
            onDelete: () => setState(() => isFileUploaded = false),
          ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isFileUploaded ? () => setState(() => currentStep = ProofStep.addExplanation) : null,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('CONTINUE', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // STEP 3: ADD EXPLANATION
  Widget _buildAddExplanation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(child: Text('ADD EXPLANATION', style: TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold))),
        const SizedBox(height: 4),
        const Center(child: Text('Provide a brief explanation (optional) to help our team review your case.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 11))),
        const SizedBox(height: 20),

        Material(
          color: const Color(0xFF16161A),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: TextField(
              controller: explanationController,
              maxLines: 4,
              style: const TextStyle(color: AppColors.textWhite, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Opponent left the match early...',
                hintStyle: TextStyle(color: AppColors.textMuted),
                border: InputBorder.none,
              ),
            ),
          ),
        ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => setState(() => currentStep = ProofStep.reviewDispute),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('CONTINUE', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // STEP 4: REVIEW & SUBMIT DISPUTE
  Widget _buildReviewDispute() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(child: Text('REVIEW DISPUTE', style: TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold))),
        const SizedBox(height: 20),

        _buildSummaryBlock('YOUR SUBMISSION', 'Winner: DaPrince (You)', 'Score: 25 - 18'),
        const SizedBox(height: 12),
        _buildSummaryBlock('PROOF FILE', 'codm_match_result.png', '1.4 MB'),
        const SizedBox(height: 12),
        _buildSummaryBlock('EXPLANATION', explanationController.text.isEmpty ? 'No explanation provided.' : explanationController.text, ''),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DisputeScreen()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('SUBMIT DISPUTE', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreRow(String title, String name, String score, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF16161A), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 9)),
            const SizedBox(height: 4),
            Text(name, style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 12)),
          ]),
          Text(score, style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSummaryBlock(String label, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF16161A), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 9)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 12)),
          if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}