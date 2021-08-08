import { Component, OnInit } from '@angular/core';
import * as Chart from 'chart.js';
import * as mapboxgl from 'mapbox-gl';
import { MailService } from '../mail.service';
import { environment } from './../../environments/environment.prod';


@Component({
  selector: 'app-dashboard-agencies',
  templateUrl: './dashboard-agencies.component.html',
  styleUrls: ['./dashboard-agencies.component.css']
})
export class DashboardAgenciesComponent implements OnInit {
  profileagencies: any;
  idOffre:any;
  offreagencies!: any[];
  chart = [];
  candidatureimages!:any[];
  count:any;
  counto:any;
  msg!:any[];
  messageList:  string[] = [];
  map!: mapboxgl.Map;
  imagealldrivers: any[] | undefined;
  likes: any;
  constructor(private service: MailService) { }

  ngOnInit(): void {
    (mapboxgl as typeof mapboxgl).accessToken = 'pk.eyJ1IjoiZGFsaW0yIiwiYSI6ImNrbnByeW1weDA1c2wycHBmbTRsN2VyajIifQ.F7r_YbITYi1iTOQxEfbNxA'

    this.map =new mapboxgl.Map({

      container:'map',
      style:'mapbox://styles/mapbox/streets-v11',
      center:[10.1815,36.8065],
      zoom:5




    });
    
    
    this.service.getlikes().subscribe(data => {
      this.likes = data[0];
      console.log("fff");
      console.log(this.likes);
  
    })

    this.service.getProfilagencies().subscribe(data => {
      this.profileagencies = data[0];
      console.log("fff");
      console.log(this.profileagencies);
  
    })

    
   
    //this.service.buildMap();
    this.service.getOffreagencies().subscribe(data => {
      this.offreagencies =  data;
      console.log("ffddddddf");
      console.log(this.offreagencies);

    })
    this.service.getlistecandidatureimages().subscribe(data => {
      this.candidatureimages =  data;
      console.log("candidtaure images");
      console.log(this.candidatureimages);

    })
    
    this.service
    .getMessages()
    .subscribe((data: any) => {
      this.messageList.push(data.message);
    });
    this.service.getcountdrivers().subscribe(res => {
      this.count=res.map(res=>res.valeur);
      console.log("ffddddddf");
      console.log(this.count);

    })
    this.service.getcountoffers().subscribe(res => {
      this.counto=res.map(res=>res.valeur);
      console.log("ffddddddf");
      console.log(this.counto);

    })
    this.service.getposition()
    .subscribe(res => {
      let lat=res.map((res: { latitude: any; })=>res.latitude);

      let long=res.map((res: { longitude: any; })=>res.longitude);
      let nom=res.map((res: { nom: any; })=>res.nom);
      let prenom=res.map((res: { prenom: any; })=>res.prenom);
      let revenu=res.map((res: { solde: any; })=>res.solde);
      let photo=res.map((res: { photo: any; })=>res.photo);
      console.log("lat",lat);

      console.log("long",long);
      console.log("prenom",prenom);

      console.log("nom",nom);
      const marker = new mapboxgl.Marker({

       
      })
      .setLngLat([long,lat])
      .setPopup(new mapboxgl.Popup().setHTML('<img class="contacts-list-img" src="http://localhost:3305/file/'+photo+'">'+'<br><br><br>'+'First Name:'+nom+'<br>'+'Last Name:'+prenom+'<br>'+'Income:'+revenu+' DT')) // add popup
      .addTo(this.map)
    })
    this.service.getstatistic()
    .subscribe(res => {
      
      let semestere=res.map(res=>res.semester);
      let valeur=res.map(res=>res.valeur);
      console.log("stat",semestere);

      console.log("stat",valeur);
    
      const chart = new Chart('canvas', {
        type: 'line',
        data: {
          labels: ["s1","s2","s3","s4"],
          datasets: [
            {
              data: [3, 8, 1, 12],
              backgroundColor : '#007bff',
              
             
             
            },
       
          ]
        },
        options: {
          legend: {
            display: false
          },
          scales: {
            xAxes: [{
              display: true
            }],
            yAxes: [{
              display: true
            }]
          }
        }
      })

    })
    this.service.getcountdrivers().subscribe(res => {
      this.count=res.map(res=>res.valeur);
      console.log("ffddddddf");
      console.log(this.count);

    })
     this.service.getimagealldriver().subscribe(data => {
      this.imagealldrivers =  data;
      console.log("candidtaure all images");
      console.log(this.candidatureimages);

    })
}
 
delete(idOffre: Number){
  
      this.service.deleteoffre(Number(idOffre)).subscribe();
    }
sendmessage(data:any){
   
  this.service.emit('message',data);
  console.log('message',data);

 
}



  }


