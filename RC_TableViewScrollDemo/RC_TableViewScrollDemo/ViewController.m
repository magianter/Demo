//
//  ViewController.m
//  RC_TableViewScrollDemo
//
//  Created by renchao on 2020/3/21.
//  Copyright © 2020 renchao. All rights reserved.
//

#import "ViewController.h"
#import "RCCustomTableViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, RCScrollDirection) {
    RCScrollDirectionNone = 0,
    RCScrollDirectionUP,
    RCScrollDirectionDown,
};

static CGFloat const cellFloat = 200.0;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RCCustomTableViewCell *playingcell;
@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) RCScrollDirection scrollDirection;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];

}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[RCCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];
    }
    cell.textLabel.text = @"test";
    return  cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellFloat;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[RCCustomTableViewCell class] forCellReuseIdentifier:kCellID];
    }
    return _tableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentOffset.y);
    if (self.lastOffsetY >= scrollView.contentOffset.y) {
        //向上滚动
        NSLog(@"up scroll");
        self.scrollDirection = RCScrollDirectionUP;
    }else if (self.lastOffsetY < scrollView.contentOffset.y) {
        //向下滚动
        NSLog(@"down scroll");
        self.scrollDirection = RCScrollDirectionDown;
    }
    self.lastOffsetY = scrollView.contentOffset.y;
    
    //判断中间cell是否滑出屏幕
    [self playingCellScrollOutScreen];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        RCCustomTableViewCell *cell = [self getMiddleCell];
        cell.backgroundColor = [UIColor redColor];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    RCCustomTableViewCell *cell = [self getMiddleCell];
    cell.backgroundColor = [UIColor redColor];
}

//获取中间cell
- (RCCustomTableViewCell *)getMiddleCell {
    
    CGFloat middleHeight = SCREEN_HEIGHT * 0.5;
    CGFloat cellToMidCellDistance = SCREEN_HEIGHT;
    RCCustomTableViewCell *middleCell = nil;
    
    if (self.tableView.visibleCells.count != 0) {
        for (UITableViewCell *item  in self.tableView.visibleCells) {
            RCCustomTableViewCell *cell = (RCCustomTableViewCell *)item;
            //cell center point
            CGPoint cellMidPoint = CGPointMake(cell.frame.origin.x, cell.frame.size.height * 0.5 + cell.frame.origin.y);
            //cell坐标转换屏幕坐标
            CGPoint cellCovertPoint = [cell.superview convertPoint:cellMidPoint toView:nil];
            CGFloat distanceTemp = fabs(middleHeight - cellCovertPoint.y);
            if (distanceTemp < cellToMidCellDistance) {
                cellToMidCellDistance = distanceTemp;
                middleCell = cell;
            }
        }
        self.playingcell = middleCell;
        
    }else {
        
    }
    return middleCell;
}

//滚出屏幕后逻辑
- (BOOL)playingCellScrollOutScreen {
    if (!self.playingcell) {
        return YES;
    }
    CGRect playCellFrame = self.playingcell.frame;
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    if (self.scrollDirection == RCScrollDirectionUP) {
        CGPoint midCellPoint = CGPointMake(playCellFrame.origin.x, playCellFrame.origin.y + playCellFrame.size.height);
        CGPoint convertPoint = [self.playingcell.superview convertPoint:midCellPoint toView:nil];
        return CGRectContainsPoint(screenRect, convertPoint);
    }else if (self.scrollDirection == RCScrollDirectionDown) {
        CGPoint midCellPoint = CGPointMake(playCellFrame.origin.x, playCellFrame.origin.y);
        CGPoint convertPoint = [self.playingcell.superview convertPoint:midCellPoint toView:nil];
        return CGRectContainsPoint(screenRect, convertPoint);
    }else {
        return NO;
    }
}

@end
