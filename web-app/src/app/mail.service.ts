import { Injectable } from '@angular/core';
import {HttpClient,HttpParams} from '@angular/common/http';
import { ActivatedRoute, Router } from '@angular/router';
import {profil} from './profil';
import { isEmpty } from 'rxjs/operators';
import { Observable, Subscriber } from 'rxjs';
import { io } from 'socket.io-client';
import * as mapboxgl from 'mapbox-gl';
import { environment } from "../environments/environment";
//import { Message } from './message';
@Injectable({
  providedIn: 'root'
})
export class MailService {
  map!: mapboxgl.Map;
  style = 'mapbox://styles/mapbox/streets-v11';
  lat = 36.8065;
  lng = 10.1815;
  zoom = 12
  message : any;
  socket: any;
  readonly url: string ="http://localhost:56001";

  constructor(private http: HttpClient, private router : Router  ) { 
    this.socket = io(this.url);
    (mapboxgl as typeof mapboxgl).accessToken = environment.mapbox.accessToken;
  }
/*   onNewMessage(eventName:string) {
    return new Observable((subscriber) => {
      this.socket.on(eventName, (data:any) => {
        subscriber.next(data);
        console.log("test1",data)
       
        
      });
    });
  } */
  public getMessages = () => {
    return Observable.create((observer: { next: (arg0: any) => void; }) => {
            this.socket.on('message', (data: any) => {
                observer.next(data);
            });
    });
}
  emit(eventName:string,data:any){
    this.socket.emit(eventName,data)
  }
  
  register(data :any){
    console.log(data);
    //this.message = new Message(data['nom'], data['email']);
    //console.log(this.message);
    return this.http.post('http://localhost:56001/register_user', data).subscribe((res: any) => {
      localStorage.setItem('token', res.token);
      console.log(res.token);
      this.router.navigate( ['/login/']);

    })
  }
  registeragencies(data :any){
    console.log(data);
    //this.message = new Message(data['nom'], data['email']);
    //console.log(this.message);
    return this.http.post('http://localhost:56001/register_agencies', data).subscribe((res: any) => {
      localStorage.setItem('token', res.token);
      console.log(res.token);
      this.router.navigate( ['/']);

    })
  }
  

  login(data: any) {
    return this.http.post<any>('http://localhost:56001/login', data)
      .subscribe((res: any) => {
        localStorage.setItem('token', res.token);
        console.log(res.token);
        const token = localStorage.getItem('token');
        this.router.navigate( ['/profil/']);
      
        

      }, (error) =>{
        let e = error.error;
        return alert(e);
      })
  }
  loginagencies(data: any) {
    return this.http.post<any>('http://localhost:56001/loginagencies', data)
      .subscribe((res: any) => {
        localStorage.setItem('token', res.token);
        console.log(res.token);
        const token = localStorage.getItem('token');
    
        this.router.navigate( ['/profil-agencies/']);
      
        

      }, (error) =>{
        let e = error.error;
        return alert(e);
      })
  }

  logout() {
    localStorage.removeItem("token");
}

  getMembre(){
    return this.http.get<any[]>('http://localhost:56001/automobiliste');
  }
  getProfil(){
   
    return this.http.get<any[]>('http://localhost:56001/profil')
  }
  getProfilagencies(){
   
    return this.http.get<any[]>('http://localhost:56001/profil-agencies')
  }
  getOffreagencies(){
   
    return this.http.get<any[]>('http://localhost:56001/offres')
  }
  getOffreAuto(){
   
    return this.http.get<any[]>('http://localhost:56001/offre-auto')
  }
  getcompany(){
   
    return this.http.get<any>('http://localhost:56001/company')
  }
  getlikes(){
   
    return this.http.get<any>('http://localhost:56001/all-likes')
  }
  getImage(){
   
    return this.http.get<any[]>('http://localhost:56001/file/:fileName')
  }
  deleteToken() {
    localStorage.removeItem('token');
  }
  getcandidature(idOffre: number){
    return this.http.get<any[]>('http://localhost:56001/liste-candidature/'+idOffre)
  }
  verified(data: any) {
    return this.http.post<any>('http://localhost:56001/verified/',data).subscribe((res: any) => {
      
    console.log("daliiiddndnd",res);

  })
    
  }
  getlistecandidatureimages(){
   
    return this.http.get<any[]>('http://localhost:56001/liste-candidature-images/')
  }
  getimagealldriver(){
   
    return this.http.get<any[]>('http://localhost:56001/image-all-drivers')
  }
  getnotif(){
   
    return this.http.get<any[]>('http://localhost:56001/display-notif')
  }
  getcountdrivers(){
   
    return this.http.get<any[]>('http://localhost:56001/all-drivers')
  }
  getcountoffers(){
   
    return this.http.get<any[]>('http://localhost:56001/countoffers')
  }
  deleteoffre(idOffre:number){
   
    return this.http.delete('http://localhost:56001/deleteoffers/'+idOffre)
  }
  deletecandida(idAuto:number){
   
    return this.http.delete('http://localhost:56001/deletecandida/'+idAuto)
  }
  getstatistic(){
   
    return this.http.get<any[]>('http://localhost:56001/stat')
  }
  getnot(){
   
    return this.http.get<any[]>('http://localhost:56001/aff-notification')
  }
  sendnotif(data: any)
  {
    return this.http.post<any>('http://localhost:56001/send-notification', data).subscribe((res: any) => {
      console.log("fffff",res);

  })

}

sendemail(data: any)
{
  return this.http.post<any>('http://localhost:56001/forgot_password', data).subscribe((res: any) => {
    console.log("emailjkjkjkjkkjjk",res);
    this.router.navigate(['/reset-password-automobiliste/']);
}, (error) =>{
  let e = error.error;
  return alert(e);
})

}
resetpassword(data: any)
{
  return this.http.post<any>('http://localhost:56001/reset_password', data).subscribe((res: any) => {
    console.log("email",res);
    this.router.navigate(['/login/']);

})}
buildMap() {
  this.map = new mapboxgl.Map({
    container: 'map',
    style: this.style,
    zoom: this.zoom,
    center: [this.lng, this.lat]
  })
 this.map.addControl(new mapboxgl.NavigationControl());
}
getposition(){
   
  return this.http.get<any>('http://localhost:56001/drivers-positions')
}
addoffre(data: any) {
  return this.http.post<any>('http://localhost:56001/addoffres/',data).subscribe((res: any) => {
    
  console.log("daliiiddndnd",res);
  this.router.navigate( ['/dashboard-agencies/']);
})
}
}