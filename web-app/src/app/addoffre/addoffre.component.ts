import { Component, OnInit } from '@angular/core';
import { MailService } from '../mail.service';

@Component({
  selector: 'app-addoffre',
  templateUrl: './addoffre.component.html',
  styleUrls: ['./addoffre.component.css']
})
export class AddoffreComponent implements OnInit {
  profileagencies:any;
  constructor(private service: MailService) { }

  ngOnInit(): void {
    this.service.getProfilagencies().subscribe(data => {
      this.profileagencies = data[0];
      console.log("fff");
      console.log(this.profileagencies);
  
    })
  }
  addoffre(data: any) {
    this.service.addoffre(data);

  }
}
