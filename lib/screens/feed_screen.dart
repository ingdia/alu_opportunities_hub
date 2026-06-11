import 'package:flutter/material.dart';
import '../models/opportunity.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late List<Opportunity> opportunities;
  late Map<String, bool> likedStatus;

  @override
  void initState() {
    super.initState();
    opportunities = _generateSampleOpportunities();
    likedStatus = {for (var opp in opportunities) opp.id: opp.isLiked};
  }

  List<Opportunity> _generateSampleOpportunities() {
    return [
      Opportunity(
        id: '1',
        title: 'Software Engineering Internship',
        description:
            'Join our team for a 3-month internship in mobile app development. Work on real projects and learn from experienced engineers.',
        location: 'Kacyiru, Kigali',
        category: 'Internship',
        deadline: DateTime.now().add(const Duration(days: 30)),
        author: 'Tech Corp',
        likes: 234,
      ),
      Opportunity(
        id: '2',
        title: 'Tech Conference 2024',
        description:
            'Annual tech conference featuring keynotes from industry leaders, workshops, and networking sessions.',
        location: 'Convention Center, Kigali',
        category: 'Event',
        deadline: DateTime.now().add(const Duration(days: 15)),
        author: 'Tech Events Inc',
        likes: 567,
      ),
      Opportunity(
        id: '3',
        title: 'UI/UX Design Competition',
        description:
            'Showcase your design skills in our annual competition. Win prizes and get noticed by leading companies.',
        location: 'Online',
        category: 'Competition',
        deadline: DateTime.now().add(const Duration(days: 45)),
        author: 'Design Community',
        likes: 123,
      ),
      Opportunity(
        id: '4',
        title: 'Full Stack Developer Job Opening',
        description:
            'We are hiring experienced full stack developers. Competitive salary, remote options available.',
        location: 'Remote',
        category: 'Job',
        deadline: DateTime.now().add(const Duration(days: 60)),
        author: 'StartUp XYZ',
        likes: 456,
      ),
      Opportunity(
        id: '5',
        title: 'Web Development Workshop',
        description:
            'Learn modern web development techniques with React and Node.js. Beginner to intermediate level.',
        location: 'Norrsken',
        category: 'Workshop',
        deadline: DateTime.now().add(const Duration(days: 21)),
        author: 'Code Academy',
        likes: 89,
      ),
    ];
  }

  void _toggleLike(String opportunityId) {
    setState(() {
      likedStatus[opportunityId] = !likedStatus[opportunityId]!;
    });
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return 'In ${difference.inDays} days';
    } else {
      return 'In ${(difference.inDays / 7).ceil()} weeks';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunities Feed'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: opportunities.length,
        itemBuilder: (context, index) {
          final opportunity = opportunities[index];
          final isLiked = likedStatus[opportunity.id] ?? false;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with category badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(opportunity.category),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          opportunity.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        _formatDeadline(opportunity.deadline),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    opportunity.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    opportunity.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Location and Author
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        opportunity.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'by ${opportunity.author}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Like and Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _toggleLike(opportunity.id),
                        child: Row(
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color:
                                  isLiked ? Colors.red : Colors.grey[600],
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isLiked
                                  ? '${opportunity.likes + 1}'
                                  : '${opportunity.likes}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Applied to ${opportunity.title}!',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('Apply Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Internship':
        return Colors.blue;
      case 'Event':
        return Colors.purple;
      case 'Competition':
        return Colors.orange;
      case 'Job':
        return Colors.green;
      case 'Workshop':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
