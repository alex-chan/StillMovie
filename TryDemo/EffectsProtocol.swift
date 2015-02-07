//
//  EffectsProtocol.swift
//  TryDemo
//
//  Created by Alex Chan on 15/2/3.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation

enum MyAVPlayerItemType{
    
    case MAIN_ITEM
    case PREFIX_ITEM
}

class MyAVPlayerItem: AVPlayerItem{
    
    var TYPE: MyAVPlayerItemType = MyAVPlayerItemType.MAIN_ITEM
    convenience init!(asset: AVAsset!, itemType type:MyAVPlayerItemType) {
        self.init(asset: asset)
        self.TYPE = type
    }
    

}

typealias PreviewEffectComplectionBlock = ([NSURL] ) -> Void
typealias ImplementEffectComplectionBlock = (NSURL) -> Void

protocol Effect{
    init(sourceURL: NSURL)
    func previewEffect(completionBlock: PreviewEffectComplectionBlock)
    func implementEffect()
    
}