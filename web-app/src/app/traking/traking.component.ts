import { Component, OnInit } from '@angular/core';
import * as mapboxgl from 'mapbox-gl';
import { MailService } from '../mail.service';
import { interval } from 'rxjs';
import { delay } from 'rxjs/operators';
@Component({
  selector: 'app-traking',
  templateUrl: './traking.component.html',
  styleUrls: ['./traking.component.css']
})
export class TrakingComponent implements OnInit {
  map!: mapboxgl.Map;
  profileagencies: any;
  constructor(private service: MailService) { }
  marker1!: mapboxgl.Marker;
  marker2!: mapboxgl.Marker;
  ismarker1 = true;
  ngOnInit(): void {
    (mapboxgl as typeof mapboxgl).accessToken = 'pk.eyJ1IjoiZGFsaW0yIiwiYSI6ImNrbnByeW1weDA1c2wycHBmbTRsN2VyajIifQ.F7r_YbITYi1iTOQxEfbNxA'
    
    this.map = new mapboxgl.Map({

      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [ 10.118496805860685, 36.80331479016154],
      zoom: 12

    });

    this.service.getProfilagencies().subscribe(data => {
      this.profileagencies = data[0];
      console.log("fff");
      console.log(this.profileagencies);

    })

    this.service.getposition()
    .subscribe(res => {
      let lat=res.map((res: { latitude: any; })=>res.latitude);

      let long=res.map((res: { longitude: any; })=>res.longitude);
      let nom=res.map((res: { nom: any; })=>res.nom);
      let prenom=res.map((res: { prenom: any; })=>res.prenom);
      let revenu=res.map((res: { solde: any; })=>res.solde);
      let photo=res.map((res: { photo: any; })=>res.photo);
      console.log("lat",lat);

      console.log("long",long);
      console.log("prenom",prenom);

      console.log("nom",nom);
      this.marker1 = new mapboxgl.Marker({

       
      })
      .setLngLat([long,lat])
      .setPopup(new mapboxgl.Popup().setHTML('<img class="contacts-list-img" src="http://localhost:3305/file/'+photo+'">'+'<br><br><br>'+'First Name:'+nom+'<br>'+'Last Name:'+prenom+'<br>'+'Income:'+revenu+' DT')) // add popup
      .addTo(this.map)
    })

    interval(2000).subscribe(x => {
      this.service.getposition()
        .subscribe(async res => {

          let lat = res.map((res: { latitude: any; }) => res.latitude);

          let long = res.map((res: { longitude: any; }) => res.longitude);
          let nom = res.map((res: { nom: any; }) => res.nom);
          let prenom = res.map((res: { prenom: any; }) => res.prenom);
          let revenu = res.map((res: { solde: any; }) => res.solde);
          let photo = res.map((res: { photo: any; }) => res.photo);
          console.log("lat", lat);

          console.log("long", long);
          console.log("prenom", prenom);

          console.log("nom", nom);

          if (this.ismarker1) {
            this.marker1 = new mapboxgl.Marker({
            })
              .setLngLat([long, lat])
              .setPopup(new mapboxgl.Popup().setHTML('<img class="contacts-list-img" src="http://localhost:3305/file/' + photo + '">' + '<br><br><br>' + 'First Name:' + nom + '<br>' + 'Last Name:' + prenom + '<br>' + 'Income:' + revenu + ' DT')) // add popup
              .addTo(this.map)
            this.ismarker1 = !this.ismarker1;
            this.marker2.remove();
          } else {
            this.marker2 = new mapboxgl.Marker({
            })
              .setLngLat([long, lat])
              .setPopup(new mapboxgl.Popup().setHTML('<img class="contacts-list-img" src="http://localhost:3305/file/' + photo + '">' + '<br><br><br>' + 'First Name:' + nom + '<br>' + 'Last Name:' + prenom + '<br>' + 'Income:' + revenu + ' DT')) // add popup
              .addTo(this.map)
            this.ismarker1 = !this.ismarker1;
            this.marker1.remove();
          }
        })
    });
  }

}
