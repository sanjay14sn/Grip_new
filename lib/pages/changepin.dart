import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grip/components/Dotloader.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:sizer/sizer.dart';
import '../backend/api-requests/no_auth_api.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final currentPinController = TextEditingController();
  final newPinController = TextEditingController();
  final confirmPinController = TextEditingController();

  bool isLoading = false;

  // Visibility states for each PIN field
  bool _showCurrentPin = false;
  bool _showNewPin = false;
  bool _showConfirmPin = false;

  Future<void> _handleChangePin() async {
    final currentPin = currentPinController.text.trim();
    final newPin = newPinController.text.trim();
    final confirmPin = confirmPinController.text.trim();

    // Validation
    if (currentPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
      ToastUtil.showToast(context, "Please fill all fields");
      return;
    }
    if (currentPin.length != 4 ||
        newPin.length != 4 ||
        confirmPin.length != 4) {
      ToastUtil.showToast(context, "All PINs must be exactly 4 digits");
      return;
    }
    if (newPin != confirmPin) {
      ToastUtil.showToast(context, "New PINs do not match");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await PublicRoutesApiService.changePin(
        currentPin: currentPin,
        newPin: newPin,
      );

      setState(() => isLoading = false);

      if (response.isSuccess) {
        ToastUtil.showToast(
            context, response.message ?? "PIN updated successfully");
        Navigator.pop(context);
      } else {
        ToastUtil.showToast(
            context, response.message ?? "Failed to update PIN");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ToastUtil.showToast(context, "Something went wrong");
    }
  }

  @override
  void dispose() {
    currentPinController.dispose();
    newPinController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text("Change PIN"),
            centerTitle: true,
            backgroundColor: const Color(0xFFFF3534),
          ),
          body: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter your current PIN and choose a new one.",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 3.h),
                _pinField("Current PIN", currentPinController, _showCurrentPin,
                    () {
                  setState(() => _showCurrentPin = !_showCurrentPin);
                }),
                SizedBox(height: 2.h),
                _pinField("New PIN", newPinController, _showNewPin, () {
                  setState(() => _showNewPin = !_showNewPin);
                }),
                SizedBox(height: 2.h),
                _pinField(
                    "Confirm New PIN", confirmPinController, _showConfirmPin,
                    () {
                  setState(() => _showConfirmPin = !_showConfirmPin);
                }),
                SizedBox(height: 4.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF3534),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLoading ? null : _handleChangePin,
                    child: isLoading
                        ? const DotLoader(
                            color: Colors.white, size: 8, dotCount: 3)
                        : Text(
                            "Update PIN",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 2.h),
                Center(
                  child: Text(
                    "Your PIN should be exactly 4 digits.",
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _pinField(String label, TextEditingController controller,
      bool isVisible, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      keyboardType: TextInputType.number,
      maxLength: 4,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        if (value.length == 4) {
          FocusScope.of(context).unfocus(); // Close keyboard
        }
      },
      decoration: InputDecoration(
        labelText: label,
        counterText: "",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
