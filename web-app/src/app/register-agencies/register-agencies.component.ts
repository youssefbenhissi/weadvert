import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { MailService } from '../mail.service';

@Component({
  selector: 'app-register-agencies',
  templateUrl: './register-agencies.component.html',
  styleUrls: ['./register-agencies.component.css']
})
export class RegisterAgenciesComponent implements OnInit {
  registerAgForm = new FormGroup({



    name: new FormControl('', [Validators.required]),
    email: new FormControl('', [Validators.required,Validators.pattern("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$")]),
    password: new FormControl('', [Validators.required])
  
    
  })
  get registerAgFormControl() {
    return this.registerAgForm.controls;
  }
  constructor(private service: MailService) { }

  ngOnInit(): void {
  }
  registeragencies(data: any) {
    this.service.registeragencies(data);

  }
}
