//
//  ViewController.swift
//  eventos
//
//  Created by MaestroD1 on 11/1/19.
//  Copyright © 2019 MaestroD1. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tvEventos: UITableView!
    var eventos : [Evento] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request("http://localhost:8888/eventos/wp-json/wp/v2/eventos").responseJSON {
            
        response in
            switch (response.result) {
        case .success(let datos) :
            if let arregloEventos = datos as? NSArray {
                for evento in arregloEventos {
                    if let diccionarioEvento = evento as? NSDictionary {
                        let nuevoEvento = Evento(diccionario: diccionarioEvento)
                        self.eventos.append(nuevoEvento)
                    }
                }
                self.tvEventos.reloadData()
            }
        case .failure(_) :
            print("Algo salio mal")
        
        }
    }
    
}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "cellEvento") as? CeldaEventoController
        celda?.lblNombre.text = eventos[indexPath.row].nombre
        celda?.lblFecha.text = eventos[indexPath.row].fecha
        
        AF.request(eventos[indexPath.row].urlFlyer).responseImage {
            response in
            switch(response.result) {
            case .success(let data) :
                celda?.imgFlyer.image = data
            case .failure(_) :
                print("Algo salio mal")
            }
        } 
        
        return celda!
    }


}

