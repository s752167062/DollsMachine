//
//  YRBasicVc.m
//  JoyMachine
//
//  Created by ZMJ on 2017/11/12.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "YRBasicVc.h"
#import "UINavigationBar+HJChangeBarColor.h"



@interface YRBasicVc ()<UINavigationControllerDelegate>



@end



@implementation YRBasicVc

#pragma mark-- 懒加载

- (NSMutableArray *)basicDataArr
{
    if (!_basicDataArr) {
        _basicDataArr = [NSMutableArray array];
    }
    return _basicDataArr;
}


#pragma mark-- Tableview相关

- (UITableView *)myTableView
{
    if (!_myTableView) {
        
        _myTableView = [self getTableViewWithStyle:MyTableView_StylePlain];
    }
    return _myTableView;
}

- (UITableView *)getTableViewWithStyle:(MyTableView_Type)tableStyle
{
    if (_myTableView)
        return _myTableView;
    
    switch (tableStyle) {
            
        case MyTableView_StyleGrouped:
        {
            _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MJScreenW, MJScreenH - MJSafeAreButtomH) style:UITableViewStyleGrouped];
        }
            break;
            
        default:
        {
            _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MJScreenW, MJScreenH) style:UITableViewStylePlain];
            
        }
            break;
    }
    
    _myTableView.contentInset = UIEdgeInsetsMake(0, 0, MJSafeAreButtomH + MJNavMaxY, 0);
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.backgroundColor = MJMainRedColor;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return _myTableView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

#pragma mark-- 头部视图
- (YRPrivateMsgView *)private_MsgHeaderV
{
    if (!_private_MsgHeaderV) {
        _private_MsgHeaderV = [YRPrivateMsgView MJ_viewFromXib];
        _private_MsgHeaderV.frame = CGRectMake(0, 0, MJScreenW, Size(40, 44, 44));
    }
    return _private_MsgHeaderV;
}

#pragma mark-- UICOllectionView相关

- (UICollectionView *)youColView
{
    if (!_youColView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _youColView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MJScreenW, MJScreenH - MJSafeAreButtomH) collectionViewLayout:flowLayout];
        
        _youColView.contentInset = UIEdgeInsetsMake(0, 0, MJSafeAreButtomH + MJNavMaxY, 0);
        
        _youColView.backgroundColor = MJMainRedColor;
        
        _youColView.dataSource = self;
        
        _youColView.delegate = self;
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        flowLayout.minimumLineSpacing = self.youColsMargin;
        
        flowLayout.minimumInteritemSpacing = self.youColsMargin;
        
        //colView的边距
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        
        flowLayout.itemSize = CGSizeMake(MJ_cellWH, MJ_cellWH);
        
        
        [self.view addSubview:_youColView];
        
        
    }
    return _youColView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [UICollectionViewCell new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //col默认每行两个
    self.youColsNum = 2;
    //col间距默认为10
    self.youColsMargin = 10;
    
    self.navigationController.delegate = self;
    
    self.pageSize = 20;
    
    self.pageNow = 0;
    
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己// || [viewController isKindOfClass:NSClassFromString(@"HJMyVc")]
    BOOL isShowNav = [viewController isKindOfClass:NSClassFromString(@"YRJoyGameVc")];
    
    [self.navigationController setNavigationBarHidden:isShowNav animated:YES];
}

#pragma mark-- 上下拉刷新
#pragma mark - 添加上下拉刷新
- (void)addHeaderRefresh:(UIScrollView *)scrView
{
    ZMJWeakSelf(self);
    
    scrView.mj_header = [YRRefreshHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新");
        
        weakself.pageNow = 1;
        
        [weakself getRequestData];
    }];
    
}

- (void)addFooterRefresh:(UIScrollView *)scrView
{
    ZMJWeakSelf(self);
    
    scrView.mj_footer = [YRRefreshFooter footerWithRefreshingBlock:^{
        
        NSLog(@"上拉刷新");
        
        [weakself getRequestData];
    }];
    
}

//开始请求数据
- (void)getRequestData
{
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar HJ_star];
    
    self.navigationController.delegate = self;
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    /*
     9.0之前navigationController的delegate修饰的是assgin,当被设置为delegate的控制器被释放,
     其delegate不会被置为nil,会造成野指针错误.
     需要手动置nil
     */
    self.navigationController.delegate = nil;
    
//    [self.navigationController.navigationBar HJ_reset];
}

#pragma mark- (tableview的headerView就一个带label的)
- (UIView *)headViewWithSize:(CGSize)size andTitleStr: (NSString *) titleStr
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    [headerView setTag:Tag_HeaderView];
    [headerView setBackgroundColor:MJMainRedColor];
    
    if (titleStr.length > 0)
    {
        UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MJScreenW - 10, size.height)];
        [tipLabel setTextColor:[UIColor whiteColor]];
        [tipLabel setTextAlignment:NSTextAlignmentLeft];
        //        tipLabel.font = [UIFont fontWithName:nil size:13.0];
        tipLabel.font = [UIFont systemFontOfSize:13.0];
        [tipLabel setText:titleStr];
        
        tipLabel.textColor = [UIColor blackColor];
        
        [headerView addSubview:tipLabel];
    }
    return headerView;
}

#pragma mark- (tableview的footerView就一个带label的)
/// footView
- (UIView *)footViewWithSize:(CGSize)size andTitleStr: (NSString *) titleStr
{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MJScreenW, size.height)];
   
    [footView setBackgroundColor:MJMainRedColor];
    
    if (titleStr.length > 0)
    {
        UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MJScreenW, size.height)];
        [tipLabel setTextColor:[UIColor whiteColor]];
        
        [tipLabel setTextAlignment:NSTextAlignmentLeft];
        //        tipLabel.font = [UIFont fontWithName:nil size:13.0];
        tipLabel.font = [UIFont systemFontOfSize:13.0];
        
        [tipLabel setText:titleStr];
        
        [footView addSubview:tipLabel];
    }
    
    return footView;
}



- (void)dealloc
{
    NSLog(@"%s",__func__);
    
}

@end
