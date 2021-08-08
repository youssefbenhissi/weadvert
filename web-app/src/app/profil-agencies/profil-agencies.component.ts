import { Component, OnInit } from '@angular/core';
import { MailService } from '../mail.service';

@Component({
  selector: 'app-profil-agencies',
  templateUrl: './profil-agencies.component.html',
  styleUrls: ['./profil-agencies.component.css']
})
export class ProfilAgenciesComponent implements OnInit {

 
  profileagencies: any;
  offreagencies!: any[];
  image : any;
  candidatureimages!:any[];
  constructor(private service: MailService) { }


  ngOnInit(): void {
    this.service.getProfilagencies().subscribe(data => {
      this.profileagencies = data[0];
      console.log("fff");
      console.log(this.profileagencies);
  
    })
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
  }
 

}
