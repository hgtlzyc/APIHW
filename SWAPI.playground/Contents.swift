import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//based on the instructions from https://github.com/DevMountain/SWAPI_Playgrounds
struct Person: Codable {
    let name: String
    let films: [URL]
    let height: String
}

struct Film: Codable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/people")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        guard let baseURL = baseURL else {
            completion(nil)
            return
        }
        
        let finalURL = baseURL.appendingPathComponent("\(id)")
        
        URLSession.shared.dataTask(with: finalURL) { data, _, err in
            if let _ = err {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                completion(person)
            } catch {
                print(error)
                completion(nil)
            }
            
        }.resume()
    
    }//End Of fetch person function
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, err in
            if let error = err {
                print(error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                completion(film)
            } catch {
                print(error)
                completion(nil)
            }
            
            
        }.resume()
        
    }//End Of fetchFilm
    
}//End Of class


SwapiService.fetchPerson(id: 5) { person in
    guard let person = person else { return }
    print(person.name)
    print("height ", person.height)
    person.films.forEach { url in
        SwapiService.fetchFilm(url: url) { film in
            guard let film = film else { return }
            print(film.title, "----", film.release_date)
        }
    }
}


