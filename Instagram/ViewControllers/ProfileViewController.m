//
//  ProfileViewController.m
//  Instagram
//
//  Created by Eric Moran on 6/29/22.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"
#import "Post.h"
#import "../GridCell.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
- (IBAction)chooseProfilePic:(id)sender;
@property (strong, nonatomic) NSMutableArray *postArray;
@property (weak, nonatomic) IBOutlet UILabel *username;

//@property (nonatomic, strong) UIRefreshControl *refreshControl;



@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.gridView.dataSource = self;
    self.gridView.delegate = self;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.gridView.collectionViewLayout;
    layout.minimumLineSpacing =0;
    layout.minimumInteritemSpacing = 0;
    NSLog(@"%f", self.gridView.frame.size.width);
    CGFloat itemWidth = (self.gridView.frame.size.width/3 - 15);
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
//    self.gridView.heightAnchor =
    
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseProfilePic:)];
    [imageTapRecognizer setDelegate:self];
    [self.profilePic addGestureRecognizer:imageTapRecognizer];
    
    
    self.postArray = [[NSMutableArray alloc] init];
    
    [self getPosts];
    
    
    PFUser *user = [PFUser currentUser];
    PFFileObject *pic = user[@"profilePic"];
    
    NSURL *url = [NSURL URLWithString:pic.url];
    
    if (pic)
    {
        [self.profilePic setImageWithURL:url];
    }
    else{
        self.profilePic.image = [UIImage imageNamed:@"profile_tab"];
    }
//    NSLog(@"%@", user.username);
    self.username.text = user.username;
    
}

- (void)getPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    query.limit = 100;
    NSLog(@"%@", [PFUser currentUser].objectId);
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"author" equalTo:user];
    [query orderByDescending:@"createdAt"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postArray = posts;
            [self.gridView reloadData];
//            NSLog(@"%@", self.postArray);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
//        [self.refreshControl endRefreshing];
    }];
}




- (IBAction)chooseProfilePic:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
//    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    self.profilePic.image = info[UIImagePickerControllerOriginalImage];
//    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    PFUser *user = [PFUser currentUser];
    CGSize size = CGSizeMake(1000, 1000);
    self.profilePic.image = [self resizeImage:self.profilePic.image withSize:size];
    user[@"profilePic"] = [Post getPFFileFromImage:self.profilePic.image];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[PFUser currentUser] saveInBackground];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)gridView cellForItemAtIndexPath:
    (NSIndexPath *)indexPath {
    GridCell *cell = [gridView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
    
    cell.post = self.postArray[indexPath.row];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: cell.post.image.url]];
    cell.profilePost.image = [UIImage imageWithData: imageData];
    
    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postArray.count;
}

@end
