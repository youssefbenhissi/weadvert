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
  likes:any;
  msg!:any[];
  messageList:  string[] = [];
  map!: mapboxgl.Map;
  constructor(private service: MailService) { }

  ngOnInit(): void {
   
  


    this.service.getProfilagencies().subscribe(data => {
      this.profileagencies = data[0];
      console.log("fff");
      console.log(this.profileagencies);
  
    })

    this.service.getlikes().subscribe(data => {
      this.likes = data[0];
      console.log("fff");
      console.log(this.likes);
  
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
              backgroundColor : '#33c8c1',
              
             
             
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
}
 
delete(){
  
  this.service.deleteoffre(Number(this.idOffre)).subscribe();
}
sendmessage(data:any){
   
  this.service.emit('message',data);
  console.log('message',data);

 
}



  }


