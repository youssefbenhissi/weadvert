import { Pipe, PipeTransform } from '@angular/core';
import { profil } from './../profil';

@Pipe({name: 'searchfilter'})
export class Searchfilter implements PipeTransform {
  transform(candidiature:profil[], searchValue: string): profil[] {
    if(!candidiature || !searchValue ) {return candidiature;
    }
    
    return candidiature.filter(profil=>profil.nom.toLocaleLowerCase().includes(searchValue.toLocaleLowerCase()));
   }
}

