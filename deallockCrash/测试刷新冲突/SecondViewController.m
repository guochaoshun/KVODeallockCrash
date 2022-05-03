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

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];



}

- (IBAction)popAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addKVO:(id)sender {
    [self tableViewArray];
}

- (IBAction)changeRootVC:(id)sender {

}


- (NSArray *)tableViewArray {
    if (_tableViewArray == nil) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
        GCSTableView *tableView1 = [[GCSTableView alloc] initWithFrame:CGRectMake(10, 100, 90, 90)];
        tableView1.contentSize = CGSizeMake(100, 1000);
        tableView1.backgroundColor = [UIColor orangeColor];
        [array addObject:tableView1];
        [self.view addSubview:tableView1];

        GCSTableView *tableView2 = [[GCSTableView alloc] initWithFrame:CGRectMake(10, 200, 90, 90)];
        tableView2.contentSize = CGSizeMake(100, 1000);
        tableView2.backgroundColor = [UIColor orangeColor];
        [array addObject:tableView2];
        [self.view addSubview:tableView2];

        GCSTableView *tableView3 = [[GCSTableView alloc] initWithFrame:CGRectMake(10, 300, 90, 90)];
        tableView3.contentSize = CGSizeMake(100, 1000);
        tableView3.backgroundColor = [UIColor orangeColor];
        [array addObject:tableView3];
        [self.view addSubview:tableView3];

        _tableViewArray = [array copy];
    }
    return _tableViewArray;
}


- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
