//
//  MenuView.swift
//  BunkerGame
//
//  Created by Илья on 05.07.2021.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        
        //ZStack{
        
        VStack{
            Text("Бункер")
                .font(.system(size: 40, weight: .bold, design: .rounded))
            Text("Выполнил работу: Викторов Илья ПИ-91")
                .foregroundColor(.gray)
                .font(.system(Font.TextStyle.subheadline))
            //Spacer()
            HStack{

                Button(action:{
                    
                }){
                    Image(systemName: "chevron.right.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                        .padding()
                    
                        
                    
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        
        }
    //}
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
