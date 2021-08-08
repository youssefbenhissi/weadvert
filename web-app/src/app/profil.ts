export class profil{

    idAuto:number;
    nom: string;
    prenom: string;
    email:string;
    dateNaiss:Date;
    password:string;
    cin:Number;
    profession:string;
    phone:number;
    photo:string;
    lieuCirculation:string;

    constructor(idAuto:number,name: string,prenom:string ,email:string,password:string,dateNaiss:Date,cin:Number,profession:string,phone:number,photo:string,lieuCirculation:string){
        this.idAuto=idAuto;
        this.nom = name;
        this.prenom = prenom;
         this.email = email;
         this.password = password;
         this.dateNaiss = dateNaiss;
         
         this.cin = cin;
         this.profession = profession;
         this.phone = phone;
         this.photo = photo;
         this.lieuCirculation = lieuCirculation;
     }



}