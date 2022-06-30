//
//  PostCell.m
//  Instagram
//
//  Created by Eric Moran on 6/27/22.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData {
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.post.image.url]];
    self.postImage.image = [UIImage imageWithData: imageData];
    
    self.postCaption.text = self.post.caption;
    self.postCaption.text = [NSString stringWithFormat:@"%@ %@", self.post.author.username, self.post.caption];
    
    NSMutableAttributedString *postText = [[NSMutableAttributedString alloc] initWithString:self.postCaption.text];
    NSRange boldRange = [self.postCaption.text rangeOfString:self.post.author.username];
    [postText addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:boldRange];
    [self.postCaption setAttributedText: postText];
    
    [self setTimestamp];
}

- (void)setTimestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date = self.post.createdAt;
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;

    NSDate *curDate = [NSDate date];
    NSTimeInterval diff = [curDate timeIntervalSinceDate:date];

    //format the created string based on if it was posted an hour or more ago or a minute or more ago
    NSInteger interval = diff;
    long minutes = (interval / 60) % 60;
    long hours = (interval / 3600);
    NSDateComponentsFormatter *formatter2 = [[NSDateComponentsFormatter alloc] init];
        formatter2.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
//        formatter2.allowedUnits = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        
        
    if (hours > 24)
    {
        formatter2.allowedUnits = NSCalendarUnitDay;
    }
    else if(hours > 1) {
        formatter2.allowedUnits = NSCalendarUnitHour;
        
    } else if(minutes > 1) {
        formatter2.allowedUnits = NSCalendarUnitMinute;
    } else {
        formatter2.allowedUnits = NSCalendarUnitSecond;
    }
    NSString *elapsed = [formatter2 stringFromDate:date toDate:[NSDate date]];
    self.timestamp.text = [NSString stringWithFormat:@"%@ ago", elapsed];
}
@end
