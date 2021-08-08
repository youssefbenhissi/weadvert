import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProfilAgenciesComponent } from './profil-agencies.component';

describe('ProfilAgenciesComponent', () => {
  let component: ProfilAgenciesComponent;
  let fixture: ComponentFixture<ProfilAgenciesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ProfilAgenciesComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ProfilAgenciesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
