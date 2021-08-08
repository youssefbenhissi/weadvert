import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LoginAgenciesComponent } from './login-agencies.component';

describe('LoginAgenciesComponent', () => {
  let component: LoginAgenciesComponent;
  let fixture: ComponentFixture<LoginAgenciesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ LoginAgenciesComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LoginAgenciesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
