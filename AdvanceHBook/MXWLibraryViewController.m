//
//  MXWLibraryViewController.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/12/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWLibraryViewController.h"
#import "MXWTag.h"
#import "MXWBook.h"
#import "MXWAuthor.h"


@interface MXWLibraryViewController ()

@end

@implementation MXWLibraryViewController

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar cual es la libreta
    MXWBook *b = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
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
    
    
}

@end
