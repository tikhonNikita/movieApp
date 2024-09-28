// This guard prevent this file to be compiled in the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>
#import "react_native_movie_list-Swift.h"

#ifndef MovieListViewNativeComponent_h
#define MovieListViewNativeComponent_h

NS_ASSUME_NONNULL_BEGIN

@interface MovieListView : RCTViewComponentView
@end

NS_ASSUME_NONNULL_END

#endif /* MovieListViewNativeComponent_h */
#endif /* RCT_NEW_ARCH_ENABLED */
