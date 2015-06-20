//
//  ViewController.m
//  Web
//
//  Created by kunren10 on 2014/04/21.
//  Copyright (c) 2014年 Takahide Baba. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *wvWeb;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *biGoBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *biGoForward;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiIndicator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	
	// IBで設定済
//	self.wvWeb.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Method

// キーボード確定時
- (IBAction)exitTextField:(id)sender {
	//
}

// URLテキスト更新時
- (IBAction)changeAddress:(UITextField *)sender {
	
	// Webページ読込
	[self loadWebPage:sender.text];
}

// ホームボタン押下
- (IBAction)goHome:(id)sender {
	
	// Webページ読込
	[self loadWebPage:@"http://www.apple.com/jp/"];
}

// Safariボタン押下
- (IBAction)sendSafari:(id)sender {
	
	NSURL *url = [NSURL URLWithString:self.tfAddress.text];
	[[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Own MEthod

// Webページ読込
- (void)loadWebPage:(NSString *)urlString {
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *req = [NSURLRequest requestWithURL:url];
	[self.wvWeb loadRequest:req];
}

#pragma mark - UIWebViewDelegate Method

// Webページ読込開始後
- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	// インジケーター表示
	{
		// （ネットワーク アクティビティ インジケーター）
		[UIApplication sharedApplication].
			networkActivityIndicatorVisible = YES;
		
		// （アクティビティ インジケーター）
		[self.aiIndicator startAnimating];
	}
}

// Webページ読込完了後
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	// インジケーター非表示
	{
		// （ネットワーク アクティビティ インジケーター）
		[UIApplication sharedApplication].
			networkActivityIndicatorVisible = NO;
		
		// （アクティビティ インジケーター）
		[self.aiIndicator stopAnimating];
	}

	// WebページのURLテキスト反映
	self.tfAddress.text =
		[webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    
    // Webページの大きさを自動的に画面にフィットさせる
    //webView.scalesPageToFit = YES;
	
	// 戻る、進むボタン制御
	self.biGoBack.enabled = webView.canGoBack;
	self.biGoForward.enabled = webView.canGoForward;
	
	
	// ページタイトル取得
	NSString *str01 =
		[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	NSLog(@"ページタイトル：%@", str01);
	
	// HTML(BODY部)取得
	NSString *str02 =
		[webView stringByEvaluatingJavaScriptFromString:
		 @"document.body.innerHTML"];
	NSLog(@"HTML(BODY部)：%@", str02);
}

@end
