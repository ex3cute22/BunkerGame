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

var timeOfDay = 10.0
let freq = 0.05

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
                            Text("Шахта⛏\n🧱\(mine.amountOfResources)/\(VM.world.humObj.getAmountOfPeople() * 2)")
                            
                        }
                        .position(x: (mine.x + mine.x0) / 2, y: (mine.y + mine.y0) / 2)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.green.opacity(0.5))
                                .frame(width: forest.x - forest.x0 + 30, height: forest.y - forest.y0 + 30)
                            Text("Лес🦌\n🍖\(forest.amountOfResources)/\(VM.world.humObj.getAmountOfPeople() * 2)")
                            
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
                                        Text(human.isFight ? "⚔️" : human.isLove ? "👩‍❤️‍👨" : "")
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
                                        Text(!human.isFree ? "💊" : human.isLove ? "👩‍❤️‍👨" : "")
                                            .font(.system(size: 10))
                                        Capsule()
                                            .frame(width: CGFloat(human.Character.Health)/CGFloat(human.Character.maxHealth) * human.size, height: 2)
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
                            else if human.Profession == "Инженер"{
                                
                                ZStack{
                                    
                                    Text(human.sex == "Мужской" ? personage[3] : personage[4])
                                        .foregroundColor(.blue)
                                    
                                    VStack{
                                        Text(!human.isFree ? "🔧" : human.isLove ? "👩‍❤️‍👨" : "")
                                            .font(.system(size: 10))
                                        Capsule()
                                            .frame(width: CGFloat(human.Character.Health)/CGFloat(human.Character.maxHealth) * human.size, height: 2)
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
                                
                                //}
                                
                            }
                        }
                        
                        if VM.world.isNight {
                            
                            ForEach(VM.world.zombObj.zombies){zombie in
                                
                                ZStack{
                                    
                                    Circle()
                                        .fill(Color.red.opacity(0.5))
                                        .frame(width: zombie.isFight ? 0 : zombie.range, height: zombie.isFight ? 0 : zombie.range)
                                    Text(zombie.isAlive ? personage[0] : personage[7])
                                    
                                    
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

//struct MessageBox : View {
//
//    var body: some View{
//
//        Text("Вы проиграли")
//
//    }
//
//}


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
        amountOfResources = amountOfPeople * 2
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
        amountOfResources = amountOfPeople * 2
    }
    
}

class Backpack {
    
    var amountOfFoods : Int
    var amountOfResources : Int
    
    
    init(){
        amountOfFoods = 0
        amountOfResources = 0
    }
}

class Bunker {
    
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
//        x0 = CGFloat(Int.random(in: 60...Int(UIScreen.main.bounds.width) - 60))
//        y0 = CGFloat(Int.random(in: 60...Int(UIScreen.main.bounds.height) - 60))
        x = x0 + 200
        y = y0 + 100
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
    @Published var isAlive : Bool
    
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
        isAlive = true
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
        
        
        Strength = Int.random(in: 2...10)
        Agility = Int.random(in: 2...10)
        Intelligence = Int.random(in: 2...10)
        
        Health = 100//Int.random(in: 70...100)
        maxHealth = 100
    }
}

class Human : Identifiable{
    
    var id = UUID()
    var sex : String
    var size: CGFloat
    
    var position: CGPoint
    var Character : Сharacteristic
    var Profession : String
    
    
    var target_coord : CGPoint
    var backpack : Backpack
    @Published var satiety : Int
    @Published var isFight : Bool
    @Published var isAlive : Bool
    @Published var isFree : Bool
    @Published var isRelax : Bool
    @Published var inWay : Bool
    @Published var isLove : Bool
    @Published var isChildBirth : Bool
    @Published var target : String
    
    
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
                
                isFree = false
                
                Timer.scheduledTimer(withTimeInterval: timeOfDay / 2 ,repeats: false){[self]_ in
                    
                    if target == "Лес"{
                        
                        if forest.amountOfResources >= Character.Strength {
                            
                            backpack.amountOfFoods += Character.Strength
                            forest.amountOfResources -= Character.Strength
                        }
                        else if forest.amountOfResources > 0{
                            
                            backpack.amountOfFoods += forest.amountOfResources
                            forest.amountOfResources = 0
                        }
                    }
                    else if target == "Шахта" {
                        
                        if mine.amountOfResources >= Character.Strength{
                            
                            backpack.amountOfResources += Character.Strength
                            mine.amountOfResources -= Character.Strength
                        }
                        else if mine.amountOfResources > 0{
                            
                            backpack.amountOfResources += mine.amountOfResources
                            mine.amountOfResources = 0
                        }
                    }
                    
                    target = ""
                    inWay = false
                    
                    
                }
            }
            else if position == target_coord && target == "" && !isRelax{
                
                isRelax = true
                
                Timer.scheduledTimer(withTimeInterval: timeOfDay / 2, repeats: false){[self]timer in
                    //if bunker.FoodSupply > 0{
                    isRelax = false
                    inWay = false
                    isFree = true
                    timer.invalidate()
                    //}
                }
                
                if backpack.amountOfFoods > 0 && bunker.FoodSupply < bunker.maxFoodSupply{
                    
                    if bunker.FoodSupply + backpack.amountOfFoods > bunker.maxFoodSupply{
                        
                        let foods = bunker.maxFoodSupply - bunker.FoodSupply
                        
                        bunker.FoodSupply += foods
                        backpack.amountOfFoods -= foods
                        
                    }
                    else{
                        
                        bunker.FoodSupply += backpack.amountOfFoods
                        backpack.amountOfFoods = 0
                    }
                    
                }
                
                if backpack.amountOfResources > 0 && bunker.ResourcesSupply < bunker.maxResourcesSupply{
                    
                    if bunker.ResourcesSupply + backpack.amountOfResources > bunker.maxResourcesSupply{
                        
                        let resources = bunker.maxResourcesSupply - bunker.ResourcesSupply
                        
                        bunker.ResourcesSupply += resources
                        backpack.amountOfResources -= resources
                        
                    }
                    else{
                        
                        bunker.ResourcesSupply += backpack.amountOfResources
                        backpack.amountOfResources = 0
                    }
                    
                    
                }
                
            }
            
        } else if Profession == "Врач"{
            
//            if amountOfPeople < bunker.CapacityOfPeople && isFree {
//
//                isFree = false
//
//
//
//
//                //Timer.scheduledTimer(withTimeInterval: , repeats: <#T##Bool#>, block: <#T##(Timer) -> Void#>)
//            }
            
        }  else if Profession == "Инженер"{
            
            if bunker.ResourcesSupply != 0 && isFree{
                
                bunker.ResourcesSupply -= 1
                isFree = false
                
                Timer.scheduledTimer(withTimeInterval: TimeInterval(Int(timeOfDay) / Character.Intelligence), repeats: false){[self]_ in
                    
                    isFree = true
                    bunker.CapacityOfPeople += 1
                    bunker.maxFoodSupply += 1
                    bunker.maxResourcesSupply += 1
                }
            }
            //            }else if !isFree {
            
            //                var pos = position
            //
            //                repeat{
            //                    pos = position
            //                    pos.x += CGFloat(Int.random(in: -1...1) * Character.Agility)
            //                    pos.y += CGFloat(Int.random(in: -1...1) * Character.Agility)
            //                }while(position.x < bunker.x0 || position.x > bunker.x || position.y < bunker.y0 || position.y > bunker.y)
            //
            //                position = pos
            //}
            //}
            
            //            } else if !isFree {
            //
            //                var pos = position
            //
            //                repeat{
            //                    pos = position
            //
            ////                    pos.x += CGFloat(Int.random(in: -1...1) * Character.Agility)
            ////                    pos.y += CGFloat(Int.random(in: -1...1) * Character.Agility)
            //                    pos.x += (cos(CGFloat.random(in: 0...360) * CGFloat.pi / 180)) * CGFloat(Character.Agility)
            //                    pos.y += sin(CGFloat.random(in: 0...360) * CGFloat.pi / 180) * CGFloat(Character.Agility)
            //
            //                } while(position.x < bunker.x0 || position.x > bunker.x || position.y < bunker.y0 || position.y > bunker.y)
            //
            //                position = pos
            //
            //            }
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
        position = CGPoint(x: CGFloat.random(in: bunker.x0 + 30...bunker.x - 30), y: CGFloat.random(in: bunker.y0 + 30...bunker.y - 30))//bunker.position
        //angle = 0
        Character = Сharacteristic.init()
        Profession = profAll[Int.random(in: 0...2)]
        isFree = true
        target_coord = position
        satiety = 10
        isFight = false
        isAlive = true
        backpack = Backpack.init()
        target = ""
        isRelax = false
        inWay = false
        isLove = false
        isChildBirth = false
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
        newArr = humans.filter{$0.isAlive}
        return newArr.count
    }
    
    func getAmountOfPeopleBySex(sex: String) -> Int{
        
        var newArr = humans
        newArr = humans.filter{$0.sex == sex && $0.isAlive}
        return newArr.count
        
    }
    
    func getAmountOfPeopleByProfession(profession: String) -> Int{
        
        var newArr = humans
        newArr = humans.filter{$0.Profession == profession && $0.isAlive}
        return newArr.count
    }
    
    func getAmountOfDeaths() -> Int{
        
        var newArr = humans
        newArr = humans.filter{!$0.isAlive}
        return newArr.count
    }
    
}

class World : ObservableObject {
    
    static var shared = World()
    var humObj = HumanObject()
    var zombObj = ZombieObject()
    //var bioms = Bioms()
    @Published var isNight : Bool = false
    @Published var isPause = false
    @Published var day : Int = 0
    
    
    func fight(indexH : Int, indexZ : Int){
        
        let zombie = zombObj.zombies[indexZ]
        let human = humObj.humans[indexH]
        
        zombie.Character.Health -= human.Character.Strength
        human.Character.Health -= zombie.Character.Strength
        
        
        
        if zombie.Character.Health <= 0{

            human.isFight = false
            zombie.isAlive = false
        }
        
        if human.Character.Health <= 0{
            human.isAlive = false
            zombie.isFight = false
        }
        
    }
    
    func addHuman(){
        humObj.humans.append(Human())
        amountOfPeople += 1
    }
    
    
    
    
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
                        
                        if day % 3 == 0 {
                            forest.amountOfResources = humObj.getAmountOfPeople() * 2
                            mine.amountOfResources = humObj.getAmountOfPeople() * 2
                        }
                        
                        humObj.humans.indices.forEach{
                            index in
                            
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
                            
                            if humObj.humans[index].satiety == 0 && humObj.humans[index].Character.Health > 0{
                                humObj.humans[index].Character.Health -= (50 / humObj.humans[index].Character.Strength)
                                
                                if humObj.humans[index].Character.Health <= 0{
                                    humObj.humans[index].isAlive = false
                                }
                            }
                            
                            if humObj.humans[index].satiety != 10 && bunker.FoodSupply != 0 && humObj.humans[index].isAlive{
                                
                                humObj.humans[index].satiety += 1
                                bunker.FoodSupply -= 1
                            }
                        }
                        
                    }
                    
                    if !isNight {
                        
                        zombObj.zombies.indices.forEach{
                            index in
                            
                            zombObj.zombies[index].isAlive = true
                            zombObj.zombies[index].isFight = false
                            
                            if !zombObj.zombies[index].isFight{
                                zombObj.zombies[index].position = CGPoint(x: -10, y: -10)
                                zombObj.zombies[index].isFight = false
                            }
                        }
   
                    }
                    else{
                        zombObj.mechanics()
                    }
                }
                
            }
            
            
            
            //логика людей
            if !isPause{
                
                
                if humObj.getAmountOfPeople() < bunker.CapacityOfPeople {
                    
                    let newArrMan = humObj.humans.filter{$0.sex == "Мужской" && $0.isFree && !$0.isLove && $0.Profession != "Врач"}
                    let newArrGirl = humObj.humans.filter{$0.sex == "Женский" && $0.isFree && !$0.isLove && $0.Profession != "Врач"}
                    
                    
                    if newArrGirl.count > 0 && newArrMan.count > 0{
                        
                        if newArrGirl.count >= newArrMan.count{
                         
                            newArrMan.indices.forEach{index_ in
                                
                                var i = humObj.humans.firstIndex(where: {$0.id == newArrMan[index_].id})
                                
                                humObj.humans[i!].isLove = true
                                
                                Timer.scheduledTimer(withTimeInterval: timeOfDay * 3, repeats: false){_ in
                                    
                                    humObj.humans[i!].isLove = false
                                    
                                }

                                
                                i = humObj.humans.firstIndex(where: { $0.id == newArrGirl[index_].id})
                                
                                humObj.humans[i!].isLove = true
                                
                                Timer.scheduledTimer(withTimeInterval: timeOfDay * 3, repeats: false){_ in
                                    
                                    humObj.humans[i!].isLove = false
                                    humObj.humans[i!].isChildBirth = true
                                    
                                }
                                
                                
                            }
                            
                        }
                        else {
                            
                            newArrGirl.indices.forEach{index_ in
                                
                                var i = humObj.humans.firstIndex(where: {$0.id == newArrMan[index_].id})
                                
                                humObj.humans[i!].isLove = true
                                
                                Timer.scheduledTimer(withTimeInterval: timeOfDay * 3, repeats: false){_ in
                                    
                                    humObj.humans[i!].isLove = false
                                    
                                }
                                
                                i = humObj.humans.firstIndex(where: { $0.id == newArrGirl[index_].id})
                                
                                humObj.humans[i!].isLove = true
                                
                                Timer.scheduledTimer(withTimeInterval: timeOfDay * 3, repeats: false){_ in
                                    
                                    humObj.humans[i!].isLove = false
                                    humObj.humans[i!].isChildBirth = true
                                    humObj.humans[i!].isFree = false

                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
                
                
                humObj.humans.indices.forEach{index in
                    
                    if !isNight {
                        humObj.humans[index].isFight = false
                    }
                    
                    //определение цели
                    if humObj.humans[index].Profession == "Охотник"{
                        if !humObj.humans[index].inWay && humObj.humans[index].isFree{
                            
                            if bunker.FoodSupply < bunker.maxFoodSupply{
                                
                                humObj.humans[index].inWay = true
                                humObj.humans[index].target = "Лес"
                                humObj.humans[index].target_coord = CGPoint(x: CGFloat.random(in: forest.x0...forest.x), y: CGFloat.random(in: forest.y0...forest.y))
                                
                                
                            }
                            else if bunker.ResourcesSupply < bunker.maxResourcesSupply{
                                
                                humObj.humans[index].inWay = true
                                humObj.humans[index].target = "Шахта"
                                humObj.humans[index].target_coord = CGPoint(x: CGFloat.random(in: mine.x0...mine.x), y: CGFloat.random(in: mine.y0...mine.y))
                                
                            }
                            
                            
                        }
                        
                        if humObj.humans[index].target == "" && !humObj.humans[index].isFree && !humObj.humans[index].inWay{
                            
                            humObj.humans[index].inWay = true
                            humObj.humans[index].target_coord = CGPoint(x: CGFloat.random(in: bunker.x0...bunker.x), y: CGFloat.random(in: bunker.y0...bunker.y))
                            
                            
                        }
                    }
                    else if humObj.humans[index].Profession == "Врач" && humObj.humans[index].isFree && !humObj.humans[index].isLove{

                        humObj.humans.indices.forEach{index_ in
                                
                            if humObj.humans[index_].isChildBirth {
                                
                                humObj.humans[index].isFree = false
                             
                                Timer.scheduledTimer(withTimeInterval: timeOfDay / 2 , repeats: false){_ in
                                    
                                let chance = humObj.humans[index].Character.Intelligence * 10
                                
                                if !(chance < Int.random(in: 0...100)){
                                 
                                    addHuman()
                                    
                                }
                                    
                                humObj.humans[index].isFree = true
                                humObj.humans[index_].isChildBirth = false
                                humObj.humans[index_].isFree = true
                                
                            }
                            
                            }
                        }
//                          if index != index_{
//
//                                                            if humObj.humans[index_].sex == "Мужской"{





}
                    //
                    ////                                if humObj.humans[index_].Profession == "Охотник" && humObj.humans[index_].isRelax{
                    ////
                    ////                                    humObj.humans[index].isFree = false
                    ////
                    ////
                    ////                                } else if (humObj.humans[index_].Profession == "Врач" || humObj.humans[index_].Profession == "Инженер") && humObj.humans[index_].isFree{
                    ////
                    ////                                }
                    //                                }
                    //                            }
                    //
                    //                        }
                    
                    
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
                                
                                
                                if human.position.x > (zombie.position.x - zombie.range / 2) && human.position.x < (zombie.position.x + zombie.range / 2) && human.position.y < (zombie.position.y + zombie.range / 2) && human.position.y > (zombie.position.y - zombie.range / 2) {
                                    
                                    
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
