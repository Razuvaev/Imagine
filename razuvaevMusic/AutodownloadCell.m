//
//  AutodownloadCell.m
//  razuvaevMusic
//
//  Created by Vladimir Vishnyagov on 23.08.16.
//  Copyright © 2016 Pavel Razuvaev. All rights reserved.
//

#import "AutodownloadCell.h"

@interface AutodownloadCell ()

@property (nonatomic,strong) UISwitch *switchComponent;

@end

@implementation AutodownloadCell

- (void)prepareForReuse {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)loadView {
    self.textLabel.text = @"Автозагрузка песен";
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.switchComponent];
    [_switchComponent setOn:[[MainStorage sharedMainStorage].currentUser.settings.autodownload boolValue]];
}

- (UISwitch*)switchComponent {
    if (!_switchComponent) {
        _switchComponent = [[UISwitch alloc]init];
        [_switchComponent addTarget:self action:@selector(changeSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return _switchComponent;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_switchComponent sizeToFit];
    _switchComponent.frame = (CGRect) {
        .origin.x = screenWidth - 60,
        .origin.y = self.frame.size.height/2.f - _switchComponent.frame.size.height/2.f,
        .size = _switchComponent.frame.size
    };
}

- (void)changeSwitch {
    Settings *settings = [MainStorage sharedMainStorage].currentUser.settings;
    settings.autodownload = @(_switchComponent.on);
    [[MainStorage sharedMainStorage] saveContext];
}

@end
