//
//  ViewController.m
//  msgpack-objectivec-sample
//
//  Created by 松前　健太郎 on 13/01/16.
//  Copyright (c) 2013年 kenmaz.net. All rights reserved.
//

#import "ViewController.h"
#import "MessagePack.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)print:(NSString*)line {
    NSString* text = self.textView.text;
    text = [[text stringByAppendingString:line] stringByAppendingString:@"\n"];
    self.textView.text = text;
}

- (IBAction)touchStartButton:(id)sender {
    
    //1) craete some test data
    NSArray* ary = @[@"hello", @"kenmaz", @"net!"];
    NSData* msg1 = [ary messagePack];

    NSDictionary* dic = @{@"Apple" : @123, @"Microsoft" : @234};
    NSData* msg2 = [dic messagePack];

    NSArray* trap = @[@"this", @"is", @"trap"];
    NSData* msg3 = [trap messagePack];
    msg3 = [NSData dataWithBytes:[msg3 bytes] length:10]; //incompletion data
    
    [self print:[NSString stringWithFormat:@"msg1 %@", [msg1 description]]];
    [self print:[NSString stringWithFormat:@"msg2 %@", [msg2 description]]];
    [self print:[NSString stringWithFormat:@"msg3 (incompletion) %@", [msg3 description]]];
    [self print:@"---"];
    
    //2) streaming
    MessagePackParser* parser = [[MessagePackParser alloc] init];
    [parser feed:msg1];
    [parser feed:msg2];
    [parser feed:msg3];

    //3) fetch parsed objects
    id result;
    while ((result = [parser next])) {
        [self print:[NSString stringWithFormat:@"result: %@", [(NSObject*)result description]]];
    }
}

@end
