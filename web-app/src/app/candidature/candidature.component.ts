import { Component, OnInit} from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { MailService } from '../mail.service';
import { ToastrService } from 'ngx-toastr';
import { profil } from './../profil';
@Component({
  selector: 'app-candidature',
  templateUrl: './candidature.component.html',
  styleUrls: ['./candidature.component.css'],

})



export class CandidatureComponent implements OnInit{
  idOffre:any;
  candidiature!:profil[];
  idAuto:any;
  profileagencies: any;
  
  profil:any[] | undefined;
  searchValue:any;
  constructor(private activatedRoute: ActivatedRoute,private service: MailService, private router : Router,private toastr: ToastrService) { }


  ngOnInit(): void {
    this.service.getProfilagencies().subscribe(data => {
      this.profileagencies = data[0];
      console.log("fff");
      console.log(this.profileagencies);
  
    })
    this.activatedRoute.paramMap.subscribe(result => {
    this.idOffre=result.get('idOffre');
     this.service.getcandidature(Number(this.idOffre)).subscribe((result:profil[]) => {
      this.candidiature = result;
      console.log("idoffre:",result);
    console.log("idoffremmmmmmm:",this.idOffre);
      console.log(this.candidiature);
  })

})

  }
  verified(data:any){
    console.log(data);

    this.service.verified(data);
    console.log("idAuto",data);
  }
  sendnotif(data:any){
   
    this.service.emit('connection',data);
    console.log('rrrrrrr',data);
 
   
  }
  showSuccess(){
    this.toastr.success("notification to the driver", "Send")
}
deletecandida(idAuto: Number){
  
  this.service.deletecandida(Number(idAuto)).subscribe();
}

}







