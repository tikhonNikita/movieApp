#import "MovieListView.h"
#import <react/renderer/components/RNMovieList/ComponentDescriptors.h>
#import <react/renderer/components/RNMovieList/EventEmitters.h>
#import <react/renderer/components/RNMovieList/Props.h>
#import <react/renderer/components/RNMovieList/RCTComponentViewHelpers.h>
#import "RCTFabricComponentsPlugins.h"
#import "React/RCTConversions.h"

using namespace facebook::react;

template <typename StatusType>
NetworkStatus convertToNetworkStatus(StatusType status) {
    switch (status) {
        case StatusType::Loading:
            return [NetworkStatusHelper createLoading];
        case StatusType::Error:
            return [NetworkStatusHelper createError];
        case StatusType::Success:
            return [NetworkStatusHelper createSuccess];
    }
}

@interface MovieListView () <RCTMovieListViewViewProtocol>
@end

@implementation MovieListView {
    MovieListViewController *_movieListViewController;
    UIView *_view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
    return concreteComponentDescriptorProvider<MovieListViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        static const auto defaultProps = std::make_shared<const MovieListViewProps>();
        _props = defaultProps;
        
        _movieListViewController = [MovieListViewController createViewController];
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) {
        [self setupView];
    }
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps {
    const auto &oldViewProps = *std::static_pointer_cast<MovieListViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<MovieListViewProps const>(props);
    
    [self updateMovieListAndStatusIfNeeded:oldViewProps newProps:newViewProps];
    [self updateMovieDetailsStatusAndMovieDetilsIfNeeded:oldViewProps newProps:newViewProps];
    [self setupEventHandlers];
    
    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> MovieListViewCls(void) {
    return MovieListView.class;
}

#pragma mark - Private Methods

- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]]) {
        responder = [responder nextResponder];
    }
    return [responder isKindOfClass:[UIViewController class]] ? (UIViewController *)responder : nil;
}

- (void)setupView {
    UIViewController *parentViewController = [self parentViewController];
    if (parentViewController) {
        UIView *swiftUIView = _movieListViewController.view;
        [self addSubview:swiftUIView];
        [self setupViewConstraintsFor:swiftUIView];
        [self addChildViewController:_movieListViewController toParentViewController:parentViewController];
    }
}

- (void)setupViewConstraintsFor:(UIView *)swiftUIView {
    swiftUIView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [swiftUIView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [swiftUIView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [swiftUIView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [swiftUIView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)addChildViewController:(UIViewController *)childViewController toParentViewController:(UIViewController *)parentViewController {
    [parentViewController addChildViewController:childViewController];
    [childViewController didMoveToParentViewController:parentViewController];
}

- (void)updateMovieListAndStatusIfNeeded:(const MovieListViewProps &)oldProps newProps:(const MovieListViewProps &)newProps {
    if (oldProps.movieListStatus != newProps.movieListStatus) {
        NetworkStatus status = convertToNetworkStatus(newProps.movieListStatus);
        [_movieListViewController updateMovieListStatusWithStatus:status];
        
        if(newProps.movieListStatus == facebook::react::MovieListViewMovieListStatus::Success) {
            NSArray<Movie *> *newMoviesArray = [self convertToMoviesList:newProps.movies];
            [_movieListViewController updateMoviesWithMovies:newMoviesArray];
        }
    }
}

- (void)updateMovieDetailsStatusAndMovieDetilsIfNeeded:(const MovieListViewProps &)oldProps newProps:(const MovieListViewProps &)newProps {
    if (oldProps.movieDetailsStatus != newProps.movieDetailsStatus) {
        NetworkStatus status = convertToNetworkStatus(newProps.movieDetailsStatus);
        [_movieListViewController updateSelectedMovieDetailsStatusWithStatus:status];
    }
    
    if (![self areMovieDetailsEqual:oldProps.movieDetails rhs:newProps.movieDetails]) {
        MovieDetails *newMovieDetails = [self convertToMovieDetails:newProps.movieDetails];
        [_movieListViewController updateSelectedMovieDetailsWithSelectedMovie:newMovieDetails];
    }
    
}


- (void)setupEventHandlers {
    __weak MovieListView *weakSelf = self;
    
    [_movieListViewController updateOnMovieAddedToFavoritesHandlerOnAddToFavourites:^(NSInteger movieId) {
        __strong MovieListView *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf onMovieAddedToFavorites:movieId];
        }
    }];
    
    [_movieListViewController updateOnMovieRemovedFromFavoritesHandlerOnMovieRemove:^(NSInteger movieId) {
        __strong MovieListView *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf onMovieRemovedFromFavorites:movieId];
        }
    }];
    
    [_movieListViewController updateOnMoviePressHandlerOnMoviePress:^(NSInteger movieId) {
        __strong MovieListView *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf onMoviePress:movieId];
        }
    }];
    
    [_movieListViewController updateOnMoreMoviesRequestedOnMoreMoviesRequested:^() {
        __strong MovieListView *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf onMoreMoviesRequested];
        }
    }];
}

- (NSArray<Movie *> *)convertToMoviesList:(const std::vector<MovieListViewMoviesStruct> &)moviesStruct {
    NSMutableArray<Movie *> *moviesArray = [NSMutableArray arrayWithCapacity:moviesStruct.size()];
    
    for (const auto &movieStruct : moviesStruct) {
        Movie *movie = [Movie createWithId:movieStruct.id
                                       url:[NSString stringWithUTF8String:movieStruct.url.c_str()]
                                     title:[NSString stringWithUTF8String:movieStruct.title.c_str()]
                          movieDescription:[NSString stringWithUTF8String:movieStruct.movieDescription.c_str()]
                                    rating:movieStruct.rating];
        [moviesArray addObject:movie];
    }
    
    return [moviesArray copy];
}

- (MovieDetails *)convertToMovieDetails:(const MovieListViewMovieDetailsStruct &)detailsStruct {
    NSMutableArray<Genre *> *genresArray = [NSMutableArray arrayWithCapacity:detailsStruct.genres.size()];
    
    for (const auto &genreStruct : detailsStruct.genres) {
        Genre *genre = [Genre createGenreWithId:genreStruct.id
                                           name:[NSString stringWithUTF8String:genreStruct.name.c_str()]];
        [genresArray addObject:genre];
    }
    
    MovieDetails *details = [MovieDetails createWithId:detailsStruct.id
                                             posterURL:[NSString stringWithUTF8String:detailsStruct.posterURL.c_str()]
                                                 title:[NSString stringWithUTF8String:detailsStruct.title.c_str()]
                                              overview:[NSString stringWithUTF8String:detailsStruct.overview.c_str()]
                                                rating:detailsStruct.rating
                                                genres:genresArray
                                           isFavourite:detailsStruct.isFavourite];
    return details;
}

- (NetworkStatus)convertToMovieModelStatus:(MovieListViewMovieListStatus)status {
    return convertToNetworkStatus<MovieListViewMovieListStatus>(status);
}

- (NetworkStatus)convertToMovieModelStatusFromDetails:(MovieListViewMovieDetailsStatus)status {
    return convertToNetworkStatus<MovieListViewMovieDetailsStatus>(status);
}

- (void)onMoviePress:(NSInteger)movieId {
    if (_eventEmitter != nullptr) {
        auto emitter = std::dynamic_pointer_cast<const facebook::react::MovieListViewEventEmitter>(_eventEmitter);
        if (emitter) {
            emitter->onMoviePress(facebook::react::MovieListViewEventEmitter::OnMoviePress{static_cast<int>(movieId)});
        }
    }
}

- (void)onMovieAddedToFavorites:(NSInteger)movieId {
    if (_eventEmitter != nullptr) {
        auto emitter = std::dynamic_pointer_cast<const facebook::react::MovieListViewEventEmitter>(_eventEmitter);
        if (emitter) {
            emitter->onMovieAddedToFavorites(facebook::react::MovieListViewEventEmitter::OnMovieAddedToFavorites{static_cast<int>(movieId)});
        }
    }
}

- (void)onMovieRemovedFromFavorites:(NSInteger)movieId {
    if (_eventEmitter != nullptr) {
        auto emitter = std::dynamic_pointer_cast<const facebook::react::MovieListViewEventEmitter>(_eventEmitter);
        if (emitter) {
            emitter->onMovieRemovedFromFavorites(facebook::react::MovieListViewEventEmitter::OnMovieRemovedFromFavorites{static_cast<int>(movieId)});
        }
    }
}

- (void)onMoreMoviesRequested {
    if (_eventEmitter != nullptr) {
        auto emitter = std::dynamic_pointer_cast<const facebook::react::MovieListViewEventEmitter>(_eventEmitter);
        if (emitter) {
            emitter->onMoreMoviesRequested(facebook::react::MovieListViewEventEmitter::OnMoreMoviesRequested());
        }
    }
}

- (BOOL)areMovieDetailsEqual:(const MovieListViewMovieDetailsStruct &)lhs
                         rhs:(const MovieListViewMovieDetailsStruct &)rhs {
    if (lhs.id != rhs.id ||
        lhs.title != rhs.title ||
        lhs.posterURL != rhs.posterURL ||
        lhs.overview != rhs.overview ||
        lhs.rating != rhs.rating ||
        lhs.isFavourite != rhs.isFavourite) {
        return NO;
    }
    
    if (lhs.genres.size() != rhs.genres.size()) {
        return NO;
    }
    
    for (size_t i = 0; i < lhs.genres.size(); ++i) {
        const auto &genre1 = lhs.genres[i];
        const auto &genre2 = rhs.genres[i];
        if (genre1.id != genre2.id || genre1.name != genre2.name) {
            return NO;
        }
    }
    
    return YES;
}

@end
