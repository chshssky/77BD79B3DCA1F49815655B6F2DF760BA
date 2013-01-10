#import "LoadMoreTableFooterView.h"


#define TEXT_COLOR   [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]


@interface LoadMoreTableFooterView (Private)
- (void)setState:(LoadMoreState)aState;
@end

@implementation LoadMoreTableFooterView

@synthesize delegate=_delegate;



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
//        UIView *footerView = [[UIView alloc] init];
//        footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"footerView.png"]];
//        footerView.frame  = CGRectMake(0, 0, 640, 300);
//        footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        [self addSubview:footerView];
//        _footerBackgroundView = footerView;
//        //_footerBackgroundView.hidden = YES;
        
        UIImage *img =[UIImage imageNamed:@"footerView.png"];
        [self setBackgroundColor:[UIColor colorWithPatternImage:img]];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, 20.0f)];
//        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        label.font = [UIFont boldSystemFontOfSize:15.0f];
//        label.textColor = TEXT_COLOR;
//        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = UITextAlignmentCenter;
//        label.text = @"没有更多数据了";
//        [self addSubview:label];
//        _statusLabel=label;
//        _statusLabel.hidden = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:15.0f];
        label.textColor = TEXT_COLOR;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.text = @"没有更多数据了";
        [self addSubview:label];
        _statusLabel=label;
        _statusLabel.hidden = YES;
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake(155.0f, 20.0f, 10.0f, 20.0f);
        [self addSubview:view];
        _activityView = view;
        
        self.hidden = YES;
        
        [self setState:LoadMoreNormal];
        _whetherRefresh = YES;
    }
    
    return self;
}


#pragma mark -
#pragma mark Setters

- (void)setState:(LoadMoreState)aState{
    switch (aState) {
        case LoadMorePulling:
            //_statusLabel.text = NSLocalizedString(@"松开即可加载...", @"Release to load more...");
            break;
        case LoadMoreNormal:
            //_statusLabel.text = NSLocalizedString(@"上拉加载更多...", @"Pull up to load more...");
            //_statusLabel.hidden = NO;
            [_activityView stopAnimating];
            break;
        case LoadMoreLoading:
            //_statusLabel.hidden = NO;
            //_statusLabel.text = NSLocalizedString(@"正在加载数据...", @"Loading Status...");
            [_activityView startAnimating];
            break;
        default:
            break;
    }
    _state = aState;
}

- (void)setFooterLabelIfNoMoreData
{
    _whetherRefresh = NO;
    _statusLabel.hidden = NO;
}

- (void)setFooterLabelIfHasData
{
    _statusLabel.hidden = YES;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
    if (_state == LoadMoreLoading) {
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
    } else if (scrollView.isDragging) {
        
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
            _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
        }
        //由于源里的LoadMoreTableFooterView只是适应320分辨率的iphone版, 所以需要修改
        /*if (_state == LoadMoreNormal && scrollView.contentOffset.y < (scrollView.contentSize.height - 260) && scrollView.contentOffset.y > (scrollView.contentSize.height - 320) && !_loading) {
         self.frame = CGRectMake(0, scrollView.contentSize.height, self.frame.size.width, self.frame.size.height);
         self.hidden = NO;
         } else if (_state == LoadMoreNormal && scrollView.contentOffset.y > (scrollView.contentSize.height - 260) && !_loading) {
         [self setState:LoadMorePulling];
         } else if (_state == LoadMorePulling && scrollView.contentOffset.y < (scrollView.contentSize.height - 260) && scrollView.contentOffset.y > (scrollView.contentSize.height - 320) && !_loading) {
         [self setState:LoadMoreNormal];
         }*/
        
        //滚动条被拖离的距离，此距离是相对的（滚动条滚动的距离 ＋ ScrollView的高度 － ScrollView内容高度），可自适应多个分辨率：
        CGFloat scrollOffsetHeight = scrollView.contentOffset.y + self.frame.size.height - scrollView.contentSize.height;
        
        //滚动条被拖离的距离小于REFRESH_REGION_HEIGHT，且滚动条被拖离的距离 > 0（向上拖动）
        if (_state == LoadMoreNormal && scrollOffsetHeight < REFRESH_REGION_HEIGHT && scrollOffsetHeight > 0 && !_loading) {
            
            self.frame = CGRectMake(0, scrollView.contentSize.height, self.frame.size.width, self.frame.size.height);
            
            self.hidden = NO;
            
        } else if (_state == LoadMoreNormal && scrollOffsetHeight > REFRESH_REGION_HEIGHT && !_loading  && _whetherRefresh == YES) {
            //滚动条被拖离的距离大于REFRESH_REGION_HEIGHT
            [self setState:LoadMorePulling];
            
        } else if (_state == LoadMorePulling && scrollOffsetHeight < REFRESH_REGION_HEIGHT && scrollOffsetHeight > 0 && !_loading  && _whetherRefresh == YES) {
            //滚动条被拖离的距离小于REFRESH_REGION_HEIGHT，且滚动条被拖离的距离 > 0（向上拖动）
            //在滚动到"松开即可加载更多..."时，如果又向下滚动（复位），又重新回到"上拉可以加载更多..."
            [self setState:LoadMoreNormal];
        }
        
        
        if (scrollView.contentInset.bottom != 0) {
            //NSLog(@"?????");
            //[self setState:LoadMorePulling];
        }
    }
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
        _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
    }
    //滚动条被拖离的距离大于REFRESH_REGION_HEIGHT
    //if (scrollView.contentOffset.y > (scrollView.contentSize.height - 260) && !_loading) {
    if (scrollView.contentOffset.y > (scrollView.contentSize.height - self.frame.size.height + REFRESH_REGION_HEIGHT) && !_loading && _whetherRefresh == YES) {
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
            [_delegate loadMoreTableFooterDidTriggerRefresh:self];
        }
        
        [self setState:LoadMoreLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        [UIView commitAnimations];
    }
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    /*[UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:.3];
     [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
     [UIView commitAnimations];*/
    
    [self setState:LoadMoreNormal];
    self.hidden = YES;
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    _delegate=nil;
    _activityView = nil;
    _statusLabel = nil;
}


@end