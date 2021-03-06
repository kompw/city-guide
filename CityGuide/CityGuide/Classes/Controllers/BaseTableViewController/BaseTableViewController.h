//
//  BaseViewController.h
//  CityGuide
//
//  Created by taras on 23.06.15.
//  Copyright (c) 2015 t. All rights reserved.
//

#import <UIKit/UIKit.h>

// all screen with table in app
typedef NS_ENUM(NSUInteger, Controller) {
    MainMenu,
    Shares,
    Directory1,
    Directory2,
    Directory3,
    Map,
    News,
    Taxi,
    Delivery1,
    Delivery2,
    Delivery3,
    Poster1,
    Poster2,
    Poster3
};

@interface BaseTableViewController : UIViewController
@property (readwrite) Controller controllerType;
@property (nonatomic, strong) NSNumber *numberId;

@end
