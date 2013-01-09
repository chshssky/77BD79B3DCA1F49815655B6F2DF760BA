#import <UIKit/UIKit.h>

#define  REFRESH_REGION_HEIGHT 5.0f


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
    UIActivityIndicatorView *_activityView;
}

@property(nonatomic,retain) id <LoadMoreTableFooterDelegate> delegate;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)setFooterLabelIfNoMoreData;
- (void)setFooterLabelIfHasData;
@end

@protocol LoadMoreTableFooterDelegate
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view;
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view;
@end