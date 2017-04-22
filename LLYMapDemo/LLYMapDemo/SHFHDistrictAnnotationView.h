//
//  SHFHDistrictAnnotationView.h
//  FocusLive
//
//  Created by 任丽凤 on 2016/12/15.
//  Copyright © 2016年 sohu. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "LLYDistrictsModel.h"

@protocol SHFHDistrictAnnotationDelegate <NSObject>

- (void)districtAnnotationClick:(LLYDistrictsModel *)districtInfo;

@end

@interface SHFHDistrictAnnotationView : MAAnnotationView

@property (nonatomic, weak) id<SHFHDistrictAnnotationDelegate> delegate;

- (void)loadUIData:(LLYDistrictsModel *)districtData;

@end
