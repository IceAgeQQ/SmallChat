//
//  ViewController.m
//  ChatClient
//
//  Created by Chao Xu on 14-3-11.
//  Copyright (c) 2014年 Chao Xu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize inputNameField;
@synthesize inputMessageField;
@synthesize chatView;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [inputNameField resignFirstResponder];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initNetworkCommunication];
    messages = [[NSMutableArray alloc] init];
  //  self.tView.delegate = self;
//	  self.tView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNetworkCommunication{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 80, &readStream, &writeStream);
    inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    
}
- (IBAction)joinChat:(id)sender {
    NSString *response = [NSString stringWithFormat:@"iam:%@",inputNameField.text];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    [self.view bringSubviewToFront:chatView];
    
}

- (IBAction)sendMessage:(id)sender {
    NSString *response = [NSString stringWithFormat:@"msg:%@",inputMessageField.text];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    inputMessageField.text = @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	NSString *s = (NSString *) [messages objectAtIndex:indexPath.row];
	
    static NSString *CellIdentifier = @"ChatCellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	cell.textLabel.text = s;
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return messages.count;
}
/**
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    NSLog(@"stream event %i",streamEvent);
    
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            break;
            
        default:
            NSLog(@"Unknow event");
    }

}
 **/
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"stream event %i",eventCode);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            
            if (aStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            [self messageReceived:output];
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            break;
            
        default:
            NSLog(@"Unknow event");
    }
}

-(void)messageReceived:(NSString *)message {
    [messages addObject:message];
    [self.tView reloadData];
    
    NSIndexPath *topIndexPath =
    [NSIndexPath indexPathForRow:messages.count-1
                       inSection:0];
    [self.tView scrollToRowAtIndexPath:topIndexPath
                      atScrollPosition:UITableViewScrollPositionMiddle
                              animated:YES];
}
@end






































