//
//  MissionView.swift
//  Moonshot
//
//  Created by Dmitry Kononov on 3.09.25.
//

import SwiftUI

struct MissionView: View {
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        

        
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                

                
                VStack(alignment: .leading) {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.lightBackground)
                        .padding(.vertical)
                    
                    Text("Mission highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    Text(mission.description)
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.lightBackground)
                        .padding(.vertical)
                    
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(crew, id: \.role) { crew in
                            NavigationLink {
                                AstronautView(astronaut: crew.astronaut)
                            } label: {
                                Image(crew.astronaut.id)
                                    .resizable()
                                    .frame(width: 104, height: 72)
                                    .clipShape(.capsule)
                                    .overlay (
                                        Capsule()
                                        .strokeBorder(.white, lineWidth: 1)
                                    )
                                VStack(alignment: .leading) {
                                    Text(crew.astronaut.name)
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                    
                                    Text(crew.role)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    init(mission: Mission, astrounats: [String : Astronaut]) {
        self.mission = mission
        self.crew = mission.crew.map { member in
            if let astrounat = astrounats[member.name] {
                return CrewMember(role: member.role, astronaut: astrounat)
            } else {
                fatalError("Missing astronaut data for \(member.name)")
            }
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String : Astronaut] = Bundle.main.decode("astronauts.json")
    
    MissionView(mission: missions[0], astrounats: astronauts)
        .preferredColorScheme(.dark)
}
