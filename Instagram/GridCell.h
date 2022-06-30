//
//  GridCell.h
//  Instagram
//
//  Created by Eric Moran on 6/29/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface GridCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePost;
@property (weak, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
