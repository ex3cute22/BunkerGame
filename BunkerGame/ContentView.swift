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

let personage = ["🧟‍♂️", "👨‍⚕️","👩‍⚕️","👨‍🔧","👩‍🔧", "👨‍🚒","👩‍🚒", "☠️", "🔧"]

var amountOfPeople = 10
var currentIndex = 0

var timeOfDay = 30.0
let freq = 0.1

var bunker = Bunker()
var forest = Forest()
var mine = Mine()

var choose : Bool = Bool.random()

var isFirstLaunch = true
var installTimerOfDay = true
var installTimerOfHalfDay = true

struct ContentView: View {
    
    @ObservedObject var VM = ViewModel()
    @State var checkSettingsView = false
    @State var checkInfoPerson = false
    
    var body: some View {
        
        NavigationView{
            VStack {
                
                HStack{
                    
                    NavigationLink(
                        destination: InfoView(humObj: VM.world.humObj),
                        label: {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 30, height: 30)
                        })
                    
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
                        
                        if !VM.world.isPause{
                            installTimerOfDay = true
                            installTimerOfHalfDay = true
                            
                        }
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
                            .ignoresSafeArea()
                            .animation(.spring())
                        
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: bunker.x - bunker.x0 + 30, height: bunker.y - bunker.y0 + 30)
                            
                            Text("Бункер\n👤\(VM.world.humObj.getAmountOfPeople())/\(bunker.CapacityOfPeople)\n🍖\(bunker.FoodSupply)/\(bunker.maxFoodSupply)\n🧱\(bunker.ResourcesSupply)/\(bunker.maxResourcesSupply)")
                        }
                        .position(bunker.position)
                        //                    .gesture(DragGesture()
                        //                                .onChanged{value in
                        //
                        //                                    bunker.position = value.location
                        //
                        //                                }
                        //                    )
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.black.opacity(0.5))
                                .frame(width: mine.x - mine.x0 + 30, height: mine.y - mine.y0 + 30)
                            Text("Шахта⛏\n🧱\(mine.amountOfResources)/\(VM.world.humObj.getAmountOfPeople())")
                            
                        }
                        .position(x: (mine.x + mine.x0) / 2, y: (mine.y + mine.y0) / 2)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.green.opacity(0.5))
                                .frame(width: forest.x - forest.x0 + 30, height: forest.y - forest.y0 + 30)
                            Text("Лес🦌\n🍖\(forest.amountOfResources)/\(VM.world.humObj.getAmountOfPeople())")
                            
                        }
                        
                        .position(x: (forest.x + forest.x0) / 2, y: (forest.y + forest.y0) / 2)
                        
                        
                        ForEach(VM.world.humObj.humans){human in
                            
                            //VM.world.humObj.humans.indices.forEach{
                            //ZStack{
                            
                            if human.Profession == "Охотник"{
                                
                                ZStack{
                                    
                                    //if (human.isAlive){
                                    Text(human.isAlive == false ? personage[7] : human.sex == "Мужской" ? personage[5] : personage[6])
                                        
                                        //                                        }
                                        //                                        else {
                                        //                                            Text(personage[7])
                                        //                                        }
                                        
                                        .foregroundColor(Color.green)
                                    VStack{
                                        Text(human.isFight ? "⚔️" : "")
                                            .font(.system(size: 12))
                                        Capsule()
                                            .frame(width: CGFloat(human.Character.Health)/CGFloat(human.Character.maxHealth) * human.size, height: 2)
                                            //.fill(Color.white)
                                            .foregroundColor(human.Character.Health > 70 ? .green : human.Character.Health > 30 ? .yellow : .red)
                                            .cornerRadius(20)
                                        Capsule()
                                            .frame(width: CGFloat(human.satiety)/10 * human.size, height: 2)
                                            .foregroundColor(.blue)
                                            .cornerRadius(20)
                                            .offset(y: -6)
                                    }.offset(y: -6)
                                    .offset(y: -human.size - 2)
                                }
                                .position(human.position)
                                .onTapGesture {
                                    let index_ = VM.world.humObj.humans.firstIndex(where: {$0.id == human.id
                                    })
                                    
                                    
                                    currentIndex = index_!
                                    checkInfoPerson = true
                                    
                                }
                            }
                            else if human.Profession == "Врач"{
                                
                                
                                ZStack{
                                    
                                    Text(human.sex == "Мужской" ? personage[1] : personage[2])
                                    
                                    VStack{
                                        //                                        Text(human.isFight == true ? "⚔️" : "")
                                        //                                            .font(.system(size: 10))
                                        Capsule()
                                            .frame(width: CGFloat(human.Character.Health)/CGFloat(human.Character.maxHealth) * human.size, height: 2)
                                            .foregroundColor(human.Character.Health > 70 ? .green : human.Character.Health > 30 ? .yellow : .red)
                                            .cornerRadius(20)
                                        Capsule()
                                            .frame(width: CGFloat(human.satiety)/10 * human.size, height: 2)
                                            .foregroundColor(.blue)
                                            .cornerRadius(20)
                                            .offset(y: -6)
                                    }//.offset(y: -6)
                                    .offset(y: -human.size)
                                    
                                }
                                .position(human.position)
                                .onTapGesture {
                                    let index_ = VM.world.humObj.humans.firstIndex(where: {$0.id == human.id
                                    })
                                    
                                    
                                    currentIndex = index_!
                                    checkInfoPerson = true
                                    
                                }
                                
                            }
                            else if human.Profession == "Инженер"{
                                
                                ZStack{
                                    
                                    Text(human.isFree == false ? personage[8] : human.sex == "Мужской" ? personage[3] : personage[4])
                                        .foregroundColor(.blue)
                                    
                                    VStack{
                                        Capsule()
                                            .frame(width: CGFloat(human.Character.Health)/CGFloat(human.Character.maxHealth) * human.size, height: 2)
                                            .foregroundColor(human.Character.Health > 70 ? .green : human.Character.Health > 30 ? .yellow : .red)
                                            .cornerRadius(20)
                                        Capsule()
                                            .frame(width: CGFloat(human.satiety)/10 * human.size, height: 2)
                                            .foregroundColor(.blue)
                                            .cornerRadius(20)
                                            .offset(y: -6)
                                    }//.offset(y: -6)
                                    .offset(y: -human.size)
                                    
                                }
                                .position(human.position)
                                .onTapGesture {
                                    let index_ = VM.world.humObj.humans.firstIndex(where: {$0.id == human.id
                                    })
                                    
                                    
                                    currentIndex = index_!
                                    checkInfoPerson = true
                                    
                                }
                                
                                //}
                                
                            }
                        }
                        
                        if VM.world.isNight {
                            
                            ForEach(VM.world.zombObj.zombies){zombie in
                                
                                ZStack{
                                    
                                    Circle()
                                        .fill(Color.red.opacity(0.5))
                                        .frame(width: zombie.isFight ? 0 : zombie.range, height: zombie.isFight ? 0 : zombie.range)
                                    Text(personage[0])
                                    
                                    
                                }
                                .onAppear{
                                    
                                    
                                    var randomX = CGFloat(0)
                                    var randomY = CGFloat(0)
                                    var pos = CGPoint(x: 0, y: 0)
                                    
                                    repeat{
                                        randomX = CGFloat.random(in: 40..<reader.frame(in: .global).width-40)
                                        
                                        randomY = CGFloat.random(in: 40..<reader.frame(in: .global).height-40)
                                        pos = CGPoint(x: randomX, y: randomY)
                                        
                                    }while(pos.x > bunker.x0 - 40 && pos.y > bunker.y0 - 40 && pos.x < bunker.x + 40 && pos.y < bunker.y + 40 || (pos.x + zombie.range) > reader.frame(in: .global).width || (pos.x - zombie.range) < 0)
                                    
                                    
                                    zombie.position = pos
                                }
                                .position(zombie.position)
                                .animation(.spring())
                                
                            }
                        }
                        
                        if checkInfoPerson{
                            ZStack{
                                
                                VStack {
                                    HStack(spacing: 40){
                                        
                                        if VM.world.humObj.humans[currentIndex].Profession == "Охотник"{
                                            Text(VM.world.humObj.humans[currentIndex].sex == "Мужской" ? personage[5] : personage[6])
                                                .font(.system(size: 40))
                                        }
                                        else if VM.world.humObj.humans[currentIndex].Profession == "Врач"{
                                            Text(VM.world.humObj.humans[currentIndex].sex == "Мужской" ? personage[1] : personage[2])
                                                .font(.system(size: 40))
                                        }
                                        else if
                                            VM.world.humObj.humans[currentIndex].Profession == "Инженер"{
                                            Text(VM.world.humObj.humans[currentIndex].sex == "Мужской" ? personage[3] : personage[4])
                                                .font(.system(size: 40))
                                        }
                                        
                                        VStack(alignment: .leading){
                                            
                                            Text("❤️ Здоровье: \(VM.world.humObj.humans[currentIndex].Character.Health)/\(VM.world.humObj.humans[currentIndex].Character.maxHealth)")
                                            Text("🍗 Сытость: \(VM.world.humObj.humans[currentIndex].satiety)/10")
                                            
                                            Text("💪 Сила: \(VM.world.humObj.humans[currentIndex].Character.Strength)")
                                            Text("🏃‍♂️ Ловкость: \(VM.world.humObj.humans[currentIndex].Character.Agility)")
                                            Text("🧠 Интеллект: \(VM.world.humObj.humans[currentIndex].Character.Intelligence)")
                                        }
                                    }
                                    .padding(.top)
                                    Button(action: {
                                        checkInfoPerson.toggle()
                                    }){
                                        Image(systemName: "xmark.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .padding(.bottom)
                                        
                                    }
                                    
                                }.background(
                                    Capsule()
                                        .fill(Color.white)
                                        .frame(width: UIScreen.main.bounds.width - 30, height: 180)
                                        .shadow(radius: 5)
                                        .padding()
                                    
                                )
                                //.animation(.spring())
                            }
                            
                        }
                    }
                    //}
                }
                
            }
            //.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            
        }
    }
}

struct InfoView : View{
    
    @Environment (\.presentationMode) var presentation
    @ObservedObject var humObj : HumanObject
    
    var body: some View{
        NavigationView{
            VStack{
                Form{
                    Section(header: Text("Выжившие").multilineTextAlignment(.leading)){
                        Stepper("👥 Общее кол-во выжишвых: \(humObj.getAmountOfPeople())"){
                            
                            if humObj.getAmountOfPeople() < bunker.CapacityOfPeople{
                                humObj.humans.append(Human())
                            }
                        } onDecrement: {
                            
                            if humObj.getAmountOfPeople() > 0{
                                humObj.humans.removeLast()
                            }
                        }
                        Text("☠️ Кол-во смертей: \(humObj.getAmountOfDeaths())")
                        Text("👨‍🚒 Кол-во охотников: \(humObj.getAmountOfPeopleByProfession(profession: "Охотник"))")
                        Text("👨‍⚕️ Кол-во врачей: \(humObj.getAmountOfPeopleByProfession(profession: "Врач"))")
                        Text("👨‍🔧 Кол-во инженеров: \(humObj.getAmountOfPeopleByProfession(profession: "Инженер"))")
                        Text("👱‍♂️ Кол-во мужчин: \(humObj.getAmountOfPeopleBySex(sex: "Мужской"))")
                        Text("👩 Кол-во женщина: \(humObj.getAmountOfPeopleBySex(sex: "Женский"))")
                    }
                    
                    Section(header: Text("Бункер")){
                        Text("🍖 Запасы еды: \(bunker.FoodSupply)")
                        Text("🧱 Запасы ресурсов: \(bunker.ResourcesSupply)")
                        Text("📈 Прирост людей: \(bunker.Growth)")
                    }
                }
            }
            .navigationBarHidden(true)
            //.navigationBarTitle(Text("Настройки"), displayMode: .inline)
            //.edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            //        .navigationBarItems(leading:
            //                                Button(action: {
            //                                    self.presentation.wrappedValue.dismiss()
            //                                }, label: {
            //                                    HStack{
            //                                    Image(systemName: "chevron.backward")
            //                                    Text("Назад")
            //                                    }
            //                                }))
            
        }
    }
    
}

//struct HealthBar : View{
//
//    @State var human : Human
//    @State var colorState : Color = .green
//
//    var body: some View{
//        VStack{
//            Text(human.isFight == true ? "⚔️" : "")
//            //.font(.system(size: 10))
//            Capsule()
//                .frame(width: CGFloat(human.Character.Health)/CGFloat(human.Character.maxHealth) * human.size, height: 2)
//
//                .onAppear{
//                    if human.Character.Health > 70{
//                        colorState = .green
//                    }
//                    else if human.Character.Health > 30{
//                        colorState = .yellow
//                    }
//                    else {
//                        colorState = .red
//                    }
//                }
//                .foregroundColor(colorState)
//                .cornerRadius(20)
//            Capsule()
//                .frame(width: CGFloat(human.satiety)/10 * human.size, height: 2)
//                .foregroundColor(.blue)
//                .cornerRadius(20)
//                .offset(y: -6)
//        }.offset(y: -6)
//
//
//
//    }
//}

//struct MessageBox : View {
//
//    var body: some View{
//
//        Text("Вы проиграли")
//
//    }
//
//}

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
    @Published var amountOfResources : Int
    
    init(){
        x0 = 300
        y0 = 380
        x = UIScreen.main.bounds.width - 30
        y = 600
        amountOfResources = amountOfPeople
    }
    
}

class Mine {
    var x0 : CGFloat
    var y0 : CGFloat
    var x : CGFloat
    var y : CGFloat
    @Published var amountOfResources : Int
    
    init(){
        x0 = 50
        y0 = 630
        x = 250
        y = 700
//        x0 = 100
//        y0 = 100
//        x = 300
//        y = 200
        amountOfResources = amountOfPeople
    }
    
}

class Bunker {
    
    //var Health : Int = 0
    var CapacityOfPeople : Int
    var FoodSupply : Int
    var maxFoodSupply : Int
    var ResourcesSupply : Int
    var maxResourcesSupply : Int
    var Growth : Double
    var x0 : CGFloat
    var y0 : CGFloat
    var x : CGFloat
    var y : CGFloat
    var position : CGPoint
    
    init(){
        //Health = 1000
        CapacityOfPeople = amountOfPeople
        FoodSupply = amountOfPeople
        ResourcesSupply = 0 //amountOfPeople
        Growth = 0.01
//        x0 = 50
//        y0 = 630
//        x = 250
//        y = 700
        x0 = 100
        y0 = 100
        x = 300
        y = 200
        position = CGPoint(x: (x + x0) / 2, y: (y + y0) / 2)
        maxFoodSupply = FoodSupply
        maxResourcesSupply = amountOfPeople
    }
    
    func getPos() -> CGPoint{
        
        return CGPoint(x: (x + x0) / 2, y: (y + y0) / 2)
        
    }
}

class Zombie : Identifiable{
    
    var id = UUID()
    var position : CGPoint
    var Character : Сharacteristic
    var range: CGFloat
    @Published var isFight : Bool
    
    init(){
        position = CGPoint(x: 0, y: 0)
        Character = Сharacteristic.init()
        Character.Strength /= 2
        Character.Agility /= 2
        Character.Intelligence = 0
        Character.Health = 50
        Character.maxHealth = 50
        range = CGFloat(20 + Character.Agility) * 2
        isFight = false
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
        
        for _ in 0..<amountOfPeople / 2 {
            zombies.append(Zombie())
        }
    }
    
    func mechanics(){
        zombies.indices.forEach{
            index in
            zombies[index].changePos()
        }
    }
}
class Сharacteristic {
    
    @Published var Health : Int
    var maxHealth : Int
    
    var Strength : Int
    var Agility : Int
    var Intelligence : Int
    
    
    init(){
        
        
        Strength = Int.random(in: 1...10)
        Agility = Int.random(in: 1...10)
        Intelligence = Int.random(in: 1...10)
        
        Health = 100//Int.random(in: 70...100)
        maxHealth = 100
    }
}

class Human : Identifiable{
    
    var id = UUID()
    var sex : String
    var size: CGFloat
    
    var position: CGPoint
    //var angle : CGFloat
    var Character : Сharacteristic
    var Profession : String
    
    
    var target_coord : CGPoint
    var backpack : Int
    @Published var satiety : Int
    @Published var isFight : Bool
    @Published var isAlive : Bool
    @Published var isFree : Bool
    @Published var isRelax : Bool
    @Published var needTarget : Bool
    
    
    func step() {
        
        if Profession == "Охотник" {
            
            
            if position.x != target_coord.x{
                
                if target_coord.x - position.x > 0{
                    
                    
                    
                    if target_coord.x - position.x < CGFloat(Character.Agility / 2){
                        
                        position.x += target_coord.x - position.x
                        
                    }
                    else {
                        position.x += CGFloat(Character.Agility / 2)
                    }
                    
                }
                else {
                    
                    
                    
                    if abs(target_coord.x - position.x) < CGFloat(Character.Agility / 2){
                        
                        position.x -= CGFloat(Character.Agility / 2)
                    }
                    else {
                        position.x -= CGFloat(Character.Agility / 2)
                    }
                }
                
                
                
            }
            
            if position.y != target_coord.y{
                
                if target_coord.y - position.y > 0{
                    
                    
                    
                    if target_coord.y - position.y < CGFloat(Character.Agility / 2){
                        
                        position.y += target_coord.y - position.y
                        
                    }
                    else{
                        position.y += CGFloat(Character.Agility / 2)
                    }
                }
                else{
                    
                    
                    if abs(target_coord.y - position.y) < CGFloat(Character.Agility / 2){
                        position.y -= CGFloat(Character.Agility / 2)
                    } else{
                        position.y -= CGFloat(Character.Agility / 2)
                    }
                    
                }
            }
            
            if position == target_coord && isFree && !isRelax{
                
                print("на месте \(Character.Health)")
                
                Timer.scheduledTimer(withTimeInterval: timeOfDay / 2 ,repeats: false){[self]_ in
                    
                    isFree = false
                    needTarget = true
                    
                    if choose{
                        forest.amountOfResources -= Character.Strength
                    }
                    else{
                        mine.amountOfResources -= Character.Strength
                    }
                    
                    backpack += Character.Strength
                    
                }
            }
            else if position == target_coord{
                
//                Timer.scheduledTimer(withTimeInterval: freq, repeats: true){timer in
//                    if bunker.FoodSupply > 0{
//                        timer.invalidate()
//                    }
//                }
                
                backpack -= Character.Strength
                bunker.FoodSupply += Character.Strength
                isRelax = true
                
            }
            
        } else if Profession == "Врач"{
            
            if amountOfPeople < bunker.CapacityOfPeople && isFree {
                //Timer.scheduledTimer(withTimeInterval: , repeats: <#T##Bool#>, block: <#T##(Timer) -> Void#>)
            }
            
        } else if Profession == "Инженер" && bunker.ResourcesSupply != 0 && isFree{
            
            bunker.ResourcesSupply -= 1
            isFree = false
            
            Timer.scheduledTimer(withTimeInterval: TimeInterval(Int(timeOfDay) / Character.Intelligence), repeats: false){[self]_ in
                
                isFree = true
                bunker.CapacityOfPeople += 1
            }
                    
//            var pos = position
//
//            repeat{
//
//                pos = position
////            var offset = CGPoint(x: CGFloat.random(in: bunker.x0...bunker.x), y: CGFloat.random(in: bunker.y0...bunker.y))
//
//                pos.x += CGFloat(Int(cos(CGFloat.pi)) * Character.Agility / 2)
//                pos.y += CGFloat(Int(sin(CGFloat.pi)) * Character.Agility / 2)
//            }while (position.x < bunker.x0 || position.x > bunker.x)
            //}
            
            //}
            
        }
        
    }
    //} while position == target_coord
    //} while position == newCoord
    //           Int(position.x) != Int(newCoord.x) || Int(position.y) != Int(newCoord.y)
    //
    //
    //        }
    //        else{
    //step()
    
    
    init(){
        
        sex = sexAll[Bool.random() == true ? 1 : 0]
        size = 10.0
        position = CGPoint(x: CGFloat.random(in: bunker.x0...bunker.x), y: CGFloat.random(in: bunker.y0...bunker.y))//bunker.position
        //angle = 0
        Character = Сharacteristic.init()
        Profession = profAll[Int.random(in: 0...2)]
        isFree = true
        target_coord = position
        satiety = 10
        isFight = false
        isAlive = true
        backpack = 0
        needTarget = true
        isRelax = false
        
    }

    
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
    
    func getAmountOfPeople() -> Int {
        
        var newArr = humans
        newArr = humans.filter{$0.isAlive == true}
        return newArr.count
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
    
    func getAmountOfDeaths() -> Int{
        
        var newArr = humans
        newArr = humans.filter{$0.isAlive == false}
        return newArr.count
    }
    
}

class World : ObservableObject {
    
    static var shared = World()
    var humObj = HumanObject()
    var zombObj = ZombieObject()
    var bioms = Bioms()
    @Published var isNight : Bool = false
    @Published var isPause = false
    @Published var day : Int = 0
    
    
    func fight(indexH : Int, indexZ : Int){
        
        let zombie = zombObj.zombies[indexZ]
        let human = humObj.humans[indexH]
        
        zombie.Character.Health -= human.Character.Strength
        human.Character.Health -= zombie.Character.Strength
        
        
        
        if zombie.Character.Health <= 0{
            //zombObj.zombies.remove(at: indexZ)
            human.isFight = false
            //zombie.isFight = false
        }
        
        if human.Character.Health <= 0{
            human.isAlive = false
            zombie.isFight = false
        }
        
        //return human.isAlive
    }
    
    func addHuman(){
        humObj.humans.append(Human())
        amountOfPeople += 1
    }
    
    //    func upgradeBunker(){
    //
    //    }
    
    init(){
        
    //бесконечный цикл с обновлением в freq сек
        Timer.scheduledTimer(withTimeInterval: freq, repeats: true){
            [self] timer in
            
            //установка таймера игрового дня
            if installTimerOfDay{
                
                installTimerOfDay = false
                
                Timer.scheduledTimer(withTimeInterval: timeOfDay, repeats: true){timerDay in
                    
                    if isPause{
                        timerDay.invalidate()
                    }
                    else{
                        day += 1
                        
                        humObj.humans.indices.forEach{
                            index in
                            //print(index)
                            if humObj.humans[index].satiety > 0{
                                humObj.humans[index].satiety -= 1
                            }
                            
                        }
                    }
                    
                }
            }
            
            //установка смены таймера игрового пол-дня(смена времени дня - утро, ночь)
            if installTimerOfHalfDay{
                
                installTimerOfHalfDay = false
                
                Timer.scheduledTimer(withTimeInterval: Double(timeOfDay / 2), repeats: true){timerHalfDay in
                    
                    if isPause{
                        timerHalfDay.invalidate()
                    }
                    else{
                        
                        isNight.toggle()
                        
                        humObj.humans.indices.forEach{
                            index in
                            
                            if humObj.humans[index].satiety == 0{
                                humObj.humans[index].Character.Health -= (50 / humObj.humans[index].Character.Strength)
                            }
                            
                            if humObj.humans[index].satiety != 10 && bunker.FoodSupply != 0{
                                
                                humObj.humans[index].satiety += 1
                                bunker.FoodSupply -= 1
                            }
                        }
                        
                    }
                    
                        if !isNight {
                            
                            //var zombies = zombObj.zombies
                            zombObj.zombies.indices.forEach{
                                index in
                                if !zombObj.zombies[index].isFight{
                                    zombObj.zombies[index].position = CGPoint(x: -10, y: -10)
                                    zombObj.zombies[index].isFight = false
                                }
                            }
                            //zombObj.zombies = zombies
                            //zombObj.zombies = []
                        }
                        else{
                            zombObj.mechanics()
                            //zombObj = ZombieObject()
                        }
                }
                
            }
            
            //логика людей
            if !isPause{
                                
                humObj.humans.indices.forEach{index in
                    
                    //определение цели
                    if humObj.humans[index].needTarget {
                        
                        if humObj.humans[index].Profession == "Охотник" && humObj.humans[index].isFree{
                            
                            humObj.humans[index].needTarget = false
                            //humObj.humans[index].isFree = false
                            
                            //choose = Bool.random()
                            
                            if bunker.FoodSupply < bunker.maxFoodSupply {
                                
                                humObj.humans[index].target_coord = CGPoint(x: CGFloat.random(in: forest.x0...forest.x), y: CGFloat.random(in: forest.y0...forest.y))
                            }
                            else if bunker.ResourcesSupply < bunker.maxResourcesSupply{
                                
                                humObj.humans[index].target_coord = CGPoint(x: CGFloat.random(in: mine.x0...mine.x), y: CGFloat.random(in: mine.y0...mine.y))
                            }
                            
                        }
                        else if humObj.humans[index].Profession == "Охотник"{
                            
                            humObj.humans[index].needTarget = false
                            humObj.humans[index].target_coord = CGPoint(x: CGFloat.random(in: bunker.x0...bunker.x), y: CGFloat.random(in: bunker.y0...bunker.y))
                            
                        }
                        
                    }
                    
                    let human = humObj.humans[index]
                    
                    
                    //передвижение
                    if !human.isFight && human.isAlive{
                        human.step()
                    }
                    
                    
                    //проверка на столкновение с зомби
                    if human.Profession == "Охотник" && !human.isFight && human.isAlive{
                        
                        zombObj.zombies.indices.forEach{
                            
                            indexZ in
                            
                            let zombie = zombObj.zombies[indexZ]
                            
                            
                            if !zombie.isFight{
                                
                                
                                if human.position.x > (zombie.position.x - zombie.range / 2) && human.position.x < (zombie.position.x + zombie.range / 2) && human.position.y < (zombie.position.y + zombie.range / 2) && human.position.y > (zombie.position.y - zombie.range / 2){
                                    
                                    
                                    human.isFight = true
                                    zombie.isFight = true
                                    print("fight")
                                    
                                }
                                
                            }
                        }
                    }
                    
                    
                    
                }
                
                //                    humObj.humans.indices.forEach{
                //
                //                        indexH in
                //
                //
                //                    }
                
                
                //                else if (human.Profession == "Инженер" && bunker.ResourcesSupply != 0){
                //
                //                    bunker.ResourcesSupply -= 1
                //
                //                    human.isFree = false
                //
                //                    Timer.scheduledTimer(withTimeInterval: timeOfDay / Double(human.Character.Intelligence), repeats: false){_ in
                //
                //                        addHuman()
                //                        bunker.CapacityOfPeople += 1
                //
                //                        Timer.scheduledTimer(withTimeInterval: timeOfDay - timeOfDay / Double(human.Character.Intelligence), repeats: false){_ in
                //                            human.isFree = true
                //                        }
                //
                //                    }
                //
                //
                //
                //
                //
                //
                //                }
                
                //////////////////
                //}
                
                //                humObj.humans.indices.forEach{
                //                    index in
                //
                //                    if humObj.humans[index].Profession == "Охотник" && humObj.humans[index].isFree {
                //
                //
                //                        humObj.humans[index].isFree = false
                //
                //                        //Timer.scheduledTimer(withTimeInterval: )
                ////                        let choose = Bool.random()
                ////
                ////                        if choose{
                //                        humObj.humans[index].target_coord = CGPoint(x: CGFloat.random(in: forest.x0...forest.x), y: CGFloat.random(in: forest.y0...forest.y))
                //
                ////                        }else {
                ////
                ////                            humObj.humans[index].target_coord = CGPoint(x: CGFloat.random(in: mine.x0...mine.x), y: CGFloat.random(in: mine.y0...mine.y))
                ////
                ////                                    }
                //
                //                        //repeat{
                //
                //                        if humObj.humans[index].position.x != humObj.humans[index].target_coord.x{
                //
                //                            humObj.humans[index].position.x += CGFloat(humObj.humans[index].Character.Agility / 2)
                //
                //                            if humObj.humans[index].target_coord.x - humObj.humans[index].position.x < CGFloat(humObj.humans[index].Character.Agility / 2){
                //
                //                                humObj.humans[index].position.x += humObj.humans[index].target_coord.x - humObj.humans[index].position.x
                //
                //                            }
                //
                //                        }
                //
                //                        if humObj.humans[index].position.y != humObj.humans[index].target_coord.y{
                //
                //                            humObj.humans[index].position.y += CGFloat(humObj.humans[index].Character.Agility / 2)
                //
                //                            if humObj.humans[index].target_coord.y - humObj.humans[index].position.y < CGFloat(humObj.humans[index].Character.Agility / 2){
                //
                //                                humObj.humans[index].position.y += humObj.humans[index].target_coord.y - humObj.humans[index].position.y
                //
                //                            }
                //                        }
                //
                //                        //} while position == target_coord
                //                        //} while position == newCoord
                //                        //           Int(position.x) != Int(newCoord.x) || Int(position.y) != Int(newCoord.y)
                //                        //
                //                        //
                //                        //        }
                //                        //        else{
                //                        //step()
                //                    }
                //
                //                    else if humObj.humans[index].Profession == "Инженер"{
                //
                //                        if bunker.ResourcesSupply != 0{
                //
                //                            bunker.ResourcesSupply -= 1
                //                            humObj.humans[index].isFree = false
                //
                //                            Timer.scheduledTimer(withTimeInterval: timeOfDay / Double(humObj.humans[index].Character.Intelligence), repeats: false){_ in
                //
                //                              addHuman()
                //                              bunker.CapacityOfPeople += 1
                //
                //                              Timer.scheduledTimer(withTimeInterval: timeOfDay - timeOfDay / Double(humObj.humans[index].Character.Intelligence), repeats: false){_ in
                //                                humObj.humans[index].isFree = true
                //                              }
                //
                //                          }
                //
                //                        }
                //                        else {
                //
                //                            var newPosition = humObj.humans[index].position
                //
                //                                  repeat {
                //                                    newPosition = humObj.humans[index].position
                //
                //                                    humObj.humans[index].angle += CGFloat(Int.random(in: -30..<30))
                //                                    newPosition.y += CGFloat(sin(humObj.humans[index].angle * CGFloat.pi / 180) * CGFloat(humObj.humans[index].Character.Agility) / 2)
                //                                    newPosition.x += CGFloat(cos(humObj.humans[index].angle * CGFloat.pi / 180) * CGFloat(humObj.humans[index].Character.Agility) / 2)
                //                                  } while newPosition.y < bunker.y0 || newPosition.x < bunker.x0 || newPosition.y > bunker.y || newPosition.x > bunker.x
                //
                //                            humObj.humans[index].position = newPosition
                //
                //                        }
                //                    }
                //
                //                }
                
                
            }
            objectWillChange.send() //обновление view
        }
        
        //бой зомби и охотника в такт
        Timer.scheduledTimer(withTimeInterval: freq, repeats: true){[self] timer in
            
            if !isPause{
                
                humObj.humans.indices.forEach{
                    
                    indexH in
                    
                    zombObj.zombies.indices.forEach{
                        
                        indexZ in
                        
                        if humObj.humans[indexH].isFight && zombObj.zombies[indexZ].isFight && humObj.humans[indexH].position.x > (zombObj.zombies[indexZ].position.x - zombObj.zombies[indexZ].range / 2) && humObj.humans[indexH].position.x < (zombObj.zombies[indexZ].position.x + zombObj.zombies[indexZ].range / 2) && humObj.humans[indexH].position.y < (zombObj.zombies[indexZ].position.y + zombObj.zombies[indexZ].range / 2) && humObj.humans[indexH].position.y > (zombObj.zombies[indexZ].position.y - zombObj.zombies[indexZ].range / 2){
                            
                            fight(indexH: indexH, indexZ: indexZ)
                        }
                    }
                }
            }
        }
        
        //        Timer.scheduledTimer(withTimeInterval: timeOfDay, repeats: true){
        //            [self] timer in
        
        //            var humans_temp : [Human] = humObj.humans
        
        //            if !isPause{
        //                day += 1
        //
        //
        //                forest.amountOfResources =  humObj.getAmountOfPeople() / 2
        //                mine.amountOfResources = humObj.getAmountOfPeople() / 2
        //
        //                humObj.humans.indices.forEach{
        //                    index in
        //
        //                    if bunker.FoodSupply != 0{
        //                        bunker.FoodSupply -= 1
        //                    }
        //                    if humObj.humans[index].satiety == 0{
        //                        humObj.humans[index].isAlive = false
        //                    }
        //
        //                }
        
        //                if bunker.FoodSupply < humObj.humans.count && forest.amountOfResources != 0{
        //                    for index in 0..<forest.amountOfResources{
        //                        humObj.humans.filter{$0.Profession == "Охотник"}
        //                    }
        //                }
        
        //humObj.humans = humans_temp
        
        //            }
        //
        //            if (humObj.getAmountOfPeople() < bunker.CapacityOfPeople && humObj.getAmountOfPeopleBySex(sex: "Мужской") != 0 && humObj.getAmountOfPeopleBySex(sex: "Женский") != 0){
        //
        //                humObj.humans.append(Human())
        //                amountOfPeople += 1
        //           }
        
        //        }
        // }
        
        //if isPause{
        //            scheduledTimer(withTimeInterval: timeOfDay / 2, repeats: true){
        //                            [self] timer in
        //
        //                            if !isPause {
        //                                isNight.toggle()
        //                                humObj.humans.indices.forEach{
        //                                    index in
        //                                    //print(index)
        //                                    humObj.humans[index].satiety -= 1
        //                                }
        //                            }
        //
        //                            if !isNight {
        //                                //var zombies = zombObj.zombies
        //                                zombObj.zombies.indices.forEach{
        //                                    index in
        //                                    if !zombObj.zombies[index].isFight{
        //                                        zombObj.zombies[index].position = CGPoint(x: -10, y: -10)
        //                                        zombObj.zombies[index].isFight = false
        //                                    }
        //                                }
        //                                //zombObj.zombies = zombies
        //                                //zombObj.zombies = []
        //                            }
        //                            else{
        //                                zombObj.mechanics()
        //                                //zombObj = ZombieObject()
        //                            }
        //
        //                        }
        //Timer.//}
        
 
        
    }
    
}




class ViewModel: ObservableObject {
    
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var subscriptions = Set<AnyCancellable>()
    @Published var world = World.shared
    
    init() {
        
        
        world.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        .store(in: &subscriptions)
        
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
