//
//  MainHeaderView.m
//  CityGuide
//
//  Created by Taras on 7/20/15.
//  Copyright (c) 2015 t. All rights reserved.
//

#import "MainHeaderView.h"
#import "InfoController.h"

@implementation MainHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)openInfo:(id)sender {
    [self.navigationController pushViewController:[InfoController new] animated:YES];
}

@end
