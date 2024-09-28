#import "FavouriteMoviesStorage.h"
#import "react_native_movie_list-Swift.h"

@implementation FavouriteMoviesStorage
RCT_EXPORT_MODULE()

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params {
    return std::make_shared<facebook::react::NativeFavouriteMoviesStorageSpecJSI>(params);
}

- (NSDictionary *)dictionaryFromFavouriteMovie:(IntermediateFavouriteMovie *)movie {
    return @{
        @"id": @(movie.id),
        @"url": movie.url,
        @"title": movie.title,
        @"rating": movie.rating
    };
}

- (NSArray<NSDictionary *> *)getFavouriteMovies {
    NSArray *movies = [[FavouriteMoviesManager shared] fetchAllFavouriteMoviesAsList];
    NSMutableArray *result = [NSMutableArray array];
    for (IntermediateFavouriteMovie *movie in movies) {
        [result addObject:[self dictionaryFromFavouriteMovie:movie]];
    }
    return result;
}

- (void)removeAllFavouriteMovies:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    [[FavouriteMoviesManager shared] removeAllFavouriteMoviesOnSuccess:^{
        resolve(@YES);
    } onError:^(NSError * _Nonnull error) {
        reject(@"remove_all_favourite_movies_error", error.localizedDescription, error);
    }];
}

- (void)removeFavouriteMovie:(double)movieId resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    [[FavouriteMoviesManager shared] removeFavouriteMovieByID:movieId onSuccess:^(NSArray<IntermediateFavouriteMovie *> * _Nonnull movies) {
        NSMutableArray *result = [NSMutableArray array];
        for (IntermediateFavouriteMovie *movie in movies) {
            [result addObject:[self dictionaryFromFavouriteMovie:movie]];
        }
        resolve(result);
    } onError:^(NSError * _Nonnull error) {
        reject(@"remove_favourite_movie_error", error.localizedDescription, error);
    }];
}

- (void)addFavouriteMovie:(JS::NativeFavouriteMoviesStorage::FavouriteMovie &)movie resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    IntermediateFavouriteMovie *swiftMovie = [[IntermediateFavouriteMovie alloc] initWithId:movie.id_()
                                                                                        url:movie.url()
                                                                                      title:movie.title()
                                                                                     rating:movie.rating()];
    
    [[FavouriteMoviesManager shared] addFavouriteMovie:swiftMovie onSuccess:^(NSArray<IntermediateFavouriteMovie *> * _Nonnull movies) {
        NSMutableArray *result = [NSMutableArray array];
        for (IntermediateFavouriteMovie *movie in movies) {
            [result addObject:[self dictionaryFromFavouriteMovie:movie]];
        }
        resolve(result);
    } onError:^(NSError * _Nonnull error) {
        reject(@"add_favourite_movie_error", error.localizedDescription, error);
    }];
}

@end
