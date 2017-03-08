//
//  NSObject+KTNotificationObserver.m
//  KTLibs
//
//  Created by KermitLiu on 2017/3/8.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import "NSObject+KTNotificationObserver.h"

@implementation NSObject (KTNotificationObserver)

#pragma mark - Add Observers

- (void)ktGetNotificationObserver:(id __strong *)observer
                          forName:(NSString *)name
                           object:(id)object
                            queue:(NSOperationQueue *)queue
                       usingBlock:(void (^)(NSNotification *, id))block
{
    NSParameterAssert(block);
    
    if (*observer)
        
        [self ktReleaseNotificationObserver:observer];
    
    __weak id weakSelf = self;
    
    * observer = [[NSNotificationCenter defaultCenter] addObserverForName:name
                                                                   object:object
                                                                    queue:queue
                                                               usingBlock:^(NSNotification *note) {
                                                                   __strong id strongSelf = weakSelf;
                                                                   
                                                                   block(note, strongSelf);
                                                               }];
}



- (void)ktGetNotificationObserver:(id __strong *)observer
                          forName:(NSString *)name
                           object:(id)object
              mainQueueUsingBlock:(void (^)(NSNotification *, id))block
{
    [self ktGetNotificationObserver:observer
                            forName:name
                             object:object
                              queue:[NSOperationQueue mainQueue]
                         usingBlock:block];
}


- (void)ktGetNotificationObserver:(id __strong *)observer
                          forName:(NSString *)name
              mainQueueUsingBlock:(void (^)(NSNotification *, id))block
{
    [self ktGetNotificationObserver:observer forName:name object:nil mainQueueUsingBlock:block];
}

#pragma mark - Remove Observers

- (void)ktReleaseNotificationObserver:(id __strong *)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:*observer];
    * observer = nil;
}


@end
