//
//  MinifigCell.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct MinifigCell: View {
    @EnvironmentObject private var  collection : UserCollection

    @ObservedObject var minifig : LegoMinifig
    @Environment(\.dataCache) var cache : DataCache
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ZStack(alignment: .bottomTrailing){
                self.makeImage()
                self.makePastil()
            }.frame(width:100,height: 150)

            .modifier(RoundedShadowMod())
            VStack(alignment: .leading, spacing: 8) {
                Text(minifig.name ?? minifig.minifigNumber).font(.headline).padding(.top,16)
                ForEach(minifig.subthemes, id: \.self){ sub in
                    Text(sub).font(.subheadline).foregroundColor(Color.gray)
                }
                
            }
            
        }.frame(height: 150)
        
        .contextMenu {

            Button(action: {
                self.collection.action(.qty(self.minifig.ownedLoose+1),on: self.minifig)

            }) {
                HStack(alignment: .lastTextBaseline) {
                    Image(systemName: "plus.circle" ).foregroundColor(.white).font(.headline)
                    Text("collection.increment").fontWeight(.bold)
                }
            }
            if self.minifig.ownedLoose > 0 {
                Button(action: {
                    self.collection.action(.qty(self.minifig.ownedLoose-1),on: self.minifig)

                }) {
                    HStack(alignment: .lastTextBaseline) {
                        Image(systemName: "minus.circle" ).foregroundColor(.white).font(.headline)
                        Text("collection.decrement").fontWeight(.bold)
                    }
                }
            }
            Button(action: {
                self.collection.action(.want(!self.minifig.wanted), on: self.minifig)
            }) {
                HStack(alignment: .lastTextBaseline) {
                    Image(systemName: minifig.wanted ? "heart.fill" : "heart").foregroundColor(.white).font(.headline)
                    Text("collection.want").fontWeight(.bold)
                }
            }
        }
    }
    
    
    func makeImage() -> some View{
        AsyncImage(string: minifig.imageUrl, cache: cache, configuration: {$0.resizable()})
        
        .aspectRatio(2/3, contentMode: .fill)
        .clipped()
        .background(Color.white)
        
    }
    func makePastil() -> some View {
        HStack {
            
            if minifig.ownedTotal != 0 {
                Text("\(minifig.ownedTotal)").font(.body).bold()
                    .padding(.horizontal,8).foregroundColor(.white)
            }
            
            if  minifig.wanted  {
                Image(systemName: minifig.wanted ? "heart.fill":"heart").font(.footnote)
                    .padding(.horizontal,8)
                    .padding(.vertical,8)
                    .foregroundColor(.white)
            }            
        }.background(RoundedCorners(color: Color.black, tl: 16, tr: 0, bl: 0, br: 0))
        
    }
}


struct MinifigCell_Previews: PreviewProvider {
    static var previews: some View {

            MinifigCell(minifig: LegoMinifig()).previewLayout(.fixed(width: 180, height: 320))

        
    }
}
