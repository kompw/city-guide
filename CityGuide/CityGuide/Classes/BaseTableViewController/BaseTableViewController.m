//
//  BaseViewController.m
//  CityGuide
//
//  Created by taras on 23.06.15.
//  Copyright (c) 2015 t. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseDetailViewController.h"
#import "MapViewController.h"
#import "CompanyViewController.h"
#import "SendMessageViewController.h"

#import "SendView.h"
#import "MainMenuCell.h"
#import "TextCell.h"
#import "TextWithImageCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

static NSString *reuseIdentifier = @"cell";

//all tab in main menu
typedef NS_ENUM(NSInteger, mainMenu) {
    SharesTab     = 0,
    DirectoryTab  = 1,
    MapTab        = 2,
    NewsTab       = 3,
    TaxiTab       = 4,
    DeliveryTab   = 5,
    PosterTab     = 6
};


@interface BaseTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation BaseTableViewController
@synthesize dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = @[];
    self.tableView.sectionHeaderHeight = 0;
    
    switch (self.controllerType) {
        case MainMenu:{
            self.title = @"Главное меню";
            dataSource = [ServerManager getMainMenu];
            UIView * v = [[[NSBundle mainBundle] loadNibNamed:[MainMenuCell description] owner:self options:nil] firstObject];
            self.tableView.rowHeight = v.frame.size.height;
            [self.tableView registerNib:[UINib nibWithNibName:[MainMenuCell description] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        }
            break;
        case Shares:{
            self.title = @"Акции";
            UIView * v = [[[NSBundle mainBundle] loadNibNamed:[TextWithImageCell description] owner:self options:nil] firstObject];
            self.tableView.rowHeight = v.frame.size.height;
            [self.tableView registerNib:[UINib nibWithNibName:[TextWithImageCell description] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
            
            SendView *sendView = [[[NSBundle mainBundle] loadNibNamed:[SendView description] owner:self options:nil] firstObject];
            self.tableView.sectionHeaderHeight = sendView.frame.size.height;
           
            
            [ServerManager sharesData:^(NSArray *array) {
                dataSource = array;
                [self.tableView reloadData];
            }];
        }
            break;
        case Directory1:{
            self.title = @"Справочник";
            UIView * v = [[[NSBundle mainBundle] loadNibNamed:[TextCell description] owner:self options:nil] firstObject];
            self.tableView.rowHeight = v.frame.size.height;
            [self.tableView registerNib:[UINib nibWithNibName:[TextCell description] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
            
            SendView *sendView = [[[NSBundle mainBundle] loadNibNamed:[SendView description] owner:self options:nil] firstObject];
            self.tableView.sectionHeaderHeight = sendView.frame.size.height;
            
            [ServerManager directory1Data:^(NSArray *array) {
                dataSource = array;
                [self.tableView reloadData];
            }];
        }
            break;
            
        case Directory2:{
            UIView * v = [[[NSBundle mainBundle] loadNibNamed:[TextCell description] owner:self options:nil] firstObject];
            self.tableView.rowHeight = v.frame.size.height;
            [self.tableView registerNib:[UINib nibWithNibName:[TextCell description] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
            
            SendView *sendView = [[[NSBundle mainBundle] loadNibNamed:[SendView description] owner:self options:nil] firstObject];
            self.tableView.sectionHeaderHeight = sendView.frame.size.height;
            
            [ServerManager  directory2Data:self.numberId.description forMap:NO completion:^(NSArray *array) {
                dataSource = array;
                [self.tableView reloadData];
            }];
        }
            break;
            
        case Directory3:{
            UIView * v = [[[NSBundle mainBundle] loadNibNamed:[TextWithImageCell description] owner:self options:nil] firstObject];
            self.tableView.rowHeight = v.frame.size.height;
            [self.tableView registerNib:[UINib nibWithNibName:[TextWithImageCell description] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
            
            SendView *sendView = [[[NSBundle mainBundle] loadNibNamed:[SendView description] owner:self options:nil] firstObject];
            self.tableView.sectionHeaderHeight = sendView.frame.size.height;
            
            [ServerManager  directory3Data:self.numberId.description forMap:NO completion:^(NSArray *array) {
                dataSource = array;
                [self.tableView reloadData];
            }];
        }
            break;
    
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SendView *sendView = [[[NSBundle mainBundle] loadNibNamed:[SendView description] owner:self options:nil] firstObject];
    [sendView.sendButton addTarget:self action:@selector(openSendController) forControlEvents:UIControlEventTouchUpInside];
    
    switch (self.controllerType) {
        case MainMenu:
            return nil;
            break;

        case Shares:
            [sendView.sendButton setTitle:@"Разместить Акцию" forState: UIControlStateNormal];
            break;
            
        case Directory1:
        case Directory2:
        case Directory3:
            [sendView.sendButton setTitle:@"Разместить Компанию" forState: UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    return sendView;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSDictionary *model = self.dataSource[indexPath.row];
     UITableViewCell *cell;

     switch (self.controllerType) {
         case MainMenu:{
             cell = [self mainMenuCell:indexPath andModel:model];
         }
             break;
         case Shares:{
             cell = [self textWithImageCell:indexPath andTitle:model[title_key] andImageUrl:model[image_key]];
         }
             break;
         case Directory1:{
             cell = [self textCell:indexPath andModel:model];
         }
             break;
         case Directory2:{
             cell = [self textCell:indexPath andModel:model];
         }
             break;
             
         case Directory3:{
             cell = [self textWithImageCell:indexPath andTitle:model[name_key] andImageUrl:model[image_key]];
         }
             break;
             
         default:
             break;
     }
     

  return cell;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *model = self.dataSource[indexPath.row];
    
    switch (self.controllerType) {
        case MainMenu:{
            [self actionMainMenu:indexPath.row];
        }
            break;
        case Shares:{
            BaseDetailViewController *baseDetailViewController = [BaseDetailViewController alloc];
            baseDetailViewController.detailData = model[details_key];
            [self.navigationController pushViewController:[baseDetailViewController init] animated:YES];
        }
            break;
         
        case Directory1:{
            BaseTableViewController *baseTableViewController = [BaseTableViewController alloc];
            baseTableViewController.title = model[name_key];
            baseTableViewController.numberId = model[id_key];
            baseTableViewController.controllerType = Directory2;
            [self.navigationController pushViewController:[baseTableViewController init] animated:YES];
        }
            break;
        case Directory2:{
            BaseTableViewController *baseTableViewController = [BaseTableViewController alloc];
            baseTableViewController.title = model[name_key];
            baseTableViewController.numberId = model[id_key];
            baseTableViewController.controllerType = Directory3;
            [self.navigationController pushViewController:[baseTableViewController init] animated:YES];
        }
            break;
            
        case Directory3:{
            CompanyViewController *companyViewController = [CompanyViewController alloc];
            companyViewController.souceDictionary = model;
            [self.navigationController pushViewController:[companyViewController init] animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma  configure cell

-(UITableViewCell*)mainMenuCell:(NSIndexPath *)indexPath andModel:(NSDictionary*)model{
    MainMenuCell* mainMenuCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (mainMenuCell == nil) {
        mainMenuCell = [[[NSBundle mainBundle] loadNibNamed:[MainMenuCell description] owner:self options:nil] firstObject];
    }
    
    [mainMenuCell configure:model[image_key] andTitle:model[title_key] andData:model[details_key]];
    return mainMenuCell;
}

-(UITableViewCell*)textWithImageCell:(NSIndexPath *)indexPath andTitle:(NSString*)title andImageUrl:(NSString*)url{
    TextWithImageCell* textWithImageCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (textWithImageCell == nil) {
        textWithImageCell = [[[NSBundle mainBundle] loadNibNamed:[TextWithImageCell description] owner:self options:nil] firstObject];
    }
    textWithImageCell.title.text = title;
    [textWithImageCell.image sd_setImageWithURL:[NSURL URLWithString:url]];
    
    
    return textWithImageCell;
}

-(UITableViewCell*)textCell:(NSIndexPath *)indexPath andModel:(NSDictionary*)model{
    TextCell* textWithImageCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (textWithImageCell == nil) {
        textWithImageCell = [[[NSBundle mainBundle] loadNibNamed:[TextCell description] owner:self options:nil] firstObject];
    }
    textWithImageCell.title.text = model[name_key];

    return textWithImageCell;
}

#pragma action mainMenu

-(void)actionMainMenu:(NSInteger)row{
    BaseTableViewController *baseViewController = [BaseTableViewController alloc];
    
    switch (row) {
        case SharesTab:
            baseViewController.controllerType = Shares;
            break;
            
        case DeliveryTab:
            baseViewController.controllerType = Delivery;
            break;
            
        case DirectoryTab:
            baseViewController.controllerType = Directory1;
            break;
        case MapTab:
            [self.navigationController pushViewController:[MapViewController new] animated:YES];
            return;
            break;
        case NewsTab:
            baseViewController.controllerType = News;
            break;
        case TaxiTab:
            baseViewController.controllerType = Taxi;
            break;
        case PosterTab:
            baseViewController.controllerType = Poster;
            break;
            
        default:
            return;
            break;
    }
    
    [self.navigationController pushViewController:[baseViewController init] animated:YES];
}

-(void)openSendController{
    [self.navigationController pushViewController:[SendMessageViewController new] animated:YES];
}


@end