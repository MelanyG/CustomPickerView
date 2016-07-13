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

@interface MainVC () <MHMenuVCProtocol>

@property (weak, nonatomic) IBOutlet UIView *containerMenu; // conteinerMeny
@property (strong, nonatomic) MHMenuViewController *menuViewController;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContainerMenuConstraint;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Test";
    NSString *urlString = @"http://wallfon.com/nature/volcano-ash-storm-lightning-natural-disaster.html";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
    self.menuViewController = [[MHMenuViewController alloc]init];
    self.menuViewController.arrayOfModels =[self createArrayOfModels];
    [self displayContentController:_menuViewController];
    [self shouldUpdatePageControl];
    _menuViewController.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate methods ///TAble  ???

- (void)didSelectCell:(NSInteger)selectedCell {
    NSString *urlString = [MHConfigure sharedConfiguration].dataSourceArray[selectedCell];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)shouldUpdatePageControl {
    if(_menuViewController.pager.hidden) {
        self.heightContainerMenuConstraint.constant = 60.f; // like constant
    } else {
        self.heightContainerMenuConstraint.constant = 80.f;
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

- (void)createConstraints
{
//    self.scrollVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    
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
        item.stationID = [[MHConfigure sharedConfiguration]stationID];
        item.inActiveThumbnnailUrl = [MHConfigure sharedConfiguration].dataSourceArray[i];
       item.activeThumbnnailUrl = [MHConfigure sharedConfiguration].activeChannelLogoURL;
        if(i == 0) {
            item.isSplitter = NO;
        } else {
            item.isSplitter = YES;
        }
        arrayOfModels[i] = item;
    }
     return arrayOfModels;
}


@end
