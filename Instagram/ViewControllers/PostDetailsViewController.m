//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by Eric Moran on 6/28/22.
//

#import "PostDetailsViewController.h"

@interface PostDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postCaption;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.post.image.url]];
    self.postImage.image = [UIImage imageWithData: imageData];
    self.postCaption.text = self.post.caption;
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
    long seconds = interval % 60;
    long minutes = (interval / 60) % 60;
    long hours = (interval / 3600);
    if(hours > 1) {
        self.timestamp.text = [NSString stringWithFormat:@"%ldh ago", hours];
    } else if(minutes > 1) {
        self.timestamp.text = [NSString stringWithFormat:@"%ldm ago", minutes];
    } else {
        self.timestamp.text = [NSString stringWithFormat:@"%lds ago", seconds];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
