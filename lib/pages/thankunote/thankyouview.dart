import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/components/filter.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class Thankyouviewpage extends StatefulWidget {
  final List<dynamic> givenNotes;

  const Thankyouviewpage({super.key, required this.givenNotes});

  @override
  State<Thankyouviewpage> createState() => _ThankyouviewpageState();
}

class _ThankyouviewpageState extends State<Thankyouviewpage> {
  bool isReceivedSelected = false;
  bool _isLoading = false;
  List<dynamic> receivedNotes = [];

  @override
  void initState() {
    super.initState();
    _loadReceivedThankYouNotes();
  }

  Future<void> _loadReceivedThankYouNotes() async {
    print('🌐 Fetching received thank you notes...');
    final response = await PublicRoutesApiService.fetchReceivedThankYouNotes();
    print('📥 API Response: ${response.statusCode} - ${response.message}');

    if (response.isSuccess && response.data != null) {
      final List<dynamic> list = response.data is List
          ? response.data
          : []; // Protect against wrong type

      print('✅ Fetched ${list.length} received notes');
      for (var note in list) {
        print(
          '📝 Note: ${note['_id']} from '
          '${note['fromMember']?['personalDetails']?['firstName']} '
          'to ${note['toMember']?['personalDetails']?['firstName']}',
        );
      }

      setState(() {
        receivedNotes = list;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      print('❌ Failed to fetch received notes: ${response.message}');
      print('📛 Full response data: ${response.data}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGiven = !isReceivedSelected;
    final data = isGiven ? widget.givenNotes : receivedNotes;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: "Dismiss",
                        barrierColor: Colors.transparent,
                        transitionDuration: const Duration(milliseconds: 200),
                        pageBuilder: (_, __, ___) {
                          return Stack(
                            children: [
                              Positioned(
                                top: 60,
                                right: 16,
                                child: Material(
                                  color: Colors.transparent,
                                  child: FilterDialog(),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.filter_alt_outlined),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Title
              Row(
                children: [
                  Text('Thank U Note Details', style: TTextStyles.ReferralSlip),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/handshake.png',
                    width: 34,
                    height: 34,
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),

              // Toggle
              Text('Category:', style: TTextStyles.Category),
              SizedBox(height: 1.h),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isReceivedSelected = false),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:
                                !isReceivedSelected ? Tcolors.red_button : null,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Given',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: !isReceivedSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isReceivedSelected = true),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:
                                isReceivedSelected ? Tcolors.red_button : null,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Received',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isReceivedSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // List Section
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : data.isEmpty
                        ? const Center(child: Text('No data found.'))
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];

                              final name = isReceivedSelected
                                  ? "${item['fromMember']?['personalDetails']?['firstName'] ?? ''} ${item['fromMember']?['personalDetails']?['lastName'] ?? ''}"
                                  : "${item['toMember']?['personalDetails']?['firstName'] ?? ''} ${item['toMember']?['personalDetails']?['lastName'] ?? ''}";

                              final rawDate = item['createdAt'];
                              final formattedDate = rawDate != null
                                  ? DateFormat('dd-MM-yy')
                                      .format(DateTime.parse(rawDate))
                                  : '';

                              return referralTile(
                                  name,
                                  formattedDate,
                                  'assets/images/person.png',
                                  isReceivedSelected,
                                  item);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget referralTile(String name, String date, String imagePath,
      bool isReceived, dynamic item) {
    return GestureDetector(
      onTap: () {
        if (isReceived) {
          context.push('/Recivedthankyou', extra: item);
        } else {
          context.push('/Giventhankyou', extra: item);
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 0.6.h, horizontal: 2.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(imagePath),
                onBackgroundImageError: (_, __) =>
                    debugPrint('⚠️ Failed to load image'),
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
