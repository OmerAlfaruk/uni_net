import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_link/common_widget/profile_widget/profile_widget.dart';
import 'package:uni_link/constant/color.dart';
import 'package:uni_link/constant/const.dart';
import 'package:uni_link/features/post/domain/entities/post_entity.dart';
import 'package:uni_link/features/post/presentation/manager/post/post_cubit.dart';
import 'package:uni_link/features/post/presentation/pages/post/post_detail_page.dart';
import 'package:uni_link/features/profile/presentation/pages/single_user_profile_page.dart';
import 'package:uni_link/features/search/presentation/pages/search/widget/search_wiget.dart';
import 'package:uni_link/features/user/domain/user_entity/user_entity.dart';
import 'package:uni_link/features/user/presentation/manager/user/user_cubit/user/user_cubit.dart';

class SearchMainWidget extends StatefulWidget {

  const SearchMainWidget({Key? key}) : super(key: key);

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUsers(user: UserEntity());
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    super.initState();

    _searchController.addListener(() {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            if (userState is UserLoaded) {
              final filterAllUsers = userState.users.where((user) =>
              user.username!.startsWith(_searchController.text) ||
                  user.username!.toLowerCase().startsWith(_searchController.text.toLowerCase()) ||
                  user.username!.contains(_searchController.text) ||
                  user.username!.toLowerCase().contains(_searchController.text.toLowerCase())
              ).toList();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: ()=>Get.back(),
                          child: Icon(Icons.arrow_back),
                        ),
                        sizeHor(6),
                        Expanded(
                          child: SearchWidget(
                            controller: _searchController,
                          ),
                        ),
                      ],
                    ),
                    sizeVer(10),
                    _searchController.text.isNotEmpty ? Expanded(
                      child: ListView.builder(itemCount: filterAllUsers.length,itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(()=>SingleUserProfilePage(otherUserId: "${filterAllUsers[index].uid}"));
                          },
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: profileWidget(imageUrl: filterAllUsers[index].profileUrl),
                                ),
                              ),
                              sizeHor(10),
                              Text("${filterAllUsers[index].username}", style: TextStyle(color: oPrimaryColor, fontSize: 15, fontWeight: FontWeight.w600),)
                            ],
                          ),
                        );
                      }),
                    ) :BlocBuilder<PostCubit, PostState>(
                      builder: (context, postState) {
                        if (postState is PostLoaded) {
                          final posts = postState.post;
                          return Expanded(
                            child: GridView.builder(
                                itemCount: posts.length,
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(()=>PostDetailPage(postId: '${posts[index].postId}',));},
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: profileWidget(
                                          imageUrl: posts[index].postImageUrl
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }
                        return Center(child: CircularProgressIndicator(),);
                      },
                    )
                  ],
                ),
              );

            }
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}