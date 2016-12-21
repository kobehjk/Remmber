//
//  IntroView.h
//  Remmber
//
//  Created by 何锦坤 on 15/10/26.
//  Copyright © 2015年 何锦坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroViewDelegate <NSObject>

-(void)onDoneButtonPressed;

@end

@interface IntroView : UIView
@property id<IntroViewDelegate> delegate;

@end
