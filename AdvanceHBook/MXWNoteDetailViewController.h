//
//  MXWNoteDetailViewController.h
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/19/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import UIKit;
@class MXWNote;

@interface MXWNoteDetailViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelPage;
@property (weak, nonatomic) IBOutlet UILabel *labelCreationDate;
@property (weak, nonatomic) IBOutlet UILabel *labelModificationDate;

@property (weak, nonatomic) IBOutlet UITextView *textNoteText;

@property (weak, nonatomic) IBOutlet UIImageView *imageNote;


- (IBAction)doneAction:(id)sender;
- (IBAction)trashAction:(id)sender;
- (IBAction)cameraAction:(id)sender;


- (id) initWithModel:(MXWNote *) aNote;





@end
