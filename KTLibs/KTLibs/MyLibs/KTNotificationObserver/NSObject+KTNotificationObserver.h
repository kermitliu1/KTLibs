//
//  NSObject+KTNotificationObserver.h
//  KTLibs
//
//  Created by KermitLiu on 2017/3/8.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KTNotificationObserver)

// Add Observers
- (void)ktGetNotificationObserver:(id __strong *)observer
                          forName:(NSString *)name
                           object:(id)object
                            queue:(NSOperationQueue *)queue
                       usingBlock:(void (^)(NSNotification *note, id strongSelf))block;


- (void)ktGetNotificationObserver:(id __strong *)observer
                          forName:(NSString *)name
                           object:(id)object
              mainQueueUsingBlock:(void (^)(NSNotification *note, id strongSelf))block;


- (void)ktGetNotificationObserver:(id __strong *)observer
                          forName:(NSString *)name
              mainQueueUsingBlock:(void (^)(NSNotification *note, id strongSelf))block;



// Remove Observers
- (void)ktReleaseNotificationObserver:(id __strong *)observer;

@end
