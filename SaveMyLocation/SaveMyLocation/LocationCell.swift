//
//  LocationCell.swift
//  SaveMyLocation
//
//  Created by Gina Hagg on 6/11/15.
//  Copyright (c) 2015 Gina Hagg. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    var cornerRadius = 0.0
    var separatorHeight = 0.0
    var backgroundVieww : FUICellBackgroundView = FUICellBackgroundView()
    var selectedBackgroundVieww :FUICellBackgroundView = FUICellBackgroundView()    
    
    func configureFlatCellWithColor(color:UIColor,selectedColor:UIColor, textColor: UIColor,
        selectedTextColor: UIColor){
            configureFlatCellWithColor(color,selectedColor:selectedColor, textColor:textColor, selectedTextColor:selectedTextColor, roundingCorners: UIRectCorner(0))
    }
    
    func configureFlatCellWithColor(color:UIColor,selectedColor:UIColor, textColor: UIColor, selectedTextColor: UIColor, roundingCorners:(UIRectCorner) ){
        backgroundVieww.backgroundColor = color;
        backgroundVieww.roundedCorners = UIRectCorner.AllCorners;
        backgroundVieww.cornerRadius = 0.5
        backgroundVieww.separatorHeight = 0.2
        
        selectedBackgroundVieww.roundedCorners = roundingCorners
        selectedBackgroundVieww.backgroundColor = selectedColor
        self.backgroundView = backgroundVieww
        self.selectedBackgroundView = selectedBackgroundVieww
        
        //The labels need a clear background color or they will look very funky
        self.textLabel!.backgroundColor = UIColor.clearColor()
        
        self.detailTextLabel!.backgroundColor = UIColor.clearColor()
        self.detailTextLabel!.textColor = textColor
        self.detailTextLabel!.highlightedTextColor = selectedTextColor
        
        //Guess some good text colors
        self.textLabel!.textColor = textColor
        self.textLabel!.highlightedTextColor = selectedTextColor
        
        
    }
    
    func settCornerRadius(cornerRadius:CGFloat) {
        backgroundVieww.cornerRadius = cornerRadius
        self.backgroundView = backgroundView
       
        selectedBackgroundVieww.cornerRadius = cornerRadius
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    func settSeparatorHeight(separatorHeight:CGFloat) {
        self.backgroundVieww.separatorHeight = separatorHeight
        self.selectedBackgroundVieww.separatorHeight = separatorHeight
        self.backgroundView = backgroundVieww
        self.selectedBackgroundView = selectedBackgroundVieww
    }

}
