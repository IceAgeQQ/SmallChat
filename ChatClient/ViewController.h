//
//  ViewController.h
//  ChatClient
//
//  Created by Chao Xu on 14-3-11.
//  Copyright (c) 2014年 Chao Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate,NSStreamDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSMutableArray *messages;
}
@property (strong, nonatomic) IBOutlet UITextField *inputNameField;
@property (nonatomic,strong) IBOutlet UITextField *inputMessageField;
@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UIView *chatView;

- (IBAction)joinChat:(id)sender;
- (IBAction)sendMessage:(id)sender;

@end
