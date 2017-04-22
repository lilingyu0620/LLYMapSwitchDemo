//
//  SHFHBuildAnnotationView.h
//  FocusLive
//
//  Created by 任丽凤 on 2016/12/15.
//  Copyright © 2016年 sohu. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class LLYDistrictsModel;
@class SHFHBuildAnnotationView;

@protocol SHFHBuildAnnotationViewDelegate <NSObject>

- (void)annotationClick:(SHFHBuildAnnotationView *)view isOpen:(BOOL)isOpen;

@end

@interface SHFHBuildAnnotationView : MAAnnotationView

@property (weak, nonatomic) id<SHFHBuildAnnotationViewDelegate> delegate;

@property (strong, nonatomic, readonly) LLYDistrictsModel *buildInfo;

- (void)loadUIData:(LLYDistrictsModel *)buildInfo;
- (void)setMBackgroundImageSeleted:(BOOL)selected;

@end
