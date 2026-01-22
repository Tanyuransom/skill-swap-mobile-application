import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:skillswapp_shared/skillswapp_shared.dart';
import '../controllers/social_feed_controller.dart';

class SocialFeedRoutes {
  final SocialFeedController _controller = SocialFeedController();

  Router get router {
    final router = Router();

    // Posts
    router.post('/posts', (Request request) => _controller.createPost(request));
    router.get('/posts/<postId>', (Request request, String postId) => _controller.getPost(request, postId));
    router.delete('/posts/<postId>', (Request request, String postId) => _controller.deletePost(request, postId));
    router.get('/posts/user/<userId>', (Request request, String userId) => _controller.getUserPosts(request, userId));

    // Feed
    router.get('/feed/for-you', (Request request) => _controller.getForYouFeed(request));
    router.get('/feed/following', (Request request) => _controller.getFollowingFeed(request));

    // Social
    router.post('/follow/<userId>', (Request request, String userId) => _controller.followUser(request, userId));
    router.delete('/unfollow/<userId>', (Request request, String userId) => _controller.unfollowUser(request, userId));
    router.get('/users/<userId>/stats', (Request request, String userId) => _controller.getUserStats(request, userId));

    return router;
  }

  Handler get handler {
    final router = this.router;

    final pipeline = Pipeline()
        .addMiddleware(corsMiddleware())
        .addMiddleware(loggingMiddleware())
        .addMiddleware(authMiddleware())
        .addHandler(router.call);

    return pipeline;
  }
}
