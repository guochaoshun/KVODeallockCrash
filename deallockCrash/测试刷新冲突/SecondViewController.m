//
//  SecondViewController.m
//  测试刷新冲突
//
//  Created by 郭朝顺 on 2021/9/24.
//

#import "SecondViewController.h"
#import "GCSTableView.h"

@interface SecondViewController ()

@property (nonatomic, strong) NSArray *tableViewArray;
@property (nonatomic, weak) UIScrollView *currScrollView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)popAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addKVO:(id)sender {
    self.currScrollView = [self setupContentControllerScroll];
}

- (IBAction)changeRootVC:(id)sender {
    UIViewController *rootVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RootVC"];
    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
}


/// 设置内容控制器滚动监听
- (UIScrollView *)setupContentControllerScroll {
    UIScrollView * scrollView = [self getCurrScrollView];
    static int i = 0;
    i++;
    if (i == 3) {
        scrollView = nil;
        i = 0;
        NSLog(@"触发为nil的情况, %zd",scrollView.tag);
    }
    if (scrollView) {
        //内容控制器滚动回调
        [self removeCurrentScrollViewObserver];
        @try {
            NSLog(@"添加观察者, %zd",scrollView.tag);
            [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        } @catch (NSException *exception) {
            NSLog(@"[%s]: 添加滚动监听失败:%@",__func__,[exception description]);
        }
    } else {
//        [self removeCurrentScrollViewObserver];
    }
    return scrollView;
}


- (void)dealloc {
    NSLog(@"%s",__func__);
    [self removeCurrentScrollViewObserver];
}

- (void)removeCurrentScrollViewObserver {
    if (self.currScrollView) {
        @try {
            NSLog(@"移除观察者, %zd",self.currScrollView.tag);
            //保证当前只有一个scrollview监听
            [self.currScrollView removeObserver:self forKeyPath:@"contentOffset"];
        } @catch (NSException *exception) {
            NSLog(@"[%s]: 移除滚动监听失败:%@",__func__,[exception description]);
        }
    }
}

/// 获取当前显示的scrollView
- (UIScrollView *)getCurrScrollView {
    UITableView *tableView = [self.tableViewArray objectAtIndex:arc4random()%3];
    return tableView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSValue *newPoint = [change objectForKey:NSKeyValueChangeNewKey];
    NSValue *oldPoint = [change objectForKey:NSKeyValueChangeOldKey];
    if (![newPoint isEqualToValue:oldPoint]) {
        NSLog(@"%@  发送滚动  %@",@(object.tag), newPoint);
    }
}

- (NSArray *)tableViewArray {
    if (_tableViewArray == nil) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
        GCSTableView *tableView1 = [[GCSTableView alloc] initWithFrame:CGRectMake(10, 100, 90, 90)];
        tableView1.contentSize = CGSizeMake(100, 1000);
        tableView1.tag = 100;
        tableView1.backgroundColor = [UIColor orangeColor];
        [array addObject:tableView1];
        [self.view addSubview:tableView1];

        GCSTableView *tableView2 = [[GCSTableView alloc] initWithFrame:CGRectMake(10, 200, 90, 90)];
        tableView2.contentSize = CGSizeMake(100, 1000);
        tableView2.tag = 101;
        tableView2.backgroundColor = [UIColor orangeColor];
        [array addObject:tableView2];
        [self.view addSubview:tableView2];

        GCSTableView *tableView3 = [[GCSTableView alloc] initWithFrame:CGRectMake(10, 300, 90, 90)];
        tableView3.contentSize = CGSizeMake(100, 1000);
        tableView3.tag = 102;
        tableView3.backgroundColor = [UIColor orangeColor];
        [array addObject:tableView3];
        [self.view addSubview:tableView3];

        _tableViewArray = [array copy];
    }
    return _tableViewArray;
}


@end
