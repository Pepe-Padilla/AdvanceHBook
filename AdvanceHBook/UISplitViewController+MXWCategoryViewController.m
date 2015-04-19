//
//  MXWCategoryViewController.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/19/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "UISplitViewController+MXWCategoryViewController.h"

@implementation UIViewController (MXWNavigaton)

-(UINavigationController *) wrappedInNavigation{
    
    UINavigationController *nav = [UINavigationController new];
    [nav pushViewController:self
                   animated:NO];
    return nav;
}

@end