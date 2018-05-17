//
//  TableViewCell.m
//  Assignment
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (self.lblTitle == nil) {
            self.lblTitle = [[UILabel alloc] init];
        }
        self.lblTitle.backgroundColor = [UIColor clearColor];
        self.lblTitle.textAlignment = NSTextAlignmentLeft;
        self.lblTitle.numberOfLines = 0;
        self.lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblTitle.font = [UIFont boldSystemFontOfSize:self.lblTitle.font.pointSize];
        self.lblTitle.textColor = [UIColor darkTextColor];
        
        if (self.lblDescription == nil) {
            self.lblDescription = [[UILabel alloc] init];
        }
        self.lblDescription.backgroundColor = [UIColor clearColor];
        self.lblDescription.numberOfLines = 0;
        self.lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblDescription.textAlignment = NSTextAlignmentLeft;
        self.lblDescription.textColor = [UIColor grayColor];
        
        if (self.imageHref == nil) {
            self.imageHref = [[UIImageView alloc]init];
        }
        self.imageHref.layer.cornerRadius = 8.0;
        self.imageHref.clipsToBounds = TRUE;
        
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblDescription];
        [self.contentView addSubview:self.imageHref];
        [self addLayoutConstraints];
    }
    
    return self;
}

-(void)addLayoutConstraints {
    
    self.imageHref.translatesAutoresizingMaskIntoConstraints = FALSE;
    self.lblTitle.translatesAutoresizingMaskIntoConstraints = FALSE;
    self.lblDescription.translatesAutoresizingMaskIntoConstraints = FALSE;
    
    //Dictionary with all the controls need to be display on the cell
    NSDictionary *views = @{@"imageHref":self.imageHref,
                            @"lblTitle":self.lblTitle,
                            @"lblDescription":self.lblDescription
                            };
    
    //Add constraints for image and title view
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[imageHref]-10-[lblTitle]-10-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[imageHref]-10-[lblDescription]-10-|" options:0 metrics:nil views:views]];
    
    // Vertical layouts
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[imageHref]->=10@999-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[lblTitle]-[lblDescription]->=10-|" options:0 metrics:nil views:views]];
    
    //Need to fix the height of the imageview
    //May WS will return differnet image size
    [self.imageHref addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageHref(75)]" options:0 metrics:nil views:views]];
    [self.imageHref addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageHref(75)]" options:0 metrics:nil views:views]];
    
    //Auto resize the height of the title label
    [self.lblTitle setContentHuggingPriority:999 forAxis:UILayoutConstraintAxisVertical];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)dealloc {
    self.lblTitle = nil;
    self.lblDescription = nil;
    self.imageHref = nil;
}
@end
