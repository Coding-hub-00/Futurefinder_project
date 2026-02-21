import 'package:flutter/material.dart';
import '../models/linkedin_job.dart';
import '../services/linkedin_service.dart';

class TrendingCareersScreen extends StatefulWidget {
  @override
  _TrendingCareersScreenState createState() => _TrendingCareersScreenState();
}

class _TrendingCareersScreenState extends State<TrendingCareersScreen> {
  List<LinkedInJob> jobs = [];
  bool isLoading = true;
  String? errorMessage;
  final searchController = TextEditingController(text: 'software developer');

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs([String? keywords]) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedJobs = await LinkedInService.searchJobs(
        keywords: keywords ?? searchController.text,
      );
      setState(() {
        jobs = fetchedJobs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending Careers'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search careers...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FilledButton(
                  onPressed: () => fetchJobs(),
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Fetching trending careers...'),
                      ],
                    ),
                  )
                : errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red),
                            SizedBox(height: 16),
                            Text(
                              'Failed to load careers',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(height: 8),
                            Text(
                              errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 16),
                            FilledButton(
                              onPressed: fetchJobs,
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : jobs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.work_off, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('No careers found'),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => fetchJobs(),
                            child: ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: jobs.length,
                              itemBuilder: (context, index) {
                                return CareerCard(job: jobs[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class CareerCard extends StatelessWidget {
  final LinkedInJob job;

  const CareerCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        job.company,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.bookmark_border,
                  color: Colors.grey[600],
                ),
              ],
            ),
            
            SizedBox(height: 8),
            
            // Location
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  job.location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Description
            Text(
              job.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            SizedBox(height: 16),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (job.postedDate != null)
                  Text(
                    'Posted: ${job.postedDate}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  )
                else
                  SizedBox(),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        // Show more details
                        showDialog(
                          context: context,
                          builder: (context) => JobDetailsDialog(job: job),
                        );
                      },
                      child: Text('Details'),
                    ),
                    SizedBox(width: 8),
                    FilledButton(
                      onPressed: job.applyUrl != null
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Opening application link...'),
                                ),
                              );
                            }
                          : null,
                      child: Text('Apply'),
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
}

class JobDetailsDialog extends StatelessWidget {
  final LinkedInJob job;

  const JobDetailsDialog({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(job.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              job.company,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16),
                SizedBox(width: 4),
                Text(job.location),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(job.description),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
        if (job.applyUrl != null)
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening application link...')),
              );
            },
            child: Text('Apply Now'),
          ),
      ],
    );
  }
}