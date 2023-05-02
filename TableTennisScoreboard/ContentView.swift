//
//  ContentView.swift
//  Table Tennis Scoreboard
//
//  Created by James on 2023-03-21.
//

import SwiftUI



// custom view modifier to track rotation and
// call our action
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}




// main view
struct ContentView: View {
    @State private var orientation = UIDeviceOrientation.unknown

    @State var playerA = ""
    @State var playerB = ""
    @State var playerAPoints = 0
    @State var playerBPoints = 0
    @State var playerAGames = 0
    @State var playerBGames = 0
    @State var serviceA = false
    @State var serviceB = false
    
    
    // change ends
    func changeEnds() {
        var tempPlayer = ""
        var tempGames = 0

        tempPlayer = playerA
        playerA = playerB
        playerB = tempPlayer
        
        tempGames = playerAGames
        playerAGames = playerBGames
        playerBGames = tempGames
        
        playerAPoints = 0
        playerBPoints = 0
        
        serviceA = false
        serviceB = false
    }
    
    // reset points
    func resetPoints() {
        playerAPoints = 0
        playerBPoints = 0
        serviceA = false
        serviceB = false
    }
    
    // reset all
    func resetAll() {
        playerAPoints = 0
        playerBPoints = 0
        playerAGames = 0
        playerBGames = 0
        playerA = ""
        playerB = ""
        serviceA = false
        serviceB = false
    }
    
    // change serve
    func changeServe() {
        var totalPoints = 0
        totalPoints = playerAPoints + playerBPoints
        
        // deuce
        if(playerAPoints >= 10 && playerBPoints >= 10) {
            if(serviceA){
                serviceA = false
                serviceB = true
            } else if(serviceB){
                serviceA = true
                serviceB = false
            }
        } else {
            // when totalPoints is even, change serve
            if(totalPoints % 2 == 0) {
                if(serviceA){
                    serviceA = false
                    serviceB = true
                } else if(serviceB){
                    serviceA = true
                    serviceB = false
                }
            }
        }
    }
    
    // Function to check if either player has won the game
    func checkWinner() {
        // Standard table tennis rules: first player to 11 points wins, must win by 2 points
        if playerAPoints >= 11 && playerAPoints - playerBPoints >= 2 {
            // playerA won
            playerAGames += 1
        } else if playerBPoints >= 11 && playerBPoints - playerAPoints >= 2 {
            // playerB won
            playerBGames += 1
        } else {
            // tie
        }
    }

    
    var body: some View {
        Group {
            if orientation.isPortrait {
                portraitView
            } else if orientation.isLandscape {
                landscapeView
            } else if orientation.isFlat {
                landscapeView
            } else {
                landscapeView
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
    
    
    var portraitView: some View {
            VStack {
                // Player 1
                Group {
                    ZStack {
                        
                        VStack(spacing: 10){
                            HStack {
                                TextField("Player A", text: $playerA)
                                        .font(.largeTitle)
                                        .foregroundColor(.black)
                                        .background(Color.white)
                                        .padding(5)
                                
                                    Toggle("", isOn: $serviceA)
                                        .toggleStyle(.automatic)
                            }
                            
                            Spacer()
                        }
                        // VStack
                        
                        HStack {
                            Spacer()
                            
                            // current point
                             Button(action: {
                                 playerAPoints += 1
                                 changeServe()
                                 checkWinner()
                             }, label: {
                                 Text("\(playerAPoints)")
                                     .font(.system(size: 240, weight: Font.Weight.bold))
                             })
                             .foregroundColor(.white)
                             .frame(alignment: .center)
                             .simultaneousGesture(LongPressGesture()
                                .onEnded { _ in
                                    playerAPoints -= 2
                                })
                                         
                            Spacer()
                            
                            // game score
                            Button(action: {
                                playerAGames += 1
                            }, label: {
                                Text("\(playerAGames)")
                                    .font(.system(size: 80, weight: Font.Weight.bold))
                            })
                            .padding(.trailing)
                            .foregroundColor(.white)
                            .simultaneousGesture(LongPressGesture()
                               .onEnded { _ in
                                   playerAGames -= 2
                               })
                        } // end HStack
                        
                        
                        VStack(spacing: 10){
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                // change ends
                                Button(action: {
                                    changeEnds()
                                }, label: {
                                    Text("Change Ends")
                                })
                                .foregroundColor(.white)
                                
                                Spacer()
                                
                                // reset points
                                Button(action: {
                                    resetPoints()
                                }, label: {
                                    Text("Reset Points")
                                })
                                .foregroundColor(.white)
                                
                                Spacer()
                            } // end HStack
                        }
                        // VStack
                        
                    }
                    // zstack
                    
                }
                .background(Color.blue)
                // group
                
                Spacer()
                    
               // Player 2
                Group {
                    ZStack {
                        
                        VStack(spacing: 10){
                            HStack {
                                TextField("Player B", text: $playerB)
                                        .font(.largeTitle)
                                        .foregroundColor(.black)
                                        .background(Color.white)
                                        .padding(5)
                                
                                    Toggle("", isOn: $serviceB)
                                        .toggleStyle(.automatic)
                            }
                            
                            Spacer()
                        }
                        // VStack
                        
                        HStack {
                            Spacer()
                            
                            // current point
                             Button(action: {
                                 playerBPoints += 1
                                 changeServe()
                                 checkWinner()
                             }, label: {
                                 Text("\(playerBPoints)")
                                     .font(.system(size: 240, weight: Font.Weight.bold))
                             })
                             .foregroundColor(.white)
                             .frame(alignment: .center)
                             .simultaneousGesture(LongPressGesture()
                                .onEnded { _ in
                                    playerBPoints -= 2
                                })
                            
                            Spacer()
                            
                            // game score
                            Button(action: {
                                playerBGames += 1
                            }, label: {
                                Text("\(playerBGames)")
                                    .font(.system(size: 80, weight: Font.Weight.bold))
                            })
                            .padding(.trailing)
                            .foregroundColor(.white)
                            .simultaneousGesture(LongPressGesture()
                               .onEnded { _ in
                                   playerBGames -= 2
                               })

                        } // end HStack
                        
                        
                        VStack(spacing: 10){
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                // Reset All
                                Button(action: {
                                    resetAll()
                                }, label: {
                                    Text("Reset All")
                                })
                                .foregroundColor(.white)
                                
                                Spacer()
                            } // end HStack
                        }
                        // VStack
                        
                    }
                    // zstack
                    
                }
                .background(Color.red)
                // group

            }
        }
        

    var landscapeView: some View {
        HStack {

            // Player 1
            Group {
                ZStack {
                    
                    VStack(spacing: 10){
                        HStack {
                            TextField("Player A", text: $playerA)
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                                    .background(Color.white)
                                    .padding(5)
                            
                                Toggle("", isOn: $serviceA)
                                    .toggleStyle(.automatic)
                        }
                        
                        Spacer()
                    }
                    // VStack
                    
                    HStack {
                        Spacer()
                        
                        // current point
                         Button(action: {
                             playerAPoints += 1
                             changeServe()
                             checkWinner()
                         }, label: {
                             Text("\(playerAPoints)")
                                 .font(.system(size: 240, weight: Font.Weight.bold))
                         })
                         .foregroundColor(.white)
                         .frame(alignment: .center)
                         .simultaneousGesture(LongPressGesture()
                            .onEnded { _ in
                                playerAPoints -= 2
                            })
                                     
                        Spacer()
                        
                        // game score
                        Button(action: {
                            playerAGames += 1
                        }, label: {
                            Text("\(playerAGames)")
                                .font(.system(size: 80, weight: Font.Weight.bold))
                        })
                        .padding(.trailing)
                        .foregroundColor(.white)
                        .simultaneousGesture(LongPressGesture()
                           .onEnded { _ in
                               playerAGames -= 2
                           })
                    } // end HStack
                    
                    
                    VStack(spacing: 10){
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            // change ends
                            Button(action: {
                                changeEnds()
                            }, label: {
                                Text("Change Ends")
                            })
                            .foregroundColor(.white)
                            
                            Spacer()
                            
                            // reset points
                            Button(action: {
                                resetPoints()
                            }, label: {
                                Text("Reset Points")
                            })
                            .foregroundColor(.white)
                            
                            Spacer()
                        } // end HStack
                    }
                    // VStack
                    
                }
                // zstack
                
            }
            .background(Color.blue)
            // group
 
            
            
            Spacer()
            
            

            // Player 2
            Group {
                ZStack {
                    
                    VStack(spacing: 10){
                        HStack {
                            TextField("Player B", text: $playerB)
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                                    .background(Color.white)
                                    .padding(5)
                            
                                Toggle("", isOn: $serviceB)
                                    .toggleStyle(.automatic)
                        }
                        
                        Spacer()
                    }
                    // VStack
                    
                    HStack {
                        // game score
                        Button(action: {
                            playerBGames += 1
                        }, label: {
                            Text("\(playerBGames)")
                                .font(.system(size: 80, weight: Font.Weight.bold))
                        })
                        .padding(.trailing)
                        .foregroundColor(.white)
                        .simultaneousGesture(LongPressGesture()
                           .onEnded { _ in
                               playerBGames -= 2
                           })

                        Spacer()
                        
                        // current point
                         Button(action: {
                             playerBPoints += 1
                             changeServe()
                             checkWinner()
                         }, label: {
                             Text("\(playerBPoints)")
                                 .font(.system(size: 240, weight: Font.Weight.bold))
                         })
                         .foregroundColor(.white)
                         .frame(alignment: .center)
                         .simultaneousGesture(LongPressGesture()
                            .onEnded { _ in
                                playerBPoints -= 2
                            })
                         
                         Spacer()
                    } // end HStack
                    
                    
                    VStack(spacing: 10){
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            // Reset All
                            Button(action: {
                                resetAll()
                            }, label: {
                                Text("Reset All")
                            })
                            .foregroundColor(.white)
                        } // end HStack
                    }
                    // VStack
                    
                }
                // zstack
                
            }
            .background(Color.red)
            // group
 

        }
        // HStack
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
