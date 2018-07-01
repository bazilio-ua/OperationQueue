//
//  ViewController.m
//  OperationQueue
//
//  Created by Basil Nikityuk on 7/1/18.
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import "NSOperationQueue+Completion.h"

@interface ViewController ()

- (void)operationsQueue;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self operationsQueue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Operations Queue

- (void)operationsQueue {
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"block operation 1 iterator: %d", i);
        }
        
        NSLog(@"block operation 1 code block");
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        
        for (NSInteger i = 0; i < 50; i++) {
            NSLog(@"block operation 2 iterator: %d", i);
        }
        
        NSLog(@"block operation 2 code block. that operation is depend on block operation 1");
    }];
    
    [operation2 addDependency:operation1];
    
    NSOperation *operation3 = [[NSOperation alloc] init];
    [operation3 setCompletionBlock:^{
        
        for (NSInteger i = 0; i < 30; i++) {
            NSLog(@"operation 3 iterator: %d", i);
        }
        
        NSLog(@"operation 3 completion code block");
    }];
    
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        
        for (NSInteger i = 100; i > 0 ; i--) {
            NSLog(@"block operation 4 iterator: %d", i);
        }
        
        NSLog(@"block operation 4 code block");
    }];
    
    NSInvocationOperation *operation5 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doTask) object:nil];
    
    NSBlockOperation *operation6 = [[NSBlockOperation alloc] init];
    [operation6 addExecutionBlock:^{
        NSLog(@"block operation 6 code block #1");
    }];
    [operation6 addExecutionBlock:^{
        NSLog(@"block operation 6 code block #2");
    }];
    [operation6 addExecutionBlock:^{
        NSLog(@"block operation 6 code block #3");
    }];
    [operation6 addDependency:operation2];
    
    NSArray *operations = [NSArray arrayWithObjects:operation1, operation2, operation3, operation4, nil];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:operations waitUntilFinished:NO];
    [queue addOperation:operation5];
    [queue addOperation:operation6];
    
    [queue addOperationWithBlock:^{
        NSLog(@"that just unnumbered operation with block");
    }];
    
    [queue setMaxConcurrentOperationCount:1]; // NSOperationQueueDefaultMaxConcurrentOperationCount
    
//    [queue setCompletion:^{
//        // handle operation queue's completion here (launched in main thread!)
//        NSLog(@"*** operation queue has completed ***");
//    }];
    
//    [queue waitUntilAllOperationsAreFinished];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [queue waitUntilAllOperationsAreFinished];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"*** operation queue has completed ***");
        });
    });
    
    NSLog(@"*** all done ***");
}

- (void)doTask {
    
    for (NSInteger i = 0; i < 5; i++) {
        NSLog(@"invocation operation 5 iterator: %d", i);
    }
    
    NSLog(@"invocation operation 5 code invocation");
}

@end
