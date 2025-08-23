import 'package:flutter/material.dart';
import '../services/referral_service.dart';

class ReferralApplySheet extends StatefulWidget {
  const ReferralApplySheet({super.key});

  @override
  State<ReferralApplySheet> createState() => _ReferralApplySheetState();
}

class _ReferralApplySheetState extends State<ReferralApplySheet> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20, right: 20, top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Have a referral code?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter code (e.g., ABC123)',
              filled: true,
            ),
          ),
          const SizedBox(height: 12),
          if (_message != null)
            Text(_message!,
                style: TextStyle(
                    color: _message!.startsWith('Referral applied') ? Colors.greenAccent : Colors.redAccent)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loading ? null : () async {
              setState(() { _loading = true; _message = null; });
              final msg = await ReferralService().applyReferralCode(_controller.text);
              setState(() { _loading = false; _message = msg; });
            },
            child: _loading ? const SizedBox(
              width: 18, height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ) : const Text('Apply Code'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
