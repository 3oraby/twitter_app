
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/comments/presentation/widgets/custom_make_reply_section.dart';
import 'package:twitter_app/features/comments/presentation/widgets/show_tweet_comments_part.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_main_details_tweet_card.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class ShowTweetCommentsScreen extends StatelessWidget {
  const ShowTweetCommentsScreen({
    super.key,
    required this.tweetDetailsEntity,
  });

  static const String routeId = 'kShowTweetCommentsScreen';
  final TweetDetailsEntity tweetDetailsEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        title: Text(
          "Post",
          style: AppTextStyles.uberMoveBlack20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomMainDetailsTweetCard(
                      tweetDetailsEntity: tweetDetailsEntity,
                    ),
                    const Divider(
                      color: AppColors.dividerColor,
                      height: 32,
                    ),
                    ShowTweetCommentsPart(
                        tweetDetailsEntity: tweetDetailsEntity),
                  ],
                ),
              ),
            ),
            CustomMakeReplySection(
              tweetDetailsEntity: tweetDetailsEntity,
            ),
            const VerticalGap(16),
          ],
        ),
      ),
    );
  }
}



// class ExpandedMakeReplySection extends StatefulWidget {
//   const ExpandedMakeReplySection({
//     super.key,
//     required this.currentUser,
//     required this.tweetDetailsEntity,
//   });
//   final UserEntity currentUser;
//   final TweetDetailsEntity tweetDetailsEntity;

//   @override
//   State<ExpandedMakeReplySection> createState() =>
//       _ExpandedMakeReplySectionState();
// }

// class _ExpandedMakeReplySectionState extends State<ExpandedMakeReplySection> {
//   late FocusNode _focusNode;
//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//     // Delay focus request to ensure the widget is fully built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _focusNode.requestFocus();
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlidingUpPanel(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             ListTile(
//               contentPadding: EdgeInsets.all(0),
//               leading: BuildUserCircleAvatarImage(
//                 profilePicUrl: widget.currentUser.profilePicUrl,
//                 circleAvatarRadius: 20,
//               ),
//               title: Text(
//                 "${widget.currentUser.firstName} ${widget.currentUser.lastName}",
//               ),
//               subtitle: Text(widget.currentUser.email),
//             ),
//             VerticalGap(4),
//             Row(
//               children: [
//                 Text("Replying to"),
//                 Text("@${widget.currentUser.email}"),
//               ],
//             ),
//             VerticalGap(12),
//             CustomTextFormFieldWidget(
//               hintText: "Post your reply",
//               contentPadding: 16,
//               focusNode: _focusNode,
//             ),
//             VerticalGap(8),
//             Row(
//               children: [],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
