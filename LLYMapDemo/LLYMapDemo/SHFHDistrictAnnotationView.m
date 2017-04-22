//
//  SHFHDistrictAnnotationView.m
//  FocusLive
//
//  Created by 任丽凤 on 2016/12/15.
//  Copyright © 2016年 sohu. All rights reserved.
//

#import "SHFHDistrictAnnotationView.h"

@interface SHFHDistrictAnnotationView ()

@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UILabel *mLabelName;
@property (strong, nonatomic) UILabel *mLabelCount;

@property (strong, nonatomic) LLYDistrictsModel *districtInfo;

@end

@implementation SHFHDistrictAnnotationView

#pragma mark - Override
- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected) {
        return;
    }
    
    if (selected) {
        if ([self.delegate respondsToSelector:@selector(districtAnnotationClick:)]) {
            [self.delegate districtAnnotationClick:_districtInfo];
        }
    }
}

#pragma mark - Life Cycle
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        UIImage *bgImage = [UIImage imageNamed:@"home_map_district_bg"];
        self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
        self.bgImageView.image = bgImage;
        [self addSubview:self.bgImageView];
        
        CGRect frame = self.bgImageView.frame;
        
        self.mLabelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 19, frame.size.width, 20)];
        self.mLabelName.font = [UIFont systemFontOfSize:16];
        self.mLabelName.textColor = [UIColor whiteColor];
        self.mLabelName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.mLabelName];
        
        self.mLabelCount = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_mLabelName.frame) + 3.0f, frame.size.width, 12)];
        self.mLabelCount.font = [UIFont systemFontOfSize:11];
        self.mLabelCount.textColor = [UIColor whiteColor];
        self.mLabelCount.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.mLabelCount];

        //必须设置 否则，无点击效果
        self.bounds = self.bgImageView.frame;
    }
    return self;
}

- (void)loadUIData:(LLYDistrictsModel *)districtData
{
    self.districtInfo = districtData;

    self.mLabelName.text = districtData.districtName;
    self.mLabelCount.text = [NSString stringWithFormat:@"%@个楼盘",districtData.buildingCount];
}

@end
