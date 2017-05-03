//
//  KtInputProtocol.h
//  KTLibs
//
//  Created by KermitLiu on 2017/5/3.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol KtInputActionDelegate <NSObject>

@optional

- (void)onSendText:(NSString *)text;

- (void)onCancelRecording;

- (void)onStopRecording;

- (void)onStartRecording;

@end
