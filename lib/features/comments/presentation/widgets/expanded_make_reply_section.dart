import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_text_form_field.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class ExpandedMakeReplySection extends StatefulWidget {
  const ExpandedMakeReplySection({
    super.key,
    required this.currentUser,
    required this.tweetDetailsEntity,
  });

  final UserEntity currentUser;
  final TweetDetailsEntity tweetDetailsEntity;

  @override
  State<ExpandedMakeReplySection> createState() =>
      _ExpandedMakeReplySectionState();
}

class _ExpandedMakeReplySectionState extends State<ExpandedMakeReplySection> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: BuildUserCircleAvatarImage(
            profilePicUrl: widget.currentUser.profilePicUrl,
            circleAvatarRadius: 20,
          ),
          title: Text(
            "${widget.currentUser.firstName} ${widget.currentUser.lastName}",
          ),
          subtitle: Text(widget.currentUser.email),
        ),
        const VerticalGap(4),
        Row(
          children: [
            Text("Replying to"),
            Text("@${widget.currentUser.email}"),
          ],
        ),
        const VerticalGap(8),
        CustomTextFormFieldWidget(
          hintText: "Post your reply...",
          focusNode: _focusNode,
        ),
        const VerticalGap(12),
        ElevatedButton(
          onPressed: () {
            log("Reply posted");
          },
          child: Text("Reply"),
        ),
      ],
    );
  }
}
