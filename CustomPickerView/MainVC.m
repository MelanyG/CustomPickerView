//
//  MainVC.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/6/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MainVC.h"
#import "MHMenuViewController.h"
#import "MHConfigure.h"
#import "MHMenuModelItem.h"


CGFloat const kInvisiblePagerConstant = 44.f;
CGFloat const kVisiblePagerConstant = 64.f;
NSString *const kHTTP = @"http";


@interface MainVC () <MHMenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerMenu;
@property (strong, nonatomic) MHMenuViewController *menuViewController;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContainerMenuConstraint;

- (IBAction)updateItems:(id)sender;

@end


@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Test";
    NSString *urlString = @"http://wallfon.com/nature/volcano-ash-storm-lightning-natural-disaster.html";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
    self.menuViewController = [[MHMenuViewController alloc]initWithArray:[self createArrayOfModels]];
    [self displayContentController:self.menuViewController];
    [self updateMenuController];
    self.menuViewController.delegate = self;
}

#pragma mark - UpdateMenuController

- (void)updateMenuController {
    //self.menuViewController.arrayOfModels = [self createArrayOfModels];
    self.menuViewController.backgroundColor = [[MHConfigure sharedConfiguration]streamPickerBackgroundColor];
    self.menuViewController.inactivePageDotColor = [[MHConfigure sharedConfiguration]inactivePageDotColor];
    self.menuViewController.activePageDotColor = [[MHConfigure sharedConfiguration]activePageDotColor];
    self.menuViewController.activeIndex = [NSIndexPath indexPathForItem:[[MHConfigure sharedConfiguration]activeStation] inSection:0];
    [self.menuViewController updateAll];
    [self shouldUpdateHeighOfMenuContainer];
}
- (void)updateMenuControllerWithoutRotation {
    self.menuViewController.arrayOfModels = [self createArrayOfModels];
    self.menuViewController.backgroundColor = [[MHConfigure sharedConfiguration]streamPickerBackgroundColor];
    self.menuViewController.inactivePageDotColor = [[MHConfigure sharedConfiguration]inactivePageDotColor];
    self.menuViewController.activePageDotColor = [[MHConfigure sharedConfiguration]activePageDotColor];
    self.menuViewController.activeIndex = [NSIndexPath indexPathForItem:[[MHConfigure sharedConfiguration]activeStation] inSection:0];
    [self.menuViewController updateAllWithoutRotation];
    [self shouldUpdateHeighOfMenuContainer];
}

#pragma mark - MenuController Delegate methods

- (void)didSelectCell:(NSInteger)selectedCell {
    NSString *urlString = [MHConfigure sharedConfiguration].dataSourceArray[selectedCell];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)shouldUpdateHeighOfMenuContainer {
    if(self.menuViewController.pager.hidden) {
        self.heightContainerMenuConstraint.constant = kInvisiblePagerConstant;
    } else {
        self.heightContainerMenuConstraint.constant = kVisiblePagerConstant;
    }
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - Navigation methods

- (void) displayContentController: (MHMenuViewController*) content {
    [self addChildViewController:content];
    content.view.frame = CGRectMake(self.containerMenu.frame.origin.x, self.containerMenu.frame.origin.y, self.containerMenu.frame.size.width, self.containerMenu.frame.size.height);
    [self.containerMenu addSubview:content.view];
    content.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self createConstraints];
    [content didMoveToParentViewController:self];
}

#pragma mark - Private methods

- (void)createConstraints {
    [self.containerMenu addConstraint:[NSLayoutConstraint constraintWithItem:self.menuViewController.view
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerMenu
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1
                                                                    constant:0]];
    
    [self.containerMenu addConstraint:[NSLayoutConstraint constraintWithItem:self.menuViewController.view
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerMenu
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1
                                                                    constant:0]];
    
    [self.containerMenu addConstraint:[NSLayoutConstraint constraintWithItem:self.menuViewController.view
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerMenu
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1
                                                                    constant:0]];
    
    [self.containerMenu addConstraint:[NSLayoutConstraint constraintWithItem:self.menuViewController.view
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerMenu
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1
                                                                    constant:0]];
}

- (NSArray *)createArrayOfModels {
    NSMutableArray *arrayOfModels = [[NSMutableArray alloc]init];
    NSInteger count = [[MHConfigure sharedConfiguration]numberOfElements];
    for(int i = 0; i < count; i++) {
        MHMenuModelItem *item = [[MHMenuModelItem alloc]init];
        if ([[MHConfigure sharedConfiguration].dataSourceArray[i] containsString:kHTTP]) {
            item.inActiveThumbnnailUrl = [MHConfigure sharedConfiguration].dataSourceArray[i];
            item.activeThumbnnailUrl = [MHConfigure sharedConfiguration].activeChannelLogoURL;
        } else {
            item.textForLable = [MHConfigure sharedConfiguration].dataSourceArray[i];
        }
        item.stationID = [[MHConfigure sharedConfiguration]stationID];
        arrayOfModels[i] = item;
    }
    return arrayOfModels;
}


- (IBAction)updateItems:(id)sender {
    NSInteger randomAllNumbers = arc4random() % 10;
//    if([MHConfigure sharedConfiguration].streamPickerItemsPadPortrait > 1)
//        [MHConfigure sharedConfiguration].streamPickerItemsPadPortrait -= 1;
//    if([MHConfigure sharedConfiguration].streamPickerItemsPadLandscape > 1)
//        [MHConfigure sharedConfiguration].streamPickerItemsPadLandscape -= 1;
//    if(([MHConfigure sharedConfiguration].numberOfElements - randomAllNumbers) > 1 )
//        [MHConfigure sharedConfiguration].numberOfElements -= randomAllNumbers;
//    
    [self updateMenuControllerWithoutRotation];
    //[self.menuViewController.view layoutSubviews];
}
@end
