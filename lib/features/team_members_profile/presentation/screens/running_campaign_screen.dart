import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_karlfive223_manager/core/network/constants/key_constants.dart';
import 'package:flutter_karlfive223_manager/core/network/services/secure_store_services.dart';

import '../../../../core/common/widgets/app_bottom_navbar.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../team_members_profile/data/models/campaign_model.dart';

class RunningCampaignScreen extends StatefulWidget {
  const RunningCampaignScreen({super.key});

  @override
  State<RunningCampaignScreen> createState() => _RunningCampaignScreenState();
}

class _RunningCampaignScreenState extends State<RunningCampaignScreen> {
  bool _isLoading = true;
  String? _error;
  List<Campaign> _runningCampaigns = [];
  List<Campaign> _expiredCampaigns = [];
  String? _stoppingCampaignId;

  @override
  void initState() {
    super.initState();
    _fetchCampaigns();
  }

  Future<void> _fetchCampaigns() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final token =
          await SecureStoreServices().retrieveData(KeyConstants.accessToken);
      
      print('DEBUG: Token: $token');
      
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final endpointUrl = ApiConstants.coupon.manageAll;
      print('DEBUG: Calling endpoint: $endpointUrl');
      
      final response = await dio.get(endpointUrl);

      print('DEBUG: Response status code: ${response.statusCode}');
      print('DEBUG: Response data type: ${response.data.runtimeType}');
      print('DEBUG: Response data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data is String
            ? jsonDecode(response.data) as Map<String, dynamic>
            : response.data as Map<String, dynamic>;
        
        print('DEBUG: Parsed response data: $responseData');
        
        // Extract the 'data' field which contains the actual campaign data
        final actualData = responseData['data'] as Map<String, dynamic>?;
        
        print('DEBUG: Actual data: $actualData');
        
        if (actualData != null) {
          final campaignResponse = CampaignResponse.fromJson(actualData);

          print('DEBUG: Running campaigns: ${campaignResponse.coupons.running.length}');
          print('DEBUG: Expired campaigns: ${campaignResponse.coupons.expired.length}');

          setState(() {
            _runningCampaigns = campaignResponse.coupons.running;
            _expiredCampaigns = campaignResponse.coupons.expired;
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'No data in response';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Failed to load campaigns';
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('DEBUG: Error: $e');
      print('DEBUG: Stack trace: $stackTrace');
      setState(() {
        _error = 'Error loading campaigns: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _showStartCampaignDialog() {
    DateTime? startDate;
    DateTime? endDate;
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isCreating = false;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickStartDate() async {
              final picked = await showDatePicker(
                context: context,
                initialDate: startDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setDialogState(() => startDate = picked);
              }
            }

            Future<void> pickEndDate() async {
              final picked = await showDatePicker(
                context: context,
                initialDate:
                    endDate ?? (startDate ?? DateTime.now()).add(const Duration(days: 7)),
                firstDate: startDate ?? DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 730)),
              );
              if (picked != null) {
                setDialogState(() => endDate = picked);
              }
            }

            Future<void> createCoupon() async {
              if (titleController.text.isEmpty ||
                  descriptionController.text.isEmpty ||
                  startDate == null ||
                  endDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all fields'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (endDate!.isBefore(startDate!)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('End date must be after start date'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                setDialogState(() => isCreating = true);

                final token = await SecureStoreServices()
                    .retrieveData(KeyConstants.accessToken);

                print('DEBUG: Creating coupon');

                final dio = Dio(
                  BaseOptions(
                    baseUrl: ApiConstants.baseUrl,
                    headers: {
                      if (token != null) 'Authorization': 'Bearer $token',
                      'Content-Type': 'application/json',
                    },
                  ),
                );

                final payload = {
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'startDate': startDate!.toIso8601String(),
                  'endDate': endDate!.toIso8601String(),
                };

                print('DEBUG: Coupon payload: $payload');

                final response = await dio.post(
                  ApiConstants.coupon.create,
                  data: payload,
                );

                print('DEBUG: Create coupon status: ${response.statusCode}');
                print('DEBUG: Create coupon response: ${response.data}');

                if (response.statusCode == 201 || response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coupon created successfully'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Navigator.pop(dialogContext);

                  // Refresh campaigns after successful creation
                  await _fetchCampaigns();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to create coupon'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                print('DEBUG: Error creating coupon: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              } finally {
                setDialogState(() => isCreating = false);
              }
            }

            String _formatDate(DateTime dateTime) {
              final months = [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec',
              ];
              return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
            }

            return AlertDialog(
              backgroundColor: Colors.grey.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                'Create Coupon',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: const TextStyle(color: AppColors.secondaryText),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      style: const TextStyle(color: AppColors.white),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        hintStyle: const TextStyle(color: AppColors.secondaryText),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: pickStartDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade700),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.date_range,
                              color: AppColors.secondaryText,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                startDate == null
                                    ? 'Start Date'
                                    : _formatDate(startDate!),
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: pickEndDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade700),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.date_range,
                              color: AppColors.secondaryText,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                endDate == null ? 'End Date' : _formatDate(endDate!),
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                TextButton(
                  onPressed: isCreating ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isCreating ? null : createCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.buttonText,
                  ),
                  child: isCreating
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.buttonText,
                            ),
                          ),
                        )
                      : const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _stopCampaign(Campaign campaign) async {
    try {
      setState(() {
        _stoppingCampaignId = campaign.id;
      });

      final token =
          await SecureStoreServices().retrieveData(KeyConstants.accessToken);
      
      print('DEBUG: Stopping campaign ID: ${campaign.id}');
      
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final endpointUrl = ApiConstants.coupon.stopCoupon(campaign.id);
      print('DEBUG: Calling stop endpoint: $endpointUrl');
      
      final response = await dio.patch(endpointUrl);

      print('DEBUG: Stop response status: ${response.statusCode}');
      print('DEBUG: Stop response data: ${response.data}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Campaign stopped: ${campaign.title}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Refresh campaigns after successful stop
        await _fetchCampaigns();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to stop campaign'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('DEBUG: Error stopping campaign: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _stoppingCampaignId = null;
      });
    }
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.leagueBackgroundGrey,
      appBar: AppBar(
        backgroundColor: AppColors.leagueBackgroundGrey,
        elevation: 0,
        title: const Text(
          'Running Campaign',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showStartCampaignDialog,
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: AppColors.buttonText),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'View active and expired campaigns.',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    )
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _error!,
                                style: const TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchCampaigns,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryGreen,
                                  foregroundColor: AppColors.buttonText,
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _runningCampaigns.isEmpty &&
                              _expiredCampaigns.isEmpty
                          ? const Center(
                              child: Text(
                                'No campaigns',
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _fetchCampaigns,
                              color: AppColors.primaryGreen,
                              child: ListView(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  90,
                                ),
                                children: [
                                  if (_runningCampaigns.isNotEmpty) ...[
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        top: 8,
                                        bottom: 12,
                                      ),
                                      child: Text(
                                        'Running',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    ..._runningCampaigns.map(
                                      (campaign) => _CampaignCard(
                                        campaign: campaign,
                                        isRunning: true,
                                        onStopPressed: () =>
                                            _stopCampaign(campaign),
                                        formatDate: _formatDate,
                                        isStoppingCampaignId: _stoppingCampaignId,
                                      ),
                                    ),
                                  ],
                                  if (_expiredCampaigns.isNotEmpty) ...[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            _runningCampaigns.isNotEmpty
                                                ? 24
                                                : 8,
                                        bottom: 12,
                                      ),
                                      child: const Text(
                                        'Expired',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    ..._expiredCampaigns.map(
                                      (campaign) => _CampaignCard(
                                        campaign: campaign,
                                        isRunning: false,
                                        onStopPressed: () {},
                                        formatDate: _formatDate,
                                        isStoppingCampaignId: _stoppingCampaignId,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final bool isRunning;
  final VoidCallback onStopPressed;
  final String Function(DateTime) formatDate;
  final String? isStoppingCampaignId;

  const _CampaignCard({
    required this.campaign,
    required this.isRunning,
    required this.onStopPressed,
    required this.formatDate,
    this.isStoppingCampaignId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (isRunning
                          ? AppColors.primaryGreen
                          : Colors.redAccent)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_offer,
                  color:
                      isRunning
                          ? AppColors.primaryGreen
                          : Colors.redAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Code: ${campaign.code}',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (isRunning
                          ? AppColors.primaryGreen
                          : Colors.redAccent)
                      .withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isRunning ? 'Running' : 'Expired',
                  style: TextStyle(
                    color:
                        isRunning
                            ? AppColors.primaryGreen
                            : Colors.redAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            campaign.description,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 12,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate(campaign.startDate),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate(campaign.endDate),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reward Days',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${campaign.rewardDays} days',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isRunning) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isStoppingCampaignId == campaign.id ? null : onStopPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: isStoppingCampaignId == campaign.id
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Stop Campaign',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

