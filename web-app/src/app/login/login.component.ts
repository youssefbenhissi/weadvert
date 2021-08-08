import { Component, OnInit } from '@angular/core';
import { MailService } from '../mail.service';
import { FormControl,FormGroup,Validators } from '@angular/forms';
import { isEmpty } from 'rxjs/operators';
@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  loginForm = new FormGroup({
    email: new FormControl('', [Validators.required,Validators.pattern("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$")]),
    password: new FormControl('', [Validators.required])
  })
  
  get name() { return this.loginForm.get('email'); }

  constructor(private service: MailService) { }

  ngOnInit(): void {
  }
  login(data:any){
    this.service.login(data);
  }
  
}
