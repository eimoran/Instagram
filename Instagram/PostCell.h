//
//  PostCell.h
//  Instagram
//
//  Created by Eric Moran on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postCaption;
@property (weak, nonatomic) IBOutlet UIButton *logout2;
- (IBAction)logout2:(id)sender;

@property (weak, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
