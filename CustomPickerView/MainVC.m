//
//  MainVC.m
//  CustomPickerView
//
//  Created by Melaniia Hulianovych on 7/6/16.
//  Copyright © 2016 Melaniia Hulianovych. All rights reserved.
//

#import "MainVC.h"
#import "MHScrollView.h"
#import "MHScrollViewC.h"

@interface MainVC () <MHScrollVCProtocol>

@property (weak, nonatomic) IBOutlet UIView *scrollView;
@property (strong, nonatomic)  MHScrollViewC *scrollVC;
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
    
    _scrollVC = [[MHScrollViewC alloc]initWithView:_scrollView];
    [self shouldUpdatePageControl];
    _scrollVC.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate methods

- (void)didSelectCell:(NSInteger)selectedCell {
    NSString *urlString = @"http://www.wallpapersxl.com/wallpaper/1920x1080/natural-disasters-tornado-200748.html";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)shouldUpdatePageControl {
    if(_scrollVC.scrollView.pager.hidden) {
        self.heightScrollViewConstraint.constant = 60.f;
    } else {
        self.heightScrollViewConstraint.constant = 80.f;
    }
    [self.view setNeedsUpdateConstraints];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
