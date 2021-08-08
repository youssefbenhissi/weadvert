import { Component, OnInit } from '@angular/core';
import { MailService } from '../mail.service';
import { FormControl,FormGroup,Validators } from '@angular/forms';
@Component({
  selector: 'app-registre',
  templateUrl: './registre.component.html',
  styleUrls: ['./registre.component.css']
})
export class RegistreComponent implements OnInit {
  registerForm = new FormGroup({


    lastName : new FormControl('', [Validators.required]),
    firstName: new FormControl('', [Validators.required]),
    email: new FormControl('', [Validators.required,Validators.pattern("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$")]),
    password: new FormControl('', [Validators.required]),
    cardNumber: new FormControl('', [Validators.required, Validators.maxLength(8)]),
    professionRequired: new FormControl('', [Validators.required]),
    professionOnlyLetters: new FormControl('',Validators.pattern('^[A-Za-zñÑáéíóúÁÉÍÓÚ ]+$')),

    
  })
  
  get name() { return this.registerForm.get('name'); }

  get registerFormControl() {
    return this.registerForm.controls;
  }


  liste: any = [];
  constructor(private service: MailService) { }

  ngOnInit(): void {
    this.service.getMembre().subscribe(data => {
      this.liste = data;
      console.log(this.liste);
    })
  }

  register(data: any) {
    this.service.register(data);

  }

  login(data:any){
    console.log(data);
    this.service.login(data);
  }
  concatener(ch1: any, ch2: any, ch3: any) {
    var chaine = ch1 + ch2 + ch3 ; 
   // var toDayDate = new Date(chaine);
    return chaine;
  }

}
