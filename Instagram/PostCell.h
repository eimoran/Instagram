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

@property (weak, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
