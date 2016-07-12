//
//  MainVC.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/6/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MainVC.h"
#import "MHScrollVC.h"
#import "MHConfigure.h"
#import "MHMenuModelItem.h"

@interface MainVC () <MHScrollVCProtocol>

@property (weak, nonatomic) IBOutlet UIView *scrollView; // conteinerMeny
@property (strong, nonatomic) MHScrollVC *scrollVC;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightScrollViewConstraint;

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
    self.scrollVC = [[MHScrollVC alloc]init];
    self.scrollVC.arrayOfModels =[self createArrayOfModels];
    [self displayContentController:_scrollVC];
    [self shouldUpdatePageControl];
    _scrollVC.delegate = self;
    
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
    if(_scrollVC.pager.hidden) {
        self.heightScrollViewConstraint.constant = 60.f; // like constant
    } else {
        self.heightScrollViewConstraint.constant = 80.f;
    }
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - Navigation methods

- (void) displayContentController: (MHScrollVC*) content {
    [self addChildViewController:content];
    content.view.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:content.view];
    content.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self createConstraints];
    [content didMoveToParentViewController:self];
}

#pragma mark - Private methods

- (void)createConstraints
{
//    self.scrollVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollVC.view
                                                    attribute:NSLayoutAttributeTop
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:self.scrollView
                                                    attribute:NSLayoutAttributeTop
                                                   multiplier:1
                                                     constant:0]];

    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollVC.view
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:0]];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollVC.view
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeLeading
                                                               multiplier:1
                                                                 constant:0]];
    
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollVC.view
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
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
