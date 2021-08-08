import { Component, OnInit } from '@angular/core';
import { MailService } from '../mail.service';
import { Router } from "@angular/router";
import {profil} from '../profil';
@Component({
  selector: 'app-admin',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.css']
})
export class AdminComponent implements OnInit {

  profile: any;
  messageList:  string[] = [];
  offreAuto!: any[];
  notification!: any[];
  image: any;
  test:any;
  test2:any;
  company:any;

  constructor(private service: MailService, private router : Router ) { 
    this.test2=localStorage.getItem("data");
    console.log("test2",this.test2);
  }


  ngOnInit(): void {
    this.service.getProfil().subscribe(data => {
      this.profile = data[0];
      console.log("fff");
      console.log(this.profile);
      
      
  
    })
   
  
    this.service.getOffreAuto().subscribe(data => {
      this.offreAuto = data;
      console.log("ffddddddf");
      console.log(this.offreAuto);

    })
    this.service.getcompany().subscribe(data => {
      this.company = data[0];
      console.log("comapny");
      console.log(this.company);

    })
    this.service.getImage().subscribe(data => {
      this.image =  data;
      console.log("daliiiii");
      console.log(this.image);

    })
    this.service.getnotif().subscribe(data => {
      this.notification =  data;
      console.log("daliiiii");
      console.log(this.notification);

    })
    this.service
    .getMessages()
    .subscribe((data: any) => {
      this.messageList.push(data.message);
    });

/*     this.service.onNewMessage('connections').subscribe((data: any) => {
      this.test=data.message;
      console.log('ididididdi',this.test);
      localStorage.setItem("data",this.test);
  

      
      
    }) */
  
    }
    
  onLogout(){
    this.service.deleteToken();
    this.router.navigate(['']);
  }
  sendmessage(data:any){
   
    this.service.emit('message',data);
    console.log('message',data);
  
   
  }
}
