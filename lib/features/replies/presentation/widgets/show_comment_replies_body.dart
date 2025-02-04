
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:twitter_app/core/utils/app_colors.dart';
// import 'package:twitter_app/core/utils/app_text_styles.dart';
// import 'package:twitter_app/core/widgets/horizontal_gap.dart';
// import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
// import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
// import 'package:twitter_app/features/replies/presentation/cubits/get_comment_replies_cubit/get_comment_replies_cubit.dart';
// import 'package:twitter_app/features/replies/presentation/widgets/custom_reply_info_card.dart';

// class ShowCommentRepliesBody extends StatefulWidget {
//   const ShowCommentRepliesBody({
//     super.key,
//     required this.commentDetailsEntity,
//     required this.replies,
//   });
//   final CommentDetailsEntity commentDetailsEntity;
//   final List<ReplyDetailsEntity> replies;
//   @override
//   State<ShowCommentRepliesBody> createState() =>
//       _ShowCommentRepliesBodyState();
// }

// class _ShowCommentRepliesBodyState extends State<ShowCommentRepliesBody> {
//   bool isRepliesHidden = true;
  
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Visibility(
//           visible: isRepliesHidden,
//           child: GestureDetector(
//             onTap: () {
//               setState(() {
//                 isRepliesHidden = false;
//               });
//               BlocProvider.of<GetCommentRepliesCubit>(context)
//                   .getCommentReplies(
//                 commentId: widget.commentDetailsEntity.commentId,
//               );
//             },
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Divider(
//                     color: AppColors.thirdColor,
//                   ),
//                 ),
//                 const HorizontalGap(12),
//                 Expanded(
//                   flex: 6,
//                   child: Row(
//                     children: [
//                       Text(
//                         "View ${widget.commentDetailsEntity.comment.repliesCount} replies",
//                         style: AppTextStyles.uberMoveMedium16.copyWith(
//                           color: AppColors.thirdColor,
//                         ),
//                       ),
//                       Icon(
//                         Icons.keyboard_arrow_down,
//                         size: 20,
//                         color: AppColors.thirdColor,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Column(
//           children: widget.replies
//               .map((reply) => CustomReplyInfoCard(replyDetailsEntity: reply))
//               .toList(),
//         ),
//         Visibility(
//           visible: !isRepliesHidden,
//           child: GestureDetector(
//             onTap: () {
//               setState(() {
//                 isRepliesHidden = true;
//               });
//             },
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Divider(
//                     color: AppColors.thirdColor,
//                   ),
//                 ),
//                 const HorizontalGap(12),
//                 Expanded(
//                   flex: 6,
//                   child: Row(
//                     children: [
//                       Text(
//                         "Hide",
//                         style: AppTextStyles.uberMoveMedium16.copyWith(
//                           color: AppColors.thirdColor,
//                         ),
//                       ),
//                       Icon(
//                         Icons.keyboard_arrow_up,
//                         size: 20,
//                         color: AppColors.thirdColor,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
