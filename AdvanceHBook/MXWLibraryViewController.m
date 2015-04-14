//
//  MXWLibraryViewController.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/12/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWLibraryViewController.h"
#import "MXWBookViewController.h"
#import "MXWTag.h"
#import "MXWAuthor.h"
#import "MXWLibraryMng.h"
#import "Header.h"

@interface MXWLibraryViewController ()

@property (strong,nonatomic) MXWLibraryMng * library;
@property (strong,nonatomic) NSMutableDictionary * mdHeader;
@property (strong,nonatomic) NSMutableDictionary * mdFavorites;
@property (strong,nonatomic) NSMutableDictionary * mdGenders;
@property (strong,nonatomic) NSMutableDictionary * mdTitles;
@property (strong,nonatomic) NSMutableArray * maTags;
@property (strong,nonatomic) NSMutableArray * maAuthors;

@end

@implementation MXWLibraryViewController

//-(id) initWithArray:(NSMutableArray *)arrayOfFetchC style:(UITableViewStyle)aStyle {
//
//}

- (id) initWithStyle:(UITableViewStyle)style{
    if (self=[super initWithStyle:style]) {
        
        _library = [[MXWLibraryMng alloc] init];
        _mdHeader = [[NSMutableDictionary alloc] init];
        _mdFavorites = [[NSMutableDictionary alloc] init];
        _mdGenders = [[NSMutableDictionary alloc] init];
        _maTags = [[NSMutableArray alloc] init];
        _maAuthors = [[NSMutableArray alloc] init];
        
        self.title = @"Library";
        
    }
    
    return self;
}

- (void) manageStart {
    
    [self.library beginStack];
    
    NSError * error = nil;
    if (![self.library chargeLibrayWithError:&error]) {
        NSLog(@"Error in library: %@",error.userInfo);
    }
    
    
    
    self.mdHeader = [NSMutableDictionary
                     dictionaryWithDictionary:@{TITLE_SECTION : @"",
                                                SECTION_FRC : @"NO",
                                                NOFRC_COUNT : @1 }];
    
    self.mdFavorites = [self.library fetchForFavorites];
    self.mdGenders = [self.library fetchForGenders];
    self.maTags = [self.library fetchForTags];
    self.maAuthors = [self.library fetchForAuthors];
    
    NSMutableArray * aSections = [NSMutableArray arrayWithArray:@[self.mdHeader, self.mdFavorites]];
    
    [aSections addObjectsFromArray:self.maTags];
    
    self.arrayTable = aSections;
    [self performFetch];
    [self.library autoSave];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // Averiguar cual es la libreta
    id obj = [self fetchedObjectAtIndexPath:indexPath];
    
    MXWBook *b = nil;
    if ([obj isKindOfClass:[MXWBook class]]) {
        b=obj;
        
        
        // Crear una celda
        static NSString *cellID = @"notebookCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:cellID];
        }
        
        // Configurarla (sincronizar libreta -> celda)
        NSArray * aAtuthors = [b.authors allObjects];
        NSString * strAuthors = @"";
        
        for (MXWAuthor* auth in aAtuthors) {
            if (![strAuthors isEqualToString:@""]) {
                strAuthors = [strAuthors stringByAppendingString:@", "];
            }
            strAuthors = [strAuthors stringByAppendingString:auth.authorName];
        }
        
        cell.textLabel.text = b.title;
        cell.detailTextLabel.text = strAuthors;
        cell.imageView.image = b.portraidImg;
        
        // Devolverla
        return cell;
    } else {
        // Crear una celda
        static NSString *cellID = @"notebookCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:cellID];
        }
        
        cell.textLabel.text = @"Special Cell";
        
        return cell;
    }
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Averiguar cual es la libreta
    //NSLog(@"indexpagth section-row: %d - %d",indexPath.section, indexPath.row);
    
    id obj = [self fetchedObjectAtIndexPath:indexPath];
    
    MXWBook *b = nil;
    if ([obj isKindOfClass:[MXWBook class]]) {
        b=obj;
        
        if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
            [self.delegate libraryTableViewController:self
                                        didSelectBook:b];
        }
        //MXWBookViewController * bVC = [[MXWBookViewController alloc] initWithModel:b];
        
    }
}


@end
