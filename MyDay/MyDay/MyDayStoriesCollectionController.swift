//
//  MyDayStories.swift
//  MyDay
//
//  Created by Gina Hagg on 5/13/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

//import Cocoa
import UIKit

class MyDayStoriesCollectionController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var myStoryCell:MyStoryViewCell?
    
    let stories = ["Happy","Sad","Content","Joyous","Ecstatic","Dreamy","Depressed","In hell","Crying","Pmsing","Angry","Hopeless", "Helpless", "Mental", "Silly", "Anxious", "Nervous"]
    
    private let reuseIdentifier = "StoryCell"
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
        
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var storyCell = (collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyStoryViewCell)
        storyCell.storyName.text = stories[indexPath.row]
        storyCell.setNeedsLayout()
        storyCell.layoutIfNeeded()
        return storyCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return sizingForRowAtIndexPath(indexPath)
    }
    
   
    func sizingForRowAtIndexPath(indexPath: NSIndexPath) -> CGSize {
        
                return CGSizeMake(110, 50)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    
    /*- (CGSize)sizingForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *title                  = @"This is a long title that will cause some wrapping to occur. This is a long title that will cause some wrapping to occur.";
    static NSString *subtitle               = @"This is a long subtitle that will cause some wrapping to occur. This is a long subtitle that will cause some wrapping to occur.";
    static NSString *buttonTitle            = @"This is a really long button title that will cause some wrapping to occur.";
    static CollectionViewCell *sizingCell   = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    sizingCell                          = [[NSBundle mainBundle] loadNibNamed:@"CollectionViewCell" owner:self options:nil][0];
    });
    [sizingCell configureWithTitle:title subtitle:[NSString stringWithFormat:@"%@: Number %d.", subtitle, (int)indexPath.row] buttonTitle:buttonTitle];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize cellSize = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"cellSize: %@", NSStringFromCGSize(cellSize));
    return cellSize;
    }
    - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *title                  = @"This is a long title that will cause some wrapping to occur. This is a long title that will cause some wrapping to occur.";
    static NSString *subtitle               = @"This is a long subtitle that will cause some wrapping to occur. This is a long subtitle that will cause some wrapping to occur.";
    static NSString *buttonTitle            = @"This is a really long button title that will cause some wrapping to occur.";
    CollectionViewCell *cell                = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureWithTitle:title subtitle:[NSString stringWithFormat:@"%@: Number %d.", subtitle, (int)indexPath.row] buttonTitle:buttonTitle];
    return cell;
    }*/
    
    
}
