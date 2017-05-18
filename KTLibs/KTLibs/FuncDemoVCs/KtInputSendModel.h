//
//  KtInputSendModel.h
//  KTLibs
//
//  Created by KermitLiu on 2017/5/4.
//  Copyright © 2017年 KermitLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KtInputSendModel : NSObject

@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * audioFilePath;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, assign) BOOL isPlaying;


@end
