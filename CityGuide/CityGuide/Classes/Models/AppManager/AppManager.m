//
//  AppManager.m
//  CityGuide
//
//  Created by taras on 23.06.15.
//  Copyright (c) 2015 t. All rights reserved.
//

#import "AppManager.h"
#import "SVProgressHUD.h"

@implementation AppManager

+(void)showProgressBar{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil) maskType:SVProgressHUDMaskTypeBlack];
}

+(void)hideProgressBar{
    [SVProgressHUD dismiss];
}

+(void)showMessage:(NSString*)message{
    UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]; 
    [alertView show];
}

+(UIBarButtonItem*)backetButton:(UIViewController*)controller{
    UIButton *backet = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backet setImage:[UIImage imageNamed:@"cart_x.png"] forState:UIControlStateNormal];
    
    [backet addTarget:controller action:@selector(openBacket) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backet];
}

+(UIBarButtonItem*)plusButton:(UIViewController*)controller andSelector:(SEL)s{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:controller action:s];
}

+(void)roundMyView:(UIView*)view borderRadius:(CGFloat)radius borderWidth:(CGFloat)border color:(UIColor*)color{
    CALayer *layer = [view layer];
    layer.masksToBounds = YES;
    layer.cornerRadius = radius;
    layer.borderWidth = border;
    layer.borderColor = color.CGColor;
}

+(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
