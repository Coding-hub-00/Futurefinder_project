import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/career_provider.dart';
import '../models/job.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveJobsScreen extends StatefulWidget {
  @override
  _LiveJobsScreenState createState() => _LiveJobsScreenState();
}

class _LiveJobsScreenState extends State<LiveJobsScreen> {
  final _searchController = TextEditingController();
  String _selectedLocation = 'us';
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CareerProvider>(context, listen: false).loadLiveJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Job Opportunities'),
        backgroundColor: Color(0xFF2874F0),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSearchFilters(),
          Expanded(child: _buildJobsList()),
        ],
      ),
    );
  }

  Widget _buildSearchFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search jobs...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _searchJobs,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2874F0)),
                child: Text('Search', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text('Location: '),
              DropdownButton<String>(
                value: _selectedLocation,
                items: [
                  DropdownMenuItem(value: 'us', child: Text('United States')),
                  DropdownMenuItem(value: 'in', child: Text('India')),
                  DropdownMenuItem(value: 'uk', child: Text('United Kingdom')),
                  DropdownMenuItem(value: 'ca', child: Text('Canada')),
                ],
                onChanged: (value) => setState(() => _selectedLocation = value!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    return Consumer<CareerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingJobs) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.liveJobs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No jobs found', style: TextStyle(fontSize: 18)),
                Text('Try different search terms'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: provider.liveJobs.length,
          itemBuilder: (context, index) => _buildJobCard(provider.liveJobs[index]),
        );
      },
    );
  }

  Widget _buildJobCard(Job job) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (job.salary != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(job.salary!, style: TextStyle(color: Colors.green[700])),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.business, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(job.employer, style: TextStyle(color: Colors.grey[600])),
                SizedBox(width: 16),
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(job.location, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: 12),
            Text(
              job.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(height: 1.4),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (job.postedDate != null)
                  Text(
                    'Posted: ${_formatDate(job.postedDate!)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                Row(
                  children: [
                    if (job.applyUrl != null)
                      ElevatedButton(
                        onPressed: () => _launchUrl(job.applyUrl!),
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2874F0)),
                        child: Text('Apply', style: TextStyle(color: Colors.white)),
                      ),
                    SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _showApplicationDialog(job),
                      child: Text('Track Application'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _searchJobs() {
    final query = _searchController.text.isNotEmpty ? _searchController.text : 'developer';
    Provider.of<CareerProvider>(context, listen: false)
        .loadLiveJobs(query: query, location: _selectedLocation);
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date).inDays;
      if (diff == 0) return 'Today';
      if (diff == 1) return 'Yesterday';
      return '${diff}d ago';
    } catch (e) {
      return 'Recently';
    }
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  
  void _showApplicationDialog(Job job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Track Application'),
        content: Text('Track your application for ${job.title} at ${job.employer}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Application tracked successfully!')),
              );
            },
            child: Text('Track'),
          ),
        ],
      ),
    );
  }
}