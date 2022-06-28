//
//  PostDetailsViewController.h
//  Instagram
//
//  Created by Eric Moran on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "../Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostDetailsViewController : UIViewController

@property (weak, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
