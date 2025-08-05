import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/AddToWishlist/addToWishlistStates.dart';
import 'package:indiclassifieds/data/cubit/Wishlist/wishlist_repository.dart';

class AddToWishlistCubit extends Cubit<AddToWishlistStates> {
  WishlistRepository wishlistRepository;
  AddToWishlistCubit(this.wishlistRepository) : super(AddToWishlistInitially());

  Future<void> addToWishlist(int product_id) async {
    emit(AddToWishlistLoading());
    try {
      final response = await wishlistRepository.addToWishlist(product_id);
      if (response != null && response.success == true) {
        emit(AddToWishlistLoaded(response, product_id));
      } else {
        emit(AddToWishlistFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(AddToWishlistFailure(e.toString()));
    }
  }
}
