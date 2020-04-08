//
//  RCCustomTableViewCell.m
//  RC_TableViewScrollDemo
//
//  Created by renchao on 2020/3/21.
//  Copyright © 2020 renchao. All rights reserved.
//

#import "RCCustomTableViewCell.h"

@interface RCCustomTableViewCell ()

@end

@implementation RCCustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
