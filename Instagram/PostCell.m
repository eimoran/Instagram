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


- (IBAction)logout2:(id)sender {
//    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
//        // PFUser.current() will now be nil
//        if (!error)
//        {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//            self.view.window.rootViewController = loginViewController;
//        }
//    }];
}
@end
