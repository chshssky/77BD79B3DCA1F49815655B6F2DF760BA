#import <UIKit/UIKit.h>

#define  REFRESH_REGION_HEIGHT 110.0f


typedef enum{
    LoadMorePulling = 0,
    LoadMoreNormal,
    LoadMoreLoading,
} LoadMoreState;

@protocol LoadMoreTableFooterDelegate;
@interface LoadMoreTableFooterView : UIView {
    id _delegate;
    LoadMoreState _state;
    
    UILabel *_statusLabel;
    UIView *_footerBackgroundView;
    UIActivityIndicatorView *_activityView;
    BOOL _whetherRefresh;
    BOOL _internetConnect;
}

@property(nonatomic,retain) id <LoadMoreTableFooterDelegate> delegate;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)setFooterLabelIfNoMoreData;
- (void)setFooterLabelIfHasData;
- (void)setState:(LoadMoreState)aState;
- (void)setInternetConnect:(BOOL)internetConnect;
@end

@protocol LoadMoreTableFooterDelegate
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view;
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view;
@end