import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { MailService } from '../mail.service';

@Component({
  selector: 'app-email-automobiliste',
  templateUrl: './email-automobiliste.component.html',
  styleUrls: ['./email-automobiliste.component.css']
})
export class EmailAutomobilisteComponent implements OnInit {
  sendemailForm = new FormGroup({
    email: new FormControl('', [Validators.required,Validators.pattern("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$")]),
  })
  constructor(private service: MailService, private router : Router  ) { }

  ngOnInit(): void {
  }
  sendemail(data: any) {
    this.service.sendemail(data);
    

  }

}
