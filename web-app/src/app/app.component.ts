import { Component } from '@angular/core';
import { MailService } from './mail.service';
//import { Message } from './message';
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'weadvertorg';
  message: any;
  constructor(private mailService: MailService){

  }

  sendMessage(){
    console.log(this.message);
  }
}
