//
//  ContentView.swift
//  BunkerGame
//
//  Created by Илья on 28.06.2021.
//

import SwiftUI
import Foundation
import Combine


let sexAll = ["Мужской", "Женский"]
let profAll = ["Охотник", "Врач", "Инженер"]

let humanImage = ["🧟‍♂️", "👨‍⚕️","👩‍⚕️","👨‍🔧","👩‍🔧", "👨‍🚒","👩‍🚒"]

var amountOfPeople = 10

var timeOfDay = 10.0

var bunker = Bunker()
var forest = Forest()
var mine = Mine()

struct ContentView: View {
    
    @ObservedObject var VM = ViewModel()
    @State var h1 : Int = 1
    
    var body: some View {
        
        VStack {
            HStack{
                //                Image(systemName: VM.world.isNight ? "sun.max.fill" : "moon.zzz.fill")
                Button(action: {
                    
                }){
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                //                Image(systemName: "sun.max.fill")
                
                Spacer()
                VStack{
                    Text("День: \(VM.world.day)")
                    HStack{
                        Text(VM.world.isNight ? "Ночь" : "Утро")
                        Image(systemName: VM.world.isNight ?  "moon.zzz.fill" : "sun.max.fill")
                    }
                }
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                Spacer()
                Button(action: {
                    VM.world.isPause.toggle()
                }, label: {
                    Image(systemName: VM.world.isPause ? "play.fill" : "pause.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
            }
            .padding()
            
            GeometryReader{ reader in
                
                ZStack{ //WORLD
                    
                    Color(VM.world.isNight ? .blue : .green)
                        .opacity(0.2)
                        .animation(.spring())
                    
                    VStack{
                        Text("Общее кол-во выжишвых: \(VM.world.humObj.humans.count)")
                        Text("Кол-во охотников: \(VM.world.humObj.getAmountOfPeopleByProfession(profession: "Охотник"))")
                        Text("Кол-во врачей: \(VM.world.humObj.getAmountOfPeopleByProfession(profession: "Врач"))")
                        Text("Кол-во инженеров: \(VM.world.humObj.getAmountOfPeopleByProfession(profession: "Инженер"))")
                        Text("Кол-во мужчин: \(VM.world.humObj.getAmountOfPeopleBySex(sex: "Мужской"))")
                        Text("Кол-во женщина: \(VM.world.humObj.getAmountOfPeopleBySex(sex: "Женский"))")
                        
                        VStack{
                            Text("\nh1\(h1)")
                        }
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: bunker.x - bunker.x0 + 30, height: bunker.y - bunker.y0 + 30)
                        
                        Text("Бункер\n\(amountOfPeople)/\(bunker.CapacityOfPeople)")
                    }
                    .position(x: (bunker.x + bunker.x0) / 2, y: (bunker.y + bunker.y0) / 2)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.5))
                            .frame(width: mine.x - mine.x0 + 30, height: mine.y - mine.y0 + 30)
                        Text("Шахта⛏")
                        
                    }
                    .position(x: (mine.x + mine.x0) / 2, y: (mine.y + mine.y0) / 2)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.green.opacity(0.5))
                            .frame(width: forest.x - forest.x0 + 30, height: forest.y - forest.y0 + 30)
                        Text("Лес🦌")
                        
                    }
                    .position(x: (forest.x + forest.x0) / 2, y: (forest.y + forest.y0) / 2)
                    
                    
                    ForEach(VM.world.humObj.humans){human in
                        
                        ZStack{
                            
                            if human.Profession == "Охотник"{
                                
                                ZStack{
                                    
                                    Text(human.sex == "Мужской" ? humanImage[5] : humanImage[6])
                                        
                                        .foregroundColor(Color.green)
                                    HealthBar(human: human)
                                        .offset(y: -human.size - 2)
                                }
                                .position(human.position)
                                .onTapGesture {
                                    let index_ = VM.world.humObj.humans.firstIndex(where: {$0.id == human.id
                                    })
                                    
                                    h1 = VM.world.humObj.humans[index_!].Character.Health
                                    
                                    
                                }
                            }
                            else if human.Profession == "Врач"{
                                
                                
                                ZStack{
                                    
                                    Text(human.sex == "Мужской" ? humanImage[1] : humanImage[2])
                                    
                                    HealthBar(human: human)
                                        .offset(y: -human.size - 2)
                                    
                                }
                                .position(human.position)
                                
                            }
                            else if human.Profession == "Инженер"{
                                
                                ZStack{
                                    
                                    Text(human.sex == "Мужской" ? humanImage[3] : humanImage[4])
                                        .foregroundColor(.blue)
                                    
                                    HealthBar(human: human)
                                        .offset(y: -human.size - 2)
                                    
                                }
                                .position(human.position)
                                
                            }
                            
                        }
                    }
                    
                    ForEach(VM.world.zombObj.zombies){zombie in
                        
                        ZStack{
                            
                            Circle()
                                .fill(Color.red.opacity(0.5))
                                .frame(width: CGFloat(20 + zombie.Character.Agility) * 2, height: CGFloat(20 + zombie.Character.Agility) * 2)
                            Text(humanImage[0])
                            
                            
                        }
                        .onAppear{
                            
                            
                            var randomX = CGFloat(0)
                            var randomY = CGFloat(0)
                            var pos = CGPoint(x: 0, y: 0)
                            
                            //if VM.world.isNight{
                            
                            repeat{
                                randomX = CGFloat.random(in: 0..<reader.frame(in: .global).width)
                                
                                randomY = CGFloat.random(in: 0..<reader.frame(in: .global).height)
                                pos = CGPoint(x: randomX, y: randomY)
                                
                            }while(pos.x > bunker.x0 - 40 && pos.y > bunker.y0 - 40 && pos.x < bunker.x + 40 && pos.y < bunker.y + 40)
                            
                            
                            //}
                            zombie.position = pos
                        }
                        .position(zombie.position)
                        //.animation(.spring())
                        
                    }
                }

            }
        }
    }
}

//struct InfoView : View{
//
//   var body: some View{
//
//
//
//    }
//
//}

struct HealthBar : View{
    
    var human : Human
    @State var colorState : Color = .green
    
    var body: some View{
        
            Capsule()
                .frame(width: CGFloat(human.Character.Health)/CGFloat(human.Character.maxHealth) * human.size, height: 2)
                
                .onAppear{
                    if human.Character.Health > 70{
                        colorState = .green
                    }
                    else if human.Character.Health > 30{
                        colorState = .yellow
                    }
                    else {
                        colorState = .red
                    }
                }
                .foregroundColor(colorState)
                .cornerRadius(20)
            
            
            
    }
}

class Bioms {
    var bunker : Bunker
    var forest : Forest
    var mine : Mine
    
    init(){
        bunker = Bunker.init()
        forest = Forest.init()
        mine = Mine.init()
    }
}

class Forest {
    
    var x0 : CGFloat
    var y0 : CGFloat
    var x : CGFloat
    var y : CGFloat
    
    init(){
        x0 = 300
        y0 = 380
        x = UIScreen.main.bounds.width - 30
        y = 600
    }
    
}

class Mine {
    var x0 : CGFloat
    var y0 : CGFloat
    var x : CGFloat
    var y : CGFloat
    
    init(){
        x0 = 50
        y0 = 630
        x = 250
        y = 700
    }
    
}

class Bunker {
    
    var Health : Int = 0
    var CapacityOfPeople : Int
    var FoodSupply : Int
    var Growth : Double
    var x0 : CGFloat
    var y0 : CGFloat
    var x : CGFloat
    var y : CGFloat
    
    
    init(){
        Health = 1000
        CapacityOfPeople = amountOfPeople
        FoodSupply = 1000
        Growth = 0.01
        x0 = 100
        y0 = 100
        x = 200
        y = 150
    }
}

class Zombie : Identifiable{
    
    var id = UUID()
    var position : CGPoint
    var Character : Сharacteristic
    
    init(){
        position = CGPoint(x: bunker.x0, y: bunker.y0)
        Character = Сharacteristic.init()
        Character.Strength /= 2
        Character.Agility /= 2
        Character.Intelligence = 0
        Character.Health = 50
        Character.maxHealth = 50
    }
    
    func changePos() {
        
        var randomX = CGFloat(0)
        var randomY = CGFloat(0)
        var pos = CGPoint(x: 0, y: 0)
        
        repeat{
            randomX = CGFloat.random(in: 0..<UIScreen.main.bounds.width)
            
            randomY = CGFloat.random(in: 0..<UIScreen.main.bounds.height)
            pos = CGPoint(x: randomX, y: randomY)
            
        }while(pos.x > bunker.x0 - 40 && pos.y > bunker.y0 - 40 && pos.x < bunker.x + 40 && pos.y < bunker.y + 40)
        
        position = pos
        
    }
}

class ZombieObject : ObservableObject{
    
    @Published var zombies : [Zombie] = []
    
    init(){
        
        for _ in 0..<amountOfPeople / 5 {
            zombies.append(Zombie())
        }
    }
    
    func tick(){
        zombies.indices.forEach{
            index in
            zombies[index].changePos()
        }
    }
}

class Human : Identifiable{
    
    var id = UUID()
    var sex : String
    var size: CGFloat
    
    var position: CGPoint
    var angle : CGFloat
    var Character : Сharacteristic
    var Profession : String
    
    var ticks: Int
    
    func tick() {
        ticks += 1
        
//
//        if Profession == "Охотник"{
//            moveTo(biom: "Лес")
//        }
//        else{
            step()
        //}
        
    }
    
    init(){
        
        sex = sexAll[Bool.random() == true ? 1 : 0]
        size = 10.0
        position = CGPoint(x: bunker.x0, y: bunker.y0)
        angle = 0
        Character = Сharacteristic.init()
        Profession = profAll[Int.random(in: 0...2)]
        ticks = 0
        
    }
    
    func step() {
        var newPosition = position
        
        repeat {
            newPosition = position
            
            angle += CGFloat.random(in: -30..<30)
            newPosition.y += sin(angle * CGFloat.pi / 180) * CGFloat(Character.Agility) / 2
            newPosition.x += cos(angle * CGFloat.pi / 180) * CGFloat(Character.Agility) / 2
        } while newPosition.y < bunker.y0 || newPosition.x < bunker.x0 || newPosition.y > bunker.y || newPosition.x > bunker.x
        
        position = newPosition
    }
    
//    func moveTo(biom : String){
//
//        var newPosition = position
//        var length : CGFloat
//        var biomСoordX0Y0 : CGPoint = CGPoint()
//        var biomCoordXY : CGPoint = CGPoint()
//
//        if biom == "Лес"{
//            biomСoordX0Y0 = CGPoint(x: forest.x0, y: forest.y0)
//            biomCoordXY = CGPoint(x: forest.x, y: forest.y)
//        }
//        else if biom == "Шахта"{
//            biomСoordX0Y0 = CGPoint(x: mine.x0, y: mine.y0)
//            biomCoordXY = CGPoint(x: mine.x, y: mine.y)
//        }
//
//        newPosition.y = CGFloat.random(in: biomСoordX0Y0.y...biomCoordXY.y)
//        newPosition.x = CGFloat.random(in: biomСoordX0Y0.x...biomCoordXY.x)
//
//        newPosition.x -= position.x
//        newPosition.y -= position.y
//
//        length = sqrt(pow(newPosition.x, 2) + pow(newPosition.y, 2))
//
//
//        position = newPosition
////        repeat{
////
////            newPosition = position
////
////            newPosition.y += sin(angle * CGFloat.pi / 180)
////            * CGFloat(Character.Agility) / 2
////            newPosition.x += cos(angle * CGFloat.pi / 180) * CGFloat(Character.Agility) / 2
////        } while (newPosition.y > biomPos.minY )
//
//
//    }
    
}

class HumanObject: ObservableObject {
    @Published var humans : [Human] = []
    
    init() {
        
        
        repeat{
            humans = []
            
            for _ in 0..<amountOfPeople{
                humans.append(Human())
            }
        
        }
        while(self.getAmountOfPeopleByProfession(profession: "Охотник") == 0 || self.getAmountOfPeopleByProfession(profession: "Врач") == 0 || self.getAmountOfPeopleByProfession(profession: "Инженер") == 0 || self.getAmountOfPeopleBySex(sex: "Мужской") == 0 || self.getAmountOfPeopleBySex(sex: "Женский") == 0)
    }

    func getAmountOfPeopleBySex(sex: String) -> Int{
        
        var newArr = humans
        newArr = humans.filter{$0.sex == sex}
        return newArr.count

    }
    
    func getAmountOfPeopleByProfession(profession: String) -> Int{
        
        var newArr = humans
        newArr = humans.filter{$0.Profession == profession}
        return newArr.count
    }
    
    func tick(){
        humans.indices.forEach{
            index in
            humans[index].tick()
        }
    }
}

class Сharacteristic {
    
    var Health : Int
    var maxHealth : Int
    
    var Strength : Int
    var Agility : Int
    var Intelligence : Int
    
    
    init(){
        
        
        Strength = Int.random(in: 1...10)
        Agility = Int.random(in: 1...10)
        Intelligence = Int.random(in: 1...10)
        
        Health = Int.random(in: 70...100)
        maxHealth = 100
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class World : ObservableObject {
    
    static var shared = World()
    var humObj = HumanObject()
    var zombObj = ZombieObject()
    var bioms = Bioms()
    @Published var isNight : Bool = false
    @Published var isPause = true
    @Published var day : Int = 0
        
    init(){
        
        Timer.scheduledTimer(withTimeInterval: timeOfDay, repeats: true){
            [self] timer in
            if !isPause{
                day += 1
            }
            
            if (amountOfPeople < bunker.CapacityOfPeople && humObj.getAmountOfPeopleBySex(sex: "Мужской") != 0 && humObj.getAmountOfPeopleBySex(sex: "Женский") != 0){
                humObj.humans.append(Human())
                amountOfPeople += 1
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: timeOfDay / 2, repeats: true){
            [self] timer in
            
            if !isPause {
                isNight.toggle()
            }
            
//            if !isNight {
//                zombObj.tick()
//                objectWillChange.send()
//            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){
            [self] timer in
            
            if !isPause {
                humObj.tick()
                objectWillChange.send()
            }
        }
    }
}


class ViewModel: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    var world = World.shared
    
    init() {
        world.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        .store(in: &subscriptions)
        
    }
}
