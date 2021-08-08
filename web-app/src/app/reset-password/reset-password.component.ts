import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { MailService } from '../mail.service';

@Component({
  selector: 'app-reset-password',
  templateUrl: './reset-password.component.html',
  styleUrls: ['./reset-password.component.css']
})
export class ResetPasswordComponent implements OnInit {
  resetForm = new FormGroup({
    email: new FormControl('', [Validators.required,Validators.pattern("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$")]),
    password: new FormControl('', [Validators.required]),
    code: new FormControl('', [Validators.required])
  })
  constructor(private service: MailService) { }

  ngOnInit(): void {
  }
  resetpassword(data: any) {
    this.service.resetpassword(data);

  }
}
