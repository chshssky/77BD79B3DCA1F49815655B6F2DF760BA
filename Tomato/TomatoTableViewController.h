//
//  TomatoTableViewController.h
//  Tomato
//
//  Created by lisiqi on 12-11-16.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"

@interface TomatoTableViewController : CoreDataTableViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate, LoadMoreTableFooterDelegate>{
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
    
    LoadMoreTableFooterView *_loadMoreTableFooter;
    BOOL _hasMore;
    BOOL _loadingMore;
}

//开始重新加载时调用的方法
- (void)reloadTableViewDataSource;
//完成加载时调用的方法
- (void)doneLoadingTableViewData;

@end
