import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uni_link/features/post/domain/entities/post_entity.dart';
import 'package:uni_link/features/post/domain/use_cases/read_single_post_usecase.dart';




part 'get_single_post_state.dart';

class GetSinglePostCubit extends Cubit<GetSinglePostState> {
final ReadSinglePostUseCase readSinglePostUseCase;
GetSinglePostCubit({required this.readSinglePostUseCase}) : super(GetSinglePostInitial());

Future<void> getSinglePost({required String postId}) async {
emit(GetSinglePostLoading());
try {
final streamResponse = readSinglePostUseCase.call(postId);
streamResponse.listen((posts) {
emit(GetSinglePostLoaded(post:posts.first));
});
} on SocketException catch(_) {
emit(GetSinglePostFailure());
} catch (_) {
emit(GetSinglePostFailure());
}
}
}
