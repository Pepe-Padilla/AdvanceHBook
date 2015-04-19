//
//  MXWNoteDetailViewController.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/19/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWNoteDetailViewController.h"
#import "MXWNote.h"

@interface MXWNoteDetailViewController ()

@property (strong,nonatomic) MXWNote * note;

@end

@implementation MXWNoteDetailViewController


- (id) initWithModel:(MXWNote *) aNote {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _note = aNote;
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.labelPage.text = [@"Page: " stringByAppendingString:[self.note.page stringValue]];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    self.labelCreationDate.text = [@"Creation Date: " stringByAppendingString:
                                   [dateFormatter stringFromDate:self.note.creationDate]];
    self.labelModificationDate.text = [@"Modification Date: " stringByAppendingString:
                                       [dateFormatter stringFromDate:self.note.modificationDate]];
    
    self.textNoteText.text = self.note.text;
    
    self.imageNote.image = self.note.noteImg;
    
}


#pragma mark - Actions
- (IBAction)doneAction:(id)sender {
    
    self.note.modificationDate = [NSDate date];
    
    self.note.text = self.textNoteText.text;
    
    self.note.noteImg = self.imageNote.image;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)trashAction:(id)sender {
    
    [self.note.managedObjectContext deleteObject:self.note];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (IBAction)cameraAction:(id)sender {
    
    self.note.text = self.textNoteText.text;
    
    UIImagePickerController * piker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        piker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        piker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    piker.delegate = self;
    
    piker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:piker animated:YES completion:^{
        
    }];

}

#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Sacamos la UImage del diccionario
    // Pico de memoria asegurado:
    UIImage  * img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    //La guardo en el modelo y la despliego
    self.imageNote.image = img;
    self.note.noteImg = img;
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
                             }];
}

@end
