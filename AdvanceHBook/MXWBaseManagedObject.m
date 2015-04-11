//
//  MXWBaseManagedObject.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/11/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWBaseManagedObject.h"

@implementation MXWBaseManagedObject

#pragma mark - Class methods
+(NSArray*)observableKeys{
    
    return @[];
}


#pragma mark - Life cycle
-(void) awakeFromInsert{
    [super awakeFromInsert];
    
    // Solo se produce una vez en la vida del objeto
    [self setupKVO];
    
}

-(void) awakeFromFetch{
    [super awakeFromFetch];
    
    // Se produce n veces a lo largo de la vida del objeto
    [self setupKVO];
    
}

-(void) willTurnIntoFault{
    [super willTurnIntoFault];
    
    // Se produce cuando el objeto se vacia convirtiéndose en
    // un fault.
    // Baja en todas las notificaciones
    [self tearDownKVO];
}

#pragma mark - KVO
-(void) setupKVO{
    
    // Observamos todas las propiedades EXCEPTO modificationDate
    for (NSString *key in [[self class] observableKeys]) {
        
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:NULL];
        
    }
    
}

-(void) tearDownKVO{
    // me doy de baja de todas las notificaciones
    for (NSString *key in [[self class] observableKeys]) {
        
        [self removeObserver:self
                  forKeyPath:key];
    }
}

@end
